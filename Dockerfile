ARG KEYCLOAK_VERSION=26.0.5
FROM quay.io/keycloak/keycloak:$KEYCLOAK_VERSION as builder

# See https://www.keycloak.org/server/containers
# For Dockerfile and build documentation

# Refer to https://www.keycloak.org/server/all-config
# for a complete lits of all built options and confoguration for keycloak

# Enable health and metrics support
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true

# By default, the new Quarkus distribution removes /auth from the context-path.
# Restore it with KC_HTTP_RELATIVE_PATH
ENV KC_HTTP_RELATIVE_PATH=/auth

# Configure a database vendor
ENV KC_DB=postgres

WORKDIR /opt/keycloak

# For demonstration purposes only, please make sure to use proper certificates in production instead
RUN keytool -genkeypair -storepass password -storetype PKCS12 -keyalg RSA -keysize 2048 -dname "CN=server" -alias server -ext "SAN:c=DNS:localhost,IP:127.0.0.1" -keystore conf/server.keystore
RUN /opt/keycloak/bin/kc.sh build

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
ENV KC_PROXY_HEADERS=xforwarded
ENV KEYCLOAK_ADMIN=admin
# If we set this we can debug hostname issues
# Using the expected hostname at <HOSTNAME>/auth/realms/master/hostname-debug/
#ENV KC_HOSTNAME_DEBUG=true

# At run-time we expect and set the following: -
# - KC_HOSTNAME (e.g. keycloak.example.com)
# - KC_DB_PASSWORD
# - KEYCLOAK_ADMIN_PASSWORD

ENTRYPOINT [ \
    "/opt/keycloak/bin/kc.sh", \
    "start", \
    "--optimized", \
    "--spi-login-protocol-openid-connect-legacy-logout-redirect-uri=true" \
    ]
