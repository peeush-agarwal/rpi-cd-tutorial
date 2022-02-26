#!/bin/sh
gunicorn -w 1 -b 0.0.0.0:4000 app:app