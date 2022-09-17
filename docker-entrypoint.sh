#!/bin/sh

# activate virtual environment
. /venv/bin/activate

# prepare init migration
python manage.py makemigrations
# migrate db, so we have the latest db schema
python manage.py migrate
# collect static
#python manage.py collectstatic --noinput --verbosity 0
# start development server on public ip interface, on port 8000
python manage.py runserver --insecure 0.0.0.0:8000
