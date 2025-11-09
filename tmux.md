---
layout: default
title: referencia rapida de tmux
fecha: 2023-12-08
---

&nbsp;

## 1 qué es
Terminal MUltipleXer, con arquitectura cliente-servidor, donde el servidor mantienen en ejecucion las sesiones de manera que el cliente puede volver a conectarse a ellas, por ejemplo antes desconexiones SSH.

Es posterior a screen y permite multiples ventanas, cada una de las cuales dividida en varias partes, para tener vista y ejecución simultanea de multiples shell.

Admite personalizacion global en /etc/tmux.conf e individual en el fichero ~/.tmux.conf, así como scripts de inicio, plugins y funciones mas avanzadas. Mas ayuda, 
- [tmux 2 Productive Mouse-Free Development, Brian P. Hogan, Ed. The Pragmatic Programmers](https://pragprog.com/titles/bhtmux2/tmux-2/)
- [Getting Started](https://github.com/tmux/tmux/wiki/Getting-Started)

&nbsp;

## 2 conceptos
- **session** es una coleccion de *windows* o ventanas. Las sesiones pueden tener nombre o no (numeradas desde 0)

- **window** es una coleccion de *panes* o paneles. Las ventanas pueden tener nombre o no (numeradas desde 0). Solo se muestra una ventana a la vez, ocupando toda la pantalla y pudiendo cambiar de una ventana a otra a modo de pestañas

- **pane** es cada una de las secciones rectangulares en que se divide una ventana, en donde se ejecuta un shell con el que trabajar

&nbsp;

## 3 comandos básicos

- version de tmux &emsp; `tmux -V`
- ejecutar en 256 colores &emsp; `tmux -2`
- nueva sesion "nombre" &emsp; `tmux new -s nombre`
- nueva sesion "nombre" en background &emsp; `tmux new -s nombre -d`
- nueva sesion "nombre", y window con nombre "monit" &emsp; `tmux new -s nombre -n monit`
- lista de sesiones &emsp; `tmux ls`
- conectarse a sesion "nombre" &emsp; `tmux a -t nombre`
- renombrar sesion &emsp; `tmux rename-session -t nombreanterior nombrenuevo`
- nueva ventana &emsp; `tmux new-window -t nombresesion -n nombrewindow`
- renombrar ventana &emsp; `tmux rename-window -t nombresesion.window nombrenuevo` 
- matar todos los servidores de tmux &emsp; `tmux kill-server`
- matar todas las sesiones de tmux, excepto la actual &emsp; `tmux kill-server -a`
- matar sesion "nombre" &emsp; `tmux kill-session -t nombre`

&nbsp;

## 4 secuencias de teclas

### generales
- prefijo (PR) &emsp; `CTRL-b`
- ayuda &emsp; `(PR) ?`
- modo comando &emsp; `(PR) :`
- abandonar la sesion &emsp; `(PR) d`
- mostrar reloj &emsp; `(PR) t`
- renombrar sesion &emsp; `(PR) $`

&nbsp;

### ventanas
- crear nueva ventana &emsp; `(PR) c`
- renombrar ventana &emsp; `(PR) ,`
- listar ventanas &emsp; `(PR) w`
- mover ventana siguiente &emsp; `(PR) n`
- mover ventana anterior &emsp; `(PR) p`
- mover a ventana 1|2|3|... &emsp; `(PR) 1|2|3...` &emsp; *ver personalizacion para redefinir F1,F2,F3... directamente*
- cierra una ventana &emsp; `(PR) &`

&nbsp;

### paneles
- dividir en dos verticalmente (a izquierda y derecha) &emsp; `(PR) %`
- dividir en dos horizontalmente (arriba y abajo) &emsp; `(PR) "`
- mover entre paneles &emsp; `(PR) o`
- mover entre paneles &emsp; `(PR) izquierda|abajo|arriba|derecha`
- aplica disposicion estandar &emsp; `(PR) espacio`
- cierra el panel &emsp; `(PR) x`

&nbsp;

## 5 scripting
existen al menos tres vias para automatizar la configuración de una sesion, definiendo sus ventanas, paneles y que comandos se lanzan en cada panel
- empleando un fichero de configuracion de tmux, que contenga las ordenes para crear el entorno. Este es el mecanismo recomendado por ser nativo de tmux

Ejemplo de contenido de `monitor.tmux.conf`

    source-file ~/.tmux.conf                   # para incluir la configuracion generica definida para tmux
    new        -s monitor     -d 
    renamew    -t monitor:1   sistema
    neww       -t monitor     -n eventos
    neww       -t monitor     -n red
    splitw     -t monitor:1    -v -p 20
    send-keys  -t monitor:1.1  'sudo htop' C-m
    send-keys  -t monitor:1.2  'watch -n 60 df -hT' C-m
    splitw     -t monitor:2    -v -p 20
    send-keys  -t monitor:2.1  'sudo journalctl -f' C-m
    send-keys  -t monitor:2.2  'sudo watch last -20 -F -x' C-m
    splitw     -t monitor:3    -v
    send-keys  -t monitor:3.1  'sudo iftop' C-m
    splitw     -t monitor:3.2  -h
    send-keys  -t monitor:3.2 'watch vnstat -hg' C-m
    send-keys  -t monitor:3.3 'sudo nethogs -l' C-m
    selectw    -t monitor:1

Para acceder a este entorno, tras comprobar cob `tmux ls` que no existe ya la sesion *monitor* se ejecutaria  `tmux -f monitor.tmux.conf a -t monitor`

- empleando un script de bash normal, donde se incluya la secuencia de comandos a ejecutar. Este script será practicamente identido al fichero de configuracion (salvo la primera linea, `source ....`) pero precediendo cada comando por `tmux `, y al final ejecutando un `tmux a -t monitor`

- empleando un plugin como `tmuxinator` donde se define el entorno en un fichero YAML, con el requisito de necesitar Ruby para su ejecución

&nbsp;

## 6 copiar y pegar texto mostrado por pantalla

### movimiento

Se entra el modo *Copiar* con las teclas `(PR) [` lo que permite moverse, seleccionar y copiar texto que se haya mostrado en el panel. El movimiente se realiza con los cursores, PgUp, PgDown. Se abandona el modo *Copiar* con 'q'

Ademas de las teclas de movimiento estándar, si se añade la línea `set -g mode-keys vi` en `~/.tmux.conf` se pueden emplear las teclas de movimiento de vi. Este es el modo recomendado y extiende el funcionamiento con,

- izquierda,abajo,arriba,derecha &emsp; `h j k l`
- comienzo de linea, final de linea &emsp; `0 $`
- página arriba, abajo &emsp; `C-b C-f` (para C-b es necesario pulsar b dos veces si PR=C-b)
- comienzo, final del buffer &emsp; `g G`
- salida &emsp; `ENTER`
- busqueda hacia arriba, abajo &emsp; `? /`
- ocurrencia siguiente, anterior &emsp; `n N`

&nbsp;

### seleccionar texto, copiarlo al buffer y pegarlo.

Dentro del modo *Copiar* se emplea la tecla `ESPACIO` para empezar a seleccionar y `ENTER` para terminar de seleccionar. El texto seleccionado se copia automáticamente a un buffer de memoria

- Seleccionar toda la salida de texto del panel con el comando &emsp; `capture-pane` (*para introducir un comando se emplea* `(PR) :`)

- Mostrar el contenido del buffer con el comando &emsp; `show-buffer`

- Se puede guardar el contenido del buffer con el comando &emsp; `save-buffer nombre_fichero`

Fuera del modo *Copiar*, se pega el texto en la posición del cursor con la combinación `(PR) ]` para pegar el texto

tmux va copiando los textos seleccionados automáticamente a nuevos buffers, que se pueden listar con el comando &emsp; `show-buffer`

Por defecto los buffers se *apilan* y se pega siempre el último; pero se puede seleccionar el buffer con el que se trabaja con el comando &emsp; `choose-buffer` 

Los buffers de tmux se comparten, entre paneles de una misma ventana, entre ventanas de una misma sesion, y **tambien entre diferentes sesiones** de un mismo servidor tmux

Para compartir el buffer con el s.o. se puede emplear la utilidad externa xclip, e invocarla redefiniendo las teclas empleadas para copiar y pegar

&nbsp;

## 7 compartir sesión de tmux

Varias personas pueden estar conectadas a una misma sesión de tmux y trabajar simultaneamente sobre un mismo panel o sobre distintos paneles, de manera colaborativa. Existen al menos tres vias para esto

- conectando el cliente de tmux al socket empleado por el servidor tmux. Esta es la manera nativa y la recomendada
- compartiendo un usuario de la maquina donde se ejecuta el servidor tmux. Aunque el usuario se cree expresamente para este fin, y no se comparta la contraseña sino que el acceso SSH sea por clave pública, por seguridad esto no es recomendable ya que ambas personas tienen acceso al mismo directorio home, etc...
- empleando una herramienta externa, como es `tmate` (un fork de tmux)

Al mostrar la pantalla a otra persona, compartir la sesion tmux tiene consideraciones de seguridad. Es recomendable emplear un host con los ficheros/proyectos a compartir, de manera que por error no se muestren a la otra persona ficheros fuera del alcance del proyecto para el que se comparte la sesión tmux. El empleo de máquinas virtuales puede ser de ayuda. 

Se resume el caso de uso nativo empleando la conexión al socket

&nbsp;

### sesiones agrupadas

Diferentes sesiones pueden pertenecer a un mismo grupo o sesion agrupada. Una sesion agrupada se muestra como un mismo conjunto de ventanas, donde cada cliente conectado pueden estar en una ventana distinta de la sesión agrupada.

De esta forma dos personas conectadas a una sesión agrupada que tenga dos ventanas, pueden estar cada una de ellas trabajando en una ventana diferente, o pueden estar en la misma ventana y trabajar simultaneamente.

Para crear una sesion agrupada, la primera sesion se inicia normalmente (la sesion agrupada empleará este nombre)

    tmux new-session -s sesion1

La persona abandona la sesión (C-b d), y puede vuelve a conectarse normalmente a la sesion1 (asi se muestra en la linea de estado de tmux)

    tmux a -t sesion1

Ahora la segunda persona crea una nueva sesión, con el nombre sesion2, y la crea de manera agrupada con la existente sesion1 (en este momento se define la sesion agrupada "sesion1")

    tmux new-session -t sesion1 -s sesion2

La segunda persona se conecta a la sesion2 (así se muestra en la linea de estado de tmux), que pertenece a la sesion agrupada sesion1, y puede crear ventanas nuevas (que tambien estarán disponibles para la primera persona en sesion1) y cambiarse a ellas.

Si alguna de las dos personas se desconecta y lista las sesiones, el servidor muestra lo siguiente

    sesion1: 1 windows (created Sun Dec 10 18:53:20 2023) (group sesion1)
    sesion2: 1 windows (created Sun Dec 10 18:53:31 2023) (group sesion1)  


&nbsp;


## 8 plugins
Para gestionar los plugins, resulta de utilidad **Tmux Plugin Manager**. Para instalarlo,

- Se clona el repositorio
```
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

- Se añade la siguiente como  última línea de *.tmux.conf*
```
run '~/.tmux/plugins/tpm/tpm'
```

- Se recarga la configuración de tmux
```
tmux source ~/.tmux.conf
```

- **prefix + I** &emsp; instala plugins de  GitHub u otro repositorio git, y refresca el entorno tmux
- **prefix + U** &emsp; actualiza plugins
- **prefix + alt + u** &emsp; elimina desinstalar plugins que no estén listados en .tmux.conf



Para recuperar el estado de tmux, es frecuente emplear los plugins *tmux-resurrect* y *tmux-continuum*. Para instalarlos se deben añadir estas líneas en .tmux.conf.

```
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'
set -g @continuum-restore 'on'
```

La primera vez que se ejecuta tmux, se deben instalar mediante **prefix + I** 

Para el correcto funcionamiento de ambos plugin, no se puede ocultar la barra de estado

tmux-resurrect opera con las siguientes teclas:
*  **prefix + CTRL-S** &emsp; guarda el estado
*  **prefix + CTRL-R** &emsp; restaura el estado

tmux-continuum, autoguarda cada 15 minutos el estado. La tercera linea, asegura la restauración automatica al iniciar tmux.

