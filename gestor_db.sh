#!/bin/bash

#   Ruta absoluta al archivo de credenciales.env
ARCHIVO="$(dirname "$(readlink -f "$0")")/credenciales.env"
#   Traigo las credenciales
source $ARCHIVO

traer_db(){
    mariadb -h "$HOST" -u"$USUARIO" -p"$CLAVE" --skip-ssl -e "show databases;" 
}

MENU=$(cat << 'EOF'
====================================
      MENÚ DE OPCIONES
====================================
1) Mostrar DBs
2) ???
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
            echo "???"
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