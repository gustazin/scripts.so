#!/bin/bash

echo -e "\033[1;34m TraceHunter-Forensic Collector \033[0m"

#verifica se o script se o arquivo estÃ¡ rodamdo como root 


if [[ $EUID -ne 0 ]]; then 
	echo -e "\033[1;31m Este script precisa ser executado como root. 
	\033[0m"
	exit 1 
fi 

# Criando diretÃrio para os arquivos coletados 
COLLECTED_DIR="collected_files"
mkdir -p "$COLLECTED_DIR"

#exibindo mensagem mo inicio do processo 
echo -e "\033[1;35m Coletando arquivos do sistema... \033[0m"

#coleta de informaÃ§Ãµes do sistema
echo -e "\033[1;95m Listando informaÃÃes sobre discos e partiÃÃes... \033[0m"
lsblk > disk_info.txt

#coletando informaÃÃes de conexoes de rede 
echo -e "\033[1;95m Coletando informaÃ§Ãµes de rede. \033[0m"
ss > active_connections.txt
netstat >open_ports.txt

#coletando processos em execuÃÃo
echo -e "\033[1;95m coletando lista de processos... \033[0m"
ps > process_list.txt

#coletando registros do sistema
echo -e "\033[1;95m coletando logs do sistema... \033[0m"
cp /var/log/syslog $COLLECTED_DIR/syslog.log
cp /var/log/auth.log $COLLECTED_DIR/auth.log
cp /var/log/dmesg  $COLLECTED_DIR/dmesg.log

#coleta de arquivo de configuiraÃÃo
echo -e "\033[1;95m coletando arquivos de configuraÃÃo... \033[0m"
cp -r /etc/ $COLLECT_DIR/etc_bkp

#coleta de lista de arquivos no diretÃ³rio raiz 
echo -e "\033[1;95m Listando o diretÃrio raiz... \033[m"
ls -la /  > root_dir_list.txt

#compactando e nomeando o arquivo de saida 
DATA_HORA=$(date +"%Y%m%d_%H%M%S")
HOSTNAME=$(hostname)
ARQUIVO_DESTINO="TraceHunter_${HOSTNAME}_${DATA_HORA}.tar.gz"
tar -czf "$ARQUIVO_DESTINO" -c "$COLLECTED_DIR"
echo -e "\033[1;94m Arquivo gerado: $ARQUIVO_DESTINO \033[m"
