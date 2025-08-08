# HYPIR Container Deployment Guide

This guide covers deploying HYPIR using Docker containers, specifically optimized for RunPod deployment.

## Quick Start

### Local Development

1. **Clone the repository:**
   ```bash
   git clone git@github.com:sruckh/HYPIR.git
   cd HYPIR
   ```

2. **Set up environment variables:**
   ```bash
   cp .env.example .env
   # Edit .env with your settings
   ```

3. **Build and run with Docker Compose:**
   ```bash
   docker-compose up -d
   ```

4. **Access the application:**
   - Local: http://localhost:7860
   - With share link: Use `docker-compose --profile shared up -d` for port 7861

### RunPod Deployment

1. **Build the Docker image:**
   ```bash
   docker build -t gemneye/hypir:latest .
   ```

2. **Push to Docker Hub:**
   ```bash
   docker push gemneye/hypir:latest
   ```

3. **Deploy to RunPod:**
   - Use the `gemneye/hypir:latest` image
   - Set environment variables:
     - `GRADIO_SHARE_LINK=true` (for public access)
     - `CUDA_VISIBLE_DEVICES=0`
   - Expose port 7860
   - Mount volumes for models and outputs as needed

## Configuration

### Environment Variables

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `GRADIO_SHARE_LINK` | Enable Gradio share link | `false` | No |
| `GRADIO_PORT` | Gradio port number | `7860` | No |
| `CUDA_VISIBLE_DEVICES` | GPU device selection | `0` | No |
| `GPT_API_KEY` | OpenAI API key for captioning | - | No |
| `GPT_BASE_URL` | OpenAI base URL | - | No |
| `GPT_MODEL` | GPT model for captioning | `gpt-4o-mini` | No |

### Volume Mounts

For persistent storage, mount these volumes:

```bash
# Models directory
-v /path/to/models:/workspace/HYPIR/models

# Outputs directory
-v /path/to/outputs:/workspace/HYPIR/outputs

# Configurations
-v /path/to/configs:/workspace/HYPIR/configs
```

### Model Configuration

1. **Download the HYPIR model:**
   ```bash
   wget https://huggingface.co/lxq007/HYPIR/resolve/main/HYPIR_sd2.pth -O ./models/HYPIR_sd2.pth
   ```

2. **Update configuration:**
   Edit `configs/sd2_gradio.yaml` and set:
   ```yaml
   weight_path: /workspace/HYPIR/models/HYPIR_sd2.pth
   ```

## Development

### Building the Container

```bash
# Build for current platform
docker build -t hypir:latest .

# Build for multiple platforms
docker buildx build --platform linux/amd64,linux/arm64 -t gemneye/hypir:latest .

# Build with BuildKit optimizations
DOCKER_BUILDKIT=1 docker build -t hypir:latest .
```

### Testing Locally

```bash
# Test with Docker Compose
docker-compose up hypir-app

# Test with shared link
docker-compose --profile shared up hypir-app-shared

# Test individual commands
docker run --rm -p 7860:7860 \
  -v $(pwd)/configs:/workspace/HYPIR/configs \
  -v $(pwd)/models:/workspace/HYPIR/models \
  gemneye/hypir:latest \
  python app.py --config configs/sd2_gradio.yaml --local --device cuda
```

### Linting and Quality

```bash
# Run linting locally
flake8 .
pylint HYPIR/ --errors-only

# Run linting with Docker
docker run --rm -v $(pwd):/workspace hypir:latest flake8 .
docker run --rm -v $(pwd):/workspace hypir:latest pylint HYPIR/ --errors-only
```

## CI/CD

### GitHub Actions

The project includes automated CI/CD workflows:

1. **Automatic building** on push to `main` or `develop` branches
2. **Docker Hub deployment** using GitHub secrets
3. **Code linting** with flake8 and pylint
4. **Security scanning** with Trivy
5. **Multi-platform builds** for `linux/amd64` and `linux/arm64`

### Required GitHub Secrets

- `DOCKER_USERNAME`: Docker Hub username
- `DOCKER_PASSWORD`: Docker Hub password/API token

### Manual Trigger

```bash
# Trigger workflow manually
gh workflow run docker.yml

# Monitor workflow progress
gh run watch --job <job-id>
```

## Troubleshooting

### Common Issues

1. **CUDA out of memory:**
   - Reduce `patch_size` and `stride` in the UI
   - Use smaller batch sizes
   - Ensure GPU has sufficient memory

2. **Model loading errors:**
   - Verify model path in configuration
   - Check model file integrity
   - Ensure sufficient disk space

3. **Docker build failures:**
   - Clear Docker cache: `docker system prune`
   - Check Docker daemon status
   - Verify internet connectivity

4. **Port conflicts:**
   - Change port in docker-compose.yml
   - Check existing processes on port 7860

### Logs and Monitoring

```bash
# View container logs
docker logs hypir-app

# Monitor in real-time
docker logs -f hypir-app

# Check container status
docker ps
docker stats
```

### Performance Optimization

1. **Use GPU acceleration:**
   - Ensure CUDA_VISIBLE_DEVICES is set
   - Use nvidia-docker runtime
   - Monitor GPU usage with `nvidia-smi`

2. **Optimize memory usage:**
   - Use appropriate patch sizes
   - Clear cache between runs
   - Monitor memory usage

3. **Network optimization:**
   - Use CDN for model downloads
   - Configure timeout settings
   - Use caching for static assets

## Support

For issues or questions:
- GitHub Issues: https://github.com/sruckh/HYPIR/issues
- Container Support: Check logs and troubleshoot using the guide above
- RunPod Support: https://runpod.io/support

## License

This project is licensed for non-commercial use only. See LICENSE file for details.