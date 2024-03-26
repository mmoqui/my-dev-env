# My Dev Environment

Dockerfile to build a dev environment to work on the my-app-view project while running an Apache2 serving continuously the build output.

The idea here is the following:
- [`my-app-node`](https://github.com/mmoqui/my-app-node) is bootstrapped by a Docker container and listens for incoming HTTP requests.
- a container is spawn from the [`my-apache`](https://github.com/mmoqui/my-apache) Docker image to redirects any requests from [`my-app-view`](https://github.com/mmoqui/my-app-view) to [`my-app-node`](https://github.com/mmoqui/my-app-node). The HTML pages of the [`my-app-view`](https://github.com/mmoqui/my-app-view) are accessed through the running Apache container; they are located in a docker volume shared between the Apache container and the `my-dev-env` container.
- the `my-dev-env` container allows the dev to code the [`my-app-view`](https://github.com/mmoqui/my-app-view) application with _Visual Codium_. Any build with _npm_ generates the output into the dist directory that is mounted as a volume (in order to be share with the [`my-apache`](https://github.com/mmoqui/my-apache) container)
