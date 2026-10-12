"""Static GLB ray attribution against a prior captured camera, not a raster verifier."""
from pathlib import Path
import sys,os,datetime,hashlib
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
os.environ['OPENLEAGUE_PROBE_ENV_ONLY']='1'
diagnostic=Path('E:/OpenLeague/tools/verify_native_fog_render.py')
namespace={'__file__':str(diagnostic)}
prefix=diagnostic.read_text(encoding='utf-8').split('spawn=json.loads')[0]
if os.environ.get('OPENLEAGUE_ATTRIBUTION_SOURCE'):
 prefix=prefix.replace("raw=(r/'assets/maps/twisted_treeline.glb').read_bytes()", "raw=Path(os.environ['OPENLEAGUE_ATTRIBUTION_SOURCE']).read_bytes()")
exec(prefix,namespace)
globals().update({k:v for k,v in namespace.items() if not k.startswith('__')})
frame=r/'logs/native-nexus-skin.png';screen=Image.open(frame).convert('RGB')
camera=json.loads((r/'logs/endgame-camera-pan-runtime.jsonl').read_text().splitlines()[-1]);eye=np.array(camera['render_camera_position']);focus=np.array(camera['native_render_focus'])/20.
forward=(focus-eye)/np.linalg.norm(focus-eye);right=np.cross(forward,[0,1,0]);right/=np.linalg.norm(right);up=np.cross(right,forward);fov=np.deg2rad(50);width,height=screen.size
# Select exact clear pixels outside the victory title near the upper-right map border.
samples=[]
for y in [140,160,180,200,340,360,380,400]:
 xs=[x for x in range(970,1200) if screen.getpixel((x,y))==(34,62,84)]
 if xs:samples.append((xs[len(xs)//2],y))
assert len(samples)>=4,samples
results=[];cache={}
for x,y in samples:
 direction=forward+right*((2*(x+.5)/width-1)*np.tan(fov/2)*width/height)+up*((1-2*(y+.5)/height)*np.tan(fov/2));direction/=np.linalg.norm(direction)
 h=np.cross(direction,e2);det=np.einsum('ij,ij->i',e1,h);valid=np.abs(det)>1e-8;inv=np.divide(1,det,out=np.zeros_like(det),where=valid);s=eye-v0;u=inv*np.einsum('ij,ij->i',s,h);q=np.cross(s,e1);v=inv*np.einsum('j,ij->i',direction,q);distance=inv*np.einsum('ij,ij->i',e2,q);valid&=(u>=0)&(v>=0)&(u+v<=1)&(distance>0)
 hits=[]
 for i in sorted(np.flatnonzero(valid),key=lambda i:distance[i])[:16]:
  mat=d['materials'][materials[i]];uv=uvs[i,0]*(1-u[i]-v[i])+uvs[i,1]*u[i]+uvs[i,2]*v[i];texture=mat.get('pbrMetallicRoughness',{}).get('baseColorTexture');rgba=None
  if texture:
   source=d['textures'][texture['index']]['source']
   if source not in cache:
    view=d['bufferViews'][d['images'][source]['bufferView']];off=view.get('byteOffset',0);cache[source]=Image.open(io.BytesIO(binary[off:off+view['byteLength']])).convert('RGBA')
   im=cache[source];rgba=list(im.getpixel((int(uv[0]*im.width)%im.width,int(uv[1]*im.height)%im.height)))
  depth=float(np.dot(direction*distance[i],forward))
  hits.append(dict(mesh=names[i],material=mat.get('name'),distance=float(distance[i]),view_depth=depth,within_clip=2.5<=depth<=250.,determinant=float(det[i]),alpha_mode=mat.get('alphaMode','OPAQUE'),double_sided=mat.get('doubleSided',False),alpha_cutoff=mat.get('alphaCutoff',.5),texture_nearest_rgba=rgba,world=(eye+direction*distance[i]).tolist()))
 results.append(dict(pixel=[x,y],observed_rgb=list(screen.getpixel((x,y))),hits=hits))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),complete=False,frame=str(frame),frame_sha256=hashlib.sha256(frame.read_bytes()).hexdigest(),map_sha256=hashlib.sha256(raw).hexdigest(),camera= camera,camera_fov_degrees=50,triangles=len(triangles),samples=results,limits=['Static CPU two-sided ray intersections; original/Bevy rasterization, alpha bilinear sampling, pass ordering and animated ambient occlusion not modeled.','Prior endgame-camera trace and Nexus capture share final stationary focus; exact screenshot capture timestamp not separately recorded.','No product change or new visual acceptance.'])
output=r/('docs/chaos_base_background_native_export_rays.json' if os.environ.get('OPENLEAGUE_ATTRIBUTION_SOURCE') else 'docs/chaos_base_background_ray_attribution.json');output.write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps([dict(pixel=row['pixel'],hits=len(row['hits']),nearest=row['hits'][:2]) for row in results]))
