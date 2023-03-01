#!/bin/bash
# entrypoint.sh
# do some stuff here
pipenv shell
python3 /app/manage.py migrate
python3 /app/manage.py runserver
exec "$@"