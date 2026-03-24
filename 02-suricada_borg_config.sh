#!/bin/bash
# 02-SuricadaBorg.sh - Configuração de Varredura de Malware (ICAP + ClamAV)

set -e

# Cores para UX
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}[1/8] Verificando dependências...${NC}"
sudo apt-get update -qq
sudo apt-get install -y c-icap clamav-daemon clamav-freshclam libicapapi-dev

echo -e "${YELLOW}[2/8] Configurando /etc/c-icap/virus_scan.conf...${NC}"
# Usando heredoc para garantir que o arquivo seja sobrescrito (evita duplicatas)
sudo tee /etc/c-icap/virus_scan.conf > /dev/null <<EOF
# Configuração do serviço de antivírus para c-icap com ClamAV
Service virus_scan virus_scan.so
virus_scan.DefaultEngine clamav
clamav.ClamAVSocket /var/run/clamav/clamd.ctl

# Parâmetros de Performance
Timeout 10
virus_scan.MaxObjectSize 5M
virus_scan.ScanFileTypes TEXT DATA EXECUTABLE ARCHIVE GIF JPEG MSOFFICE HTML XML PDF
virus_scan.SendPercentData 5

# Logs de Segurança (Essencial para Análise de Dados)
LogFormat virusLog "%tl %>a %ru [Action: %{virus_scan:action}Sa] [Virus: %{virus_scan:virus}Sa]"
AccessLog /var/log/c-icap-access-vscan.log virusLog
EOF

echo -e "${YELLOW}[3/8] Ajustando permissões de grupo (Cibersegurança)...${NC}"
# Permite que o c-icap acesse o socket do ClamAV
sudo usermod -aG clamav c-icap || true

echo -e "${YELLOW}[4/8] Preparando logs e diretórios...${NC}"
sudo touch /var/log/c-icap-access-vscan.log
sudo chown c-icap:c-icap /var/log/c-icap-access-vscan.log
sudo chmod 644 /var/log/c-icap-access-vscan.log

echo -e "${YELLOW}[5/8] Configurando Service Alias no c-icap.conf...${NC}"
# Remove duplicatas e adiciona a nova linha
sudo sed -i '/ServiceAlias avscan/d' /etc/c-icap/c-icap.conf
echo 'ServiceAlias avscan virus_scan?allow204=off&sizelimit=off&mode=simple' | sudo tee -a /etc/c-icap/c-icap.conf > /dev/null

echo -e "${YELLOW}[6/8] Atualizando assinaturas de vírus (Freshclam)...${NC}"
sudo systemctl stop clamav-freshclam || true
sudo freshclam || echo "Assinaturas já atualizadas ou erro de rede temporário."
sudo systemctl start clamav-freshclam

echo -e "${YELLOW}[7/8] Reiniciando serviços...${NC}"
sudo systemctl restart clamav-daemon
sudo systemctl restart c-icap

echo -e "${GREEN}✅ [8/8] Integração Concluída! O motor de scan está ativo.${NC}"
