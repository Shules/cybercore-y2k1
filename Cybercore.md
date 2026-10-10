# Cybercore Y2K1 — Roadmap Maestro

La idea es seguirlo en este orden para no terminar rehaciendo configuraciones porque una capa posterior obligue a cambiar la anterior.

## Fase 0 — Estructura y respaldo del proyecto
- [x] Crear el proyecto cybercore-y2k1.
- [ ] Incluir README, instalador y desinstalador.
- [ ] Separar configuraciones de KDE, KWin, Plasma, Konsole, KRunner, atajos, temas, cursores, iconos, fuentes, Conky, Glava, Fastfetch, SDDM, Plymouth, GRUB, Firefox, Vencord, aplicaciones propias, scripts, wallpapers y sonidos.
- [ ] Preparar cybercore-backup y cybercore-restore.
- [ ] El backup debe contemplar Plasma, KWin, Klassy, Kvantum, Conky, Glava, Konsole, Fastfetch, Firefox, Vencord, scripts, wallpapers, configuración de monitores y personalizaciones generales.
- [ ] El objetivo es que toda la personalización pueda recuperarse sin depender de acordarse qué archivos se tocaron manualmente.

## Fase 1 — Identidad visual global
- [ ] Fondo/chasis: #0E0918, violeta carbón profundo.
- [ ] Violeta estructural: #BD00FF para bordes, líneas, marcos y elementos visuales principales.
- [ ] Cian eléctrico: #00F0FF.
- [ ] Texto principal: #E2E8F0, blanco hielo.
- [ ] Cian y violeta quedan como identidad visual permanente, mezclados constantemente.
- [ ] El cian puede intensificarse en hover, focus, active, selección, telemetría e indicadores.
- [ ] Exo 2 como familia principal del sistema.
- [ ] Estética hard-edge, con radio de esquina prácticamente 0 px.
- [ ] Phosphor Thin/Light para HUD, barras, telemetría, botones técnicos y módulos custom.
- [ ] Tango 3D/skeuomorphic para Dolphin, carpetas, escritorio y elementos con estética clásica Windows/Y2K.
- [ ] Cursor Phinger Cursors Light/White.
- [ ] Sonidos Longhorn / Windows Vista Beta.
- [ ] Sin papelera visible en el escritorio.

## Fase 2 — Plasma, KWin y apariencia del shell
- [ ] Configurar Klassy y Kvantum.
- [ ] Ventanas con estilo Aero + Cybercore.
- [ ] Borde violeta neón de aproximadamente 1.5 px.
- [ ] Esquinas rectas.
- [ ] Botones de ventana 3D/cristal.
- [ ] Botón de cerrar en rojo.
- [ ] Hover cian en los demás botones.

**Blur estratégico**
- [ ] Barra superior: blur fuerte.
- [ ] Ventanas: blur moderado.
- [ ] Dolphin: blur moderado.
- [ ] Menús contextuales: blur moderado.
- [ ] KRunner: casi opaco.
- [ ] Konsole: prácticamente opaco.
- [ ] Widgets de escritorio: transparentes o sin cajas pesadas.
- [ ] Notificaciones: opacas.
- [ ] Fondos estructurales y wallpapers: sólidos.
*La idea es evitar que todo termine pareciendo simplemente Windows Aero con neón.*

**Microinteracciones**
- [ ] Burn My Windows con efecto Glitch únicamente.
- [ ] Duración objetivo: 150 ms.
- [ ] Aplicarlo a abrir, cerrar y minimizar.
- [ ] Menús contextuales con cristal oscuro, blur moderado, esquinas rectas, borde violeta de 1.5 px y selección en cian sólido.
- [ ] Scrollbars como línea fina rígida, violeta/carbón en estado normal y cian en hover.
- [ ] Caja de selección con relleno violeta translúcido y borde cian de 1 px.
- [ ] Notificaciones rectangulares, opacas, con fondo #0E0918 y línea/acento cian.
- [ ] KRunner centrado, casi opaco, con borde violeta neón de 2 px y sombra dura.

## Fase 3 — KRunner como Command Center
- [ ] KRunner no será solo el buscador de Plasma.
- [ ] Convertirlo en centro de comandos del sistema.
- [ ] Crear scripts para comandos como:
  - [ ] `> firefox`
  - [ ] `> volume 60`
  - [ ] `> workspace 4`
  - [ ] `> bluetooth`
  - [ ] `> screenshot`
  - [ ] `> music play`
  - [ ] `> timer 25`
  - [ ] `> shutdown`
- [ ] Guardar la lógica de estos comandos dentro de la carpeta de scripts del proyecto.
- [ ] La intención es controlar una parte importante del sistema desde una única interfaz rápida.

## Fase 4 — Panel superior HUD
- [ ] Panel nativo de Plasma.
- [ ] Altura objetivo inicial: 28 px.
- [ ] Siempre visible.
- [ ] Transparente con blur fuerte.
- [ ] Identidad violeta + cian.
- [ ] Divisiones finas.
- [ ] Aspecto de HUD técnico.

**Izquierda**
- [ ] Pager de 10 escritorios virtuales.
- [ ] Escritorios compactos y numerados.
- [ ] Escritorio activo marcado visualmente con una línea/barra violeta inferior.

**Zona central**
- [ ] Reloj en formato HH:MM:SS.
- [ ] Segundero continuo.
- [ ] Reproductor multimedia MPRIS.
- [ ] Audio de salida con icono Phosphor, click para mute/unmute, slider horizontal visible y desplegable para dispositivos/apps.
- [ ] Micrófono con icono Phosphor, click para mute/unmute, slider de ganancia y selector/desplegable de entrada.

**Derecha**
- [ ] Telemetría compacta de CPU, GPU, RAM y temperatura CPU.
- [ ] Formato icono Phosphor + porcentaje/valor.
- [ ] Gestor de recursos.
- [ ] Notificaciones.
- [ ] Konsole.
- [ ] Mostrar escritorio.
- [ ] Separadores verticales finos entre bloques.

## Fase 5 — Panel inferior estilo Windows
- [ ] Panel nativo de Plasma.
- [ ] 100% del ancho.
- [ ] Siempre visible.
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
- [ ] Mantener el centro y la izquierda relativamente limpios.
- [ ] Wallpaper aun por decidir.
- [ ] Carpetas y archivos visibles con Tango 3D.
- [ ] Columna de widgets perfectamente alineada a la derecha.

**Reloj**
- [ ] Texto flotante.
- [ ] Formato HH:MM:SS.
- [ ] Exo 2 Bold/Black.
- [ ] Blanco hielo.
- [ ] Sin fondo pesado.

**Calendario**
- [ ] Minimalista.
- [ ] Sin cuadrícula visible.
- [ ] Cabecera mes/año en cian.
- [ ] Días en blanco hielo.
- [ ] Día actual destacado mediante violeta + borde cian.

**Clima**
- [ ] Tarjeta minimalista.

**Reproductor**
- [ ] Espacio reservado para módulo compacto conectado al reproductor principal.

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
- [ ] Konsole como terminal principal tradicional.
- [ ] Fondo #0E0918.
- [ ] Prácticamente opaco.
- [ ] Texto blanco hielo.
- [ ] Acentos violeta/cian.
- [ ] Prompt con bloques sólidos y flechas.
- [ ] Fastfetch muy minimalista con OS, CPU, RAM y Uptime.

## Fase 9 — Polonium / Tiling opcional
- [ ] Polonium instalado pero apagado por defecto.
- [ ] Activable mediante atajo.
- [ ] Usarlo solamente cuando haga falta organizar ventanas rápidamente en grilla.
- [ ] No volver a un flujo tiling permanente.

## Fase 10 — Firefox
- [ ] Migrar/importar lo necesario desde Edge.
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
- [ ] 2. Identidad visual.
- [ ] 3. Plasma/KWin.
- [ ] 4. KRunner Command Center.
- [ ] 5. Barra superior.
- [ ] 6. Barra inferior.
- [ ] 7. Widgets del monitor principal.
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
