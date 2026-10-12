from pathlib import Path
import sys,json,struct,hashlib,io
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import numpy as np
from PIL import Image
r=Path('E:/OpenLeague');raw=(r/'assets/maps/twisted_treeline.glb').read_bytes();n=struct.unpack_from('<I',raw,12)[0];d=json.loads(raw[20:20+n]);binary=raw[28+n:];sha=lambda b:hashlib.sha256(b).hexdigest();bindings=json.loads(Path('E:/mapslol3v3/output/Rust_Integration_420/material_bindings.json').read_text(encoding='utf-8-sig'))
colors={'Blue':(.07,.35,1),'Purple':(.55,.06,1),'Yellow':(1,.5,.05),'Orange':(1,.15,.015)};results=[]
for m in d['materials']:
 name=m.get('name','')
 if name.startswith('Native_Fire_Sprite_'):color=colors[name.rsplit('_',1)[1]];opacity=.8
 elif name in ('Native_tt_mist','Native_tt_mist_02'):color=(.18,.24,.32);opacity=.16
 elif name=='Native_Ghosts':color=(.1,.65,.8);opacity=.3
 elif name=='Native_Fireflies':color=(.05,.7,1);opacity=.8
 else:continue
 path=Path(bindings[name]['image']);source=Image.open(path).convert('RGBA');arr=np.array(source,dtype=np.float32)/255;lum=arr[:,:,:3]@np.array([.2126,.7152,.0722]);alpha=lum*arr[:,:,3]*opacity;expected=np.empty_like(arr);expected[:,:,:3]=color;expected[:,:,3]=alpha;expected=(expected.clip(0,1)*255).astype('uint8')
 ti=m['pbrMetallicRoughness']['baseColorTexture']['index'];ii=d['textures'][ti]['source'];view=d['bufferViews'][d['images'][ii]['bufferView']];o=view.get('byteOffset',0);actual=Image.open(io.BytesIO(binary[o:o+view['byteLength']])).convert('RGBA');assert actual.size==source.size and actual.tobytes()==expected.tobytes(),name
 results.append({'name':name,'source':str(path),'source_sha256':sha(path.read_bytes()),'source_rgba_sha256':sha(source.tobytes()),'active_rgba_sha256':sha(actual.tobytes()),'image':ii,'size':list(actual.size),'display_tint':list(color),'opacity':opacity,'derivative_transform_equal':True,'native_shader_color_qualified':False})
assert len(results)==8
proof={'complete':False,'map_sha256':sha(raw),'sprite_derivatives':results,'passed':True,'findings':['All eight non-native pixel matches are exact documented derivatives from the existing original sprite PNGs: fixed RGB and luminance*sourceAlpha*opacity. No image corruption inferred.','Their names start Native_, but fixed RGB/opacity were reconstructed in the Blender/export workflow, not verified against original per-instance particle color/lifetime.'], 'limits':['This qualifies the derivative operation and original source PNG identity only; no claim that the fixed tint, placement, blend/atlas timing, particle behavior or appearance is faithful to4.20.','Native per-emitter definition/color/lifetime/shader playback remains required to replace provisional reconstructed sprites.']}
(r/'docs/current_map_sprite_derivatives.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');print(json.dumps({'passed':True,'sprite_derivatives':len(results),'native_shader_color_qualified':False}))
