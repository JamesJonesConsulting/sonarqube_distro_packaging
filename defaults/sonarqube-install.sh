#!/usr/bin/env bash
set -euo pipefail

SERVICE_USER="sonarqube"
SERVICE_GROUP="sonarqube"
SONARQUBE_HOME="/opt/sonarqube"
SERVICE_SHELL="/sbin/nologin"

# Create the system group if it does not already exist.
if ! getent group "${SERVICE_GROUP}" >/dev/null 2>&1; then
    groupadd --system "${SERVICE_GROUP}"
fi

# Create the system user if it does not already exist.
if ! getent passwd "${SERVICE_USER}" >/dev/null 2>&1; then
    useradd \
        --system \
        --gid "${SERVICE_GROUP}" \
        --home-dir "${SONARQUBE_HOME}" \
        --shell "${SERVICE_SHELL}" \
        --comment "SonarQube service account" \
        "${SERVICE_USER}"
else
    # Ensure an existing account uses the expected group, home, and shell.
    usermod \
        --gid "${SERVICE_GROUP}" \
        --home "${SONARQUBE_HOME}" \
        --shell "${SERVICE_SHELL}" \
        "${SERVICE_USER}"
fi

# Ensure the installation directory exists.
install -d \
    -o "${SERVICE_USER}" \
    -g "${SERVICE_GROUP}" \
    -m 0755 \
    "${SONARQUBE_HOME}"

# SonarQube must be able to write to its runtime directories.
for directory in \
    "${SONARQUBE_HOME}/data" \
    "${SONARQUBE_HOME}/logs" \
    "${SONARQUBE_HOME}/temp"
do
    install -d \
        -o "${SERVICE_USER}" \
        -g "${SERVICE_GROUP}" \
        -m 0750 \
        "${directory}"
done

# Ensure the installed SonarQube files are readable by the service account.
chown -R "${SERVICE_USER}:${SERVICE_GROUP}" "${SONARQUBE_HOME}"

chmod +x /opt/sonarqube/bin/linux-x86-64/sonar.sh
systemctl daemon-reload
sysctl --system
firewall-cmd --permanent --add-service=https
firewall-cmd --reload

exit 0
