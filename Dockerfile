# 原dockerfile地址 https://github.com/1adrianb/face-alignment/blob/master/Dockerfile
# 这个pytorch基础镜像的dockerhub地址 https://hub.docker.com/r/pytorch/pytorch/tags?page=&page_size=&ordering=&name=1.6.0-cuda10.1-cudnn7-runtime
FROM pytorch/pytorch:1.6.0-cuda10.1-cudnn7-runtime

# 包管理器换源，并安装图像处理依赖和基础工具
RUN apt update; apt install -y curl bash; \
bash -c "bash <(curl -sSL https://linuxmirrors.cn/main.sh) \
    --source mirrors.tuna.tsinghua.edu.cn \
    --protocol http \
    --intranet false \
    --install-epel false \
    --close-firewall false \
    --backup true \
    --upgrade-software true \
    --clean-cache true \
    --ignore-backup-tips";\
apt update && apt install -y \
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
WORKDIR /workspace

# 安装Python依赖 复制face-alignment运行时需要的模型
RUN /opt/conda/bin/pip install -i https://pypi.tuna.tsinghua.edu.cn/simple -r /workspace/requirements.txt; \
mkdir -p /root/.cache/torch/hub/checkpoints/ ; \
cp /workspace/lib/* /root/.cache/torch/hub/checkpoints

CMD /opt/conda/bin/python3.7 main.py