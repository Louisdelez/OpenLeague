from pathlib import Path
import json,struct,hashlib,itertools,math,datetime,sys,io
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
from PIL import Image
r=Path('E:/OpenLeague');proof=json.loads((r/'data/4.20/native_cloud_mip_chain_contract.json').read_text(encoding='utf-8'));dds=Path(proof['source']).read_bytes();levels=[]
for item in proof['levels']:
 w,h=item['width'],item['height'];header=bytearray(dds[:128]);struct.pack_into('<I',header,12,h);struct.pack_into('<I',header,16,w);struct.pack_into('<I',header,28,1)
 data=bytes(header)+dds[item['source_offset']:item['source_offset']+item['block_bytes']]
 image=Image.open(io.BytesIO(data)).convert('RGBA');assert image.size==(w,h);levels.append(image)
def f(x):return struct.unpack('<f',struct.pack('<f',x))[0]
def sample(image,u,v):
 w,h=image.size;x=u*w-.5;y=v*h-.5;xi=math.floor(x);yi=math.floor(y);fx=x-xi;fy=y-yi
 result=[]
 for c in range(4):
  a=image.getpixel((xi%w,yi%h))[c]/255;b=image.getpixel(((xi+1)%w,yi%h))[c]/255
  d=image.getpixel((xi%w,(yi+1)%h))[c]/255;e=image.getpixel(((xi+1)%w,(yi+1)%h))[c]/255
  result.append((a+(b-a)*fx)*(1-fy)+(d+(e-d)*fx)*fy)
 return result
uvs=[(-.125,1.25),(0.,0.),(.5/1024,.5/1024),(.1234,.5678),(.99999,.00001),(1.5,2.5),(6.437,4.225),(-20.001,10.999)]
lods=[-1.,0.,.5,1.,1.5,2.,3.,4.,5.,6.,7.,8.,9.,9.5,10.,11.];cases=[]
for (u,v),lod in itertools.product(uvs,lods):
 u,v,lod=map(f,[u,v,lod]);t=max(0.,min(10.,lod));low=int(math.floor(t));high=min(10,low+1);fraction=t-low
 a=sample(levels[low],u,v);b=sample(levels[high],u,v);expected=[a[i]+(b[i]-a[i])*fraction for i in range(4)]
 cases.append(dict(input=[u,v,lod,0.],expected=expected))
out=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),complete=False,cases=cases,case_count=len(cases),mip_count=11,
 asset=proof['asset'],asset_sha256=proof['asset_sha256'],reference='Pillow DXT1 decoding per original mip; independent double-precision bilinear repeat sampling and trilinear explicit-LOD blending. Inputs rounded to f32.',
 tolerance=2/255,limits=['Explicit LOD fixtures; derivative-driven mip selection in ordinary raster frame not proven.',
 'Reference uses 8-bit decoded BC1 samples; hardware BC1 interpolation and filtering rounding may differ within2/255 tolerance.',
 'Native D3D sampler backend sequence qualified separately; no original-game framebuffer equivalence or whole frame sampler state proof.'])
(r/'data/4.20/native_cloud_filter_gpu_cases.json').write_text(json.dumps(out,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(cases=len(cases),mips=11,tolerance=out['tolerance'])))
