
#!/bin/sh
set -eu

if [ "$ZAMMAD_DB_USER" = "$POSTGRES_USER" ]; then
    echo "Zammad DB user must differ from PostgreSQL superuser."
    exit 1
fi

echo "Creating Zammad database user..."

psql -v ON_ERROR_STOP=1 \
    --username "$POSTGRES_USER" \
    --dbname "$POSTGRES_DB" \
    --set=role="$ZAMMAD_DB_USER" \
    --set=pass="$ZAMMAD_DB_PASS" \
    --set=db="$ZAMMAD_DB" <<'EOSQL'

CREATE ROLE :"role" LOGIN PASSWORD :'pass';
CREATE DATABASE :"db" OWNER :"role";

EOSQL

echo "Zammad database initialized."
