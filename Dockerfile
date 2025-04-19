FROM coredns/coredns:1.11.1 AS coredns
FROM debian AS coredns_build

RUN apt-get update
RUN apt-get dist-upgrade -y
RUN apt-get install -y vim procps curl git build-essential unbound libunbound-dev

RUN curl -O https://dl.google.com/go/go1.23.2.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.23.2.linux-amd64.tar.gz
ENV PATH=$PATH:/usr/local/go/bin
RUN go version

RUN git clone https://github.com/coredns/coredns.git
WORKDIR /coredns
RUN grep -v 'file:file' plugin.cfg > plugin2.cfg
RUN echo 'rrl:github.com/coredns/rrl/plugins/rrl' >> plugin2.cfg
RUN echo 'unbound:github.com/coredns/unbound' >> plugin2.cfg
RUN echo 'dnsredir:github.com/hexcamp/dnsredir' >> plugin2.cfg
RUN echo 'hexcamp:github.com/hexcamp/hexcamp-coredns-plugin' >> plugin2.cfg
RUN echo 'file:file' >> plugin2.cfg
RUN mv plugin2.cfg plugin.cfg
RUN go get github.com/coredns/unbound
RUN go get github.com/coredns/rrl/plugins/rrl
RUN go get github.com/hexcamp/dnsredir@82118c3a5166871941ab312edb15ca65600f5a8b
RUN go get github.com/hexcamp/hexcamp-coredns-plugin@20ca598ba987e662d0c7d46d5e0da0ac62ad336e
RUN go generate
RUN make CGO_ENABLED=1

# runtime container
FROM debian AS runtime

RUN apt-get update
RUN apt-get dist-upgrade -y
RUN apt-get install -y vim procps curl unbound libunbound-dev

# set default logging, can be overridden
ENV RUST_LOG=info

# copy files
COPY --from=coredns /etc/ssl/certs/* /etc/ssl/certs/
COPY --from=coredns_build /coredns/coredns /coredns

# set entrypoint
ENTRYPOINT ["/bin/bash"]

# force build
