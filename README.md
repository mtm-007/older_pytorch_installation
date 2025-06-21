# older_pytorch_installation
Trying to install older version of pytorch and fastai
#### first and most create a vertual env to get python=3.6
## Older version fastai installation(fastai==0.7) at june [2025]
- For installing fastai=0.7 
* python=3.6
* older cython to compile with python=3.6
 - [conda install cython=0.29]
* torch=0.3.1 and torchvission=0.2:
  for installing torch=0.3 and torchvission=0.21 normal channels with pypi will not work use:
  - [pip install torch==0.3.1 -f https://download.pytorch.org/whl/cu90/torch_stable.html]
  - [pip install torchvision==0.2.1 -f https://download.pytorch.org/whl/cu90/torch_stable.html]
  - [pip install sentencepiece==0.1.83]
* pip install opencv-python==4.1.2.30
* pip install bcolz==1.2.1 or [conda install -c conda-forge bcolz] under the virtual env