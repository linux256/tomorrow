---
layout: default
title: referencia rapida de docker
fecha: 2024-02-21
nav_order: 4
---

# <a href="../" style="text-decoration: none; color:black">&larr;&larr;</a>&emsp; docker

**Referencia**    [https://docs.docker.com/engine/](https://docs.docker.com/engine/)

* Buscar imagenes
```
docker search NOMBRE_IMAGEN
```

&nbsp;

* Descargar imagen NOM_IMG
```
docker pull NOM_IMG
```

&nbsp;

* Mostrar todas las imágenes descargadas al host
```
docker images -a
```

&nbsp;

* Crear un  contenedor NOM_CON generado desde una imagen NOM_IMG  con el tag IMG_TAG (v.g. "latest")
```
docker [create] --name NOM_CON   NOM_IMG:IMG_TAG
```

&nbsp;

* Crear y ejecutar un contenedor NOM_CON generado desde una imagen NOM_IMG  con el tag IMG_TAG (v.g. "latest")
```
docker [container] run --name NOM_CON   NOM_IMG:IMG_TAG

    PARAMETROS
    ----------
    
    --rm               borra el contenedor al terminar de ejecutarse
    
    -u user:group      ejecuta el contenedor con un usuario y grupo específico
    -u 0               ejecuta el contenedor como root
    
    -d, --detach       ejecuta en segundo plano
    -a, --attach       se conecta STDIN, STDOUT y STDERR

    -t, --tty          añade un pseudoterminal
    -i, --interactive  mantiene STDIN abierto
    

    -v ruta_h:ruta_c   define el volumen "ruta_h" accedido en el contenedor como "ruta_c"

    --net=host         el contenedor queda conectado a la red del host. Los puertos expuestos por el
                       contenedor son expuestos por el host. Se puede emplear firewall-cmd para dar o quitar
                       acceso al contenedor. Este metodo parece mas sencillo de controlar, siempre que sea
                       sencillo cambiar el puerto expuesto por el contenedor
                       
    -p port_h:port_c   el puerto "port_c" expuesto por el contenedor queda accesible en el host como "port_h"
                       ahora no se puede emplear firewall-cmd para restringir el acceso al contenedor porque
                       el DNAT de iptables es de maxima prioridad. Para restringir el acceso se deben añadir
                       reglas IPTABLES en la cadena "DOCKER-USER" que se ejecuta antes que la cadena "DOCKER".
                       Este metodo parece mas complejo y no recomendable

    -e "VAR_VALOR"     ejecuta el contenedor asignando VALOR a la variable VAR

    --entrypoint CMD   cambia el comando de ejecución al iniciar el contenedor. Esto puede permitir cambiar
                       algun parametro de ejecución del contenedor (por ejemplo el puerto) que no este definido
                       mediante variables de entorno

```

&nbsp;

* Ejecutar un comando en un contenedor en  ejecución
```
docker exec -i NOM_CON   COMANDO_A_EJECUTAR 
```

&nbsp;

* Hacer login (como root -u 0:0) en un terminal interactivo (-it) en el contenedor  NOM_CON ejecutando /bin/bash
```
docker exec -u 0:0 -it NOM_CON /bin/bash
```

&nbsp;

* Inspeccionar propiedades de un contenedor
```
docker [container] inspect NOM_CON
```

&nbsp;

* Mostrar todos los contenedores
```
docker ps -a
```

&nbsp;

* Iniciar, parar, y borrar un contenedor
```
docker [container] start NOM_CON
docker [container] stop  NOM_CON        # envia SIGTERM
docker [container] kill  NOM_CON        # envía SIGKILL
docker [container] rm    NOM_CON               # borra, estando parado
docker [container] rm  --force  NOM_CON        # borra, estando en ejecucion
```

&nbsp;

* Mostrar todas las redes
```
docker network ls
```

&nbsp;

* Inspeccionar una red
```
docker network inspect NOM_NET
```

&nbsp;

* Crear una imagen a partir de un contenedor existente
```
  docker exec -u 0:0 -it NOM_CON /bin/bash                 #conectarse al  contenedor

    # realizar las modificaciones en el contenedor
    # ...
    # exit
    
  docker container commit  NOM_CON  NOM_NEW_IMG            #los cambios se hacen persistentes en NOM_NEW_IMG
  
  docker image ls                                          #comprobar que se ha creado la imagen
```

&nbsp;

* Crear una imagen empleando el fichero dockerfile, este es el método preferido
```
   Se edita el fichero "dockerfile" con los comandos:
   
   COMANDOS EN TIEMPO DE CONSTRUCCION DE LA IMAGEN
   ----------------------------------------------- 
   FROM        # imagen base
   RUN         # comandos a ejecutar en el contenedor
   COPY, ADD   # añadir ficheros del host al contenedor
   WORKDIR     # fija directorio de trabajo dentro del contenedor, evitando emplear rutas absolutas

   COMANDOS EN TIEMPO DE EJECUCION DEL CONTENEDOR GENERADO DESDE LA IMAGEN
   -----------------------------------------------------------------------
   ENTRYPOINT  # comando a ejecutar, por ejemplo    ENTRYPOINT ["ping","8.8.8.8","-c","3"]
   CMD         # parametros del comando a ejecutar

    Se crea la imagen con:

    docker image build -t NOM_IMG -f FICHERO_DOCKERFILE .     #el "." final es la ruta para buscar otros ficheros
```

&nbsp;

* Exportar una imagen a .tar y cargarla en otro equipo donde no exista
```
docker image save -o FICHERO_TAR  NOM_IMG

docker image load -i FICHERO_TAR
```
