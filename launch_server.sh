#!/bin/bash

USER=$(whoami)

print_separator(){
    echo ""
    echo "-------------------------------------------------"
    echo ""
}

docker_is_installed(){
    if which docker; then
        echo "Docker esta instalado"
        return 0
    else
        echo "Docker no esta instalado"
    fi
}

check_install_image(){
    if (docker image ls | grep mysql);then
        echo "La imagen de mysql esta instalada en docker" 
        return 0;
    else
        echo "Instalando imagen de mysql en docker"
        if (docker pull mysql) ; then
            echo "Imagen instalada."
            return 0;
        else
            echo "Algo salió mal instalando la imagen"
            exit 1;
        fi
    fi
}

theres_previous_container(){
    # Start a running or stopped container 
    if(docker ps -a | grep mysql); then
       docker start $(docker ps -a | grep mysql | cut --delimiter=' ' -f 1)
       return 0;
    fi
    return 1;
}


# ENTRY POINT
if !(docker_is_installed); then
    echo Instalar docker para poder continuar...
    return 1
    echo docker esta instalado.
fi

print_separator

if !(check_install_image); then #Si la imagen no esta instalada, instalarla
    exit 1; 
fi

print_separator
if (theres_previous_container); then
    echo "Se encontro una instancia anterior de la imagen, ahora está corriendo"
    exit 0;
fi

# Si no hay un container viejo
echo "Elegir una contraseña para el servidor mysql."
echo "Si se deja vacia, el server no tendrá contraseña."
echo ">>>"
read mysql_root_pass

echo $mysql_root_pass
if [ -z "${mysql_root_pass}" ]; then # El usuario eligio contraseña vacia
    docker run --name "$(whoami)_mysql" -e MYSQL_ALLOW_EMPTY_PASSWORD=yes -d mysql:latest
else
    docker run --name "$(whoami)_mysql" -e MYSQL_ROOT_PASSWORD="$mysql_root_pass" -d mysql:latest
fi

print_separator
if (docker ps | grep $(whoami)_mysql);then
    echo
    echo
    echo "Tu servidor de mysql esta corriendo en docker :)
    Just look at him go"
else
    echo "Tu servidor no parece haberse levantado :(, posiblemente este
    detenido."
    echo "Intenta 'docker run $(whoami)_mysql' o rendite ante el sistema"
    exit 1;
fi


print_separator
echo "Username: root"
echo "Password: $mysql_root_pass"
echo "Esta es tu ip:"
docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker ps -a | grep mysql | cut --delimiter=' ' -f 1)

echo ""
echo "Para detener el container usa 'docker stop $(whoami)_mysql'"
echo
echo "Para iniciar el container usa este mismo script o 'docker start $(whoami)_mysql'"
echo
echo "Cuando necesites saber si esta o no 'running' tu container usa 'docker ps -a'"
echo 
echo "Por si necesitas algo tan extremo como borrar le contenedor y revertir
todo usa 'docker rm -f $(whoami)_mysql' (WARNING: Si habia datos en tu server o un esquema vas a perderlo)"

sleep 4
