#!/usr/bin/env bash

REPO_PATH="/home/centos/clean-gcp-snapshots/"

cd "${REPO_PATH}" && git pull origin main || :
git push github main 
git push internal main
git push pgitlab main
exit 0
