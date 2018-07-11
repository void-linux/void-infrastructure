#!/bin/sh

find ./ -name '*pem' -exec rm {} \;
find ./ -name '*csr' -exec rm {} \;
