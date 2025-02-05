# The InformaticsMatters keycloak container image

![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/informaticsmatters/docker-keycloak)

[![build](https://github.com/InformaticsMatters/docker-keycloak/actions/workflows/build.yaml/badge.svg)](https://github.com/InformaticsMatters/docker-keycloak/actions/workflows/build.yaml)
[![release](https://github.com/InformaticsMatters/docker-keycloak/actions/workflows/release.yaml/badge.svg)](https://github.com/InformaticsMatters/docker-keycloak/actions/workflows/release.yaml)

A specialised build of keycloak used by a number of InformaticsMatters projects.

Refer to to the keycloak [container documentation] for background information.

## Custom theme settings
To highlight an identitiy provider link and show it as a button suffix its alias with `-highlight` or name the alias as `diamond`

## Building and pushing
To build and push using the currently endorsed keyclock base image...

    docker build . -t informaticsmatters/keycloak:stable
    docker push informaticsmatters/keycloak:stable

To build and push using a specific keycloak base image, like `26.0.5`...

    KEYCLOAK_VERSION=26.0.5
    docker build . -t informaticsmatters/keycloak:${KEYCLOAK_VERSION} \
        --build-arg KEYCLOAK_VERSION=${KEYCLOAK_VERSION}
    docker push informaticsmatters/keycloak:${KEYCLOAK_VERSION}

## Theme development
A docker compose file is provided to allow you to run a keycloak instance
with a database and a volume mounted for theme development. The compose file
will start a keycloak instance with a postgres database. For further information
and basic instruction on getting started read the comments inside the
theme development docker compose file: -

- docker-compose-theme-development.yaml

And, for instructions on how to develop themes, read the
[Keycloak theme development] documentation.

---

[container documentation]: https://www.keycloak.org/server/containers
[keycloak theme development]: https://www.keycloak.org/docs/latest/server_development/index.html#_themes
