from pathlib import Path
import json,hashlib,sys,datetime
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
from PIL import Image,ImageDraw
r=Path('E:/OpenLeague');data=r/'logs/native-font-source-glyphs.json';p=json.loads(data.read_text());assert p['cpu_probe'] and len(p['rows'])==5
manifest=json.loads((r/'data/4.20/native_hud_fonts_manifest.json').read_text());fonts={f['path']:f for f in manifest['files']}
canvas=Image.new('RGB',(1100,550),'white');draw=ImageDraw.Draw(canvas);draw.text((20,15),'FreeType 2.4.8 / source fonts / DPI 96 / requested metric height 48 / CPU probe',fill='black')
for i,row in enumerate(p['rows']):
 assert hashlib.sha256((r/row['path']).read_bytes()).hexdigest()==fonts[row['path']]['sha256'];assert row['version']==[2,4,8]
 y=65+i*95;draw.text((20,y),row['path'].split('/')[-1],fill='black');draw.text((20,y+25),f"26.6size={row['character_height_26_6']} metric={row['metric_height']} steps={row['adjustment_calls']}",fill='black')
 for j,glyph in enumerate(row['glyphs']):
  pixels=bytes.fromhex(glyph['pixels_hex']);assert len(pixels)==glyph['width']*glyph['height'] and any(pixels)
  alpha=Image.frombytes('L',(glyph['width'],glyph['height']),pixels);ink=Image.new('RGB',alpha.size,'black');canvas.paste(ink,(520+j*220,y+48-glyph['top']),alpha);draw.text((520+j*220,y+58),f"U+{glyph['codepoint']:04X} / glyph{glyph['index']}",fill='black')
png=r/'logs/native-font-source-glyphs.png';assert not png.exists();canvas.save(png)
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),complete=False,cpu_probe=True,source_family_count=5,glyph_bitmaps=10,source_hashes_verified=True,probe_data=str(data.relative_to(r)),probe_data_sha256=hashlib.sha256(data.read_bytes()).hexdigest(),preview=str(png.relative_to(r)),preview_sha256=hashlib.sha256(png.read_bytes()).hexdigest(),visual_inspected=False,native_glyph_fidelity_verified=False,gpu_glyph_rendering=False,limits=['Actual FreeType2.4.8 CPU bitmaps from source fonts, explicit load_flags0/render_mode0/96DPI/target48. Native compile patches/load flags still unqualified.','Diagnostic contact sheet; not original-game comparison, GPU glyph rendering or native HUD widgets.'])
(r/'docs/native_font_source_glyph_probe.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(proof))
