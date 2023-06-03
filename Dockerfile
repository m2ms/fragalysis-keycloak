ARG KEYCLOAK_VERSION=21.1.1
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

# Our built-in defaults
ENV KC_DB=postgres
ENV KC_DB_URL=jdbc:postgresql://database/keycloak
ENV KC_DB_USERNAME=keycloak
ENV KC_PROXY=edge
ENV KEYCLOAK_ADMIN=admin
ENV KC_HOSTNAME_STRICT=false
# At run-time set the folllowing: -
# - KC_DB_PASSWORD
# - KEYCLOAK_ADMIN_PASSWORD

ENTRYPOINT \
    "/opt/keycloak/bin/kc.sh" \
    " start" \
    " --optimized" \
    " --spi-login-protocol-openid-connect-legacy-logout-redirect-uri=true"
