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
    mariadb -h "$HOST" -u"$USUARIO" -p"$CLAVE" --skip-ssl -e "select schema_name from information_schema.schemata;"
}

crear_usuario(){
    echo "Vamos a crear un usuario" 
    read -p "Necesito el nombre del usuario" NUEVOUSUARIO
    read -p "Necesito La clave de $NUEVOUSUARIO" CLAVEUSUARIO
    read -p "Necesito el ambito del $NUEVOUSUARIO" AMBITO
    mariadb -h "$HOST" -u"$USUARIO" -p"$CLAVE" --skip-ssl -e "create user if not exists '$NUEVOUSUARIO'@'$AMBITO' identified by '$CLAVEUSUARIO';"
}

listar_usuario(){
    mariadb -h "$HOST" -u"$USUARIO" -p"$CLAVE" --skip-ssl -e "select distinct concat(user,'@', host) As usuario_host from mysql.user;"
}

otorgar_permisos_totales(){
    read -p "Necesito el nombre del usuario: " NUEVOUSUARIO
    read -p "Necesito el ambito del $NUEVOUSUARIO" AMBITO
    read -p "Sobre que db actuamos?: " DB
    mariadb -h "$HOST" -u"$USUARIO" -p"$CLAVE" --skip-ssl -e "grant all privileges on \`$DB\`.* to '$NUEVOUSUARIO'@'$AMBITO';"
    mariadb -h "$HOST" -u"$USUARIO" -p"$CLAVE" --skip-ssl -e "flush privileges;"
}

eliminar_usuario(){
    read -p "Nombre del usuario a eliminar: " USUARIOELIMINAR
    read -p "El ambito del $USUARIOELIMINAR" AMBITO
    mariadb -h "$HOST" -u"$USUARIO" -p"$CLAVE" --skip-ssl -e "drop user if exists '$USUARIOELIMINAR'@'$AMBITO';"

}

eliminar_db(){
    read -p "Nombre de la db a eliminar: " DBELIMINAR
    mariadb -h "$HOST" -u"$USUARIO" -p"$CLAVE" --skip-ssl -e "drop database if exists $DBELIMINAR;"
}



MENU=$(cat << 'EOF'
====================================
      MENÚ DE OPCIONES
====================================
1) Listar DBs
2) Crear DBs
3) Crear Usuario
4) Listar Usuarios
5) Asignar permisos de usuario(totales)
6) Eliminar Usuario
7) Eliminar Db
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
                otorgar_permisos_totales
                ;;
            6)
                eliminar_usuario
                ;;
            7)
                eliminar_db
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
