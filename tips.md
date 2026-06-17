# Limitar la conectividad a un único host

Se emplea **`firewalld`** para, 
1. establecer la zona por defecto a DROP, de manera que todas las comunicaciones entrantes se pierdan
2. limitar el único origen permitido (**`--add-source`**) a la dirección IP habilitada, añadiéndola como único origen a la zona **`public`**

Adicionalmente con (3) **`conntrack`** se vacía la tabla de segumiento de conexiones establecidas (**`firewalld`** es statefull) para cortar también las
conexiones que el servidor pueda tener establecidas previamente a esta configuración (ping continuo, sesiones ssh,...)


    firewall-cmd --set-default-zone=drop                               # (1); esta configuación siempre es --permanent, no es necesario especificarlo
    firewall-cmd --permanent --zone=public --add-source=192.168.0.100  # (2) solo habilita la IP 192.168.0.100
    conntrack -F                                                       # (3) vacia netfilter tracking table
                                                                       #     https://oneuptime.com/blog/post/2026-03-02-how-to-configure-netfilter-connection-tracking-on-ubuntu/view
    
    systemctl restart firewalld                                        # reinicia firewalld
    firewall-cmd --get-active-zones                                    # revisa configuración
    firewall-cmd --reset-to-defaults                                   # restablecer configuracion por defecto (/etc/firewalld.conf/firewalld.conf.old)
