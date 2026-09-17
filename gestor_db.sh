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

crear_usuario(){
    echo "Vamos a crear un usuario" 
    read -p "Necesito el nombre del usuario" NUEVOUSUARIO
    read -p "Necesito La clave de $NUEVOUSUARIO" CLAVEUSUARIO
    mariadb -h "$HOST" -u"$USUARIO" -p"$CLAVE" --skip-ssl -e "create user if not exists $NUEVOUSUARIO@% identified by $CLAVEUSUARIO;"
}

listar_usuario(){
    mariadb -h "$HOST" -u"$USUARIO" -p"$CLAVE" --skip-ssl -e "select distinct User from mysql.user;"
}

MENU=$(cat << 'EOF'
====================================
      MENÚ DE OPCIONES
====================================
1) Mostrar DBs
2) Crear DBs
3) Crear Usuario
4) Listar Usuarios
5) ???...
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
                crear_usuario                
                #echo "Dbs disponibles"
                #listar_db
                ;;
            4)
                listar_usuario
                #echo "Dbs disponibles"
                #listar_db
                ;;
            5)
                echo "Dbs disponibles"
                #listar_db
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
