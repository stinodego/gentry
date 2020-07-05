FROM python:3.8-slim

COPY requirements.txt /requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

RUN mkdir /app
COPY . /app
WORKDIR /app

EXPOSE 8000

CMD ["uvicorn", "main:app", "--reload"]
