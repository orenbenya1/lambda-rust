# https://github.com/lambci/docker-lambda#documentation
FROM lambci/lambda:build-provided.al2

ARG RUST_VERSION=1.51.0
RUN yum update -y && yum install -y jq openssl-devel
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
    | CARGO_HOME=/cargo RUSTUP_HOME=/rustup sh -s -- -y --profile minimal --default-toolchain $RUST_VERSION
COPY parallel-20220422.tar.bz2 /tmp
RUN bzip2 -dc /tmp/parallel-20220422.tar.bz2 | tar xvf - && \
    cd parallel-20220422 && \
    ./configure && make && make install && \
    cd .. && rm -rf parallel-20220422

ADD build.sh /usr/local/bin/
VOLUME ["/code"]
WORKDIR /code
ENTRYPOINT ["/usr/local/bin/build.sh"]
