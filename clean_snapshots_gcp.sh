#!/usr/bin/env bash

P_LIMIT_DEFAULT="1000"
[[ ! $P_LIMIT ]] && export P_LIMIT="${P_LIMIT_DEFAULT}"

help_display() { 
  echo "Usage: ./clean_snapshots_gcp.sh [options]" 
  echo "-h: print help" 
  echo "-e {ENV}: specify the environment (you can also export the P_ENV environment)"
  echo "-p {PRODUCT_NAME}: specify the product/software name (you can also export the P_NAME environment)"
  echo "-l {LIMIT}: specify the limit to fetch in one script execution (you can also export the P_LIMIT environment). Default value: ${P_LIMIT_DEFAULT}"
  echo "-c: perform the cleaning"
}

error() { 
  echo "ERROR: invalid parameters" >&2 
  help_display >&2
  exit 1
}

environment_set() {
  [[ ! $P_ENV ]] && export P_ENV="${1}"
}

product_set() {
  [[ ! $P_NAME ]] && export P_NAME="${1}"
}

limit_set() {
  [[ ! $P_LIMIT ]] && export P_LIMIT="${1}"
}

perform_clean() {
  [[ ! $P_ENV ]] || [[ ! $P_NAME ]] || [[ ! $P_LIMIT ]] && error

  echo "Cleaning with P_ENV=${P_ENV}, P_NAME=${P_NAME}, P_LIMIT=${P_LIMIT} and P_MAX_KEEP=${P_MAX_KEEP}"

  gcloud compute snapshots list --filter="${P_ENV}-${P_NAME}" --sort-by creationTimestamp --limit "${P_LIMIT}"|while read snapshot_id tash; do
      [[ $snapshot_id == "NAME" ]] && continue
      disk="$(gcloud compute snapshots describe ${snapshot_id}|awk -F '(: |/)' '($1 == "sourceDisk"){print $NF}')"
      timestamp="$(gcloud compute snapshots describe ${snapshot_id}|awk -F ': ' '($1 == "creationTimestamp"){print $NF}')"
      echo "${snapshot_id} ${disk} ${timestamp}"
  done|awk '
  function push(A,B) { 
    A[length(A)+1] = B 
  }
  BEGIN{
    delete todel[0]
  }
  {
    if(($2 not in snaps) or $3 > times[$2]) {
      if($2 in snaps) {
        push(todel, snaps[$2])
      }
      snaps[$2] = $1
      times[$2] = $3
    } else {
      push(to_deletes, $1)
    }
  }

  END {
    print "Deleting "length(todel)" elements"
    for(i in todel) {
      cmd="gcloud compute snapshots delete "todel[i]" -q"
      print "Running "cmd
      system(cmd)
    }
  }'
}

while getopts ":e:p:l:hc" option; do 
  case "$option" in 
    s) sudo_enable ;;
    h) help_display ;;
    e) environment_set $OPTARG ;;
    :) error ;;
    p) product_set $OPTARG ;;
    :) error ;;
    l) limit_set $OPTARG ;;
    :) error ;;
    c) perform_clean ;;
    *) error ;; 
    esac 
done
