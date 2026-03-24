🚀 Scripts de Segurança do Sistema

# 🛡️ Linux Hardening Stack: ClamAV + ICAP + UFW

[![Linux](https://img.shields.io/badge/OS-Debian%20%2F%20Ubuntu-orange?logo=linux&logoColor=white)](https://www.debian.org/)
[![Shell Script](https://img.shields.io/badge/Shell_Script-Bash-green?logo=gnu-bash&logoColor=white)](https://www.gnu.org/software/bash/)
[![Security](https://img.shields.io/badge/Security-Hardening-red)](https://en.wikipedia.org/wiki/Hardening_(computing))

Este repositório fornece uma solução de **segurança em camadas** para servidores e estações de trabalho Linux. O objetivo é automatizar a higienização de configurações, a implementação de escaneamento de malware via proxy ICAP e o fechamento rigoroso de portas de rede.

---

## 🧩 Arquitetura da Solução

A execução sequencial destes scripts estabelece três perímetros de defesa:

1.  **Higienização (01-flush):** Remove resquícios de instalações mal sucedidas, garantindo que o estado do sistema seja íntegro antes da nova configuração.
2.  **Proteção de Conteúdo (02-config):** Integra o **ClamAV** (Antivírus) com o **c-icap** (Server), permitindo a inspeção de tráfego e arquivos em nível de serviço.
3.  **Isolamento de Rede (03-ufw):** Implementa uma política de *Default Deny*. O tráfego de entrada é restrito exclusivamente ao Gateway (Roteador), mitigando ataques de movimentação lateral e varreduras externas.

---

## 📦 Conteúdo do Repositório

| Arquivo | Função |
| :--- | :--- |
| `01-flush_c-icap_clamav.sh` | Reset de ambiente e limpeza de configs legadas. |
| `02-suricada_borg_config.sh`| Deploy e integração do motor ClamAV + c-icap. |
| `03-configura_ufw.sh` | Configuração restritiva de Firewall (UFW). |

---

## 🚀 Guia de Implementação

### 1. Pré-requisitos
* Sistema baseado em **Debian/Ubuntu**.
* Privilégios de **Root** (Sudo).
* Conhecimento do IP do seu Gateway (ex: `192.168.1.1`).

### 2. Instalação
```bash
# Clone o repositório
git clone <URL_DO_REPOSITORIO>
cd <NOME_DO_DIRETORIO>

# Atribua permissões de execução
chmod +x *.sh

3. Configuração Crítica (UFW)

Antes de executar o passo 03, edite o arquivo para definir seu IP de confiança:
Bash

nano 03-configura_ufw.sh
# Altere: ROUTER_IP="SEU_IP_AQUI"

4. Execução em Ordem
Bash

sudo ./01-flush_c-icap_clamav.sh
sudo ./02-suricada_borg_config.sh
sudo ./03-configura_ufw.sh

✅ Checklist de Verificação

Após a execução, confirme se os escudos estão ativos:

    [ ] sudo systemctl status clamav-daemon (Ativo)

    [ ] sudo systemctl status c-icap (Ativo)

    [ ] sudo ufw status verbose (Deve listar permissões apenas para o IP do Roteador)

⚠️ Notas de Segurança (Disclaimer)

    Backups: Sempre realize backup de /etc/default/ufw e /etc/c-icap/ antes de rodar os scripts.

    Acesso: Certifique-se de ter acesso físico ou via console serial ao servidor para evitar lockout acidental durante a configuração do Firewall.

Desenvolvido por Luiza Grigorowsky - Foco em Segurança Centrada no Humano.
