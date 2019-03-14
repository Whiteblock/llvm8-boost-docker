FROM ubuntu:latest as built

#install deps
RUN apt-get update && \
    apt-get install -y libboost-all-dev rapidjson-dev make gcc gcc-8 g++ g++-8 cmake git

RUN git clone https://github.com/Whiteblock/served
WORKDIR /served
RUN mkdir served.build && cd served.build && cmake .. && SERVED_BUILD_SHARED=true make && make install

ENTRYPOINT ["/bin/bash"]