FROM ac2-registry.cn-hangzhou.cr.aliyuncs.com/ac2/pytorch:2.7.1.8-cuda12.8.1-py312-alinux3.2104

# 适配 Alinux 的包管理
RUN yum install -y mesa-libGL-devel glib2-devel git && \
    yum clean all

# 确保使用镜像自带的 Python 3.12 路径
RUN ln -sf /usr/bin/python3 /usr/bin/python

# 剩下的 pip 安装逻辑...
COPY requirements.txt .
RUN python -m pip install --upgrade pip && \
    python -m pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/
RUN grep -vE "torch|torchvision|torchaudio|nvidia-" requirements.txt > req.txt && \
    pip install --no-cache-dir -r req.txt && \
    rm req.txt
