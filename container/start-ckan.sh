#!/bin/bash

# Set up the Secret key used by Beaker and Flask
# This can be overriden using a CKAN___BEAKER__SESSION__SECRET env var
if grep -qE "SECRET_KEY ?= ?$" ckan.ini
then
    echo "Setting SECRET_KEY in ini file"
    ckan config-tool $CKAN_INI "SECRET_KEY=$(python3 -c 'import secrets; print(secrets.token_urlsafe())')"
    ckan config-tool $CKAN_INI "WTF_CSRF_SECRET_KEY=$(python3 -c 'import secrets; print(secrets.token_urlsafe())')"
    JWT_SECRET=$(python3 -c 'import secrets; print("string:" + secrets.token_urlsafe())')
    ckan config-tool $CKAN_INI "api_token.jwt.encode.secret=${JWT_SECRET}"
    ckan config-tool $CKAN_INI "api_token.jwt.decode.secret=${JWT_SECRET}"
fi

# Run the prerun script to init CKAN
python3 -u prerun.py

EXIT_CODE=$?

if [[ $EXIT_CODE -ne 0 ]]; then
  echo "[prerun] FAILED - not starting CKAN"
  sleep infinity
fi

echo "[prerun] SUCCESS - starting CKAN"

# Run any startup scripts provided by images extending this one
if [[ -d "/docker-entrypoint.d" ]]
then
    for f in /docker-entrypoint.d/*; do
        case "$f" in
            *.sh)     echo "$0: Running init file $f"; . "$f" ;;
            *.py)     echo "$0: Running init file $f"; python3 "$f"; echo ;;
            *)        echo "$0: Ignoring $f (not an sh or py file)" ;;
        esac
    done
fi

# Set the common uwsgi options
UWSGI_OPTS="--plugins http,python \
            --socket /tmp/uwsgi.sock \
            --wsgi-file /srv/app/wsgi.py \
            --module wsgi:application \
            --uid 92 --gid 92 \
            --http [::]:5000 \
            --master --enable-threads \
            --lazy-apps \
            -p 2 -L -b 32768 --vacuum \
            --harakiri $UWSGI_HARAKIRI"

# Start uwsgi
uwsgi $UWSGI_OPTS