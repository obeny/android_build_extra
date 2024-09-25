#!/bin/bash

openssl x509 -inform pem -noout -text -in ${1}
