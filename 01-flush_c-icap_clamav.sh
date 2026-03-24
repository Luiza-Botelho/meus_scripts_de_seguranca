#!/bin/bash

# flush_c-icap_clamav.sh
# Objetivo: Resetar o ambiente de segurança para um estado limpo.

# Cores para feedback visual (UX)
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' 

set -e

echo -e "${YELLOW}[1/6] Parando serviços para manutenção...${NC}"
# Usamos || true para não travar o script se o serviço já estiver parado
sudo systemctl stop clamav-daemon || true
sudo systemctl stop c-icap || true

echo -e "${YELLOW}[2/6] Removendo arquivos de configuração customizados...${NC}"
# No Debian, é melhor mover para um backup do que deletar direto (Segurança!)
[ -f /etc/c-icap/virus_scan.conf ] && sudo mv /etc/c-icap/virus_scan.conf /etc/c-icap/virus_scan.conf.bak
sudo rm -f /etc/c-icap/clamav_mod.conf
sudo rm -f /var/log/c-icap-access-vscan.log

echo -e "${YELLOW}[3/6] Limpando referências no c-icap.conf...${NC}"
if [ -f /etc/c-icap/c-icap.conf ]; then
    # Criar backup antes de editar com sed é uma boa prática profissional
    sudo cp /etc/c-icap/c-icap.conf /etc/c-icap/c-icap.conf.orig
    sudo sed -i '/ServiceAlias\s\+avscan/ d' /etc/c-icap/c-icap.conf
else
    echo -e "${RED}Aviso: /etc/c-icap/c-icap.conf não encontrado.${NC}"
fi

echo -e "${YELLOW}[4/6] Forçando o reset dos pacotes via APT...${NC}"
# Para realmente voltar ao padrão, usamos o --reinstall
sudo apt-get update -qq
sudo apt-get install --reinstall -y c-icap clamav clamav-daemon

echo -e "${YELLOW}[5/6] Ajustando permissões e inicialização...${NC}"
# Importante para o c-icap ter acesso aos logs que deletamos
sudo touch /var/log/c-icap-access-vscan.log
sudo chown c-icap:c-icap /var/log/c-icap-access-vscan.log || true

echo -e "${YELLOW}[6/6] Reiniciando os motores de segurança...${NC}"
sudo systemctl enable c-icap clamav-daemon
sudo systemctl start c-icap
sudo systemctl start clamav-daemon

echo -e "${GREEN}✅ Sucesso! O ambiente foi restaurado para o padrão estável do Debian.${NC}"
