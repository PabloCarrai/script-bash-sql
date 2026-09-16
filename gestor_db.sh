#!/bin/bash

#   Ruta absoluta al archivo de credenciales.env
ARCHIVO="$(dirname "$(readlink -f "$0")")/credenciales.env"
#   Traigo las credenciales
source $ARCHIVO

traer_db(){
    mariadb -h "$HOST" -u"$USUARIO" -p"$CLAVE" --skip-ssl -e "show databases;" 
}

if [ -f $ARCHIVO ]; then
    echo "Dbs en Existencia:"
    traer_db
else
    echo "El archivo no existe."
fi