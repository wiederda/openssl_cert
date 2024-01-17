#!/bin/sh

docker run -d --name CreatePFX --rm -v $(pwd)/input:/home/input -v $(pwd)/output:/home/output openssl_cert pwsh CreatePFX.ps1
