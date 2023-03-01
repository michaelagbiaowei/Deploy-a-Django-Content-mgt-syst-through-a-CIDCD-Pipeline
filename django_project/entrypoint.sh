#!/bin/bash
# entrypoint.sh
# do some stuff here
pipenv shell
python3 manage.py migrate
python3 manage.py runserver
exec "$@"