#!/bin/bash
if [ ! -f ./ACcompactado.zip ]
then
    curl http://acraiz.icpbrasil.gov.br/credenciadas/CertificadosAC-ICP-Brasil/ACcompactado.zip -o ACcompactado.zip
fi
if [ ! -d certs ]
then
    mkdir certs
    cd certs
    unzip ../ACcompactado.zip
    cd ..
fi

if [ ! -d /etc/ssl/icp-brasil ]
then
    sudo cp -r certs /etc/ssl/icp-brasil
fi
for c in /etc/ssl/icp-brasil/*.crt
do
    PEMFILE=${c%%.crt}.pem
    sudo openssl x509 -in $c -out $PEMFILE -outform PEM
    sudo rm -f $c
    HASH=`openssl x509 -hash -in $PEMFILE -noout`
    FILE_NAME=${c##/etc/ssl/icp-brasil/}
    if [ -L /etc/ssl/certs/${HASH}.0 ]
    then
        sudo rm /etc/ssl/certs/${HASH}.0
    fi
    sudo ln -s  $PEMFILE /etc/ssl/certs/${HASH}.0
done


