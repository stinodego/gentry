FROM python:3.8-slim AS base

# Set useful Python/pip/poetry settings
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100 \
    POETRY_VIRTUALENVS_IN_PROJECT=true \
    POETRY_NO_INTERACTION=1 \
    POETRY_HOME=/opt/poetry \
    PYSETUP_PATH=/opt/pysetup
ENV VENV_PATH=$PYSETUP_PATH/.venv

# Activate poetry command and virtual env
ENV PATH="$POETRY_HOME/bin:$VENV_PATH/bin:$PATH"


FROM base AS build

# Install system dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
    curl \
 && rm -rf /var/lib/apt/lists/*

# Install Poetry
RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python

# Install Python runtime dependencies
WORKDIR $PYSETUP_PATH
COPY pyproject.toml poetry.lock ./
RUN poetry install --no-root --no-dev

# Install local package
COPY src/ src/
RUN poetry build && $VENV_PATH/bin/pip install dist/*.whl


FROM base as dev

# Copy Poetry and venv into image
COPY --from=build $POETRY_HOME $POETRY_HOME
COPY --from=build $VENV_PATH $VENV_PATH

# Install Python dev dependencies
WORKDIR $PYSETUP_PATH
COPY pyproject.toml poetry.lock ./
RUN poetry install --no-root

# Editable install of local package
COPY . .
RUN poetry install

EXPOSE 8000

CMD ["uvicorn", "main:app", "--host=0.0.0.0", "--port=8000", "--reload"]


FROM base as release

COPY --from=build $VENV_PATH $VENV_PATH

WORKDIR $VENV_PATH/lib/python3.8/site-packages/poems

# WORKDIR /app
# COPY src/poems/main.py ./
# COPY src/poems/static/ ./static/
# COPY src/poems/templates/ ./templates/

ARG USER_ID=999
ARG GROUP_ID=999
RUN groupadd -r -g $GROUP_ID appuser \
 && useradd -r -l -u $USER_ID -g $GROUP_ID appuser
USER appuser

EXPOSE 8000

CMD ["uvicorn", "main:app", "--host=0.0.0.0", "--port=8000", "--reload"]
