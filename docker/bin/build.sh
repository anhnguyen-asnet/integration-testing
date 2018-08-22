#!/usr/bin/env bash

set -ev

SCRIPT_DIR=`dirname "$0"`
SRC_DIR=$(cd $SCRIPT_DIR/../..; pwd)

echo $SCRIPT_DIR

echo $SRC_DIR

echo $GROUP

echo $REPO

echo $CIRCLE_SHA1

echo "Db Migrate: $DB_MIGRATE"

if [[ -z "$GROUP" ]] ; then
    echo "Cannot find GROUP env var"
    exit 1
fi

if [[ -z "$CIRCLE_SHA1" ]] ; then
    echo "Cannot find CIRCLE_SHA1 env var"
    exit 1
fi

docker build --rm=false \
    -t ${GROUP}/${REPO}:$CIRCLE_SHA1 \
    -f $SRC_DIR/docker/Dockerfile \
    $SRC_DIR
