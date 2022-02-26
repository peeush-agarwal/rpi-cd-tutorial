FROM python:3

WORKDIR /usr/src/app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN ls -l

ENTRYPOINT [ "./gunicorn_starter.sh" ]