import os

def create_plasma_svg(filepath, bg_color, bg_opacity, border_color, border_width, margin):
    # margin is the hint margin (e.g. 16)
    # the actual drawn border is border_width (e.g. 2)
    # The SVG should be big enough to hold the margins. Let's make it 64x64.
    svg_content = f"""<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<svg width="64" height="64" version="1.1" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <style>
      .bg {{ fill: {bg_color}; fill-opacity: {bg_opacity}; }}
      .border {{ fill: {border_color}; }}
      .transparent {{ fill: none; }}
    </style>
  </defs>

  <!-- Hints for internal padding -->
  <rect id="hint-top-margin" x="0" y="0" width="64" height="{margin}" class="transparent" />
  <rect id="hint-bottom-margin" x="0" y="{64-margin}" width="64" height="{margin}" class="transparent" />
  <rect id="hint-left-margin" x="0" y="0" width="{margin}" height="64" class="transparent" />
  <rect id="hint-right-margin" x="{64-margin}" y="0" width="{margin}" height="64" class="transparent" />

  <!-- Center (the drawn background area) -->
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

out_dir = "/home/julian/.local/share/plasma/desktoptheme/Cybercore-Y2K1"
# Update KRunner background with 16px internal padding but a 2px violet border
create_plasma_svg(f"{out_dir}/dialogs/krunner.svg", "#15051A", "0.95", "#A200FF", 2, 16)
# Update notifications background with 16px internal padding but a 2px cyan border
create_plasma_svg(f"{out_dir}/dialogs/background.svg", "#15051A", "0.95", "#00F0FF", 2, 16)

print("Dialog backgrounds updated with proper padding.")
