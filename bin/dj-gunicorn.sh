#!/usr/bin/env sh

PORT=$1

if [ "$PORT" = "" ]; then
  PORT='8000'
fi

gunicorn --bind 0.0.0.0:$PORT django_ci.wsgi:application

