FROM python:3.10 AS base

# Set ENV variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Create working dir
WORKDIR /app

# Copy files to working dir
COPY . /app

# Install pipenv
RUN cd /app
RUN pip install pipenv

# Install system dependencies
RUN apt-get update && \
    apt-get install -y libpq-dev \
    gcc musl-dev gdal-bin

# Install psycopg2
RUN pipenv install psycopg2-binary
RUN pipenv install psycopg2

# Install django framwork
RUN pipenv install django

# Make it executable
RUN chmod +x /app/entrypoint.sh

# runs the production server
EXPOSE 8000
ENTRYPOINT ["/app/entrypoint.sh"]