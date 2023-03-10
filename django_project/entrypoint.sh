#!/bin/bash
# pipenv shell
pipenv run python3 /app/manage.py migrate
pipenv run python3 /app/manage.py runserver 0.0.0.0:8000
exec "$@"
