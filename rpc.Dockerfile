FROM ubuntu:19.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install wget apt-utils software-properties-common -y
RUN wget -O- https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
RUN echo "deb http://apt.llvm.org/stretch/ llvm-toolchain-stretch main" >> /etc/apt/sources.list

#install deps
RUN apt-get update
RUN apt-get install -y libspdlog-dev libboost-all-dev rapidjson-dev make
RUN apt-get install -y gcc gcc-8 g++ g++-8 g++-9 cmake git git-extras libgflags-dev libgtest-dev
RUN apt-get install -y autoconf libtool pkg-config clang-8 clang-9 clang-tools-9 clang-tools
RUN apt-get install -y curl cppcheck doxygen libclang-8-dev libc++-9-dev libc++abi-9-dev lld-9 lldb-9

RUN git clone https://github.com/Whiteblock/served
WORKDIR /served
RUN mkdir served.build && cd served.build && cmake .. && SERVED_BUILD_SHARED=true make -j $(nproc) && make install

WORKDIR /
RUN git clone https://github.com/Whiteblock/json.git 
WORKDIR /json
RUN git checkout master && mkdir build && cd build && cmake .. && make -j$(nproc) && make install

WORKDIR /root
RUN wget https://dl.google.com/go/go1.12.5.linux-amd64.tar.gz && tar -C /usr/local -xzf go1.12.5.linux-amd64.tar.gz
RUN echo 'export PATH="$PATH:/usr/local/go/bin"' >> /root/.bashrc
RUN PATH="$PATH:/usr/local/go/bin" go get github.com/ethereum/go-ethereum

#libunwind
RUN mkdir /deps
WORKDIR /deps
RUN git clone https://github.com/libunwind/libunwind.git
WORKDIR /deps/libunwind
RUN ./autogen.sh && ./configure
RUN make -j$(nproc) && make install

#gperftools
WORKDIR /deps
RUN git clone https://github.com/gperftools/gperftools.git
WORKDIR /deps/gperftools
RUN ./autogen.sh && ./configure
RUN make -j$(nproc) && make install

#grpc
#WORKDIR /deps
#RUN git clone -b $(curl -L https://grpc.io/release) https://github.com/grpc/grpc
#WORKDIR /deps/grpc
#RUN git checkout master && git submodule update --init
#RUN make -j$(nproc) && make install


ENTRYPOINT ["/bin/bash"]
