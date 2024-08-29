FROM pytorch/pytorch:1.6.0-cuda10.1-cudnn7-runtime

# 换源
RUN apt update && apt install -y curl bash

RUN bash -c "bash <(curl -sSL https://linuxmirrors.cn/main.sh) \
--source mirrors.tuna.tsinghua.edu.cn \
--protocol http \
--intranet false \
--install-epel false \
--close-firewall false \
--backup true \
--upgrade-software true \
--clean-cache true \
--ignore-backup-tips"
RUN apt update && apt install -y \
    build-essential \
    cmake \
    git \
    curl \
    vim \
    ca-certificates \
    libboost-all-dev \
    python-qt4 \
    libjpeg-dev \
    libpng-dev \
    libgl1

COPY . /workspace
WORKDIR /workspace/face-alignment

RUN pip install pillow==8.3.2 &&\
pip install -r requirements.txt &&\
python setup.py install

RUN mkdir -p /root/.cache/torch/hub/checkpoints/ && \
cp /workspace/lib/s3fd-619a316812.pth /root/.cache/torch/hub/checkpoints/s3fd-619a316812.pth && \
cp /workspace/lib/2DFAN4_1.6-c827573f02.zip /root/.cache/torch/hub/checkpoints/2DFAN4_1.6-c827573f02.zip

WORKDIR /workspace
CMD sleep infinity