FROM coredns/coredns:1.11.1 AS coredns
FROM debian AS coredns_build

RUN apt-get update
RUN apt-get dist-upgrade -y
RUN apt-get install -y vim procps curl git build-essential

RUN curl -O https://dl.google.com/go/go1.23.2.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.23.2.linux-amd64.tar.gz
ENV PATH=$PATH:/usr/local/go/bin
RUN go version

RUN git clone https://github.com/coredns/coredns.git
WORKDIR /coredns
RUN echo 'dnsredir:github.com/leiless/dnsredir' >> plugin.cfg
RUN echo 'hexcamp:github.com/hexcamp/hexcamp-coredns-plugin' >> plugin.cfg
RUN go get github.com/leiless/dnsredir
RUN go get github.com/hexcamp/hexcamp-coredns-plugin
RUN go generate
RUN make CGO_ENABLED=1

# runtime container
FROM debian AS runtime

RUN apt-get update
RUN apt-get dist-upgrade -y
RUN apt-get install -y vim procps curl

# set default logging, can be overridden
ENV RUST_LOG=info

# copy files
COPY --from=coredns /etc/ssl/certs/* /etc/ssl/certs/
COPY --from=coredns_build /coredns/coredns /coredns

# set entrypoint
ENTRYPOINT ["/bin/bash"]
