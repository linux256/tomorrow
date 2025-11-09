---
layout: default
title: referencia rapida de git
fecha: 2024-02-13
---

&nbsp;

## 1 qué es git
Software de control de versiones creado en 2005 por Linus Torvalds, para trabajar con varios desarrolladores en el núcleo de Linux.
**git** rastrea el contenido y permite revertir y regresar a una versión anterior del código.

### conceptos
- **rama**, copia independiente del codigo que puede cambiarse y luego integrarse, o no
- **repositorio**, proyecto con multiples archivos, hay 3 servicios online de referencia para alojar repositorios
    - [github](https://github.com/), de microsoft
    - [gitlab](), de gitlab
    - [bitbucket](), de atlassian

&nbsp;

## 2 instalación de git
En RockyLinux (RedHat, CentOS),

    yum install -y git
    git --version
    git config --global user.name "nombre_usuario_defecto_guardar_el_trabajo"
    git config --global user.mail "email_defecto"

&nbsp;

## 3 comenzar cuando el repositorio está en línea
1. Una vez creado el repositorio en línea, obtener la URL para clonarlo localmente

       git clone URL

2. Una vez editados los cambios localmente, revisar estado

       git status

3. Añadir los archivos que están listos para integrarse en el repositorio

       git add NOMBRE_ARCHIVO

4. Integrar los archivos en el repositorio local

       git commit -m "MENSAJE DESCRIPTIVO CAMBIO"

5. Obtener nombre del repositorio en línea (por defecto origin)

       git remote

6. Enviar ficheros a la rama "master" del repositorio en línea "origin"

       git push origin master
       git push origin main  # en github el branch por defecto es main

7. Descargar ficheros de la rama "master" del repositorio en línea "origin"

       git pull origin master
       git pull origin main  # en github el branch por defecto es main

&nbsp;

## 4 comenzar creando un repositorio local y luego enviándolo a un repo en línea

1. Ubicados en el directorio que contendrá los ficheros, iniciar el repositorio git

       git init
       git init -b main  # util para emplea el branch 'main' por defecto en lugar de 'master' (util para github)

3. Revisar estado del repositorio

       git status

4. Añadir ficheros

       git add .

5. Integrar ficheros en el repositorio local

       git commit -m "MENSAJE"

6. Se crea el repositorio remoto (vacío,*sin README*) se obtiene su URL y se añade al proyecto git con el nombre "origin" (por defecto)

       git remote add origin URL
       git remote add origin git@github.com:usuario/repositorio.git   # para conectar por SSH y autenticar con clave publica

8. Se listan los repositorios remotos vinculados al proyecto (debe aparecer "origin" o el nombre que se haya dado)

       git remote

9. Se envian los ficheros a la rama master

       git push origin master


## 5 acceder a github de manera remota sin usuario+contraseña
Desde 2021 no se admite acceso remoto por contraseña a github. Se puede acceder por SSH o emplear un PAT (Personal Access Token)

(1) Para acceder por SSH basta generar una clave local y cargar la clave pública en GitHub.com
       
       #generar la pareja de claves, con passphrase o no y archivándola donde se quiera
       ssh-keygen -t rsa -b 4096 -C "nombre_usuario"
       
       #editar  ~/.ssh/config
       Host github.com
         User git
         IdentityFile ~/path_to_private_key/id_rsa

       #comprobar la conexión
       ssh -T git@github.com
       
       #al definir el repositorio remoto, la URL debe ser: git@github.com:usuario/repositorio.git

&nbsp;

(2) Para emplear PAT, se obtiene desde *Settings > Developer Settings > Personal Access Token > Tokens (classic) > Generate a Personal Access Token > click Generate token*

Al seleccionar los permisos de acceso, se elige el primer bloque completo "repo"

En operaciones donde introducir la contraseña, se puede introducir el PAT.

se puede cachear con el siguiente comando,

    git config --global credential.helper cache

se puede conservar (en texto plano ubicado en ~/.git-credentials) con el siguiente comando,

    git config --global credential.helper store

Tras el ejecutar el helper, git debe 'capturar' los credenciales. En la siguiente ejecución de *git push* los  solicitará, y en posteriores ya no los solicitará.

Se pueden borrar los credenciales

    git config --global --unset credential.helper
    git config --system --unset credential.helper

*Mas informacion: https://git-scm.com/docs/gitcredentials*
