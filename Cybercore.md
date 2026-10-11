# Cybercore Y2K1 — Roadmap Maestro

La idea es seguirlo en este orden para no terminar rehaciendo configuraciones porque una capa posterior obligue a cambiar la anterior.

## Fase 0 — Estructura y respaldo del proyecto
- [x] Crear el proyecto cybercore-y2k1.
- [x] Incluir README, instalador y desinstalador.
- [x] Separar configuraciones de KDE, KWin, Plasma, Konsole, KRunner, atajos, temas, cursores, iconos, fuentes, Conky, Glava, Fastfetch, SDDM, Plymouth, GRUB, Firefox, Vencord, aplicaciones propias, scripts, wallpapers y sonidos.
- [x] Preparar cybercore-backup y cybercore-restore.
- [x] El backup debe contemplar Plasma, KWin, Klassy, Kvantum, Conky, Glava, Konsole, Fastfetch, Firefox, Vencord, scripts, wallpapers, configuración de monitores y personalizaciones generales.
- [x] El objetivo es que toda la personalización pueda recuperarse sin depender de acordarse qué archivos se tocaron manualmente.

## Fase 1 — Identidad visual global
- [x] Fondo/chasis: #15051A, violeta carbón profundo.
- [x] Violeta estructural: #BD00FF para bordes, líneas, marcos y elementos visuales principales.
- [x] Cian eléctrico: #00F0FF.
- [x] Texto principal: #E2E8F0, blanco hielo.
- [x] Cian y violeta quedan como identidad visual permanente, mezclados constantemente.
- [x] El cian puede intensificarse en hover, focus, active, selección, telemetría e indicadores.
- [x] Exo 2 como familia principal del sistema.
- [x] Estética hard-edge, con radio de esquina prácticamente 0 px.
- [x] Phosphor Thin/Light para HUD, barras, telemetría, botones técnicos y módulos custom.
- [x] Tango 3D/skeuomorphic para Dolphin, carpetas, escritorio y elementos con estética clásica Windows/Y2K.
- [x] Cursor Phinger Cursors Light/White.
- [ ] Sonidos Longhorn / Windows Vista Beta.
- [x] Sin papelera visible en el escritorio.

## Fase 2 — Plasma, KWin y apariencia del shell
- [x] Configurar Klassy y Kvantum.
- [x] Ventanas con estilo Aero + Cybercore.
- [x] Borde violeta neón de aproximadamente 1.5 px.
- [x] Esquinas minimamente redondeadas (4px).
- [x] Botones de ventana 3D/cristal.
- [x] Hover cian en los demás botones.

**Blur estratégico (ACLARACIÓN CRÍTICA)**
> ⚠️ **El Blur es GLOBAL y está gestionado por KWin (`kwinrulesrc`) a una opacidad muy leve (98%/95%)**.
> Se aplica a TODAS las ventanas del sistema (nativas de Plasma y aplicaciones externas/Electron) mediante una regla global, combinada con el motor de Blur de KWin activo. 
> Como la opacidad es del 98%, genera el efecto "Aero Cristal" sin comprometer la lectura del texto.
> **Klassy** gestiona exclusivamente el renderizado y borde de la barra de título (decoración), y KWin gestiona el resto del cuerpo.
- [x] Barra superior: blur fuerte (panel nativo).
- [x] Ventanas globales: blur sutil (KWin global a 98% activo / 95% inactivo).
- [x] Dolphin, Antigravity y otros: heredan la regla global. No requieren Kvantum.
- [x] Menús contextuales: blur moderado (Kvantum/KWin).
- [x] KRunner: casi opaco.
- [x] Konsole: prácticamente opaco.
- [x] Widgets de escritorio: transparentes o sin cajas pesadas.
- [x] Notificaciones: opacas.
- [x] Fondos estructurales y wallpapers: sólidos.
*Nota: Prohibido inyectar opacidades fuertes (ej: 85%) globales porque vuelve inusable la UI.*

**Microinteracciones**
- [ ] Burn My Windows con efecto Glitch únicamente.
- [ ] Duración objetivo: 150 ms.
- [ ] Aplicarlo a abrir, cerrar y minimizar.
- [x] Menús contextuales con cristal oscuro, blur moderado, esquinas rectas, borde violeta de 1.5 px y selección en cian sólido.
- [x] Scrollbars como línea fina rígida, violeta/carbón en estado normal y cian en hover.
- [x] Caja de selección con relleno violeta translúcido y borde cian de 1 px.
- [x] Notificaciones rectangulares, opacas, con fondo #15051A y línea/acento cian.
- [x] KRunner centrado, casi opaco, con borde cian neón de 2 px y sombra dura.

## Fase 3 — KRunner como Command Center
- [x] KRunner no será solo el buscador de Plasma.
- [x] Convertirlo en centro de comandos del sistema.
- [x] Crear scripts para comandos como:
  - [x] `> firefox`
  - [x] `> volume 60`
  - [x] `> workspace 4`
  - [x] `> bluetooth`
  - [x] `> screenshot`
  - [x] `> music play`
  - [x] `> timer 25`
  - [x] `> shutdown`
- [x] Guardar la lógica de estos comandos dentro de la carpeta de scripts del proyecto.
- [x] La intención es controlar una parte importante del sistema desde una única interfaz rápida.

## Fase 4 — Panel superior HUD
- [x] Panel nativo de Plasma.
- [x] Altura objetivo inicial: 28 px.
- [x] Siempre visible.
- [x] Transparente con blur fuerte.
- [x] Identidad violeta + cian.
- [x] Divisiones finas.
- [x] Aspecto de HUD técnico.

**Izquierda**
- [x] Pager de 10 escritorios virtuales.
- [x] Escritorios compactos y numerados.
- [x] Escritorio activo marcado visualmente con una línea/barra violeta inferior.

**Zona central**
- [x] Reloj en formato HH:MM:SS.
- [x] Segundero continuo.
- [x] Reproductor multimedia MPRIS.
- [x] Audio de salida con icono Phosphor, click para mute/unmute, slider horizontal visible y desplegable para dispositivos/apps.
- [x] Micrófono con icono Phosphor, click para mute/unmute, slider de ganancia y selector/desplegable de entrada.

**Derecha**
- [x] Telemetría compacta de CPU, GPU, RAM y temperatura CPU.
- [x] Formato icono Phosphor + porcentaje/valor.
- [x] Gestor de recursos.
- [x] Notificaciones.
- [x] Konsole.
- [x] Mostrar escritorio.
- [x] Separadores verticales finos entre bloques.

## Fase 5 — Panel inferior estilo Windows
- [x] Panel nativo de Plasma.
- [ ] 100% del ancho.
- [x] Siempre visible.
- [ ] Estilo como el panel superior.
- [ ] Panel Colorizer para integrarlo visualmente con el resto.

**Izquierda**
- [ ] Menú de inicio clásico.
- [ ] Iconografía Tango/estética clásica.
- [ ] Aplicaciones abiertas agrupadas.
- [ ] Preferencia actual: solo iconos.

**Derecha**
- [ ] Flecha de apps ocultas.
- [ ] Wi-Fi.
- [ ] Bluetooth.
- [ ] Color Picker.
- [ ] Reloj/calendario.
- [ ] Mostrar escritorio.
- [ ] Phosphor solo en los iconos técnicos de la derecha.

## Fase 6 — Escritorio principal
- [x] Mantener el centro y la izquierda relativamente limpios.
- [ ] Wallpaper aun por decidir.
- [x] Carpetas y archivos visibles con Tango 3D.
- [x] Columna de widgets perfectamente alineada a la derecha (`com.cybercore.deskcolumn`).

**Reloj**
- [x] Texto flotante sin fondo pesado.
- [x] Formato `[ HH:MM:SS ]` en blanco hielo.
- [x] Tipografía `Share Tech Mono` (Consola Táctica / Terminal Cyberpunk).
- [x] Subtítulo `SYS.DATE: DD-MES // DÍA` en violeta neón (#A200FF).

**Calendario**
- [x] Minimalista sin cuadrícula pesada.
- [x] Cabecera mes/año en violeta neón (#A200FF) sincronizada con el reloj.
- [x] Días de la semana y números en blanco hielo (#E0F8FF).
- [x] Día actual destacado mediante fondo violeta neón + borde cian eléctrico.

**Clima**
- [x] Tarjeta técnica con borde cian neón y fondo violeta carbón (#15051A).
- [x] Córdoba Capital, telemetría de temperatura en blanco hielo, humedad y viento en violeta atenuado.
- [x] Icono meteorológico Phosphor ubicado debajo de la temperatura, mapeado para todos los estados (despejado, parcialmente nublado, nublado, llovizna, lluvia, tormenta, nieve, niebla).

**Reproductor**
- [x] Módulo compacto reservado con enlace MPRIS.
- [ ] Expansión interactiva con click (portada, controles de reproducción) conectado a la app propia de la Fase 12.

## Fase 7 — Monitor secundario
- [ ] Wallpaper igual al principal.
- [ ] Conky como dashboard técnico incrustado sobre el fondo.
- [ ] Mostrar CPU, GPU, RAM, temperaturas y otros datos útiles.
- [ ] Visual Exo 2, blanco hielo, cian y violeta.
- [ ] Glava como ecualizador/visualizador de audio.
- [ ] Principalmente cian.
- [ ] Renderizado por debajo de las ventanas.
- [ ] Integrado al wallpaper.

## Fase 8 — Terminal y herramientas
- [x] Konsole como terminal principal tradicional.
- [x] Fondo #15051A.
- [x] Prácticamente opaco.
- [ x Texto blanco hielo.
- [x] Acentos violeta/cian.
- [ ] Prompt con bloques sólidos y flechas.
- [x] Fastfetch muy minimalista con OS, CPU, RAM y Uptime.

## Fase 9 — Polonium / Tiling opcional
- [ ] Polonium instalado pero apagado por defecto.
- [ ] Activable mediante atajo.
- [ ] Usarlo solamente cuando haga falta organizar ventanas rápidamente en grilla.
- [ ] No volver a un flujo tiling permanente.

## Fase 10 — Firefox
- [x] Migrar/importar lo necesario desde Edge.
- [ ] Aplicar userChrome.css.
- [ ] Forzar esquinas rectas.
- [ ] Integrar violeta/cian.
- [ ] Reducir elementos modernos que choquen con el rice.
- [ ] Adaptar visualmente la UI al estilo Cybercore.
- [ ] Integrarlo con Klassy/KWin.

## Fase 11 — Discord / Vencord
- [ ] CSS custom.
- [ ] Base violeta carbón.
- [ ] Transparencia donde corresponda.
- [ ] Integración con KWin.
- [ ] Bordes estilizados.
- [ ] Menciones y estados resaltados en cian.

## Fase 12 — Reproductor de audio propio
- [ ] Aplicación separada.
- [ ] No es simplemente el widget del HUD.
- [ ] Inicialmente planteada como Electron, pero ahora cambiamos a Python + QML.
- [ ] Selector fijo entre YouTube Music y Monochrome.
- [ ] La UI debe ser completamente propia.
- [ ] No usar las interfaces web originales como UI visible.

**La interfaz debería incluir**
- [ ] Buscador propio.
- [ ] Resultados propios.
- [ ] Artistas.
- [ ] Álbumes.
- [ ] Playlists.
- [ ] Cola.
- [ ] Reproductor.
- [ ] Controles.

**Arquitectura**
- [ ] Adapter propio para YouTube Music.
- [ ] Adapter propio para Monochrome.
- [ ] Ambos deben devolver un formato interno común.
- [ ] Separar búsqueda/metadata de reproducción.
- [ ] Integrar MPRIS.
- [ ] Integrar con widget del escritorio.
- [ ] Integrar con el HUD superior.
- [ ] Integrar con KRunner.
- [ ] Por ejemplo, `> music play` debe poder controlar el reproductor.
- [ ] Este módulo queda separado del shell/Plasma porque es una aplicación propia.

## Fase 13 — Drawer lateral de notas
- [ ] Aplicación/panel custom.
- [ ] Anclado al borde derecho.
- [ ] Oculto normalmente.
- [ ] Aparece mediante hover.
- [ ] Notas Markdown.
- [ ] Minimización visual.
- [ ] Icono/post-it estilo Tango.
- [ ] Guardarlo dentro de la capa de aplicaciones propias.

## Fase 14 — Reduced Motion / Performance Mode
Crear tres modos:
**FULL**
- [ ] Burn My Windows activo.
- [ ] Glava activo.
- [ ] Blur completo.
- [ ] Transiciones completas.
- [ ] Hover y animaciones completas.
- [ ] Notificaciones animadas.

**REDUCED**
- [ ] Animaciones más discretas.
- [ ] Menor movimiento.
- [ ] Mantener la estética.

**NONE**
- [ ] Burn My Windows apagado.
- [ ] Glava apagado.
- [ ] Blur reducido o desactivado.
- [ ] Transiciones mínimas.
- [ ] Animaciones visuales mínimas.
*Pensado especialmente para gaming o situaciones donde quieras priorizar recursos.*

## Fase 15 — Boot Identity
Hacer esta fase después de terminar el escritorio, para no tocar el arranque antes de tener el sistema funcional.
Secuencia: GRUB → Plymouth → SDDM → KDE Plasma.

**GRUB**
- [ ] Dual boot CachyOS / Windows.
- [ ] Tema Grub-theme-poly Dark.
- [ ] Wallpaper Sony Discman 2002.

**Plymouth**
- [ ] Secuencia breve tipo terminal:
  - [ ] CYBERCORE SYSTEM
  - [ ] INITIALIZING KERNEL ........ OK
  - [ ] LOADING DISPLAY ............ OK
  - [ ] LOADING NETWORK ............ OK
  - [ ] LOADING USERSPACE .......... OK
  - [ ] SYSTEM READY
- [ ] Tiene que ser breve, rápida y estética.
- [ ] No convertirlo en una pantalla de diagnóstico interminable.

**SDDM**
- [ ] Sugar-Candy.
- [ ] Wallpaper EVA-01. (Igual a la pantalla de bloqueo)
- [ ] Login centrado.
- [ ] Blur.

**Lockscreen**
- [ ] EVA-01.
- [ ] QML custom.
- [ ] Lluvia digital de carácteres japoneses en cian (Y Exo2).

## Fase 16 — Automatización final
- [ ] Configurar autostart.
- [ ] Configurar KWin Rules.
- [ ] Definir por aplicación:
  - [ ] escritorio virtual;
  - [ ] monitor;
  - [ ] posición;
  - [ ] tamaño;
  - [ ] estado;
  - [ ] comportamiento.
- [ ] Mantener los 10 escritorios virtuales.
- [ ] Definir relación entre app, workspace y monitor.
- [ ] Crear scripts de startup.
- [ ] Controlar orden de arranque.
- [ ] Controlar dependencias.
- [ ] Lanzar automáticamente Conky, Glava, apps propias y servicios auxiliares.

## Fase 17 — Backup / Restore final
- [ ] Completar cybercore-backup.
- [ ] Completar cybercore-restore.
- [ ] El objetivo es poder reconstruir todo el entorno después de una reinstalación.
- [ ] Flujo ideal:
  - [ ] clonar el repo;
  - [ ] ejecutar install.sh;
  - [ ] ejecutar cybercore-restore.

---

## Orden corto para seguir sin perderte
- [x] 1. Repo y estructura Cybercore Y2K1.
- [x] 2. Identidad visual.
- [x] 3. Plasma/KWin.
- [x] 4. KRunner Command Center.
- [x] 5. Barra superior.
- [ ] 6. Barra inferior.
- [x] 7. Widgets del monitor principal.
- [ ] 8. Monitor secundario.
- [ ] 9. Konsole + prompt + Fastfetch.
- [ ] 10. Polonium opcional.
- [ ] 11. Firefox.
- [ ] 12. Discord/Vencord.
- [ ] 13. Reproductor propio.
- [ ] 14. Drawer de notas.
- [ ] 15. Reduced Motion.
- [ ] 16. Boot Identity.
- [ ] 17. Autostart / KWin Rules / monitores.
- [ ] 18. Backup / Restore final.
