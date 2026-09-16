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
    mariadb -h "$HOST" -u"$USUARIO" -p"$CLAVE" --skip-ssl -e "create database if not exists $DATABASE;"
    echo "Db creada"
}

listar_db(){
    mariadb -h "$HOST" -u"$USUARIO" -p"$CLAVE" --skip-ssl -e "select schema_name from information_schema.schemata"    
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

#   Necesito que el archivo exista
if [ -f $ARCHIVO ]; then
    # Verifico si el cliente mariadb esta instalado
    if command -v mariadb &> /dev/null; then
        # En este caso mostramos menu y esperamos ingreso de opciones por teclado        
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
                listar_db
                ;;
            *)
                echo "???"
                ;;
        esac
    else
        # Código si NO se cumple la condicion2
        echo "Estamos al horno, no tenes instalado el cliente mariadb"
    fi
else
    # Código si NO se cumple la condicion1
    echo "Estamos al horno con papas, no tenes el archivo de credenciales.env"
fi
