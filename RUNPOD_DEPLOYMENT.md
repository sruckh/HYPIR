# HYPIR RunPod Deployment Guide

## Quick Start

1. **Deploy Container**: Use the built Docker image `gemneye/hypir:latest` on RunPod
2. **GPU Required**: Select any GPU-enabled template 
3. **Port**: The Gradio interface runs on port `7860`
4. **Access**: Once container starts, connect to the Gradio web interface

## How It Works

- **Container starts immediately** - No setup required
- **Models load automatically** - On first inference request
- **No manual intervention needed** - Everything happens at runtime

## Container Features

- ✅ **Lazy Loading**: Models download/load on first use
- ✅ **GPU Optimized**: Automatic CUDA detection and optimization  
- ✅ **Memory Efficient**: Multi-stage build reduces container size
- ✅ **Health Checks**: Built-in container health monitoring
- ✅ **Error Handling**: Graceful fallback if models unavailable

## Environment Variables (Optional)

- `MODEL_PATH`: Override default model path if you have custom weights
- `GRADIO_SHARE_LINK`: Set to "true" to enable Gradio sharing
- `GRADIO_SERVER_HOST`: Server host (defaults to 0.0.0.0 for containers)

## Expected Behavior

1. **Container Start**: ~30 seconds to start Gradio interface
2. **First Inference**: 2-5 minutes to download/load models (one-time)
3. **Subsequent Requests**: Fast inference (~10-30 seconds)

That's it! No additional setup required.