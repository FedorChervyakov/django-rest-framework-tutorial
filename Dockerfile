# BASE
FROM python:3.10-slim as base

RUN apt update && apt install -y git

WORKDIR /app

# BUILDER
from base as builder

ENV PIP_DEFAULT_TIMEOUT=100 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1 \
    POETRY_VERSION=1.1.13

# install poetry
RUN pip install -U "poetry==$POETRY_VERSION"
# create virtual environment
RUN python -m venv /venv

COPY tutorial/tutorial/__init__.py /app/tutorial/__init__.py
COPY pyproject.toml poetry.lock /app/

WORKDIR /app/

RUN . /venv/bin/activate && poetry install --no-dev --no-root
RUN . /venv/bin/activate && poetry install --no-dev

# DEVELOPMENT
from python:3.10-slim as dev

# create unprivileged user
RUN adduser --disabled-password --gecos '' myuser

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

COPY --from=builder /venv /venv
COPY docker-entrypoint.sh /

RUN chown -R myuser:myuser /venv

WORKDIR /app/

USER myuser:myuser
