FROM ubuntu:19.04

#install deps
RUN apt-get update && \
    apt-get install -y libboost-all-dev rapidjson-dev make gcc gcc-8 g++ g++-8 g++-9 cmake git

RUN git clone https://github.com/Whiteblock/served
WORKDIR /served
RUN mkdir served.build && cd served.build && cmake .. && SERVED_BUILD_SHARED=true make -j $(nproc) && make install

WORKDIR /
RUN git clone git@github.com:Whiteblock/json.git
WORKDIR /json
RUN mkdir build && cd build && cmake .. && make install

ENTRYPOINT ["/bin/bash"]