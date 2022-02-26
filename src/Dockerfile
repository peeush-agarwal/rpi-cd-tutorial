# FROM ubuntu:latest
FROM python:3.7-slim-buster

RUN apt-get update -y
# RUN apt-get install python3-pip python3-dev build-essential vim -y
RUN apt-get install build-essential -y

COPY . /hello_world
WORKDIR /hello_world

EXPOSE 8003

RUN pip install -r requirements.txt

RUN ls -l

ENTRYPOINT ["./gunicorn_starter.sh"]