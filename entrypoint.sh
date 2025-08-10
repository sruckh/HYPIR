#!/bin/bash

# Ensure we are in the workspace directory
mkdir -p /workspace
cd /workspace

# Clone the repository if it doesn't exist
if [ ! -d "/workspace/HYPIR" ]; then
  echo "Cloning HYPIR repository..."
  git clone https://github.com/XPixelGroup/HYPIR.git
fi

cd /workspace/HYPIR

# Perform first-time setup if the model file doesn't exist
if [ ! -f "/workspace/HYPIR/models/sd2/HYPIR_sd2.pth" ]; then
  echo "Performing first-time setup..."

  # Install Python requirements
  pip install -r requirements.txt

  # Create model directory
  mkdir -p /workspace/HYPIR/models/sd2

  # Download model weights
  echo "Downloading model weights..."
  curl -L -o /workspace/HYPIR/models/sd2/HYPIR_sd2.pth https://huggingface.co/lxq007/HYPIR/resolve/main/HYPIR_sd2.pth

  # Configure the application
  echo "Configuring application..."
  sed -i 's|weight_path: .*|weight_path: /workspace/HYPIR/models/sd2/HYPIR_sd2.pth|' /workspace/HYPIR/configs/sd2_gradio.yaml
  sed -i 's|block.launch(server_name="0.0.0.0" if not args.local else "127.0.0.1", server_port=args.port)|block.launch(server_name="0.0.0.0" if not args.local else "127.0.0.1", server_port=args.port, share=True)|' /workspace/HYPIR/app.py

else
  echo "HYPIR already set up. Skipping installation."
fi

# Set Hugging Face home directory
export HF_HOME=/workspace/HYPIR/models

# Launch the Gradio app
echo "Launching Gradio app..."
python app.py --config configs/sd2_gradio.yaml --device cuda --gpt_caption
