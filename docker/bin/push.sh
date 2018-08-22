#!/usr/bin/env bash

set -ev

if [[ -z "$GROUP" ]] ; then
    echo "Cannot find GROUP env var"
    exit 1
fi

if [[ -z "$CIRCLE_SHA1" ]] ; then
    echo "Cannot find CIRCLE_SHA1 env var"
    exit 1
fi

push() {
    DOCKER_PUSH=1;
    while [ $DOCKER_PUSH -gt 0 ] ; do
        echo "Pushing $1";
        docker push $1;
        DOCKER_PUSH=$(echo $?);
        if [[ "$DOCKER_PUSH" -gt 0 ]] ; then
            echo "Docker push failed with exit code $DOCKER_PUSH";
        fi;
    done;
}

tag_and_push_all() {
    if [[ -z "$1" ]] ; then
        echo "Please pass the tag"
        exit 1
    else
        TAG=$1
    fi
    DOCKER_REPO=${GROUP}/${REPO}
    if [[ "$CIRCLE_SHA1" != "$TAG" ]]; then
        docker tag ${DOCKER_REPO}:${CIRCLE_SHA1} ${DOCKER_REPO}:${TAG}
    fi
    push "$DOCKER_REPO:$TAG";
}


# Push snapshot when in master
if [ "$CIRCLE_BRANCH" == "master" ] && [ -z "$CI_PULL_REQUEST" ]; then
    tag_and_push_all master-${CIRCLE_SHA1:0:8}
    tag_and_push_all master
fi;

# Push snapshot when in develop
if [ "$CIRCLE_BRANCH" == "develop" ] && [ -z "$CI_PULL_REQUEST" ]; then
    tag_and_push_all develop
fi;

# Verify if the tag has `release/` prefix
# Then push `release` tag as well
IFS='/' read -r -a array <<< "$CIRCLE_BRANCH"
BRANCH_PREFIX="${array[0]}"
if [ "$BRANCH_PREFIX" == "release" ]; then
    tag_and_push_all ${BRANCH_PREFIX}
fi;

# Push tag when tagged
if [ -n "$CIRCLE_TAG" ]; then
    tag_and_push_all ${CIRCLE_TAG}
fi;
