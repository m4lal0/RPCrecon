# RPCRecon

[![GitHub top language](https://img.shields.io/github/languages/top/m4lal0/RPCrecon?logo=gnu-bash&style=flat-square)](#)
[![GitHub repo size](https://img.shields.io/github/repo-size/m4lal0/RPCrecon?logo=webpack&style=flat-square)](#)
[![Kali Supported](https://img.shields.io/badge/Kali-Supported-blue?style=flat-square&logo=linux)](#)
[![Parrot Supported](https://img.shields.io/badge/Parrot-Supported-blue?style=flat-square&logo=linux)](#)
[![By](https://img.shields.io/badge/By-m4lal0-green?style=flat-square&logo=github)](#)

![RPCRecon](./images/Title.png)

<p align="center">
<b>RPCRecon</b> es una herramienta en Bash para efectuar una enumeración básica y extraer la información más relevante de un Directorio Activo vía rpcclient.
</p>

Esta utilidad nos permitirá obtener la siguiente información de un Dominio:

+ Usuarios del Dominio
+ Usuarios del Dominio con su descripción
+ Usuarios Administradores del Dominio
+ Grupos del Dominio
+ Dominios dentro de la red

## Instalación

```
wget https://raw.githubusercontent.com/m4lal0/RPCrecon/main/rpcrecon.sh
chmod +x rpcrecon.sh && mv rpcrecon.sh /usr/local/bin/rpcrecon
```

## ¿Cómo usar la herramienta?

Al ejecutar la herramienta nos muestra el Panel de Ayuda

![Panel de Ayuda](./images/HelpPanel.png)

Para su ejecución, es necesario especificar el modo de enumeración a usar, mostrados en el panel de ayuda.

El modo de enumeración ***Users***, nos permitirá obtener un listado de los usuarios existentes en el dominio (si no se especifica en los parámetros el Usuario y Password, se efecturará como **Null Session**):

![RPCRecon-Users](./images/Users.png)

El modo de enumeración ***UsersInfo***, nos permitirá obtener un listado de los usuarios existentes en el dominio con su descripción (si no se especifica en los parámetros el Usuario y Password, se efecturará como **Null Session**), pudiendo así identificar a usuarios potenciales:

![RPCRecon-UsersInfo](./images/UserInfo.png)

El modo de enumeración ***Admins***, nos permitirá obtener un listado de los usuarios administradores existentes del dominio (si no se especifica en los parámetros el Usuario y Password, se efecturará como **Null Session**). Esta parte es crucial, puesto que el atacante siempre va a ir en busca de las credenciales de estos, dado que poseen privilegio total sobre el dominio.

![RPCRecon-Admins](./images/Admins.png)

El modo de enumeración ***Groups***, nos permitirá obtener un listado de los grupos existentes del dominio (si no se especifica en los parámetros el Usuario y Password, se efecturará como **Null Session**).

![RPCRecon-Groups](./images/Groups.png)

El modo de enumeración ***Domains***, nos permitirá obtener un listado de los Dominios existentes dentro de la red (si no se especifica en los parámetros el Usuario y Password, se efecturará como **Null Session**).

![RPCRecon-Domains](./images/Domains.png)

Por último, el modo de enumeración ***All***, nos efectuará todas las enumeraciones de forma simultánea, pudiendo así visualizar la información más relevante del dominio.