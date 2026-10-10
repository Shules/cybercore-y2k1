import os

def create_plasma_svg(filepath, bg_color, bg_opacity, border_color, border_width):
    svg_content = f"""<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<svg width="32" height="32" version="1.1" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <style>
      .bg {{ fill: {bg_color}; fill-opacity: {bg_opacity}; }}
      .border {{ fill: {border_color}; }}
      .transparent {{ fill: none; }}
    </style>
  </defs>
  <rect id="hint-top-margin" x="0" y="0" width="32" height="{border_width}" class="transparent" />
  <rect id="hint-bottom-margin" x="0" y="{32-border_width}" width="32" height="{border_width}" class="transparent" />
  <rect id="hint-left-margin" x="0" y="0" width="{border_width}" height="32" class="transparent" />
  <rect id="hint-right-margin" x="{32-border_width}" y="0" width="{border_width}" height="32" class="transparent" />

  <rect id="center" x="{border_width}" y="{border_width}" width="{32-2*border_width}" height="{32-2*border_width}" class="bg" />

  <rect id="top" x="{border_width}" y="0" width="{32-2*border_width}" height="{border_width}" class="border" />
  <rect id="bottom" x="{border_width}" y="{32-border_width}" width="{32-2*border_width}" height="{border_width}" class="border" />
  <rect id="left" x="0" y="{border_width}" width="{border_width}" height="{32-2*border_width}" class="border" />
  <rect id="right" x="{32-border_width}" y="{border_width}" width="{border_width}" height="{32-2*border_width}" class="border" />

  <path id="topleft" d="M0,{border_width} L0,0 L{border_width},0 L{border_width},{border_width} Z" class="border" />
  <path id="topright" d="M{32-border_width},0 L32,0 L32,{border_width} L{32-border_width},{border_width} Z" class="border" />
  <path id="bottomleft" d="M0,{32-border_width} L0,32 L{border_width},32 L{border_width},{32-border_width} Z" class="border" />
  <path id="bottomright" d="M{32-border_width},{32-border_width} L32,32 L32,{32-border_width} L{32-border_width},{32-border_width} Z" class="border" />
</svg>
"""
    with open(filepath, 'w') as f:
        f.write(svg_content)

out_dir = "/home/julian/.local/share/plasma/desktoptheme/Cybercore-Y2K1/widgets"
os.makedirs(out_dir, exist_ok=True)

# Generate flat listitem
create_plasma_svg(f"{out_dir}/listitem.svg", "#A200FF", "0.3", "#A200FF", 1)

print("listitem.svg created successfully.")
