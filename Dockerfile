# 依然使用这个最全的基础镜像
FROM ac2-registry.cn-hangzhou.cr.aliyuncs.com/ac2/pytorch:2.7.1.8-cuda12.8.1-py312-alinux3.2104

# 合并命令，减少镜像层数，这能大幅提升构建速度
RUN python -m pip install --upgrade pip && \
    python -m pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/

# 拷贝依赖文件
COPY requirements.txt .

# 关键优化：使用 --no-cache-dir 减少磁盘占用，并过滤掉已经存在的包
# 这样可以避免 pip 花费大量时间去检查和下载已经有的 torch
RUN grep -vE "torch|torchvision|torchaudio" requirements.txt > req.txt && \
    pip install --no-cache-dir -r req.txt && \
    rm req.txt requirements.txt
