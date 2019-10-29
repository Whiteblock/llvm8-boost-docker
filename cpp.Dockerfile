FROM ubuntu:19.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install wget apt-utils software-properties-common tar -y
RUN wget -O- https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
RUN echo "deb http://apt.llvm.org/stretch/ llvm-toolchain-stretch main" >> /etc/apt/sources.list

#install deps
RUN apt-get update
RUN apt-get install -y libspdlog-dev make  libtbb-dev
RUN apt-get install -y gcc gcc-8 g++ g++-8 g++-9 cmake git git-extras libgflags-dev libgtest-dev
RUN apt-get install -y autoconf libtool pkg-config curl libgrpc-dev


RUN wget https://dl.bintray.com/boostorg/release/1.70.0/source/boost_1_70_0.tar.gz && tar -zxf boost_1_70_0.tar.gz
WORKDIR /boost_1_70_0
RUN ./bootstrap.sh && ./b2 install

#cppcheck doxygen libclang-8-dev libc++-9-dev libc++abi-9-dev lld-9 lldb-9 clang-8 clang-9 clang-tools-9 clang-tools
WORKDIR /
RUN git clone https://github.com/whiteblock/served
WORKDIR /served
RUN mkdir served.build && cd served.build && cmake .. && SERVED_BUILD_SHARED=true make -j $(nproc) && make install

WORKDIR /
RUN git clone https://github.com/whiteblock/json.git 
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



ENTRYPOINT ["/bin/bash"]
