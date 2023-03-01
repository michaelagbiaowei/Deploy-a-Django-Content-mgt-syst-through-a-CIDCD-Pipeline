FROM  ubuntu:latest

# Create working dir
# WORKDIR /code

# Copy Pipfile to working dir
COPY . .

# Install Python3 and pip
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    python3.10 python3-pip python3.10-dev

# Install system dependencies
RUN apt-get update && \
    apt-get install -y libpq-dev \
    gcc musl-dev

# Install pipenv
RUN pip install pipenv

# Install psycopg2
RUN pip install psycopg2-binary
RUN pip install psycopg2

# Install django framwork
RUN pipenv install django

# Make it executable
RUN chmod +x .entrypoint.sh

# runs the production server
EXPOSE 8000
ENTRYPOINT ["/entrypoint.sh"]
# CMD ["pipenv", "shell"]
# CMD ["python3", "manage.py", "migrate"]
# CMD ["python3", "manage.py", "runserver"]