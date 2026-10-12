from pathlib import Path
from fractions import Fraction as F
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');stage=Path('E:/mapslol3v3')
for src,dst in [('native_font_functions.wgsl','assets/shaders/native_font_functions.wgsl'),('native_font_raster_probe.rs','crates/client/examples/native_font_raster_probe.rs')]:shutil.copy2(stage/src,r/dst)
reference={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'complete':False,'reference_type':'independent rational evaluation of archived native HLSL with qualified native blend state; roundedUNORM8','fill_outline':[],'glow':[],'source_hashes':{p:hashlib.sha256((r/p).read_bytes()).hexdigest() for p in ['data/4.20/shaders/RenderGlyph/PS_RENDER_FILL_AND_OUTLINE.ps_2_0','data/4.20/shaders/RenderGlyph/PS_RENDER_GLOW.ps_2_0','data/4.20/native_font_blend_state_contract.json']}}
color=[F(3,4),F(1,2),F(1,4)];outline_color=[F(1,4),F(3,4),F(1,2)];fill=[F(64,255),F(128,255),F(192,255)];background=[F(32,255),F(64,255),F(96,255),F(128,255)]
def unorm(value):return round(min(F(1),max(F(0),value))*255)
for y in range(64):
 for x in range(64):
  f=F(x*4,255);o=F(min(y*4,255-x*4),255);af=F(4,5)*f*F(128,255);ao=F(3,5)*o;alpha=1-af-ao
  reference['fill_outline'].append([unorm(af*color[i]*fill[i]+ao*outline_color[i]+background[i]*alpha) for i in range(3)]+[unorm(alpha+background[3]*alpha)])
  alpha=F(4,5)*f;reference['glow'].append([unorm(color[i]*alpha+background[i]*(1-alpha)) for i in range(3)]+[unorm(alpha*alpha+background[3]*(1-alpha))])
(r/'data/4.20/native_font_raster_reference.json').write_text(json.dumps(reference,indent=2)+'\n',encoding='utf-8')
shutil.copy2(stage/'install_native_font_raster_probe.py',r/'tools/install_native_font_raster_probe.py');print('native shader helpers and8192rational raster references installed')
