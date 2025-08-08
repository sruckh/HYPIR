**Project GOALS**

 1. Wrap project to work as a container on RunPod
 2. Initial Container should be minimal and build easily on gihub
 3. sruckh/HYPIR is the respository for github use SSH connection
 4. gemneye/ is the repository for dockerhub
 5. The github secrets DOCKER_USERNAME and DOCKER_PASSWORD are used to push container to dockerhub
 6. all programs, python modules, and dependencies should be installed in the /workspace/HYPIR directory
 7. python app.py --config configs/sd2_gradio.yaml --local --device cuda is the launch point inside the container
 8. gradio app should listen on port 7860
 9. gradio app should support the share link option as a a configuration item in environmental Variable
 10. python 3.10-slim should be used for main container image
 11. These rules should be maintained across all sub-agents that are launched.
 15. use pylint and flake8 tools to lint code
