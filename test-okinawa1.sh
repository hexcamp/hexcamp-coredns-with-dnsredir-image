#! /bin/bash

set -x

q @localhost:10053 a ssrgdfv3.test.hex.camp

q @localhost:10053 txt _dnslink.ssrgdfv3.test.hex.camp
