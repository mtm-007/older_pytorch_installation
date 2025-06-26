python -m venv /tmp/fastai-tmp
source /tmp/fastai-tmp/bin/activate

# Install CPU-only PyTorch first
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu

# Then install fastai (which will use the already installed CPU PyTorch)
pip install fastai

python - <<EOF
from fastai.vision.all import untar_data, URLs
import shutil, os

path = untar_data(URLs.PASCAL_2007)
save_dir = './data'

os.makedirs(save_dir, exist_ok=True)
shutil.copytree(path, os.path.join(save_dir, 'pascal_2007'), dirs_exist_ok=True)
print("succefully downloaded data!")
EOF
deactivate
rm -rf /tmp/fastai-tmp
