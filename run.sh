#! /bin/sh

docker rm -f coredns-test

#docker run \
#  -it \
#  -p 10053:9053/udp \
#  -v ./test-fs:/data \
#  --name coredns-test \
#  test-coredns-image

#docker run \
#  -it \
#  -p 10053:9053/udp \
#  -v ./test-fs:/data \
#  --name coredns-test \
#  --entrypoint /coredns \
#  ghcr.io/hexcamp/hexcamp-coredns-with-dnsredir-image@sha256:9ddaa7160f4133dcfec91ed5bea1b07dcc70374e673a0f982b705b1760380eaf

docker run \
  -it \
  -p 10053:9053/udp \
  -v ./test-fs:/data \
  --name coredns-test \
  ghcr.io/hexcamp/hexcamp-coredns-with-dnsredir-image@sha256:0af2f69d6be677e512ed69f9c473d4bb2aef77c4c953096311690daeee89b116

#  ghcr.io/hexcamp/hexcamp-coredns-with-dnsredir-image@sha256:9ddaa7160f4133dcfec91ed5bea1b07dcc70374e673a0f982b705b1760380eaf

