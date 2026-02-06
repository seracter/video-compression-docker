# 1. 使用你选中的 Alinux 基础镜像
FROM ac2-registry.cn-hangzhou.cr.aliyuncs.com/ac2/pytorch:2.7.1.8-cuda12.8.1-py312-alinux3.2104

# 2. 用 yum 安装 OpenCV 等需要的系统依赖 (Alinux 不支持 apt-get)
RUN yum install -y mesa-libGL-devel glib2-devel git && \
    yum clean all

# 3. 配置 pip 镜像源
RUN python -m pip install --upgrade pip && \
    python -m pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/

# 4. 处理依赖并安装
COPY requirements.txt .
# 提示：过滤掉已经在基础镜像里的包，减少构建时间，防止超时
RUN grep -vE "torch|torchvision|torchaudio|nvidia-" requirements.txt > req.txt && \
    pip install --no-cache-dir -r req.txt && \
    rm req.txt requirements.txt

WORKDIR /workspace
