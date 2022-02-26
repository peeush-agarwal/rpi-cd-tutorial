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
1. Clone this GitHub repository into a local machine
   ```shell
   git clone https://github.com/peeush-agarwal/rpi-cd-tutorial.git
   ```
2. Create a virtual environment and then activate it
   ```shell
   python3 -m venv rpi-dev
   source rpi-dev/bin/activate
   ```
3. Install the dependencies by running
   ```shell
   python3 -m pip install -r requirements.txt
   ```
4. Add your flask application code in `app.py` or other python scripts. For this tutorial, we have added minimal code to serve single Http request.
   ```python
   from flask import Flask

   app = Flask(__name__)

   @app.route('/')
   def home():
     return 'Welcome to the Flask Dev team!'

   ```
5. Test the flask application using the following steps:
   ```shell
   export FLASK_APP=app.py
   flask run --host=0.0.0.0
   ```
6. Browse the url [http://127.0.0.1:5000/](http://127.0.0.1:5000/) in the browser. If you see `Welcome to the Flask Dev team!` in the browser, then your Flask application is running successfully. Otherwise, check for errors in the terminal where you ran commands in Step 5.
7. Now, we have our Flask application tested locally, we would like to host it on the Raspberry Pi.
8. Push the source code to your GitHub repository.
9. In order to push our source code from GitHub to Raspberry Pi, we have to run Raspberry Pi as [self-hosted runner](https://docs.github.com/actions/hosting-your-own-runners/about-self-hosted-runners) and tell GitHub to access it. We can make our Raspberry Pi as self-hosted runner by running few commands, which we get from GitHub itself. Follow these steps:
   1. Go to your GitHub repository in the browser
   2. Click on "Settings" tab of your repository
   3. Click on "Actions > Runners" menu item in the left
   4. Click on "New self-hosted runner" green button
   5. Select `Linux` under "Runner image"
   6. Select "ARM64" in dropdown list under "Architecture"
   7. Follow the commands under "Download", "Configure", "Using your self-hosted runner" into your raspberry pi via SSH
   8. In the end, you'll have your Raspberry Pi listening for incoming requests as part of GitHub Actions
10. Create `.github/workflows/main.yml` file
    ```shell
    mkdir .github/workflows
    touch main.yml
    ```
11. Add the following content to the `.github/workflows/main.yml` file
    ```yaml
    # This is a basic workflow to help you get started with Actions
    name: Deploy to Raspberry Pi
    # Controls when the workflow will run
    on:
        # Triggers the workflow on push or pull request events but only for the main branch
        push:
            branches: [ main ]

    # Allows you to run this workflow manually from the Actions tab
    workflow_dispatch:

    env:
        FLASK_APP: app.py

    # A workflow run is made up of one or more jobs that can run sequentially or in parallel
    jobs:
        # This workflow contains a single job called "build"
        build:
            # The type of runner that the job will run on
            runs-on: self-hosted

            # Steps represent a sequence of tasks that will be executed as part of the job
            steps:
                # Checks-out your repository under $GITHUB_WORKSPACE, so your job can access it
                - uses: actions/checkout@v2

                # Setup virtual env, install dependencies
                - name: Create new virtual env and activate it
                    run: |
                        python3 -m venv flask-env
                        source flask-env/bin/activate
                        python3 -m pip install -r requirements.txt
                        python3 -m pip install gunicorn

        deploy:
            runs-on: self-hosted
            needs: build
            
            steps:
                # Kill gunicorn server, if running already
                - name: Kill gunicorn
                    run: pkill gunicorn || true

                # Run gunicorn server
                - name: Run gunicorn
                    run: |
                        source flask-env/bin/activate
                        RUNNER_TRACKING_ID=""
                        gunicorn -w 1 -b 0.0.0.0:4000 app:app -D --log-file=gunicorn.log
    ```
12. Push the changes to the GitHub repository. This should trigger a GitHub action and you can see Raspberry Pi processing the request.
13. Once the request has been processed in the Raspberry Pi, open another terminal in Raspberry Pi via SSH and run command:
    ```shell
    ps -ef | grep "gunicorn"
    ```
    If you see more than 1 line results, then the setup is successful.
14. You can try browse http://{Raspberry-Pi's IP address}:4000/ in the browser and check if you see `Welcome to the Flask Dev team!`. 
15. To test CI/CD pipeline, make a change in `app.py` by adding extra msg in the request handler and push the changes. After the request is completed on Raspberry Pi's terminal, repeat Step 14 and you should see updated message.
16. That way you can build actual Flask application and host it on Raspberry Pi with the help of GitHub actions.
