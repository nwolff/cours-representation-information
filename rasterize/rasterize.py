import cairosvg
from PIL import Image
import io
import sys
import os

def process_svg(input_file):
    if not os.path.exists(input_file):
        print(f"Erreur : Le fichier '{input_file}' n'existe pas.")
        return

    # Configuration : Nom d'usage -> Résolution source (pixels)
    configs = {
        "tres_faible": 8,
        "faible": 16,
        "moyenne": 32,
        "bonne": 64
    }
    
    taille_affichage = 512
    base_name = os.path.splitext(input_file)[0]

    for label, res in configs.items():
        # 1. Conversion SVG -> PNG (mémoire) à basse résolution
        png_data = cairosvg.svg2png(url=input_file, output_width=res)
        
        # 2. Ouverture avec Pillow
        img = Image.open(io.BytesIO(png_data)).convert("RGBA")
        
        # 3. "Blow up" sans lissage (NEAREST), le plus grand côté à 512px, en gardant les proportions
        echelle = taille_affichage / max(img.size)
        taille_finale = (round(img.width * echelle), round(img.height * echelle))
        img_final = img.resize(taille_finale, resample=Image.NEAREST)
        
        # 4. Sauvegarde
        output_name = f"build/{base_name}_{label}_{res}px.png"
        img_final.save(output_name)
        print(f"Créé : {output_name} (Source: {img.width}x{img.height}px -> Affichage: {img_final.width}x{img_final.height}px)")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage : python rasterize.py mon_fichier.svg")
    else:
        process_svg(sys.argv[1])


