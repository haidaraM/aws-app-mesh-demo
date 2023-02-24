# Tests

This folder contains some tests to be run from Jetbrains's IDE HTTP client. You need to define an environment file
containing the endpoint after you have successfully deployed the project. It gives some idea on what to expect after
successfully deploying the application.

Example: `http-client.private.env.json`

````json
{
  "dev": {
    "endpoint": "https://demo-app-mesh.domain.com"
  }
}
````
