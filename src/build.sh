#!/usr/bin/env bash

set -e

# bzip2 required for extracting micromamba
apt update && apt install bzip2 --yes

wget -qO- https://micro.mamba.pm/api/micromamba/linux-64/latest | tar -xvj bin/micromamba
export MAMBA_ROOT_PREFIX=./micromamba
eval "$(./bin/micromamba shell hook --shell=bash)"

# gcc => build dependency
micromamba create -n gnuradio -c conda-forge gnuradio==3.10.3.0 conda-pack --yes
micromamba activate gnuradio
micromamba clean -a --yes

conda-pack --prefix ./micromamba/envs/gnuradio/ --output gnuradio-3.10.3.0.tar.gz