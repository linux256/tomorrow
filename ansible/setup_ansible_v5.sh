#!/bin/bash

# ejecutar como ansible (sudoer)
#   sudo usermod -aG wheel ansible
#   su ansible
# debe existir fichero "ansible.cfg" estándar


# VARIABLES
HOST_ROOTPASS="root"
HOST_ANSIBLEPASS="ansible"
HOST_ANSIBLEPASSHASH=$(openssl passwd -6 -salt $(date +%s%N) "$HOST_ANSIBLEPASS")

# ENTRADA AL SCRIPT
ENFASIS='\n\e[1m%s\e[0m\n'
printf "\n\e[1;4m%*s\e[0m\n" "$(tput cols)"
printf $ENFASIS "SCRIPT PARA GESTIONAR MEDIANTE ANSIBLE UN NODO REMOTO"
printf "                                        v5 2025-11-02\n"
printf "se realizan las siguientes operaciones:\n"
printf "    1,2: acceder por SSH con usuario root, contraseña $HOST_ROOTPASS\n"
printf "      4: instalar python\n"
printf "      5: crear usuario ansible, contraseña $HOST_ANSIBLEPASS\n"
printf "      5: habilitar usuario ansible para sudo, sin solicitar contraseña\n"
printf "      6: crear clave publica para conectar al host con usuario ansible por SSH\n"
printf "    3,7: definir host remoto en SSH para acceder con usuario ansible con clave\n"
printf "      8: probar modulo ping de ansible\n"
printf "\n"
printf "         primer argumento: nombre del host remoto\n"
printf "        segundo argumento: direccion IP del host remoto\n"
printf "    fichero de inventario: ./managed_hosts"
printf "\n\e[1;4m%*s\e[0m\n" "$(tput cols)"

if [ -z $1 ]
then
  read -p "....NOMBRE DEL HOST: " HOST_NAME
  [ -z $HOST_NAME ] && exit
else
  HOST_NAME="$1"
  printf $ENFASIS "nombre del host:    $HOST_NAME"
  read -r -p "....enter para confirmar, otro nombre para cambiar: " CONFIRMA
  [[ $CONFIRMA != "" ]] && HOST_NAME="$CONFIRMA"
fi

if [ -z $2 ]
then
  read -p ".......DIRECCION IP: " HOST_IP
  [ -z $HOST_IP ] && exit
else
  HOST_IP="$2"
  printf $ENFASIS "dirección IP:       $HOST_IP"
  read -r -p "....enter para confirmar, otra dir.IP para cambiar: " CONFIRMA
  [[ $CONFIRMA != "" ]] && HOST_IP="$CONFIRMA"
fi

! grep -q $HOST_NAME managed_hosts && echo $HOST_NAME >> managed_hosts
printf "\e[1;4m%*s\e[0m\n" "$(tput cols)"





# REQUISITO: tiene que haber conectividad
printf $ENFASIS "....paso 1    probando conectividad con $HOST_NAME"
read -n 1 -r -s -p $'....pulse para continuar ' && printf " ok\n"
#printf "....paso 1    probando conectividad con $HOST_NAME\n"
while ! ping -c 1 -n -w 1 $HOST_IP &> /dev/null
do
	printf "%c" "o"
done
printf "* ok\n....$HOST_NAME alcanzable\n"






# REQUISITO: tiene que existir conexión SSH al host con el usuario root
printf $ENFASIS "....paso 2    probando conexion ssh con usuario root@$HOST_IP usando contraseña"
read -n 1 -r -s -p $'....pulse para continuar ' && printf " ok\n"
printf "....borrando clave pública $HOST_IP\n"
ssh-keygen -R $HOST_IP
printf "....agregando clave pública $HOST_IP\n"
mkdir -p ~/.ssh && ssh-keyscan -t rsa $HOST_IP >> ~/.ssh/known_hosts
sshpass -p "$HOST_ROOTPASS" ssh root@$HOST_IP exit && printf "....sesion SSH establecida y cerrada\n"



# REQUISITO: configurar ssh usando nombre host remoto, con usuario ansible usando clave publica
printf $ENFASIS "....paso 3    definir conexion SSH a $HOST_NAME con usuario ansible y clave publica"
read -n 1 -r -s -p $'....pulse para continuar ' && printf " ok\n"
if [ $(sed -n "/Host $HOST_NAME/p" ~/.ssh/config | wc -l) -eq 0 ]
then
    printf "....creando nueva entrada de conexion SSH al host $HOST_NAME\n"
    echo "Host $HOST_NAME"                                         >> ~/.ssh/config
    echo "    Hostname      $HOST_IP"                              >> ~/.ssh/config
    echo "    User          ansible"                               >> ~/.ssh/config
    echo "    IdentityFile  ~/.ssh/ansible_""$HOST_NAME""_id_rsa"  >> ~/.ssh/config
fi
grep $HOST_NAME ~/.ssh/config -A4




# REQUISITO: instalar python3 en host remoto (necesita resolucion nombre <-> IP del paso anterior)
printf $ENFASIS "....paso 4    instalando python3 en $HOST_NAME"
read -n 1 -r -s -p $'....pulse para continuar ' && printf " ok\n"
ansible -u root --extra-vars "ansible_password=$HOST_ROOTPASS" $HOST_NAME  -m raw  -a "dnf install python3 -y"




# REQUISITO: crear usuario ansible con capacidad de sudo (necesita resolucion nombre <-> IP de configuracion SSH)
printf $ENFASIS "....paso 5    creando usuario (ansible) en $HOST_NAME con capacidad sudo sin contraseña"
read -n 1 -r -s -p $'....pulse para continuar ' && printf " ok\n"
printf "....creando usuario\n"
ansible -u root --extra-vars "ansible_password=$HOST_ROOTPASS" $HOST_NAME  -m user -a "name=ansible state=present password='$HOST_ANSIBLEPASSHASH'"
printf "....configurando sudo\n"
ansible -u root --extra-vars "ansible_password=$HOST_ROOTPASS" $HOST_NAME  -m copy -a "content='ansible ALL=(ALL) NOPASSWD:ALL\n' dest=/etc/sudoers.d/10_ansible"




# REQUISITO: crear clave SSH para usuario ansible y copiar a destino
printf $ENFASIS "....paso 6    copiar clave publica del usuario ansible para ssh al host remoto"
read -n 1 -r -s -p $'....pulse para continuar ' && printf " ok\n"
printf "....creando backup clave privada de conexion al host $HOST_NAME\n"
mv -f ~/.ssh/ansible_"$HOST_NAME"_id_rsa      ~/.ssh/ansible_"$HOST_NAME"_id_rsa.bak_"$(date +%s)"
printf "....creando backup clave publica de conexion al host $HOST_NAME\n"
mv -f ~/.ssh/ansible_"$HOST_NAME"_id_rsa.pub  ~/.ssh/ansible_"$HOST_NAME"_id_rsa.pub.bak_"$(date +%s)"
printf "....generando nuevas claves de conexion al host $HOST_NAME\n"
ssh-keygen -q -P "" -f ~/.ssh/ansible_"$HOST_NAME"_id_rsa
printf "....copiando nueva clave publica de conexion a $HOST_NAME al servidor $HOST_IP\n"
sshpass -p "$HOST_ANSIBLEPASS" ssh-copy-id -i ~/.ssh/ansible_"$HOST_NAME"_id_rsa.pub $HOST_IP




# REQUISITO: poder establecer ssh con host remoto como ansible
printf $ENFASIS "....paso 7    conectar con SSH a $HOST_NAME con usuario (ansible) y clave"
read -n 1 -r -s -p $'....pulse para continuar ' && printf " ok\n"
ssh $HOST_NAME exit && printf "....sesion ssh establecida y cerrada\n"




# NODO GESTIONABLE
printf $ENFASIS "....paso 8    comprobando que el nodo es gestionable mediante ansible"
ansible $HOST_NAME -m ping
