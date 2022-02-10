#!/usr/bin/env bash

REPO_PATH="/home/centos/clean-gcp-snapshots/"

cd "${REPO_PATH}" && git pull origin main || :
git push github main 
git push internal main
git push pgitlab main
git push bitbucket main
exit 0
