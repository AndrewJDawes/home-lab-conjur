FROM cyberark/conjur AS base

# Install Tini if not already included
RUN apt-get update && apt-get install -y tini

# Add your entrypoint script
COPY src /
RUN chmod +x /usr/local/bin/entrypoint.sh

# Use Tini as the ENTRYPOINT
ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/entrypoint.sh"]

HEALTHCHECK CMD ["conjurctl", "wait"]
