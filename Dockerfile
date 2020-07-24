# --- BASE IMAGE WITH USEFUL ENVS --- #
FROM python:3.8-slim AS base

# Nice-to-have optimizations
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100 \
# Required settings
    POETRY_VIRTUALENVS_CREATE=false \
    POETRY_HOME=/opt/poetry \
    VENV_PATH=/opt/venv

# Set path for using poetry and virtual env
ENV PATH="$VENV_PATH/bin:$POETRY_HOME/bin:$PATH"


# --- BUILD IMAGE WITH RUNTIME DEPENDENCIES --- #
FROM base AS build

# Install system dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
    curl \
 && rm -rf /var/lib/apt/lists/*

# Install Poetry
RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python

# Create virtual env (already activated in PATH)
RUN python -m venv $VENV_PATH

# Install Python runtime dependencies
WORKDIR /app
COPY pyproject.toml poetry.lock ./
RUN poetry install --no-root --no-dev

# Install local package (poetry does not support non-editable installs yet)
COPY src/ src/
RUN poetry build && pip install dist/*.whl


# --- DEV IMAGE WITH ADDITIONAL DEPENDENCIES --- #
FROM base as dev

# Copy dependencies from build image
COPY --from=build $POETRY_HOME $POETRY_HOME
COPY --from=build $VENV_PATH $VENV_PATH
COPY --from=build /app /app

# Install additional dependencies and editable local package
WORKDIR /app
RUN poetry install

# Copy all test, scripts, settings, etc.
COPY . .

EXPOSE 8000

CMD ["uvicorn", "poems.main:app", "--host=0.0.0.0", "--port=8000", "--reload"]


# --- MINIMAL RELEASE IMAGE --- #
FROM base as release

COPY --from=build $VENV_PATH $VENV_PATH

# Run as non-root user
ARG USER_ID=999
ARG GROUP_ID=999
RUN groupadd -r -g $GROUP_ID appuser \
 && useradd -r -l -u $USER_ID -g $GROUP_ID appuser
USER appuser

EXPOSE 8000

CMD ["uvicorn", "poems.main:app", "--host=0.0.0.0", "--port=8000", "--reload"]
