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
    echo $MENU
    read entorno

    # 2. El 'case' corre dentro del 'if'
    case $entorno in
        1)

            echo "Dbs en Existencia:"
            traer_db


            ;;
        2)
            echo "Conectando al servidor de Pruebas..."
            ;;
        3)
            echo "¡Alerta! Conectando al servidor de Producción..."
            ;;
        *)
            echo "Entorno desconocido."
            ;;
    esac

else
    echo "El archivo no existe."
fi