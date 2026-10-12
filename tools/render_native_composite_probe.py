from pathlib import Path
import sys,json,hashlib,datetime
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
from PIL import Image,ImageDraw
r=Path('E:/OpenLeague');data=r/'logs/native-glyph-composite-source-probe.json';p=json.loads(data.read_text());assert p['cpu_probe'] and len(p['rows'])==5
fonts={f['path']:f for f in json.loads((r/'data/4.20/native_hud_fonts_manifest.json').read_text())['files']}
canvas=Image.new('RGB',(1080,780),'white');draw=ImageDraw.Draw(canvas)
draw.text((20,12),'Native flags0/4 / FreeType2.4.8 / DPI96 / original coverage composition / CPU diagnostic',fill='black')
draw.text((525,35),'Normal position',fill='black');draw.text((795,35),'Clipped at left/top',fill='black')
for i,row in enumerate(p['rows']):
 assert hashlib.sha256((r/row['path']).read_bytes()).hexdigest()==fonts[row['path']]['sha256']
 y=65+i*140;draw.text((20,y),row['path'].split('/')[-1],fill='black')
 draw.text((20,y+24),f"U+{row['character_utf16']:04X} / glyph{row['glyph_index']} / metric pixels{row['metric_pixels']}",fill='black')
 draw.text((20,y+48),f"Actual A/V mode0 kerning: {row['a_v_kerning_pixels']} pixels",fill='black')
 for j,panel in enumerate(row['panels']):
  pixels=bytes.fromhex(panel['rgba_hex']);assert len(pixels)==96*64*4
  assert all(len(set(pixels[k:k+4]))==1 for k in range(0,len(pixels),4))
  bitmap=Image.frombytes('RGBA',(96,64),pixels).convert('RGB').resize((192,128),Image.Resampling.NEAREST)
  canvas.paste(bitmap,(525+j*270,y))
output=r/'logs/native-glyph-composite-source-probe.png';assert not output.exists();canvas.save(output)
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'complete':False,'cpu_probe':True,'source_families':5,'panels':10,'native_load_flags':[0,4],'source_hashes_verified':True,'visual_inspected':False,'native_original_glyph_equality':False,'gpu_drawing_verified':False,'probe_data':str(data.relative_to(r)),'probe_data_sha256':hashlib.sha256(data.read_bytes()).hexdigest(),'preview':str(output.relative_to(r)),'preview_sha256':hashlib.sha256(output.read_bytes()).hexdigest(),'limits':['Native flags0/4 and ported composition/clipping use actual original font bytes with official FreeType2.4.8; original compile patches and original bitmap equality remain open.','Grayscale channel values shown without applying alpha a second time; this is a diagnostic panel, not a complete text-layout/widget/GPU proof.']}
(r/'docs/native_glyph_composite_source_probe.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(proof))
