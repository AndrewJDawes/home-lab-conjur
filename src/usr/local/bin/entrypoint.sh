#!/usr/bin/env bash
set -e

# assert that CONJUR_ADMIN_ACCOUNT is set
if [ -z "$CONJUR_ADMIN_ACCOUNT" ]; then
    echo "CONJUR_ADMIN_ACCOUNT is not set. Exiting..."
    exit 1
fi

# assert that CONJUR_ADMIN_PASSWORD is set
if [ -z "$CONJUR_ADMIN_PASSWORD" ]; then
    echo "CONJUR_ADMIN_PASSWORD is not set. Exiting..."
    exit 1
fi

# Start the service in the background
echo "Starting the service..."
conjurctl server &

# Get the PID of the service
SERVICE_PID=$!

# Wait for the service to be ready (e.g., polling a health check or checking a port)
echo "Waiting for the service to be ready..."
# while ! nc -z localhost 80; do
#     sleep 1
# done
conjurctl wait
echo "Service is ready!"

# Run the CLI command
echo "Running the CLI command..."
echo -n "${CONJUR_ADMIN_PASSWORD}" | conjurctl account create --password-from-stdin --name "${CONJUR_ADMIN_ACCOUNT} || echo "Failed to create account""

# Stop the service
echo "Stopping the service..."
kill "$SERVICE_PID"

conjurctl server
# Keep the service running
# echo "Keeping the service running..."
# wait "$SERVICE_PID"
