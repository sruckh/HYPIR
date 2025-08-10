FROM runpod/pytorch:2.8.0-py3.11-cuda12.8.1-cudnn-devel-ubuntu22.04

# Install git and curl for the setup script
RUN apt-get update && apt-get install -y git curl && rm -rf /var/lib/apt/lists/*

# Copy the entrypoint script and make it executable
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set the entrypoint to run the setup script
ENTRYPOINT ["/entrypoint.sh"]

# The CMD is now part of the entrypoint script
CMD []