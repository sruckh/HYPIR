FROM runpod/pytorch:2.8.0-py3.11-cuda12.8.1-cudnn-devel-ubuntu22.04

# Install git and other dependencies
RUN apt-get update && apt-get install -y git curl

# Create workspace directory
RUN mkdir -p /workspace

# Clone HYPIR repository
WORKDIR /workspace
RUN git clone https://github.com/XPixelGroup/HYPIR.git

# Install requirements
WORKDIR /workspace/HYPIR
RUN pip install -r requirements.txt

# Create models directory and download model weights
RUN mkdir -p /workspace/HYPIR/models/sd2
RUN curl -L -o /workspace/HYPIR/models/sd2/HYPIR_sd2.pth https://huggingface.co/lxq007/HYPIR/resolve/main/HYPIR_sd2.pth

# Set environment variables
ENV HF_HOME=/workspace/HYPIR/models

# Modify the configuration files
RUN sed -i 's|weight_path: .*|weight_path: /workspace/HYPIR/models/sd2/HYPIR_sd2.pth|' /workspace/HYPIR/configs/sd2_gradio.yaml
RUN sed -i 's|block.launch(server_name="0.0.0.0" if not args.local else "127.0.0.1", server_port=args.port)|block.launch(server_name="0.0.0.0" if not args.local else "127.0.0.1", server_port=args.port, share=True)|' /workspace/HYPIR/app.py

# Expose port for Gradio
EXPOSE 7860

# Set working directory for the app
WORKDIR /workspace/HYPIR

# Run the Gradio app
CMD ["python", "app.py", "--config", "configs/sd2_gradio.yaml", "--device", "cuda", "--gpt_caption"]
