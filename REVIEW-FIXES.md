# Correcciones verificadas

## Respaldo y restauración

`cybercore-backup [destino-nuevo]` usa Python 3 mediante `cybercore-state`.
Publica el directorio mediante renombrado dentro del mismo sistema de archivos;
rechaza destinos existentes. Los errores de copia se propagan. El manifiesto
registra contenido SHA-256, tipos, enlaces y permisos; se comprueba antes de publicar
y antes de restaurar. Exige configuraciones centrales de Plasma/KWin/Conky.

`cybercore-restore /ruta` solo valida. `cybercore-restore /ruta --apply` aplica.
Hace staging por destino y conserva las versiones anteriores hasta terminar.
Ante errores capturables revierte los archivos ya reemplazados. No es una transacción
atómica global, un snapshot coherente de aplicaciones abiertas ni una protección
contra corte eléctrico/SIGKILL. Si falla el rollback conserva las carpetas de recuperación.
No cambia permisos de ejecutables ajenos, ni reinicia KWin, Conky o servicios.
Cerrar aplicaciones antes de restaurar; reiniciar sesión después. La habilitación
de servicios y las cachés son pasos separados, no parte del rollback de archivos.

Alcance explícito en ROOTS de cybercore-state: configuraciones enumeradas de KDE,
Kvantum, Conky, GLava, Fastfetch, perfiles Konsole, fuentes, temas e iconos propios,
plasmoids instalados, scripts KWin, entradas KRunner, ejecutables enumerados y unidades
HUD. No respalda todo el home, paquetes del sistema, Firefox, Vencord, wallpapers,
credenciales ni firmware/configuración interna del mouse. El manifiesto es verificable,
no una firma de autenticidad: usar respaldos de confianza. Los respaldos antiguos sin
manifiesto no son aceptados; crear uno nuevo.

## Widgets y comandos

Clima: valida todos los campos antes de actualizar valores; fallos conservan la lectura
anterior con indicador OFFLINE. Usa Timer QML, aborta al vencer y descarta callbacks viejos.
Temporizadores: sin bc, duración positiva limitada a siete días, redondeo hacia arriba
con mínimo de un segundo. ka conserva su implementación por PID de Antigravity.
Audio y enlaces systemd conservan las correcciones verificadas; desconexiones físicas y
cierre real de sesión siguen requiriendo prueba en el escritorio.

La corrección no modifica el tipo de ventana normal de Conky ni Mostrar escritorio.
