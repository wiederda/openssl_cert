#!/bin/sh

docker run -d --name CreateCSR --rm -v $(pwd)/input:/home/input -v $(pwd)/output:/home/output openssl pwsh CreateCSR.ps1
