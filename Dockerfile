# syntax=docker/dockerfile:1
FROM python:3.8.0-alpine
WORKDIR /code
RUN apk update && apk add postgresql-dev gcc python3-dev musl-dev
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt
COPY . .
CMD ["python", "load_data.py"]