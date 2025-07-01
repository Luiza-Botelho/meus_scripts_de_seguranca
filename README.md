🚀 Scripts de Segurança do Sistema

Este repositório contém um conjunto de scripts Bash projetados para aprimorar a segurança de um sistema Linux, combinando um sistema de varredura de vírus (c-icap e ClamAV) com uma configuração robusta de firewall (UFW). Os scripts são projetados para serem executados em uma sequência específica para garantir uma configuração limpa e eficaz.

📦 Conteúdo do Repositório

    01-flush_c-icap_clamav.sh: Script para limpar e redefinir as configurações do c-icap e ClamAV.

    02-suricada_borg_config.sh: Script principal para instalar e configurar c-icap e ClamAV para varredura de vírus.

    03-configura_ufw.sh: Script para configurar o firewall UFW, limitando o tráfego de entrada apenas ao roteador.

✨ Propósito dos Scripts

Esses scripts trabalham em conjunto para fornecer uma solução de segurança em camadas:

    Limpeza e Preparação 🧹: O primeiro script garante que quaisquer configurações anteriores ou problemáticas do c-icap e ClamAV sejam removidas, preparando o terreno para uma nova instalação.

    Proteção contra Malware 🛡️: O segundo script instala e configura o c-icap (um proxy ICAP) para integrar com o ClamAV (um motor antivírus). Isso permite que seu sistema inspecione e escaneie o tráfego de rede em busca de vírus e malwares.

    Segurança de Rede 🔒: O terceiro script configura o UFW (Uncomplicated Firewall) para criar uma barreira de segurança na rede. Ele define uma política de "negar tudo" para o tráfego de entrada e só permite conexões de entrada específicas, como SSH, vindas do seu roteador, reduzindo drasticamente a superfície de ataque.

📋 Pré-requisitos

    Sistema operacional baseado em Debian/Ubuntu (apt).

    Acesso de superusuário (sudo).

    Importante: Conhecer o endereço IP do seu roteador para configurar o UFW corretamente.

🚀 Como Usar os Scripts

É CRÍTICO EXECUTAR OS SCRIPTS NA ORDEM ESPECIFICADA.

    Clone o Repositório:
    Bash

git clone <URL_DO_SEU_REPOSITORIO>
cd <nome_do_diretorio_clonado>

Torne os Scripts Executáveis:
Bash

chmod +x 01-flush_c-icap_clamav.sh
chmod +x 02-suricada_borg_config.sh
chmod +x 03-configura_ufw.sh

Edite o Script do UFW (Obrigatório) ✍️:
Abra o arquivo 03-configura_ufw.sh e substitua o valor da variável ROUTER_IP pelo IP real do seu roteador. Exemplo:
Bash

# Mude este IP para o IP real do seu roteador
ROUTER_IP="SEU_IP_DO_ROTEADOR_AQUI"

Você pode descobrir o IP do seu roteador usando ip route | grep default ou route -n | grep "UG".

Execute os Scripts na Ordem Correta:

    Passo 1: Limpeza (Opcional, mas Recomendado)
    Bash

sudo ./01-flush_c-icap_clamav.sh

Este script irá redefinir as configurações de c-icap e ClamAV.

Passo 2: Configuração de Varredura de Vírus
Bash

sudo ./02-suricada_borg_config.sh

Este script instala (se necessário) e configura o c-icap com o ClamAV.

Passo 3: Configuração do Firewall UFW
Bash

        sudo ./03-configura_ufw.sh

        Este script configura o firewall para restringir o tráfego de entrada.

✅ Verificação Pós-Execução

Após executar todos os scripts, verifique o status dos serviços para garantir que tudo está funcionando como esperado:

    Verifique o status do ClamAV: sudo systemctl status clamav-daemon

    Verifique o status do c-icap: sudo systemctl status c-icap

    Verifique o status do UFW: sudo ufw status verbose

⚠️ Considerações de Segurança

    Backup: Sempre faça backup de arquivos de configuração importantes antes de executar scripts que os modificam.

    Acesso Físico/Console: Em ambientes de produção, sempre tenha acesso físico ou via console ao seu servidor ao configurar o firewall, caso algo dê errado e você perca o acesso via rede.

    Adaptação: Adapte as regras do UFW no 03-configura_ufw.sh conforme suas necessidades. Se você precisar de outras portas abertas para serviços específicos, adicione-as com cautela.

🤝 Contribuição

Sinta-se à vontade para abrir issues ou pull requests se tiver sugestões de melhoria. Sua contribuição é bem-vinda!
