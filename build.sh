docker buildx build --platform linux/amd64 --progress=plain . -t test-coredns-image 2>&1 | tee ~/tmp/build.log
