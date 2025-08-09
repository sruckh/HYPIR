# Stage 1: Build dependencies
FROM python:3.10-slim as builder

# Set build environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

# Create build workspace
WORKDIR /build

# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    wget \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Copy requirements first for better layer caching
COPY requirements.txt .

# Install Python dependencies to user directory for easy copying
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install --upgrade pip && \
    pip install --user --no-warn-script-location -r requirements.txt && \
    pip install --user --no-warn-script-location pylint flake8

# Stage 2: Runtime
FROM python:3.10-slim as runtime

# Set runtime environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PATH="/home/hypir/.local/bin:${PATH}" \
    HOME=/workspace/HYPIR \
    CUDA_HOME=/usr/local/cuda \
    MODEL_CACHE_DIR="/workspace/HYPIR/models" \
    OUTPUT_DIR="/workspace/HYPIR/outputs"

# Install only runtime system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender1 \
    libgomp1 \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Create non-root user with specific UID/GID for RunPod compatibility
RUN groupadd -r hypir -g 1000 && \
    useradd -r -g hypir -u 1000 -m -d /home/hypir hypir

# Create workspace directory and set ownership
WORKDIR /workspace/HYPIR
RUN chown hypir:hypir /workspace/HYPIR

# Switch to non-root user
USER hypir

# Copy Python packages from builder stage
COPY --from=builder --chown=hypir:hypir /root/.local /home/hypir/.local

# Copy application files with proper ownership
COPY --chown=hypir:hypir requirements.txt .
COPY --chown=hypir:hypir ./HYPIR ./HYPIR/
COPY --chown=hypir:hypir ./configs ./configs/
COPY --chown=hypir:hypir ./assets ./assets/
COPY --chown=hypir:hypir ./examples ./examples/
COPY --chown=hypir:hypir app.py predict.py train.py test.py ./

# Create directories for outputs and models with proper permissions
RUN mkdir -p /workspace/HYPIR/models /workspace/HYPIR/outputs /workspace/HYPIR/temp

# Set executable permissions for Python scripts
RUN chmod +x app.py predict.py train.py test.py

# Expose port 7860 for Gradio
EXPOSE 7860

# Health check - simple check if Gradio is responding
HEALTHCHECK --interval=30s --timeout=10s --start-period=90s --retries=3 \
    CMD curl -f http://localhost:7860/ || exit 1

# Set default command to run the Gradio app
CMD ["python", "app.py", "--config", "configs/sd2_gradio.yaml", "--device", "cuda"]