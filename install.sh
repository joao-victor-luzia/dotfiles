#!/bin/bash

# Cria a pasta .ssh se não existir e define as permissões corretas
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# 1. Configura a Chave Privada
if [ ! -z "$SSH_ARM_ORACLE" ]; then
    echo "Configurando chave SSH dos Secrets..."
    echo "$SSH_ARM_ORACLE" | tr -d '\r' > ~/.ssh/id_ed25519
    chmod 600 ~/.ssh/id_ed25519
    
    # Inicia o agente e adiciona a chave para não pedir senha
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519
fi

# 2. Gera o arquivo de config dinamicamente usando o Secret do IP
# Isso substitui a necessidade de ter um arquivo ssh_config no repositório
if [ ! -z "$IP_ARM_ORACLE" ]; then
    echo "Gerando configuração SSH dinâmica..."
    cat <<EOT > ~/.ssh/config
Host vps
    HostName $VPS_IP
    User root
    IdentityFile ~/.ssh/id_ed25519
    StrictHostKeyChecking no
EOT
    chmod 600 ~/.ssh/config
    echo "Atalho 'ssh vps' configurado com sucesso!"
else
    echo "Aviso: Secret IP_ARM_ORACLE não encontrado. O arquivo de config não foi gerado."
fi