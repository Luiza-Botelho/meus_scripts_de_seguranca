#!/bin/bash

# SuricadaBorg.sh

# Verifica se c-icap e ClamAV estão instalados. Se não, instala-os.

# Em seguida, realiza configurações no c-icap e ClamAV.


set -e


echo "[1/8] Verificando se c-icap e ClamAV estão instalados..."


# Verificando se o c-icap está instalado

if ! dpkg -l | grep -q c-icap; then

echo "c-icap não está instalado. Instalando..."

sudo apt-get update

sudo apt-get install -y c-icap

else

echo "c-icap já está instalado."

fi


# Verificando se o ClamAV está instalado

if ! dpkg -l | grep -q clamav; then

echo "ClamAV não está instalado. Instalando..."

sudo apt-get update

sudo apt-get install -y clamav clamav-daemon

else

echo "ClamAV já está instalado."

fi


echo "[2/8] Criando e configurando o arquivo /etc/c-icap/virus_scan.conf..."


# Continuação do seu código para configurar o c-icap com o ClamAV (como você fez anteriormente)

sudo tee /etc/c-icap/virus_scan.conf > /dev/null <<EOF

# Configuração do serviço de antivírus para c-icap com ClamAV

clamav.ClamAVSocket /var/run/clamav/clamd.ctl

Timeout 10

virus_scan.MaxObjectSize 0

virus_scan.ScanFileTypes TEXT DATA EXECUTABLE ARCHIVE GIF JPEG MSOFFICE HTML XML PDF

virus_scan.SendPercentData 0

virus_scan.StartSendPercentDataAfter 0

virus_scan.DefaultEngine clamav

LogFormat virusLog "%tl %>a %ru [Action: %{virus_scan:action}Sa] [Virus: %{virus_scan:virus}Sa]"

AccessLog /var/log/c-icap-access-vscan.log virusLog virus_scan

echo "Include clamav_mod.conf" | sudo tee -a /etc/c-icap/virus_scan.conf > /dev/null

EOF


# Restante do seu código de configuração

echo "[3/8] Corrigindo permissões e criando log se necessário..."

sudo touch /var/log/c-icap-access-vscan.log

sudo chown c-icap:c-icap /var/log/c-icap-access-vscan.log

sudo chmod 644 /var/log/c-icap-access-vscan.log


echo "[4/8] Atualizando service alias no c-icap.conf..."

sudo sed -i '/ServiceAlias\s\+avscan/ d' /etc/c-icap/c-icap.conf

echo 'ServiceAlias avscan virus_scan?allow204=off&sizelimit=off&mode=simple' | sudo tee -a /etc/c-icap/c-icap.conf 
