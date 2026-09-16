# script-bash-sql

>   Practica para crear script en bash que resuelvan ciertas tareas comunes. 

[La teoria esta Aca](https://github.com/PabloCarrai/Especializacion_Base_datos/blob/main/Materiales-8/Fix/Gestion-de-Usuarios-en-MySQL.md).

---
#   Para que funcione
> Es necesario que cambias el contenido del archivo credenciales.env. 

El archivo tiene un contenido como el siguiente 

```bash
USUARIO="mi_usuario"
CLAVE="mi_contraseña_segura"
HOST="192.168.0.238"
```
Tienes que poner las credenciales de un usuario administrativo. 
Y el dato del host que tiene mariadb funcionando. 
Es importante tener en cuenta que tu usuario deberia de poder conectarse desde remoto a mariadb

---

#   Como corre

```bash
cd script-bash-sql
bash gestor_db.sh
```

---

Lo que quiero hacer es.

---

- [ ] Script que se conecte a mariadb con usuario administrativo.
- [ ] Que tenga una funcion para cada tarea comun en el Documento en cuestion.
- [ ] Que las funciones validen bien la ayuda, y las opciones que se usan.
- [ ] Las credenciales del usuario Administrativo las quiero cargar de un archivo diferente
