#!/bin/sh

docker run -d --name CreateCSRECC --rm -v $(pwd)/input:/home/input -v $(pwd)/output:/home/output openssl pwsh CreateCSRECC.ps1
