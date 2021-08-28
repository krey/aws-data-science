#!/bin/bash

sudo apt-get update
sudo apt-get -y install unzip ncdu
sudo apt-get -y install psmisc # for killall

ARCH=$(uname -m)
if [[ "$ARCH" != "x86_64" ]] && [[ "$ARCH" != "aarch64" ]]
then
    echo "Architecture \"$ARCH\" not recognized"
    exit 1
fi
MINICONDA_INSTALLER="Miniconda3-latest-Linux-$ARCH.sh"
wget https://repo.anaconda.com/miniconda/$MINICONDA_INSTALLER
sh ./$MINICONDA_INSTALLER -b
rm -vf ./$MINICONDA_INSTALLER
eval "$(~/miniconda3/bin/conda shell.bash hook)"
conda init
conda config --set auto_activate_base false
conda install -y mamba -n base -c conda-forge
mamba create -y --name ml python=3.9

conda_packages=(
    # misc packages
    pandas pyarrow requests sympy
    # jupyter and enhancements
    notebook jupyterlab tqdm
    ipywidgets xeus-python jupyterlab_execute_time
    # machine learning packages
    seaborn scikit-learn
    pytorch torchvision tensorboard
    statsmodels lightgbm xgboost
)

mamba install -n ml -y -c conda-forge "${conda_packages[@]}"

# pip install kaggle
# mkdir .kaggle

# doesn't seem to work
# pip install humanize
# git clone https://github.com/krey/jupyter-idle-hook.git

# how reliable is this?
# echo "UUID=e9b6710b-5843-4fb8-820a-444eab785d82    /home/ubuntu/storage    xfs     defaults,nofail 0       2" | sudo tee -a /etc/fstab
# mkdir ~/storage
# sudo mount -a
# sudo chown ubuntu ~/storage
# sudo chgrp ubuntu ~/storage

# cd ~/storage
# git clone https://github.com/krey/blog-materials.git
# cd

# ipython profile create
# echo "c.InteractiveShell.ast_node_interactivity = \"all\"" >>  ~/.ipython/profile_default/ipython_config.py

conda activate ml # keep this conda, doesn't work if mamba
jupyter notebook --generate-config
echo "c.NotebookApp.port = 8889" >> ~/.jupyter/jupyter_notebook_config.py 

