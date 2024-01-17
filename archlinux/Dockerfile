FROM archlinux:latest
RUN yes | pacman -Syu
RUN yes | pacman -Sy wget
RUN yes | pacman -Sy awk

COPY . /tmp
RUN mkdir -p /home/scripts
RUN mkdir -p /opt/microsoft/powershell/7

RUN chmod u+x /tmp/install.sh && /tmp/install.sh

RUN echo "\$w = \$args[0]" > /home/scripts/CreateCSRECC.ps1
RUN echo "if (\$w){" >>/home/scripts/CreateCSRECC.ps1
RUN echo "\$key = \$w}" >>/home/scripts/CreateCSRECC.ps1
RUN echo "else{" >>/home/scripts/CreateCSRECC.ps1
RUN echo "\$key = \"prime256v1\"}" >>/home/scripts/CreateCSRECC.ps1
RUN echo "\$ergebnis = Select-String -Path \"/home/input/openssl.conf\" -Pattern \"CN = \"" >>/home/scripts/CreateCSRECC.ps1
RUN echo "\$letzteZeile = \$ergebnis[\$ergebnis.Count - 1]" >> /home/scripts/CreateCSRECC.ps1
RUN echo "\$teile = \$letzteZeile.Line.Split(\"=\")" >> /home/scripts/CreateCSRECC.ps1
RUN echo "\$letzterTeil = \$teile[\$teile.Count - 1]" >> /home/scripts/CreateCSRECC.ps1
RUN echo "If (!(Test-Path -Path \"/home/output/\$letzterTeil\")) {" >> /home/scripts/CreateCSRECC.ps1
RUN echo    "New-item \"/home/output/\$letzterTeil\" -ItemType Directory" >> /home/scripts/CreateCSRECC.ps1
RUN echo "}" >> /home/scripts/CreateCSRECC.ps1
RUN echo "openssl ecparam -out \"/home/output/\$letzterTeil/\$letzterTeil.key\" -name \"\$key\" -genkey" >> /home/scripts/CreateCSRECC.ps1
RUN echo "openssl req -new -sha256 -key \"/home/output/\$letzterTeil/\$letzterTeil.key\" -nodes -out \"/home/output/\$letzterTeil/\$letzterTeil.csr\" -config \"/home/input/openssl.conf"\" >> /home/scripts/CreateCSRECC.ps1
RUN echo "chmod -R ugo+rwx \"/home/output"\" >> /home/scripts/CreateCSRECC.ps1

RUN echo "\$ergebnis = Select-String -Path \"/home/input/openssl.conf\" -Pattern \"CN = \"" > /home/scripts/CreateCSR.ps1
RUN echo "\$letzteZeile = \$ergebnis[\$ergebnis.Count - 1]" >> /home/scripts/CreateCSR.ps1
RUN echo "\$teile = \$letzteZeile.Line.Split(\"=\")" >> /home/scripts/CreateCSR.ps1
RUN echo "\$letzterTeil = \$teile[\$teile.Count - 1]" >> /home/scripts/CreateCSR.ps1
RUN echo "If (!(Test-Path -Path \"/home/output/\$letzterTeil\")) {" >> /home/scripts/CreateCSR.ps1
RUN echo    "New-item \"/home/output/\$letzterTeil\" -ItemType Directory" >> /home/scripts/CreateCSR.ps1
RUN echo "}" >> /home/scripts/CreateCSR.ps1
RUN echo "openssl req -nodes -new -out \"/home/output/\$letzterTeil/\$letzterTeil.csr\" -keyout \"/home/output/\$letzterTeil/\$letzterTeil.key\" -config \"/home/input/openssl.conf"\" >> /home/scripts/CreateCSR.ps1
RUN echo "chmod -R ugo+rwx \"/home/output"\" >> /home/scripts/CreateCSR.ps1

RUN echo "\$w = \$args[0]" > /home/scripts/CreatePFX.ps1
RUN echo "Function Get-RandomPassword" >> /home/scripts/CreatePFX.ps1
RUN echo "{" >> /home/scripts/CreatePFX.ps1
RUN echo    "param([int]\$PasswordLength = 10)" >> /home/scripts/CreatePFX.ps1
 
RUN echo    "\$CharacterSet = @{" >> /home/scripts/CreatePFX.ps1
RUN echo            "Uppercase   = (97..122) | Get-Random -Count 10 | % {[char]\$_}" >> /home/scripts/CreatePFX.ps1
RUN echo            "Lowercase   = (65..90)  | Get-Random -Count 10 | % {[char]\$_}" >> /home/scripts/CreatePFX.ps1
RUN echo            "Numeric     = (48..57)  | Get-Random -Count 10 | % {[char]\$_}" >> /home/scripts/CreatePFX.ps1
RUN echo            "#SpecialChar = (44..47)  | Get-Random -Count 10 | % {[char]\$_}" >> /home/scripts/CreatePFX.ps1
RUN echo    "}" >> /home/scripts/CreatePFX.ps1
   
RUN echo    "\$StringSet = \$CharacterSet.Uppercase + \$CharacterSet.Lowercase + \$CharacterSet.Numeric + \$CharacterSet.SpecialChar" >> /home/scripts/CreatePFX.ps1
 
RUN echo    "-join(Get-Random -Count \$PasswordLength -InputObject \$StringSet)" >> /home/scripts/CreatePFX.ps1
RUN echo "}" >> /home/scripts/CreatePFX.ps1

RUN echo "\$key=Get-ChildItem \"/home/input/*\" -Filter *.key" >> /home/scripts/CreatePFX.ps1
RUN echo "\$p=Get-ChildItem \"/home/input/*\" -Filter *.p7b" >> /home/scripts/CreatePFX.ps1
RUN echo "\$name=\$p.name.substring(0,\$p.name.length-4)" >> /home/scripts/CreatePFX.ps1
RUN echo "If (!(Test-Path -Path \"/home/output/\$name\")) {" >> /home/scripts/CreatePFX.ps1
RUN echo    "New-item \"/home/output/\$name\" -ItemType Directory" >> /home/scripts/CreatePFX.ps1
RUN echo "}" >> /home/scripts/CreatePFX.ps1 

RUN echo "If (Test-Path -Path \"/home/output/\$name/passwort.txt\"){" >> /home/scripts/CreatePFX.ps1
RUN echo "\$pass=Get-Content -Path \"/home/output/\$name/passwort.txt"\" >> /home/scripts/CreatePFX.ps1
RUN echo "}" >> /home/scripts/CreatePFX.ps1
RUN echo "else {" >> /home/scripts/CreatePFX.ps1
RUN echo "\$pass=Get-RandomPassword -PasswordLength 20" >> /home/scripts/CreatePFX.ps1
RUN echo "Set-Content -Path \"/home/output/\$name/passwort.txt\" \$pass" >> /home/scripts/CreatePFX.ps1
RUN echo "}" >> /home/scripts/CreatePFX.ps1

RUN echo "openssl pkcs7 -print_certs -in \$p -out \"/home/output/\$name/\$name.cer"\" >> /home/scripts/CreatePFX.ps1
RUN echo "openssl pkcs7 -print_certs -in \$p -out \"/home/output/\$name/\$name.pem"\" >> /home/scripts/CreatePFX.ps1
RUN echo "If (!(Test-Path -Path \"/home/output/\$name/\$name.cer\")) {" >> /home/scripts/CreatePFX.ps1
RUN echo "openssl pkcs7 -print_certs -in \$p -out \"/home/output/\$name/\$name.cer\" -inform DER" >> /home/scripts/CreatePFX.ps1
RUN echo "openssl pkcs7 -print_certs -in \$p -out \"/home/output/\$name/\$name.pem\" -inform DER" >> /home/scripts/CreatePFX.ps1
RUN echo "}" >> /home/scripts/CreatePFX.ps1
RUN echo "If (Test-Path -Path \"/home/output/\$name/\$name.cer\") {" >> /home/scripts/CreatePFX.ps1
RUN echo "If (Test-Path -Path \"/home/input/\$name.key\") {" >> /home/scripts/CreatePFX.ps1
RUN echo "openssl pkcs12 -export -in \"/home/output/\$name/\$name.cer"\" -inkey \"/home/input/\$name.key\" -out \"/home/output/\$name/\$name.pfx"\" -passout pass:\$pass" >> /home/scripts/CreatePFX.ps1
RUN echo "}}" >> /home/scripts/CreatePFX.ps1
RUN echo "chmod -R ugo+rwx \"/home/output"\" >> /home/scripts/CreatePFX.ps1
RUN echo "openssl version" > /home/scripts/Check.ps1
RUN echo "openssl help" >> /home/scripts/Check.ps1

RUN yes | pacman -Rs wget
RUN yes | pacman -Rs awk
WORKDIR /home/scripts/
CMD ["pwsh","./Check.ps1"]