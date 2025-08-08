# CONFIG.md

## Environment Variables

### Required Variables
```bash
# GPT API Integration (Required for --gpt-caption flag)
GPT_API_KEY=your-openai-api-key-here
GPT_BASE_URL=https://api.openai.com/v1
GPT_MODEL=gpt-4o-mini

# Model Configuration (Required for training)
MODEL_PATH=./path/to/pretrained/model
OUTPUT_DIR=./output/
DATA_ROOT=./data/

# Hardware Configuration
CUDA_VISIBLE_DEVICES=0                    # GPU device selection
PYTORCH_CUDA_ALLOC_CONF=max_split_size_mb:512
```

### Optional Variables
```bash
# Application Settings
GRADIO_SHARE=false                         # Share via public URL
GRADIO_PORT=7860                           # Port for Gradio interface
GRADIO_DEBUG=false                        # Debug mode

# Training Configuration
BATCH_SIZE=4                               # Training batch size
LEARNING_RATE=1e-4                         # Learning rate
NUM_EPOCHS=100                            # Number of training epochs
GRADIENT_CLIP_VAL=1.0                     # Gradient clipping

# Performance Tuning
TILE_SIZE=512                              # VAE tiling size
TILE_OVERLAP=64                            # Tile overlap
ENABLE_HALF_PRECISION=true                # FP16 precision

# Logging
LOG_LEVEL=INFO                            # Logging level
TENSORBOARD_DIR=./runs/                   # TensorBoard log directory
CHECKPOINT_INTERVAL=1000                  # Checkpoint save interval
```

## Application Configuration

### YAML Configuration Files

#### `configs/sd2_gradio.yaml` - Gradio Interface Configuration
```yaml
model:
  base_model_path: "stabilityai/stable-diffusion-2-1-base"
  checkpoint_path: "./checkpoints/hypir-sd2.ckpt"
  
interface:
  title: "HYPIR Image Restoration"
  description: "AI-powered image restoration using diffusion models"
  max_size: [1024, 1024]
  
processing:
  tile_size: 512
  tile_overlap: 64
  use_tiled_vae: true
  half_precision: true

captioning:
  enable_gpt_caption: true
  caption_length: 100
  temperature: 0.7
```

#### `configs/sd2_train.yaml` - Training Configuration
```yaml
data:
  train_data_root: "./data/train"
  valid_data_root: "./data/valid"
  batch_size: 4
  num_workers: 4
  
training:
  learning_rate: 1e-4
  num_epochs: 100
  gradient_clip_val: 1.0
  checkpoint_interval: 1000
  validation_interval: 100
  
model:
  base_model_path: "stabilityai/stable-diffusion-2-1-base"
  use_lora: true
  lora_rank: 16
  
optimization:
  use_amp: true
  find_unused_parameters: true
  gradient_accumulation_steps: 1
```

## Common Patterns <!-- #config-patterns -->

### Configuration Loading Pattern
```python
from omegaconf import OmegaConf

# Load configuration with environment variable override
config = OmegaConf.load("configs/sd2_gradio.yaml")
config_cli = OmegaConf.from_cli(args.config_args)
config = OmegaConf.merge(config, config_cli)
```

### Environment Variable Usage Pattern
```python
import os
from dotenv import load_dotenv

load_dotenv()

# Required environment variables
api_key = os.getenv("GPT_API_KEY")
if not api_key:
    raise ValueError("GPT_API_KEY environment variable is required")
```

### GPU Configuration Pattern
```python
import torch

# Configure GPU settings
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
if device.type == "cuda":
    torch.backends.cuda.matmul.allow_tf32 = True
    torch.backends.cudnn.allow_tf32 = True
```

## Keywords <!-- #keywords -->
configuration, environment variables, yaml settings, gpu optimization, model training, gradio interface, gpt api, performance tuning, memory management