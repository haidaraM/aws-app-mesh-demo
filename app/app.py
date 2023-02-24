#!/usr/bin/env python3
import logging
import os
from os import getenv
from typing import Dict, Tuple

import requests
from flask import Flask, request, Blueprint

logging.basicConfig(level=logging.INFO)
app = Flask(__name__)

WHO_AM_I = os.getenv("WHO_AM_I", "localhost")
IS_STILL_HEALTHY = True

bp = Blueprint('my-app', __name__)


def _get_metadata() -> Tuple[Dict, Dict, Dict]:
    # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-metadata-endpoint-v4.html
    metadata_endpoint = getenv("ECS_CONTAINER_METADATA_URI_V4", None)
    if metadata_endpoint is None:
        return {"msg": "Not running on ECS"}, {}, {}

    # https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-metadata-endpoint-v4.html#task-metadata-endpoint-v4-response
    container_json_response = requests.get(f"{metadata_endpoint}").json()
    task_metadata_json_response = requests.get(f"{metadata_endpoint}/task").json()
    task_family = container_json_response["Labels"]["com.amazonaws.ecs.task-definition-family"]
    task_revision = container_json_response["Labels"]["com.amazonaws.ecs.task-definition-version"]

    metadata = {
        "service_version": f"{task_family}:{task_revision}",
        "image": container_json_response["Image"],
        "task_id": container_json_response["DockerId"].split("-")[0],
    }
    return metadata, container_json_response, task_metadata_json_response


@bp.get("/meta")
def all_metadata():
    """
    Return all metadata
    :return:
    """
    _, container_data, task_data = _get_metadata()

    return {
        "container": container_data,
        "task": task_data
    }


@app.get("/healthcheck")
def health_check():
    """
    Healthcheck for the service
    :return:
    """
    if IS_STILL_HEALTHY:
        return {"status_code": "OK", "who": WHO_AM_I}
    else:
        return {"status_code": "KO", "who": WHO_AM_I}, 503


@bp.get("/headers")
def request_headers():
    """
    Return all the headers received in the incoming request
    :return:
    """
    headers = {h[0]: h[1] for h in request.headers}
    return headers


@bp.post("/make-unhealthy")
def make_unhealthy():
    """
    Make the service unhealthy
    :return:
    """

    app.logger.warning(f"Making the service unhealthy")
    global IS_STILL_HEALTHY
    IS_STILL_HEALTHY = False
    return {"message": f"Successfully made unhealthy..."}


@bp.get("/")
def hello():
    metadata, _, _ = _get_metadata()
    return f"""
<!doctype html>
<html lang="en">
  <head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">

    <title> AWS App Mesh Service {WHO_AM_I}  </title>
  </head>
  <body>
  
  <main role="main" class="container">
  <h1 class="text-center">AppMesh Service {WHO_AM_I}</h1>
  <ul class="list-group text-center">
    <li class="list-group-item">ECS Task definition: <strong> {metadata.get('service_version', None)}</strong></li>
    <li class="list-group-item">Task Hostname: <strong>{os.environ.get("HOSTNAME", "")}</strong> </li>
    <li class="list-group-item">Talks to: <strong>{os.environ.get("TALKS_TO", "")}</strong> </li>
    <li class="list-group-item">ECS Task ID: <strong> {metadata.get('task_id', None)} </strong> </li>
    <li class="list-group-item">Image: <strong>{metadata.get('image', None)}</strong> </li>
  </ul>
  </main>
    

    <!-- Optional JavaScript -->
    <!-- jQuery first, then Popper.js, then Bootstrap JS -->
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
  </body>
</html>
    """


if __name__ == "__main__":
    app.logger.info(f"Running as '{WHO_AM_I}'...")
    base_path = os.environ.get("BASE_PATH", "")

    app.logger.info(f"Using as '{base_path}' as prefix")
    app.register_blueprint(bp, url_prefix=base_path)
    # Note: do NOT do this in a production environment and use dedicated WSGI server https://flask.palletsprojects.com/en/2.2.x/deploying/
    app.run(host="0.0.0.0")
