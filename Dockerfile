ARG KEYCLOAK_VERSION=26.0.7
FROM quay.io/keycloak/keycloak:$KEYCLOAK_VERSION as builder

# See https://www.keycloak.org/server/containers
# For Dockerfile and build documentation

# Refer to https://www.keycloak.org/server/all-config
# for a complete lits of all built options and confoguration for keycloak


WORKDIR /opt/keycloak

# For demonstration purposes only,
# please make sure to use proper certificates in production instead
RUN keytool \
    -genkeypair \
    -storepass password \
    -storetype PKCS12 \
    -keyalg RSA \
    -keysize 2048 \
    -dname "CN=server" \
    -alias server \
    -ext "SAN:c=DNS:localhost,IP:127.0.0.1" \
    -keystore conf/server.keystore

# Enable health and metrics support
# We do this as a build-time option (and set the variables in the final image later)
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true
# By default, the new Quarkus distribution removes /auth from the context-path.
# Restore it with KC_HTTP_RELATIVE_PATH
ENV KC_HTTP_RELATIVE_PATH=/auth
# Configure a database vendor
ENV KC_DB=postgres

# Now 'build the image', which will use any ENV values we've set.
# For example, health and metrics are a built-time option.
RUN /opt/keycloak/bin/kc.sh build

# Second stage...

FROM quay.io/keycloak/keycloak:$KEYCLOAK_VERSION
COPY --from=builder /opt/keycloak/ /opt/keycloak/

# Our configuration over-rides. For a comprehensive list of all configuration options
# see https://www.keycloak.org/server/all-config#category-hostname_v2.
#
# We use a postgres database where the database is called 'keycloak'.
# The DB URL is in our namespace, on a Service called database,
# and the username/owner is 'keycloak'.
# The user is expected to provide the keycloak hostname
#
ENV KC_DB=postgres
ENV KC_DB_URL=jdbc:postgresql://database/keycloak
ENV KC_DB_USERNAME=keycloak
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true
ENV KC_PROXY_HEADERS=xforwarded
# The following has (allegedly) been removed
# but we cannot run keycloak without connection refused issues
# onm the probes without setting it
ENV KC_PROXY=edge
# If we set this we can debug hostname issues
# Using the expected hostname at <HOSTNAME>/auth/realms/master/hostname-debug/
#ENV KC_HOSTNAME_DEBUG=true

ENV KEYCLOAK_ADMIN=admin

# Copy themes into the image
COPY themes/ /opt/keycloak/themes/

# At run-time set the following: -
# - KC_HOSTNAME
# - KC_DB_PASSWORD
# - KEYCLOAK_ADMIN_PASSWORD

ENTRYPOINT [ \
    "/opt/keycloak/bin/kc.sh", \
    "start", \
    "--optimized", \
    "--spi-login-protocol-openid-connect-legacy-logout-redirect-uri=true" \
    ]
