# https://github.com/rhasspy/piper/issues/306#issuecomment-1855142619
FROM nvcr.io/nvidia/pytorch:22.03-py3

RUN pip3 install \
    'pytorch-lightning'

ENV NUMBA_CACHE_DIR=.numba_cache

ENV DEBIAN_FRONTEND  noninteractive
RUN apt-get update && apt install -y python3-dev python3-venv espeak-ng git build-essential zlib1g-dev libbz2-dev liblzma-dev libncurses5-dev libreadline6-dev libsqlite3-dev libssl-dev libgdbm-dev liblzma-dev tk-dev lzma lzma-dev libgdbm-dev libffi-dev && rm -rf /var/lib/apt/lists/*

# install python 3.10.13
RUN mkdir -pv /usr/src/python
WORKDIR /usr/src/python
RUN wget https://www.python.org/ftp/python/3.10.13/Python-3.10.13.tgz
RUN tar zxvf Python-3.10.13.tgz
WORKDIR /usr/src/python/Python-3.10.13
RUN ./configure --enable-optimizations
RUN make -j8
RUN make altinstall

# install piper
RUN mkdir -pv /usr/src/
WORKDIR /usr/src/
RUN git clone https://github.com/rhasspy/piper.git piper
RUN cd ./piper && git checkout a0f09cdf9155010a45c243bc8a4286b94f286ef4

WORKDIR /usr/src/piper/src/python
RUN /usr/local/bin/python3.10 -m venv .venv
RUN source .venv/bin/activate && pip list && pip install pip wheel setuptools -U && pip list && pip install -r requirements.txt && pip list && pip install -e . && pip list && pip install torchmetrics==0.11.4 && pip install piper-tts && ./build_monotonic_align.sh && pip3 install piper-tts

# finish
RUN ln -fs /usr/share/zoneinfo/UTC /etc/localtime
