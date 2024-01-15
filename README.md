# Script de Instalación de Tomcat en Ubuntu 20.04

## Descripción

Este script automatiza la instalación y configuración de Tomcat en Ubuntu 20.04.

## Tabla de Contenidos

- [Instalación](#instalación)
- [Uso](#uso)
- [Datos de Interes](#datos-de-interes)

## Instalación

Para instalar y ejecutar este script, sigue estos pasos:

1. Asegúrate de tener instalado tar en tu sistema. Si no lo tienes, puedes instalarlo con sudo apt install tar.

2. Descarga el script de instalación de Tomcat.

3. Navega hasta el directorio donde descargaste el script.

4. Ejecuta el script con sudo bash script.sh. Esto instalará Tomcat y configurará los permisos y usuarios necesarios.

5. El script también configura el acceso a las páginas del Manager y del Host Manager de Tomcat.

6. Finalmente, el script crea un servicio para Tomcat, lo que permite que Tomcat se inicie automáticamente al arrancar el sistema.

Ahora deberías tener Tomcat instalado y configurado en tu sistema.

## Uso

Una vez instalado Tomcat, puedes acceder a la página del Manager en :8080/manager/html y a la página del Host Manager en :8080/host-manager/html.

El script configura dos usuarios:

1. Un usuario con nombre "manager" y contraseña "manager_password" que tiene el rol "manager-gui".
2. Un usuario con nombre "admin" y contraseña "admin_password" que tiene los roles "manager-gui" y "admin-gui".
Puedes iniciar sesión con cualquiera de estos usuarios.

## Datos de Interes

1. Asegúrate de cambiar las contraseñas "manager_password" y "admin_password" por contraseñas seguras antes de poner tu servidor en producción.

2. El script crea un nuevo grupo y usuario 'tomcat', y cambia el propietario y el grupo de todos los archivos y subdirectorios de Tomcat a 'tomcat'.

3. El script también da permisos de lectura y ejecución al grupo 'tomcat' en el directorio 'conf', y permisos de ejecución al usuario 'tomcat' en el directorio 'bin'.

4. El script está diseñado para Ubuntu 20.04, pero puede funcionar en otras versiones de Ubuntu o en otras distribuciones de Linux con pequeñas modificaciones.

5. El script descarga la version 10.1.18 de Tomcat a traves del enlace oficial de dlcdn. Si deja de funcionar revise dicho enlace o sustituyalo.
