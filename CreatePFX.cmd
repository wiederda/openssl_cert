set input=%~dp0input
set output=%~dp0output

docker run -d --name CreatePFX --rm -v %input%:/home/input -v %output%:/home/output openssl_cert pwsh CreatePFX.ps1