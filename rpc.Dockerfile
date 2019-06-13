FROM ubuntu:19.04

#install deps
RUN apt-get update && \
    apt-get install -y libspdlog-dev libboost-all-dev rapidjson-dev make gcc gcc-8 g++ g++-8 g++-9 cmake git

RUN mkdir /boost && apt-get install wget
WORKDIR /boost
RUN wget https://dl.bintray.com/boostorg/release/1.70.0/source/boost_1_70_0.tar.gz && tar -xzf boost_1_70_0.tar.gz
WORKDIR /boost/boost_1_70_0
RUN ./bootstrap.sh
RUN ./b2 install -j$(nproc)

WORKDIR /
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
RUN PATH="$PATH:/usr/local/go/bin" go get github.com/ethereum/go-ethereum

ENTRYPOINT ["/bin/bash"]
