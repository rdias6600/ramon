#!/bin/bash

tput reset
__Y=$(echo -e "\e[33;1m");__A=$(echo -e "\e[36;1m");__R=$(echo -e "\e[31;1m");__O=$(echo -e "\e[m");

cat <<EOL
		
		
			
			====================================================
			
				        ${__Y}INSTALADOR ARCH LINUX${__O}
					   
			====================================================
			
			==> Autor: leo.arch <leo.arch@bol.com.br>
			==> Script: arch.sh v1.0
			==> DescriÃ§Ã£o: Instalador AutomÃ¡tico Arch Linux
			
					    ${__Y}INFORMAÃ‡Ã”ES${__O}
					   
			Nesse script serÃ¡ necessÃ¡rio vocÃª escolher sua par-
			tiÃ§Ã£o Swap, Root e Home (Swap/Home nÃ£o obrigatÃ³rias)
		
			Utilizaremos o particionador CFDISK
			CÃ³digo das PartiÃ§Ãµes para quem quiser usar GDISK:
			==> EF02 BIOS
			==> EF00 EFI
			==> 8200 SWAP
			==> 8304 /
			==> 8302 /home
			
			====================================================
			
				     ${__Y}CONTINUAR COM A INSTALAÃ‡ÃƒO?${__O}
					
			   Digite s/S para continuar ou n/N para cancelar
			   DESEJA REALMENTE INICIAR A INSTALAÃ‡ÃƒO ? ${__Y}[S/n]${__O}
			   
			====================================================
EOL

setterm -cursor off

# cores
_n="\e[36;1m";_w="\e[37;1m";_g="\e[32;1m";_am="\e[33;1m";_o="\e[m";_r="\e[31;1m";

echo -ne "\n "
read -n 1 INSTALAR

tput reset

if [[ "$INSTALAR" != @(S|s) ]]; then
	exit $?
fi

echo

lsblk -l | grep disk # comando para listar os discos

echo -en "\n${_g}	Logo acima estÃ£o listados os seus discos${_o}\n"
echo -en "\n${_g}	Informe o nome do seu disco${_o} (Ex: ${_r}sda${_o}):${_w} "
read  _hd
_hd="/dev/${_hd}"
export _hd

echo

cfdisk $_hd # entrando no particionador cfdisk

if [ $? -eq 0 ]; then
    echo
else
    echo -e "\n${_r} ATENÃ‡ÃƒO:${_o} Disco ${_am}$_hd${_o} nÃ£o existe! Execute novamente o script e insira o nÃºmero corretamente\n"; exit 1
fi

tput reset
setterm -cursor off

echo -e "\n${_n} OK, vocÃª definiu as partiÃ§Ãµes, caso deseje cancelar, precione${_w}: Ctrl+c"
echo -e "\n${_n} Use os nÃºmero das partiÃ§Ãµes nas perguntas abaixo${_w}\n"

echo "==========================================================="
fdisk -l $_hd
echo "==========================================================="

echo -e "\n${_n} CONSULTE ACIMA O NÃšMERO DAS SUAS PARTIÃ‡Ã•ES${_o}"

echo -en "\n${_g} Modo de instalaÃ§Ã£o EFI?${_o} (Digite o NÃšMERO, ex: ${_r}1${_o} para sda1) ou tecle ${_am}ENTER${_o} caso nÃ£o tenha:${_w} "
read _efi

if [ -n "$_efi" ]; then
	_efi="/dev/sda${_efi}"
	export _efi
fi

echo -en "\n${_g} Caso tenha partiÃ§Ã£o SWAP${_o} (Digite o NÃšMERO, ex: ${_r}2${_o} para sda2) ou tecle ${_am}ENTER${_o} caso nÃ£o tenha:${_w} "
read _swap

if [ -n "$_swap" ]; then
	_swap="/dev/sda${_swap}"
	export _swap
fi

echo -en "\n${_g} Informe o NÃšMERO da partiÃ§Ã£o ROOT${_o} (Digite o NÃšMERO, ex: ${_r}3${_o} para sda3):${_w} "
read  _root

if [ "$_root" == "" ]; then
	cat <<STI
	
	${__R}=====================================
	AtenÃ§Ã£o: PartiÃ§Ã£o ROOT Ã© obrigatÃ³ria!
	=====================================${__O}

STI
	echo -en "${_am} Execute novamente o script e crie a partiÃ§Ã£o Root.${_o}\n\n"; exit 1;
else
	_root="/dev/sda${_root}"
	export _root
fi

echo -en "\n${_g} Caso tenha partiÃ§Ã£o HOME${_o} (Digite o NÃšMERO, ex: ${_r}4${_o} para sda4) ou tecle ${_am}ENTER${_o} caso nÃ£o tenha:${_w} "
read _home

if [ -n "$_home" ]; then
	_home="/dev/sda${_home}"
	export _home
fi

tput reset
cat <<STI
 ${__A}======================
 Iniciando a InstalaÃ§Ã£o
 ======================${__O}

STI

echo -e " Suas partiÃ§Ãµes definidas foram:\n"

if [ "$_efi" != "" ]; then
	echo -e " ${_g}EFI${_o}  = $_efi"
else
	echo -e " ${_g}EFI${_o} = SEM EFI"
fi

if [ "$_swap" != "" ]; then
	echo -e " ${_g}Swap${_o} = $_swap"
else
	echo -e " ${_g}Swap${_o} = SEM SWAP"
fi

echo -e " ${_g}Root${_o} = $_root"

if [ "$_home" != "" ]; then
	echo -e " ${_g}Home${_o} = $_home\n"
else
	echo -e " ${_g}Home${_o} = SEM HOME\n"
fi
echo "==========================================================="
fdisk -l $_hd
echo "==========================================================="

echo -ne "\n Verifique se as informaÃ§Ãµes estÃ£o corretas comparando com os dados acima.\n"
echo -ne "\n Se tudo estiver certo, Digite ${_g}s/S${_o} para continuar ou ${_g}n/N${_o} para cancelar: "
read -n 1 comecar

if [[ "$comecar" != @(S|s) ]]; then
	exit $?
fi

echo -e "\n\n ${_n}Continuando com a instalaÃ§Ã£o ...${_o}\n"

# swap
if [ "$_swap" != "" ]; then
	echo -e "${_g}===> Criando e ligando Swap${_o}"
	mkswap $_swap && swapon $_swap
fi

# root
echo -e "\n${_g}===> Formatando e Montando Root${_o}"
mkfs.ext4 -F $_root && mount $_root /mnt

# home
if [ "$_home" != "" ]; then
	echo -e "\n${_g}===> Formatando, Criando e Montando Home${_o}"
	mkfs.ext4 -F $_home && mkdir /mnt/home && mount $_home /mnt/home	
fi

# efi
if [ "$_efi" != "" ]; then
	echo -e "${_g}Formatando, Criando e Montando EFI${_o}"
	mkfs.fat -F32 $_efi && mkdir /mnt/boot && mount $_efi /mnt/boot
fi

# set morrorlist br (opcional)
echo -e "${_g}===> Setando mirrorlist BR${_o}"
wget "https://raw.githubusercontent.com/leoarch/arch-install/master/mirror-br" -O /etc/pacman.d/mirrorlist 2>/dev/null

# instalando base e base-devel
echo -e "${_g}===> Instalando base/base-devel${_o}"
pacstrap /mnt base base-devel

# gerando fstab
echo -e "${_g}===> Gerando FSTAB${_o}"
genfstab -U -p /mnt >> /mnt/etc/fstab

# download script mode chroot
echo -e "${_g}===> Baixando script para ser executado como chroot ...${_o}"
wget https://raw.githubusercontent.com/rdias6600/Teste/master/chroot.sh && chmod +x chroot.sh && mv chroot.sh /mnt

# run script
echo -e "${_g}===> Executando script ...${_o}"
arch-chroot /mnt ./chroot.sh

# umount
echo -e "${_g}===> Desmontando partiÃ§Ãµes${_o}"
umount -R /mnt

cat <<EOI

 ${__A}=============
      FIM!    
 =============${__O}
EOI

exit
