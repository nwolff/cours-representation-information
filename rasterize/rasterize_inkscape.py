import subprocess
import os
import sys
from PIL import Image

def process_svg(input_file):
    if not os.path.exists(input_file):
        print(f"Error: {input_file} not found.")
        return

    # Configuration: Source Resolution (px)
    configs = {"faible": 16, "moyenne": 64, "bonne": 256}
    display_size = 512
    base_name = os.path.splitext(input_file)[0]

    for label, res in configs.items():
        temp_png = f"temp_{res}.png"
        output_png = f"{base_name}_{label}_{res}px.png"

        # 1. Use INKSCAPE to create the small raster file
        subprocess.run(["inkscape", input_file, "-w", str(res), "-o", temp_png], 
                       stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

        # 2. Use PILLOW to "blow up" the pixels
        if os.path.exists(temp_png):
            img = Image.open(temp_png).convert("RGBA")
            # NEAREST is the magic for the pixelated look
            img_final = img.resize((display_size, display_size), resample=Image.NEAREST)
            img_final.save(output_png)
            
            # Cleanup temp file
            os.remove(temp_png)
            print(f"Created: {output_png} (Scaled to {display_size}px)")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python rasterize_inkscape.py file.svg")
    else:
        process_svg(sys.argv[1])
