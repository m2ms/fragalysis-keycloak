# The InformaticsMatters keycloak container image

![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/informaticsmatters/docker-keycloak)

[![build](https://github.com/InformaticsMatters/docker-keycloak/actions/workflows/build.yaml/badge.svg)](https://github.com/InformaticsMatters/docker-keycloak/actions/workflows/build.yaml)
[![tag](https://github.com/InformaticsMatters/docker-keycloak/actions/workflows/tag.yaml/badge.svg)](https://github.com/InformaticsMatters/docker-keycloak/actions/workflows/tag.yaml)

A specialised build of keycloak used by a number of InformaticsMatters projects.

Refer to to the keycloak [container documentation] for background information.

## Building and pushing
To build and push using the currently endorsed keyclock base image...

    docker build . -t informaticsmatters/keycloak:stable
    docker push informaticsmatters/keycloak:stable

To build and push using a specific keycloak base image, like `18.0.0`...

    KEYCLOAK_VERSION=18.0.0
    docker build . -t informaticsmatters/keycloak:${KEYCLOAK_VERSION} \
        --build-arg KEYCLOAK_VERSION=${KEYCLOAK_VERSION}
    docker push informaticsmatters/keycloak:${KEYCLOAK_VERSION}

---

[container documentation]: https://www.keycloak.org/server/containers
