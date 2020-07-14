FROM python:3.8-slim AS release

COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt \
 && rm /tmp/requirements.txt

ARG USER_ID=999
ARG GROUP_ID=999
RUN groupadd -r -g $GROUP_ID appuser \
 && useradd -r -l -u $USER_ID -g $GROUP_ID appuser
USER appuser

EXPOSE 8000

COPY poems/ /app/
WORKDIR /app/

CMD ["uvicorn", "main:app", "--reload"]
