# 使用 NVIDIA 提供的官方开发镜像作为基础，确保 CUDA 12.6 环境完整
FROM registry.cn-hangzhou.aliyuncs.com/google_containers/cuda:12.6.3-devel-ubuntu22.04

# 设置环境变量
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1

# 安装 Python 和基础工具
RUN apt-get update && apt-get install -y \
    python3.10 \
    python3-pip \
    libgl1-mesa-glx \
    libglib2.0-0 \
    git \
    && rm -rf /var/lib/apt/lists/*

# 软链接 python
RUN ln -s /usr/bin/python3 /usr/bin/python

# 升级 pip 并设置阿里云镜像源加速
RUN pip install --upgrade pip && \
    pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/

# 关键：手动安装 PyTorch 2.6.0 + CUDA 12.6 专用版本
# 注意：官方仓库有时还没同步最新版，需指定官方下载链接
RUN pip install torch==2.6.0 torchvision==0.21.0 torchaudio==2.6.0 \
    --index-url https://download.pytorch.org/whl/cu126

# 复制并安装其他依赖
COPY requirements.txt .
# 过滤掉已经手动安装过的 torch 相关包，避免冲突，然后安装剩余包
RUN grep -vE "torch|torchvision|torchaudio" requirements.txt > req_rem.txt && \
    pip install -r req_rem.txt

# 设置工作目录

WORKDIR /workspace

