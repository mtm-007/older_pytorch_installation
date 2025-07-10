#!/bin/bash
set -e

# 1. Create and activate conda env with Python 3.6
conda create -n older_pytorch python=3.6 -y
conda activate older_pytorch

# 2. Install uv (using pip inside conda env)
pip install --upgrade pip
pip install uv

# 3.5. Install conda-only packages
conda install -c conda-forge cudatoolkit=9.0 -y
conda install -c conda-forge bcolz=1.2.0 -y
conda install -c conda-forge xorg-libsm -y
conda install -c conda-forge xorg-libxext -y
conda install -c conda-forge xorg-libxrender -y

# 3. Install torch and torchvision from URLs (must be first)
uv pip install https://download.pytorch.org/whl/cu90/torch-0.3.1-cp36-cp36m-linux_x86_64.whl
uv pip install torchvision==0.2.1 -f https://download.pytorch.org/whl/cu90/torch_stable.html

# For CPU only:
# uv pip install https://download.pytorch.org/whl/cpu/torch-0.3.1-cp36-cp36m-linux_x86_64.whl
# uv pip install torchvision==0.2.1 -f https://download.pytorch.org/whl/cpu/torch_stable.html


# 4. Install remaining dependencies from pyproject.toml
uv sync

# 5. Verify installed versions
python -c "import torch, torchvision, fastai; print(f'Torch: {torch.__version__}, TorchVision: {torchvision.__version__}, FastAI: {fastai.__version__}')"