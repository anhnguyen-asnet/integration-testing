#!/usr/bin/env sh

set -e
cmd="$@"

postgres_ready() {
python << END
import sys
import os
import psycopg2
try:
    conn = psycopg2.connect(
        dbname=os.getenv("POSTGRES_DB"),
        user=os.getenv("POSTGRES_USER"),
        password=os.getenv("POSTGRES_PASSWORD"),
        host=os.getenv("POSTGRES_HOST"))

except psycopg2.OperationalError:
    sys.exit(-1)
sys.exit(0)
END
}


if [ "$DB_ENGINE" == "postgresql" ]; then
    # Waits for postgres server to go up
    until postgres_ready; do
    >&2 echo "Postgres is unavailable - sleeping"
    sleep 2
    done
fi

# Runs database migration if DB_MIGRATE flag is set
echo "Db Migrate: $DB_MIGRATE"
if [ "$DB_MIGRATE" == "true" ]; then
    bin/dj-migrate.sh
fi


echo "All ready"

exec $cmd
