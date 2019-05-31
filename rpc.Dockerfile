FROM ubuntu:19.04

#install deps
RUN apt-get update && \
    apt-get install -y libspdlog-dev libboost-all-dev rapidjson-dev make gcc gcc-8 g++ g++-8 g++-9 cmake git

RUN git clone https://github.com/Whiteblock/served
WORKDIR /served
RUN mkdir served.build && cd served.build && cmake .. && SERVED_BUILD_SHARED=true make -j $(nproc) && make install

WORKDIR /
RUN git clone https://github.com/Whiteblock/json.git 
WORKDIR /json
RUN git checkout master && mkdir build && cd build && cmake .. && make install

WORKDIR /root
RUN apt-get install -y wget
RUN wget https://dl.google.com/go/go1.12.5.linux-amd64.tar.gz && tar -C /usr/local -xzf go1.12.5.linux-amd64.tar.gz
RUN echo 'export PATH="$PATH:/usr/local/go/bin"' >> /root/.bashrc

ENTRYPOINT ["/bin/bash"]
