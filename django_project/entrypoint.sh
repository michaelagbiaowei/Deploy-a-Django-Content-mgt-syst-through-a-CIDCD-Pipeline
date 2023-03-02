#!/bin/bash
# pipenv shell
pipenv run python3 /app/manage.py migrate
pipenv run python3 /app/manage.py runserver
exec "$@"