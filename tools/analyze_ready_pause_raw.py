from pathlib import Path
import json,struct,hashlib,sys
r=Path('E:/OpenLeague');sys.path.insert(0,str(r/'tools/pythonlibs'))
from PIL import Image,ImageChops,ImageEnhance
v=sys.argv[1] if len(sys.argv)>1 else 'v75';d=json.loads((r/f'docs/annie_ready_pause_{v}.json').read_text());rows=[]
for row in d['gpu_findings']['raw_frames']:
 p=Path(row['paused_rgba']);raw=p.read_bytes();w,h=1280,800
 assert len(raw)==w*2*(h+1)*4
 header=struct.unpack_from('<8I',raw,w*2*h*4)
 assert header[0]==0x4f4c5052 and header[1]==row['gpu_frame'] and header[2]>0 and header[7]==1
 assert header[6]==row['effect_time_bits']
 atlas=Image.frombytes('RGBA',(w*2,h+1),raw);on=atlas.crop((0,0,w,h)).convert('RGB');off=atlas.crop((w,0,w*2,h)).convert('RGB')
 diff=ImageChops.difference(on,off);count=sum(max(pixel)>0 for pixel in diff.getdata());assert count==row['changed_pixels']
 on.save(p.with_suffix('.on.png'));off.save(p.with_suffix('.off.png'));ImageEnhance.Brightness(diff).enhance(8).save(p.with_suffix('.diff-x8.png'))
 rows.append({'frame':header[1],'effect_time_bits':header[6],'changed_pixels':count,'bounds':diff.getbbox(),'sha256':hashlib.sha256(raw).hexdigest(),'raw':str(p)})
assert len(rows)==2 and rows[0]['effect_time_bits']==rows[1]['effect_time_bits']
result={'raw_verified':True,'complete':False,'frames':rows,'has_visible_contribution':all(row['changed_pixels']>0 for row in rows),'limits':['Same-frame selected-layer difference; no original LoL pixel equivalence.','Background animation can change between paused frames; whole-frame equality not asserted.']}
(r/f'docs/annie_ready_pause_{v}_raw.json').write_text(json.dumps(result,indent=2));print(json.dumps(result))
