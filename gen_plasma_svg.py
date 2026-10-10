import os

def create_plasma_svg(filepath, bg_color, bg_opacity, border_color, border_width, rx, ry):
    svg_content = f"""<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<svg width="64" height="64" version="1.1" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <style>
      .bg {{ fill: {bg_color}; fill-opacity: {bg_opacity}; }}
      .border {{ fill: {border_color}; }}
      .transparent {{ fill: none; }}
    </style>
  </defs>

  <!-- Hints -->
  <rect id="hint-top-margin" x="0" y="0" width="64" height="{border_width}" class="transparent" />
  <rect id="hint-bottom-margin" x="0" y="{64-border_width}" width="64" height="{border_width}" class="transparent" />
  <rect id="hint-left-margin" x="0" y="0" width="{border_width}" height="64" class="transparent" />
  <rect id="hint-right-margin" x="{64-border_width}" y="0" width="{border_width}" height="64" class="transparent" />

  <!-- Center -->
  <rect id="center" x="{border_width}" y="{border_width}" width="{64-2*border_width}" height="{64-2*border_width}" class="bg" />

  <!-- Borders (Sides) -->
  <rect id="top" x="{border_width}" y="0" width="{64-2*border_width}" height="{border_width}" class="border" />
  <rect id="bottom" x="{border_width}" y="{64-border_width}" width="{64-2*border_width}" height="{border_width}" class="border" />
  <rect id="left" x="0" y="{border_width}" width="{border_width}" height="{64-2*border_width}" class="border" />
  <rect id="right" x="{64-border_width}" y="{border_width}" width="{border_width}" height="{64-2*border_width}" class="border" />

  <!-- Corners -->
  <path id="topleft" d="M0,{border_width} L0,0 L{border_width},0 L{border_width},{border_width} Z" class="border" />
  <path id="topright" d="M{64-border_width},0 L64,0 L64,{border_width} L{64-border_width},{border_width} Z" class="border" />
  <path id="bottomleft" d="M0,{64-border_width} L0,64 L{border_width},64 L{border_width},{64-border_width} Z" class="border" />
  <path id="bottomright" d="M{64-border_width},{64-border_width} L64,64 L64,{64-border_width} L{64-border_width},{64-border_width} Z" class="border" />

</svg>
"""
    with open(filepath, 'w') as f:
        f.write(svg_content)

out_dir = "/home/julian/.local/share/plasma/desktoptheme/Cybercore-Y2K1/dialogs"

# KRunner: Almost opaque (0.95), 2px neon violet border (#B200FF or #8B00FF)
create_plasma_svg(f"{out_dir}/krunner.svg", "#0E0918", "0.95", "#A200FF", 2, 0, 0)

# Notifications & General Popups: Opaque (1.0), 2px cyan border (#00F0FF)
create_plasma_svg(f"{out_dir}/background.svg", "#0E0918", "1.0", "#00F0FF", 2, 0, 0)

print("SVGs created successfully.")
