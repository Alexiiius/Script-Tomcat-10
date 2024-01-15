#!/bin/bash

# Este script instala y configura Tomcat 10 en Ubuntu 20.04
# Se debe ejecutar con permisos de superusuario

# Salir en caso de error
set -e

# Comprobar que se ejecuta como superusuario
echo "Actualizando sistema..."
apt update
apt upgrade -y

# Instalar Java 17
echo "Instalando Java 17..."
apt install -y openjdk-17-jdk
java -version

# Descargar Tomcat
echo "Descargando Tomcat 10..."
wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.1.18/bin/apache-tomcat-10.1.18.tar.gz -P /tmp

# Descomprimir Tomcat
echo "Descomprimiendo Tomcat..."
mkdir -p /opt/tomcat
tar xf /tmp/apache-tomcat-10*.tar.gz -C /opt/tomcat --strip-components=1

# Crear grupo tomcat
echo "Creando grupo tomcat..."
if ! getent group tomcat > /dev/null 2>&1; then
    groupadd tomcat
fi

# Crear usuario tomcat
echo "Creando usuario tomcat..."
if ! id -u tomcat > /dev/null 2>&1; then
    useradd -m -s /bin/false -g tomcat -d /opt/tomcat tomcat
fi



# Configurar permisos
echo "Configurando permisos..."
cd /opt/tomcat
# Cambiar el propietario y grupo de todos los archivos y subdirectorios a tomcat
chown -R tomcat:tomcat /opt/tomcat/
# Permisos de lectura y ejecución para el grupo tomcat
chmod -R g+r conf
chmod g+x conf
chmod -R u+x /opt/tomcat/bin

echo "Configurando usuarios administrativos..."
# Buscar "</tomcat-users>" y añadir los usuarios administrativos. (el \ es para escapar el /)
# El comando sed -i hace los cambios directamente en el archivo y no muestra la salida por pantalla
    sed -i 's/<\/tomcat-users>/  <role rolename="manager-gui" \/>\n  <user username="manager" password="manager_password" roles="manager-gui" \/>\n  <role rolename="admin-gui" \/>\n  <user username="admin" password="admin_password" roles="manager-gui,admin-gui" \/>\n<\/tomcat-users>/' /opt/tomcat/conf/tomcat-users.xml


echo "Configurando acceso a la página del Manager..."
    sed -i '/<Valve/ s/^/<!-- /' /opt/tomcat/webapps/manager/META-INF/context.xml
    sed -i '/:1|0:0:0:0:0:0:0:1" \/>/ s/$/ -->/' /opt/tomcat/webapps/manager/META-INF/context.xml


echo "Configurando acceso a la página del Host Manager..."
    sed -i '/<Valve/ s/^/<!-- /' /opt/tomcat/webapps/host-manager/META-INF/context.xml
    sed -i '/:1|0:0:0:0:0:0:0:1" \/>/ s/$/ -->/' /opt/tomcat/webapps/host-manager/META-INF/context.xml

echo "Creando servicio..."
# Obtener la ruta de la instalación de Java
RUTA=$(update-java-alternatives -l | awk '{print $3}')

cat > /etc/systemd/system/tomcat.service <<EOF
[Unit]
Description=Tomcat
After=network.target

[Service]
Type=forking

User=tomcat
Group=tomcat

Environment="JAVA_HOME=$RUTA"
Environment="JAVA_OPTS=-Djava.security.egd=file:///dev/urandom"
Environment="CATALINA_BASE=/opt/tomcat"
Environment="CATALINA_HOME=/opt/tomcat"
Environment="CATALINA_PID=/opt/tomcat/temp/tomcat.pid"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"

ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh

RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target
EOF

echo "Iniciando Tomcat..."
systemctl daemon-reload
systemctl start tomcat
systemctl --no-pager status tomcat
systemctl enable tomcat

echo "Configurando firewall..."
ufw allow 8080

echo "Tomcat instalado correctamente"
echo "Accede a la página del Manager a través del puerto 8080"
echo "La contraseña para el usuario manager es manager_password por default y para el usuario admin es admin_password por default"