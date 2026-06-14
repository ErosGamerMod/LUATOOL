#!/data/data/com.termux/files/usr/bin/bash

# Cores
VERDE='\033[0;32m'
VERDE_BRILHANTE='\033[1;32m'
CIANO='\033[1;36m'
BRANCO='\033[1;37m'
VERMELHO='\033[1;31m'
RESET='\033[0m'

clear
echo -e "${VERDE_BRILHANTE}=========================================${RESET}"
echo -e "${CIANO}          WELCOME TO LUA TOOL 🌙        ${RESET}"
echo -e "${VERDE_BRILHANTE}=========================================${RESET}"
echo -e "${VERDE} [+] Status:${BRANCO} Inicializando instalador...${RESET}"
sleep 1

# 1. Instalar dependências
echo -e "\n${CIANO}[*] Verificando dependências...${RESET}"
apt update -y && apt upgrade -y -o Dpkg::Options::="--force-confold"
pkg install -y git curl

# 2. Preparar diretório temporário
TEMP_DIR="temp_lua_repo"
rm -rf "$TEMP_DIR"  # remove qualquer resquício anterior

echo -e "\n${CIANO}[*] Baixando apenas a pasta LUA do GitHub...${RESET}"
git init "$TEMP_DIR"
cd "$TEMP_DIR"
git remote add origin https://github.com/ErosGamerMod/LUATOOL.git
git sparse-checkout init --cone
git sparse-checkout set LUA
git pull origin master
cd ..

# 3. Mover a pasta LUA para o diretório atual (substituindo se existir)
if [ -d "$TEMP_DIR/LUA" ]; then
    rm -rf LUA 2>/dev/null
    mv "$TEMP_DIR/LUA" .
    echo -e "${VERDE_BRILHANTE}[✔] Pasta LUA baixada com sucesso!${RESET}"
else
    echo -e "${VERMELHO}[✘] Erro: Não foi possível baixar a pasta LUA.${RESET}"
    rm -rf "$TEMP_DIR"
    exit 1
fi

# 4. Limpar
rm -rf "$TEMP_DIR"

# 5. (Opcional) Executar algo dentro da pasta LUA, por exemplo o interpretador lua
if [ -f "LUA/lua" ]; then
    echo -e "\n${VERDE_BRILHANTE}=========================================${RESET}"
    echo -e "${CIANO}          FERRAMENTA PRONTA!              ${RESET}"
    echo -e "${VERDE_BRILHANTE}=========================================${RESET}"
    echo -e "${BRANCO}Para usar o interpretador LUA, digite:${RESET}"
    echo -e "${VERDE}./LUA/lua${RESET}"
    # Se quiser executar automaticamente algo, descomente a linha abaixo:
    # ./LUA/lua
else
    echo -e "\n${VERDE_BRILHANTE}Download concluído. A pasta LUA está no diretório atual.${RESET}"
fi