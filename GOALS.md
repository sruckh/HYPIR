The goal of this project is to containerize the project https://github.com/XPixelGroup/HYPIR so that it can run on a runpod server.  This is an exercise of repackaging, and not rebuilding source code.  This should only build on AMD64/x86_64 archeticture.
Change the github origin to be git@github.com:sruckh/HYPIR.git.  

serena can activate the project at /workspaces/projects/backblaze/HYPIR
 
This is the base image for the main container.
Use base image:runpod/pytorch:2.8.0-py3.11-cuda12.8.1-cudnn-devel-ubuntu22.04
 
Below are the RUNTIME steps to configure HYPIR after container has loaded.

**Instructions for setting up HYPIR -- First Run**
  1) Create directory /workspace; if it does not exist
  2) In the /workspace directory; git clone https://github.com/XPixelGroup/HYPIR.git
 2a) cd to /workspace/HYPIR
 2b) pip install -r requirements
  2) Create sub-directory /workspace/HYPIR/models
  3) Create sub-directory /workspace/HYPIR/models/sd2
  4) In the /workspace/HYPIR/models/sd2 directory run, https://huggingface.co/lxq007/HYPIR/resolve/main/HYPIR_sd2.pth
  5) edit the file /workspace/HYPIR/configs/sd2_gradio.yaml;  Change weight_path to be /workspace/HYPIR/models/sd2/HYPIR_sd2.pth
  6) edit this line, block.launch(server_name="0.0.0.0" if not args.local else "127.0.0.1", server_port=args.port) to be block.launch(server_name="0.0.0.0" if not args.local else "127.0.0.1", server_port=args.port, share=TRUE)
  7) export HF_HOME=/workspace/HYPIR/models
  8) The following environmental variables will be set in runpods template configuration:  GPT_API_KEY GPT_BASE_URL GPT_MODEL (These should be used with the --gpt_caption flag from the command line)
  9) launch gradio app, python app.py --config configs/sd2_gradio.yaml --device cuda --gpt_caption
  
**Extra Notes**
  1) Check if the directory /workspace/HYPIR/models/sd2, and see if file HYPIR_sd2.pth exists.  If both are true, then only run steps 7 & 8 from above.
