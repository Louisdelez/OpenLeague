from pathlib import Path
import sys,json,hashlib,shutil,re
from datetime import datetime,timezone
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs');from PIL import Image
r=Path('E:/OpenLeague');c=json.loads((r/'data/4.20/map10_particle_catalog.json').read_text(encoding='utf-8'));deploy=Path(c['particles_source']).parents[2];sha=lambda b:hashlib.sha256(b).hexdigest();references={}
for d in c['definitions']:
 doc=json.loads((r/d['asset']).read_text(encoding='utf-8'))
 for f in doc['fields']:
  v=f['value']
  if isinstance(v,str) and v.lower().endswith(('.dds','.tga')):references.setdefault(v,[]).append({'definition':d['reference'],'section':f['section'],'field':f['name'],'native_hash':f['native_hash']})
 for h,f in doc['unknown_hashes'].items():
  v=f['value']
  if isinstance(v,str) and v.lower().endswith(('.dds','.tga')):references.setdefault(v,[]).append({'definition':d['reference'],'native_hash':int(h),'field_unknown':True})
files={}
for p in deploy.rglob('*.dds'):files.setdefault(p.name.lower(),[]).append(p)
out=r/'assets/particles/map10_native';out.mkdir(exist_ok=True);entries=[];missing=[];ambiguous=[];failed=[]
for name,uses in sorted(references.items()):
 # Native97D0A0 normalization: first case-insensitive .tga -> .dds.
 normalized=re.sub(r'\.tga','.dds',name,count=1,flags=re.I);paths=files.get(Path(normalized.replace('\\','/')).name.lower(),[])
 if not paths:missing.append({'reference':name,'normalized':normalized,'uses':uses});continue
 hashes={sha(p.read_bytes()) for p in paths}
 if len(hashes)!=1:ambiguous.append({'reference':name,'candidates':[{'path':str(p),'sha256':sha(p.read_bytes())} for p in paths],'uses':uses});continue
 source=sorted(paths)[0]
 try:
  data=source.read_bytes();image=Image.open(source).convert('RGBA');image.load();dds=out/(Path(normalized).stem.lower()+'.dds');png=dds.with_suffix('.png');dds.write_bytes(data);image.save(png);restored=Image.open(png).convert('RGBA');assert image.size==restored.size and image.tobytes()==restored.tobytes()
  entries.append({'reference':name,'normalized':normalized,'uses':uses,'source':str(source),'source_candidates':[str(p) for p in paths],'source_sha256':sha(data),'dds_asset':str(dds.relative_to(r/'assets')).replace('\\','/'),'png_asset':str(png.relative_to(r/'assets')).replace('\\','/'),'png_sha256':sha(png.read_bytes()),'rgba_sha256':sha(image.tobytes()),'dimensions':list(image.size),'dds_bytes_equal':dds.read_bytes()==data,'png_pixels_equal':True})
 except Exception as e:failed.append({'reference':name,'source':str(source),'error':str(e)})
proof={'updated_utc':datetime.now(timezone.utc).isoformat(),'complete':False,'catalog_sha256':sha((r/'data/4.20/map10_particle_catalog.json').read_bytes()),'references':len(references),'entries':entries,'missing':missing,'ambiguous':ambiguous,'decode_failures':failed,'native_filename_contract':'data/4.20/native_texture_filename_contract.json','limits':['Original DDS payloads and decoded PNG colors/alpha preserved. No fixed hue or luminance alpha baked into these native inputs.','Identical-source candidates are retained; distinct payload candidates remain unresolved rather than choosing arbitrarily. Native search-directory precedence, sampler/mip/gamma/color curve execution and actual particle playback remain unqualified.']}
(r/'data/4.20/map10_particle_textures.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve() != (r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'references':len(references),'recovered':len(entries),'missing':[m['reference'] for m in missing],'ambiguous':[m['reference'] for m in ambiguous],'decode_failures':failed}))
