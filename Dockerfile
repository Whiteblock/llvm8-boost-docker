FROM debian:stretch as built

#install deps
RUN echo "deb http://apt.llvm.org/stretch/ llvm-toolchain-stretch-8 main" >> /etc/apt/sources.list
RUN apt-get update && \
    apt-get install -y libboost-all-dev make libllvm-8-ocaml-dev \
        libllvm8 llvm-8 llvm-8-dev llvm-8-doc llvm-8-examples llvm-8-runtime \
        clang-8 clang-tools-8 clang-8-doc libclang-common-8-dev libclang-8-dev \
        libclang1-8 clang-format-8 python-clang-8