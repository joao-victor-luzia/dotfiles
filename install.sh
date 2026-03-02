#!/bin/bash

# Cria a pasta .ssh se não existir
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# Verifica se a variável SSH_ARM_ORACLE (vinda dos Secrets) existe
if [ ! -z "$SSH_ARM_ORACLE" ]; then
    echo "Configurando chave SSH dos Secrets..."
    # Salva a chave privada e remove caracteres indesejados de quebra de linha
    echo "$SSH_ARM_ORACLE" | tr -d '\r' > ~/.ssh/id_ed25519
    chmod 600 ~/.ssh/id_ed25519
    
    # Inicia o agente e adiciona a chave
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519
fi

# Opcional: Copiar seu arquivo de config SSH se você o criou no repo
if [ -f "ssh_config" ]; then
    cp ssh_config ~/.ssh/config
    chmod 600 ~/.ssh/config
fi