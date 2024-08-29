# 原dockerfile地址 https://github.com/1adrianb/face-alignment/blob/master/Dockerfile
# 这个pytorch基础镜像的dockerhub地址 https://hub.docker.com/r/pytorch/pytorch/tags?page=&page_size=&ordering=&name=1.6.0-cuda10.1-cudnn7-runtime
FROM pytorch/pytorch:1.6.0-cuda10.1-cudnn7-runtime

# 包管理器换源
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

# 安装图像处理依赖和基础工具
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


# 安装python依赖 构建face-alignment
COPY . /workspace
WORKDIR /workspace/face-alignment
RUN /opt/conda/bin/pip install pillow==8.3.2 &&\
/opt/conda/bin/pip install -r requirements.txt &&\
/opt/conda/bin/python3.7 setup.py install

# RUN /opt/conda/bin/pip install -r requirements.txt

# 复制face-alignment运行时需要的模型
RUN mkdir -p /root/.cache/torch/hub/checkpoints/ && \
cp /workspace/lib/s3fd-619a316812.pth /root/.cache/torch/hub/checkpoints/s3fd-619a316812.pth && \
cp /workspace/lib/2DFAN4_1.6-c827573f02.zip /root/.cache/torch/hub/checkpoints/2DFAN4_1.6-c827573f02.zip

WORKDIR /workspace
CMD sleep infinity