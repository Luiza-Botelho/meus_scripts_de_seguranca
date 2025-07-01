#!/bin/bash


# Define o IP do seu roteador

# Mude este IP para o IP real do seu roteador

ROUTER_IP="192.168.1.1"


# Limpa todas as regras existentes do UFW

echo "Limpando as regras existentes do UFW..."

sudo ufw reset --force


# Define a política padrão para negar todas as conexões de entrada

echo "Configurando a política padrão para negar conexões de entrada..."

sudo ufw default deny incoming


# Permite todas as conexões de saída (geralmente é o comportamento desejado)

echo "Configurando a política padrão para permitir conexões de saída..."

sudo ufw default allow outgoing


# Permite o tráfego SSH (porta 22) apenas do IP do seu roteador

# Adapte a porta e o protocolo se necessário (ex: 80/tcp para HTTP, 443/tcp para HTTPS)

echo "Permitindo tráfego SSH (porta 22) apenas do roteador ($ROUTER_IP)..."

sudo ufw allow from $ROUTER_IP to any port 22 proto tcp


# Adicione outras regras específicas aqui se precisar

# Exemplo: permitir tráfego HTTP/HTTPS do roteador

# echo "Permitindo tráfego HTTP/HTTPS (portas 80 e 443) apenas do roteador ($ROUTER_IP)..."

# sudo ufw allow from $ROUTER_IP to any port 80 proto tcp

# sudo ufw allow from $ROUTER_IP to any port 443 proto tcp


# Habilita o UFW

echo "Habilitando o UFW..."

sudo ufw enable


echo "Configuração do UFW concluída!"

echo "Status atual do UFW:"

sudo ufw status verbose 
