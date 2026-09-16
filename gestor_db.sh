#!/bin/bash

#   Ruta absoluta al archivo de credenciales.env
ARCHIVO="$(dirname "$(readlink -f "$0")")/credenciales.env"
#   Traigo las credenciales
source $ARCHIVO

traer_db(){
    mariadb -h "$HOST" -u"$USUARIO" -p"$CLAVE" --skip-ssl -e "show databases;" 
}

crear_db(){
    read -p "Ingresa el nombre de la base de datos a crear..." DATABASE
    mariadb -h "$HOST" -u"$USUARIO" -p"$CLAVE" --skip-ssl -e "create database if not exists \"$DATABASE"\;"
    echo "Db creada"
}

MENU=$(cat << 'EOF'
====================================
      MENÚ DE OPCIONES
====================================
1) Mostrar DBs
2) Crear DBs
3) ???
====================================
EOF
)





if [ -f $ARCHIVO ]; then
    echo "$MENU"
    read ELECCION
    case $ELECCION in
        1)
            echo "Dbs en Existencia:"
            traer_db
            ;;
        2)
            echo "Dbs creada"
            crear_db
            ;;
        3)
            echo "???"
            ;;
        *)
            echo "???"
            ;;
    esac

else
    echo "El archivo no existe."
fi