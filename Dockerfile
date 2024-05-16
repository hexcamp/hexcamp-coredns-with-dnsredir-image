FROM coredns/coredns:1.11.1 AS coredns

# runtime container
FROM debian:11 AS runtime

# set default logging, can be overridden
ENV RUST_LOG=info

# copy files
COPY --from=coredns /coredns /coredns
COPY --from=coredns /etc/ssl/certs/* /etc/ssl/certs/

# set entrypoint
ENTRYPOINT ["/bin/bash"]
