# We need to add arm64v8 architecture type to run it on RaspberryPi or other ARM based devices
FROM arm64v8/python:3

WORKDIR /usr/src/app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN ls -l

ENTRYPOINT [ "./gunicorn_starter.sh" ]
