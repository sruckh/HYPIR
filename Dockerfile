# Use Python 3.10-slim as specified in goals
FROM python:3.10-slim

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV PATH="/workspace/HYPIR:${PATH}"
ENV HOME=/workspace/HYPIR
ENV CUDA_HOME=/usr/local/cuda

# Install system dependencies including curl for health checks
RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    build-essential \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libgomp1 \
    && rm -rf /var/lib/apt/lists/*

# Create workspace directory as specified in goals
WORKDIR /workspace/HYPIR

# Copy requirements first for better layer caching
COPY requirements.txt .

# Install Python dependencies and linting tools
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt && \
    pip install --no-cache-dir pylint flake8

# Copy the entire project to workspace
COPY . .

# Set permissions
RUN chmod +x app.py train.py test.py predict.py

# Create directories for outputs and models
RUN mkdir -p /workspace/HYPIR/models /workspace/HYPIR/outputs /workspace/HYPIR/temp

# Expose port 7860 for Gradio
EXPOSE 7860

# Health check for the application
HEALTHCHECK --interval=30s --timeout=30s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:7860/ || exit 1

# Set default command to use environment variable for share option
CMD ["sh", "-c", "python app.py --config configs/sd2_gradio.yaml --local --device cuda ${SHARE_OPTION:+--share}"]