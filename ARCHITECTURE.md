# ARCHITECTURE.md

## Tech Stack

**Primary Language**: Python 3.8+
**Deep Learning Framework**: PyTorch 2.6.0 with CUDA support
**Diffusion Models**: Hugging Face Diffusers 0.32.2
**Web Interface**: Gradio 5.21.0
**Configuration**: OmegaConf 2.3.0 for YAML-based configuration
**Data Processing**: Polars 1.24.0 for high-performance data operations
**Model Training**: Accelerate 1.4.0 for multi-GPU training
**NLP Integration**: Transformers 4.49.0 for text processing
**Image Processing**: OpenCV-Python 4.11.0, Torchvision 0.21.0
**API Integration**: OpenAI 1.96.1 for GPT-based captioning
**Model Optimization**: Peft 0.14.0 for LoRA fine-tuning
**Evaluation Metrics**: LPiPS 0.1.4 for perceptual loss calculation

## Directory Structure
```
HYPIR/
├── app.py                    # Main Gradio web interface entry point
├── train.py                 # Training pipeline orchestration
├── predict.py               # Standalone inference script
├── test.py                  # Test suite and validation
├── requirements.txt         # Python dependencies
├── HYPIR/                   # Core library modules
│   ├── enhancer/           # Model enhancement and inference
│   │   ├── base.py         # Base enhancer class (lines 1-150)
│   │   └── sd2.py         # SD2-specific enhancer (lines 1-300)
│   ├── trainer/            # Training infrastructure
│   │   ├── base.py         # Base trainer class (lines 1-400)
│   │   └── sd2.py         # SD2-specific trainer (lines 1-350)
│   ├── model/              # Model architectures
│   │   ├── D.py           # Discriminator model (lines 1-200)
│   │   └── backbone.py    # Backbone networks (lines 1-250)
│   ├── dataset/            # Data processing utilities
│   │   ├── utils.py       # Dataset loading and processing (lines 1-300)
│   │   ├── batch_transform.py  # Batch transformations
│   │   ├── diffjpeg.py    # JPEG handling utilities
│   │   ├── file_backend.py  # File I/O backend
│   │   └── realesrgan.py  # Real-ESRGAN integration
│   └── utils/              # Helper utilities
│       ├── captioner.py    # GPT-based image captioning (lines 1-100)
│       ├── common.py      # Common utilities (lines 1-200)
│       ├── degradation.py # Image degradation simulation
│       ├── ema.py          # Exponential moving average
│       ├── tabulate.py     # Data table formatting
│       └── tiled_vae/     # Tiled VAE for memory efficiency
├── configs/                 # YAML configuration files
│   ├── sd2_gradio.yaml    # Gradio interface configuration
│   └── sd2_train.yaml     # Training configuration
├── examples/                # Example data and prompts
│   ├── lq/                 # Low-quality example images
│   └── prompt/             # Example prompts for captioning
├── assets/                  # Static assets and UI elements
│   ├── gallery_sd2/        # Gallery images for demo
│   ├── gradio.png
│   └── logo.png
└── memory/                  # Claude Flow memory storage
```

## Key Architectural Decisions

### Decision 1: Stable Diffusion 2.x Integration
**Context**: Need for state-of-the-art diffusion models for image restoration
**Decision**: Use Hugging Face Diffusers library with SD2.x models
**Rationale**: Stable Diffusion 2.x provides high-quality image generation with excellent community support and extensibility
**Consequences**: Larger model size but better restoration quality; requires GPU acceleration

### Decision 2: LoRA Fine-Tuning Support
**Context**: Need for efficient model fine-tuning with limited computational resources
**Decision**: Implement Parameter-Efficient Fine-Tuning (LoRA) via Peft library
**Rationale**: LoRA reduces trainable parameters by 90% while maintaining model quality
**Consequences**: Faster training, lower memory usage, but slightly more complex inference

### Decision 3: Tiled VAE Processing
**Context**: Memory limitations when processing high-resolution images
**Decision**: Implement tiled VAE processing in `HYPIR/utils/tiled_vae/`
**Rationale**: Enables processing of large images by splitting into smaller tiles, processing, then reassembling
**Consequences**: Allows larger image processing at cost of minor seam artifacts

### Decision 4: Configuration-Driven Architecture
**Context**: Need for reproducible experiments and easy parameter tuning
**Decision**: Use OmegaConf with YAML files for all configuration
**Rationale**: Centralized configuration management with type validation and environment variable support
**Consequences**: Easier experimentation but requires strict configuration file management

## Component Architecture

### SD2Enhancer Structure <!-- #sd2-enhancer-anchor -->
```python
# Major classes with exact line numbers
class SD2Enhancer { /* lines 1-300 */ }       # <!-- #sd2-enhancer-class -->
    __init__()                                    # Model initialization
    forward()                                    # Enhancement forward pass
    process_prompt()                             # Text prompt processing
```

### BaseTrainer Structure <!-- #base-trainer-anchor -->
```python
class BaseTrainer { /* lines 1-400 */ }     # <!-- #base-trainer-class -->
    __init__()                                    # Training setup
    train_step()                                 # Single training step
    validate()                                   # Validation step
    save_checkpoint()                            # Model checkpointing
```

### GPTCaptioner Structure <!-- #gpt-captioner-anchor -->
```python
class GPTCaptioner { /* lines 1-100 */ }    # <!-- #gpt-captioner-class -->
    generate_caption()                          # Generate image captions
    _call_gpt_api()                              # OpenAI API integration
```

### Dataset Utils Structure <!-- #dataset-utils-anchor -->
```python
class DatasetUtils { /* lines 1-300 */ }    # <!-- #dataset-utils-class -->
    load_dataset()                               # Dataset loading
    preprocess_image()                           # Image preprocessing
    create_dataloader()                          # Data loader creation
```

## System Flow Diagram
```
[User] -> [Frontend] -> [API] -> [Database]
           |            |
           v            v
       [Cache]     [External Service]
```

## Common Patterns

### [Pattern Name]
**When to use**: [Circumstances]
**Implementation**: [How to implement]
**Example**: [Code example with line numbers]

## Keywords <!-- #keywords -->
- architecture
- system design
- tech stack
- components
- patterns