#!/usr/bin/env bash
set -e

ENTRYPOINT_ERROR=false
# assert that CONJUR_ORG_ACCOUNT is set
if [ -z "$CONJUR_ORG_ACCOUNT" ]; then
    echo "CONJUR_ORG_ACCOUNT is required"
    ENTRYPOINT_ERROR=true
fi

# assert that CONJUR_ADMIN_USER_PASSWORD is set
if [ -z "$CONJUR_ADMIN_USER_PASSWORD" ]; then
    echo "CONJUR_ADMIN_USER_PASSWORD is required"
    ENTRYPOINT_ERROR=true
fi

# if ENTRYPOINT_ERROR is true, exit
if [ "$ENTRYPOINT_ERROR" = true ]; then
    exit 1
fi

# Start the service in the background
echo "Starting the service..."
conjurctl server &

# Get the PID of the service
SERVICE_PID=$!

# Wait for the service to be ready (e.g., polling a health check or checking a port)
echo "Waiting for the service to be ready..."
conjurctl wait
echo "Service is ready!"

# Run the CLI command
echo "Running the CLI command..."
echo -n "${CONJUR_ADMIN_USER_PASSWORD}" | (conjurctl account create --password-from-stdin --name "${CONJUR_ORG_ACCOUNT}" || echo "Failed to create account")

# Keep the service running
echo "Keeping the service running..."
wait "$SERVICE_PID"
