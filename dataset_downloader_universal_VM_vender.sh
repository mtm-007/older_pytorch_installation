#!/bin/bash
set -e

echo "Starting dataset download with UV..."

# Install uv if not present
command -v uv >/dev/null 2>&1 || {
    echo "Installing UV..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.cargo/bin:$PATH"
}

# Try creating venv, fallback to target install
if uv venv /tmp/fastai-tmp 2>/dev/null; then
    echo "Using temporary virtual environment"
    source /tmp/fastai-tmp/bin/activate
    CLEANUP_METHOD="venv"
else
    echo "Using isolated installation (managed environment detected)"
    INSTALL_DIR="/tmp/fastai-libs-$$"
    export PYTHONPATH="$INSTALL_DIR:$PYTHONPATH"
    INSTALL_ARGS="--target=$INSTALL_DIR"
    CLEANUP_METHOD="target"
    uv pip list --format=freeze > /tmp/packages_before.txt 2>/dev/null || pip list --format=freeze > /tmp/packages_before.txt
fi

# Install packages in separate commands
# First install PyTorch with CPU-only index
uv pip install $INSTALL_ARGS torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu

# Then install other packages from default PyPI
uv pip install $INSTALL_ARGS ipython fastai

# Download dataset
python - <<'EOF'
from fastai.vision.all import untar_data, URLs
import shutil, os

path = untar_data(URLs.CIFAR)
save_dir = './data'
os.makedirs(save_dir, exist_ok=True)
shutil.copytree(path, os.path.join(save_dir, 'cifar10'), dirs_exist_ok=True)
print("Successfully downloaded data!")
EOF

# Cleanup based on method used
echo "Cleaning up..."
if [ "$CLEANUP_METHOD" = "venv" ]; then
    deactivate 2>/dev/null || true
    rm -rf /tmp/fastai-tmp
elif [ "$CLEANUP_METHOD" = "target" ]; then
    rm -rf "$INSTALL_DIR"
    # Uninstall newly added packages
    uv pip list --format=freeze > /tmp/packages_after.txt 2>/dev/null || pip list --format=freeze > /tmp/packages_after.txt
    comm -13 /tmp/packages_before.txt /tmp/packages_after.txt | cut -d'=' -f1 | xargs -r uv pip uninstall -y 2>/dev/null || true
    rm -f /tmp/packages_before.txt /tmp/packages_after.txt
fi

rm -rf ~/.fastai/ ~/.cache/pip/ ~/.cache/uv/
echo "Cleanup complete! Dataset in ./data/cifar10"