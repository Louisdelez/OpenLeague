from pathlib import Path
import sys,re,struct,json,hashlib,datetime,shutil
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile
r=Path('E:/OpenLeague');native=Path(r'D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe');raw=native.read_bytes();pe=pefile.PE(data=raw);image=pe.get_memory_mapped_image();base=pe.OPTIONAL_HEADER.ImageBase
def cstr(address):
 if not base<=address<base+len(image):return None
 b=image[address-base:address-base+500].split(b'\0')[0]
 return b.decode() if b and all(32<=x<=126 for x in b) else None
rows=[]
for m in re.finditer(rb'(?:Environment|SkinnedMesh|FogOfWar)_[A-Za-z0-9_]+\x00',raw):
 name=m.group()[:-1].decode();address=base+pe.get_rva_from_offset(m.start())
 for ref in re.finditer(re.escape(struct.pack('<I',address)),image):
  at=ref.start()
  if at%4 or at+12>len(image):continue
  _,source,defines=struct.unpack_from('<3I',image,at);source=cstr(source);defines=cstr(defines) if defines else ''
  if not source or not source.startswith(('Environment/','SkinnedMesh/','FogOfWar/')) or not source.endswith(('.vs_2_0','.ps_2_0','.hls')):continue
  path=native.parent/'DATA/Shaders/HLSL'/source;exists=path.exists();archive=r/'data/4.20/shaders'/source
  if exists:
   archive.parent.mkdir(parents=True,exist_ok=True)
   if archive.exists():assert archive.read_bytes()==path.read_bytes(),source
   else:shutil.copy2(path,archive)
  rows.append({'name':name,'native_descriptor':hex(base+at),'source':source,'defines':defines,'exists':exists,'source_sha256':hashlib.sha256(path.read_bytes()).hexdigest() if exists else None})
assert len(rows)>20
dependencies=[];seen=set();pending=[native.parent/'DATA/Shaders/HLSL'/x for x in {x['source'] for x in rows}];hlsl=native.parent/'DATA/Shaders/HLSL'
while pending:
 path=pending.pop().resolve();relative=path.relative_to(hlsl.resolve()).as_posix()
 if relative in seen:continue
 seen.add(relative);data=path.read_bytes();archive=r/'data/4.20/shaders'/relative;archive.parent.mkdir(parents=True,exist_ok=True)
 if archive.exists():assert archive.read_bytes()==data,relative
 else:archive.write_bytes(data)
 includes=[]
 for m in re.finditer(rb'^\s*#\s*include\s*["<]([^">]+)[">]',data,re.M):
  text=m.group(1).decode();target=(path.parent/text).resolve();target.relative_to(hlsl.resolve());exists=target.exists();includes.append({'include':text,'resolved':target.relative_to(hlsl.resolve()).as_posix(),'exists':exists})
  if exists:pending.append(target)
 dependencies.append({'source':relative,'sha256':hashlib.sha256(data).hexdigest(),'includes':includes})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'descriptors':rows,'descriptor_count':len(rows),'distinct_source_count':len({x['source'] for x in rows}),'missing_sources':[x for x in rows if not x['exists']],'dependencies':dependencies,'archived_source_and_dependency_count':len(dependencies),'missing_includes':[{'source':d['source'],**i} for d in dependencies for i in d['includes'] if not i['exists']],'selection_contract':'data/4.20/skinned_shader_selection_contract.json','limits':['Static original PE records link shader name, source and defines; registration consumer/compiler and device execution not qualified.','No inference of NVR type/flags to shader selection; environment dispatch remains open.','Death-screen generated variants and source/quality descriptor producers remain open.','Archiving does not implement every variant or prove fidelity.']}
(r/'data/4.20/native_shader_descriptor_catalog.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({k:proof[k] for k in ['descriptor_count','distinct_source_count','missing_sources']}))
