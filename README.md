# Continuous integration and deployment on Raspberry Pi
A tutorial on continuous integration and deployment on Raspberry Pi machine. This tutorial targets to connect the dots to have successful CI/CD pipeline for an application. 
In this tutorial, we're building a minimal flask application which can be deployed to our Raspberry Pi machine with just a push to GitHub repo.

[Detailed blog](https://peeushagarwal.medium.com/raspberry-pi-a-web-server-with-ci-cd-pipeline-fd077b3be63a)

## Pre-requisites

1. A GitHub repository where you can host your source code and then use GitHub actions to push the code to Raspberry Pi.
2. Raspberry Pi setup so that we can connect to it using `SSH` from a dev machine.
3. A stable internet connection, which I'm sure you have as you're reading this page.

Let's start!

## Getting started

1. Create a folder into a local machine
   ```shell
   mkdir rpi-cd-tutorial && cd rpi-cd-tutorial
   ```
2. Clone this GitHub repository into a local machine
   ```shell
   git clone https://github.com/peeush-agarwal/rpi-cd-tutorial.git
   ```
3. Create a virtual environment and then activate it
   ```shell
   python3 -m venv rpi-dev
   source rpi-dev/bin/activate
   ```
4. Change directory to `src/` by running
   ```shell
   cd src
   ```
5. Install the dependencies by running
   ```shell
   python3 -m pip install -r requirements.txt
   ```
6. Test the flask application using the following steps:
   ```shell
   export FLASK_APP=app.py
   flask run --host=0.0.0.0
   ```
7. Browse the url [http://127.0.0.1:5000/](http://127.0.0.1:5000/) in the browser. If you see `Welcome to the Raspberry Pi web application!` in the browser, then your Flask application is running successfully. Otherwise, check for errors in the terminal where you ran commands in Step 6.
8. Now, we have our Flask application tested locally, we would like to build a docker container.
   ```shell
   docker build -t rpi-cd-tutorial .
   ```
9. Run the docker container
   ```shell
   docker run -p4000:4000 rpi-cd-tutorial
   ```
10. Browse the url [http://127.0.0.1:4000/](http://127.0.0.1:4000/) in the browser. If you see `Welcome to the Raspberry Pi web application!` in the browser, then the docker container is running successfully. Otherwise, check for errors in the terminal where you ran commands in Step 9.
11. Now, we have our Docker container tested locally, we would like to host it on the Raspberry Pi.
12. Push the source code to your GitHub repository, a new GitHub Action deployment will start on the Raspberry Pi machine.
13. Once the request has been processed in the Raspberry Pi, open another terminal in Raspberry Pi via SSH and run command:
    ```shell
    docker ps
    ```
    If you see the docker container with image name 'rpi-cd-tutorial:xxx', then the setup is successful.
14. You can try browse http://{Raspberry-Pi's IP address}:4000/ in the browser and check if you see `Welcome to the Raspberry Pi web application!`.
