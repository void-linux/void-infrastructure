#!/bin/bash

if ! command -v cfssl ; then
    echo "cfssl is not available!"
    exit 1
fi

if [ ! -f ca-key.pem ] ; then
    cfssl gencert -initca ca-csr.json | cfssljson -bare ca
fi

for _d in *; do
    if [ -d $_d ] && [ -f $_d/cert.json ] && [ ! -f $_d/cert-key.pem ]; then
        cfssl gencert \
              -ca ca.pem \
              -ca-key ca-key.pem \
              -profile server \
              $_d/cert.json |
            cfssljson -bare $_d/cert
    fi
done
