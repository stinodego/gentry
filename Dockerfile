# --- BASE IMAGE WITH GENERAL SETTINGS --- #
FROM python:3.8.8-slim AS base

# Important settings
ENV VENV_PATH=/opt/venv \
    POETRY_HOME=/opt/poetry \
    POETRY_VERSION=1.1.5 \
    POETRY_VIRTUALENVS_CREATE=false \
# Nice-to-have optimizations
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100

# Set path for using poetry and virtual env
ENV PATH="$VENV_PATH/bin:$POETRY_HOME/bin:$PATH"

# Set port
ENV PORT=8000
EXPOSE $PORT


# --- BUILD IMAGE WITH RUNTIME DEPENDENCIES --- #
FROM base AS build

# Install Poetry
RUN apt-get update && apt-get install --no-install-recommends -y curl \
 && curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python - \
 && apt-get purge --auto-remove -y curl \
 && rm -rf /var/lib/apt/lists/*

# Create virtual env (already activated in PATH)
RUN python -m venv $VENV_PATH

# Install Python runtime dependencies
WORKDIR /app
COPY pyproject.toml poetry.lock ./
RUN poetry install --no-root --no-dev


# --- DEV IMAGE WITH ADDITIONAL DEPENDENCIES --- #
FROM build as dev

# Install additional dependencies
RUN poetry install --no-root

# Copy all tests, scripts, settings, etc. and do editable install
COPY . .
RUN poetry install

CMD gunicorn autopoetry.main:app \
    --worker-class uvicorn.workers.UvicornWorker \
    --bind=0.0.0.0:$PORT


# --- BUILD IMAGE WITH LOCAL PACKAGE --- #
FROM build AS build-full

# Copy local package and install it
COPY src/ src/
RUN poetry build && pip install dist/*.whl


# --- MINIMAL RELEASE IMAGE --- #
FROM base as release

# Copy pre-built app and dependencies from build image
COPY --from=build-full $VENV_PATH $VENV_PATH

# Run as non-root user
ARG USER=app
ARG UID=777
ARG GID=777
RUN groupadd --system --gid $GID $USER \
 && useradd \
    --system \
    --no-log-init \
    --uid $UID \
    --gid $GID \
    $USER
USER $USER

CMD gunicorn autopoetry.main:app \
    --worker-class uvicorn.workers.UvicornWorker \
    --bind=0.0.0.0:$PORT
