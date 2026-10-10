# Cybercore Command Center - Guía de Comandos

Esta es la lista completa de comandos rápidos de 2 a 5 letras configurados para KRunner (`Alt + Espacio`).
Fueron forzados mediante archivos `.desktop` ocultos para que el buscador los posicione siempre en el **Top 1**.

## 🔊 Control de Audio
* **`v0` a `v100`**: Ajusta el volumen del sistema en saltos de 5% (Ej: `v10`, `v25`, `v50`, `v100`).
* **`mc`**: Mutea o desmutea el micrófono nativo.

## ☀️ Control de Pantalla (Brillo)
* **`b10` a `b100`**: Ajusta el brillo en saltos de 10% (Ej: `b20`, `b80`). *(Nota: `b1` lo pone al mínimo).*

## 🖥️ Workspaces
* **`w1` a `w10`**: Salta inmediatamente al escritorio virtual indicado (Ej: `w1`, `w4`).

## 🎵 Control Multimedia
* **`mplay`**: Reproducir o Pausar.
* **`mpause`**: Forzar pausa.
* **`mnext`**: Siguiente canción/video.
* **`mprev`**: Canción/video anterior.

## ⏱️ Temporizadores
* **`t1`, `t5`, `t10`, `t15`, `t20`, `t30`, `t45`, `t60`, `t90`, `t120`**: Crea una cuenta regresiva silenciosa en segundo plano por esa cantidad de minutos. Al terminar, tira una alerta crítica en pantalla.

## ⚙️ Conectividad y Sistema
* **`bt`**: Activa o desactiva el Bluetooth.
* **`wf`**: Activa o desactiva el Wi-Fi.
* **`dd`**: Activa el modo "No Molestar" (Oculta las notificaciones de Plasma).
* **`ss`**: Congela la pantalla para recortar una Screenshot y la manda directo al portapapeles sin abrir programas pesados.
* **`cl`**: Ejecuta una limpieza silenciosa de la caché de pacman (`yay`) y recorta logs basura de systemd.

## 💀 Excepciones (Los que llevan espacio)
* **`ka <nombre>`**: Fuerza el cierre de un proceso trancado (Ej: `ka firefox`). Al requerir que escribas el nombre de la app, este es el único comando que sigue usando el motor "Ejecutar comando" de KRunner.
