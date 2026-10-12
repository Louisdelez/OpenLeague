from pathlib import Path
import json,sys,struct,hashlib
r=Path('E:/OpenLeague');sys.path.insert(0,str(r/'tools/pythonlibs'))
from PIL import Image,ImageChops
v=sys.argv[1];d=json.loads((r/f'docs/annie_ready_pause_{v}.json').read_text());rows=d['gpu_findings']['raw_frames'];assert len(rows)==2
images=[];headers=[]
for row in rows:
 p=Path(row['paused_rgba']);raw=p.read_bytes();assert len(raw)==2560*801*4
 header=struct.unpack_from('<8I',raw,2560*800*4);assert header[0]==0x4f4c5052 and header[1]==row['gpu_frame'] and header[7]==1
 assert header[6]==row['effect_time_bits'];headers.append(header)
 images.append(Image.frombytes('RGBA',(2560,801),raw))
assert headers[0][6]==headers[1][6] and headers[1][1]>headers[0][1]
result={'version':v,'backend':d['backend'],'client_sha256':d['client_sha256'],'complete':False,'frames':[h[1] for h in headers],'layers':{}}
for name,left in [('on',0),('off',1280)]:
 pair=[im.crop((left,0,left+1280,800)).convert('RGB') for im in images];diff=ImageChops.difference(*pair)
 result['layers'][name]={'changed_pixels':sum(max(x)>0 for x in diff.getdata()),'bounds':diff.getbbox(),'channel_extrema':diff.getextrema(),'rgb_sha256':[hashlib.sha256(im.tobytes()).hexdigest() for im in pair]}
result['limits']=['Two sampled GPU frames only; no original LoL equivalence and no causal inference from equality.']
(r/f'docs/paused_scene_stability_{v}.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result))
