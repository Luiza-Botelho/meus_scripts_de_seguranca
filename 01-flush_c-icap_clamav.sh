#!/bin/bash

# flush_c-icap_clamav.sh

# Restaura as configurações padrão do c-icap e ClamAV, mas mantém os programas instalados.


set -e


echo "[1/6] Restaurando o arquivo de configuração /etc/c-icap/virus_scan.conf para o padrão..."


# Restaura o arquivo de configuração do c-icap para o estado inicial

# Isso irá remover as configurações de ClamAV e manter o c-icap como estava originalmente.

sudo rm -f /etc/c-icap/virus_scan.conf


echo "[2/6] Removendo referências de ClamAV do arquivo /etc/c-icap/c-icap.conf..."


# Verifica se o arquivo c-icap.conf existe antes de tentar usar o sed

if [ -f /etc/c-icap/c-icap.conf ]; then

# Removendo a linha do alias de serviço avscan do c-icap.conf

# Isso elimina a configuração do serviço de antivírus no c-icap

sudo sed -i '/ServiceAlias\s\+avscan/ d' /etc/c-icap/c-icap.conf

else

echo "Arquivo /etc/c-icap/c-icap.conf não encontrado, pulando..."

fi


echo "[3/6] Removendo o arquivo de configuração clamav_mod.conf..."


# Remover o arquivo clamav_mod.conf que foi criado para configurar o socket do ClamAV

sudo rm -f /etc/c-icap/clamav_mod.conf


echo "[4/6] Limpando o arquivo de log /var/log/c-icap-access-vscan.log..."


# Remove o arquivo de log customizado

sudo rm -f /var/log/c-icap-access-vscan.log


echo "[5/6] Parando os serviços c-icap e clamav..."


# Para os serviços para desativar o escaneamento antivírus

sudo systemctl stop clamav-daemon

#sudo systemctl stop c-icap


echo "[6/6] Instalando os pacotes c-icap e clamav para iniciar do zero..."


# Instalar os pacotes c-icap e clamav

sudo apt-get update

sudo apt-get install -y c-icap clamav


# Garantir que os serviços sejam iniciados após a instalação

sudo systemctl start c-icap

sudo systemctl start clamav-daemon


# Ativar os serviços para iniciar automaticamente no boot

sudo systemctl enable c-icap

sudo systemctl enable clamav-daemon


echo "Tudo pronto! As configurações do c-icap e ClamAV foram restauradas. O sistema está com a configuração padrão." 
