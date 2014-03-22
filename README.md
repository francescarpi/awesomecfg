awesomecfg
==========

Mi configuración de Awesome Window Manager.

Me he basado en las configuraciones de: 

- https://github.com/romockee/powerarrow
- https://github.com/esn89/powerarrow-dark

Y partir de ahí he ido personalizando a mi gusto la configuración.

Todas las modificaciones se pueden encontrar en internat, no son nada fuera de lo normal, pero he subido
esta configuración con el objetivo de tener un backup de mi configuración de awesome.

Instalación
-----------

Si ya tenemos una configuración previa, hacer antes un backup.
- ``cd ~/.config/``
- ``mv awesome awesome.back``

En el terminal:
- ``cd ~/.config/``
- ``git clone https://github.com/francescarpi/awesomecfg.git awesome``

¡Reiniciar awesime y listo!

Nuevas funcionalidades
----------------------

- Se utiliza el theme de powerarrow, más algunos widgets en la barra superior.
- Widgets activados: memoria ram, cpu, volumen, disco, nivel de batería, estado de la wifi y hora
- En el widget de volumen se añade la funcionalidad que al hacer click te abre el mixer de pulse.
- También se añade en este widget la funcionalidad de modificar el volumen con la rueda del ratón encima del widget.
- Al iniciar sesión arranco Dropbox.
- Al pulsar Mod4 + F12, muestro un popup donde te deja escoger entre bloquear la pantalla, poner la máquina en reposo, reiniciar sistema o apagar.
- Varias aplicaciones arrancan en modo flotante, independiente del layout que tengamos. Como por ejemplo nautilus, el mixer de pulse, etc.


Capturas de pantalla
--------------------

![Captura de pantalla](screenshot.png)
