# Set env name and save directory
ENV_NAME=temp-fastai-env
SAVE_DIR=./data

# Create and activate the environment
conda create -y -n $ENV_NAME python=3.9
conda activate $ENV_NAME

# Install fastai
pip install fastai

# Download PASCAL_2007 dataset and save to ./data
python - <<EOF
from fastai.vision.all import untar_data, URLs
import shutil, os

path = untar_data(URLs.PASCAL_2007)
os.makedirs("$SAVE_DIR", exist_ok=True)
shutil.copytree(path, os.path.join("$SAVE_DIR", "pascal_2007"), dirs_exist_ok=True)
EOF

# Deactivate and fully remove the environment
conda deactivate
conda remove -y --name $ENV_NAME --all
