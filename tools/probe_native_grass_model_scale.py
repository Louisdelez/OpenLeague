from pathlib import Path
import json,struct,datetime,hashlib,shutil
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_fow_terrain_ray.py').read_text(encoding='utf-8').split('\ncases=[]')[0],'native setup','exec'))
proof_path=r/'data/4.20/grass_model_bounds_contract.json';prior=json.loads(proof_path.read_text());archive=r/'data/4.20/grass_model_bounds_mesh_scan_contract.json';assert not archive.exists();shutil.copy2(proof_path,archive)
catalog=json.loads((r/'data/4.20/native_grass_model_bounds.json').read_text())
frame=sp-0x1000;model=terrain+0x2000;resource=terrain+0x3000;stub=end+0x300;scalar=end+0x400;value=None;requests=[]
native_code_ranges=list(native_code_ranges)+[(stub,stub+7)]
u.mem_write(stub,b'\xd9\x05'+struct.pack('<I',scalar)+b'\xc3')
def cstring(p):return bytes(u.mem_read(p,80)).split(b'\0')[0].decode('ascii')
def reader(uc,a,size,user):
 if a==0x8b1f50:
  stack=u.reg_read(UC_X86_REG_ESP);default=struct.unpack('<f',u.mem_read(stack+16,4))[0];section=cstring(read32(stack+8));key=cstring(read32(stack+12));assert section=='MeshSkin' and key=='SkinScale' and default==1. and read32(stack+20)==0
  selected=default if value is None else float(value);u.mem_write(scalar,struct.pack('<f',selected));requests.append(dict(section=section,key=key,default=default,value=selected));u.reg_write(UC_X86_REG_EIP,stub)
u.hook_add(unicorn.UC_HOOK_CODE,reader)
inputs=[(name,c['skin_scale']) for name,c in catalog.items()]+[('missing',None),('zero',0.),('negative',-2.5)];cases=[]
for name,value in inputs:
 requests.clear();u.mem_write(frame,bytes(0x100));u.mem_write(frame+0x24,b'MeshSkin\0');u.mem_write(resource,b'Base\0');u.reg_write(UC_X86_REG_ESP,frame);u.reg_write(UC_X86_REG_ESI,model);u.reg_write(UC_X86_REG_EDI,resource);u.reg_write(UC_X86_REG_ECX,frame+0x24);u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_FPSW,0)
 u.emu_start(0x9648bc,0x9648e1,count=10000);assert u.reg_read(UC_X86_REG_EIP)==0x9648e1 and len(requests)==1
 bits=read32(model+4);cases.append(dict(name=name,authored=value,result_bits=bits,requests=list(requests)))
 if name in catalog:
  row=catalog[name]
  for field in ['mesh','config']:assert hashlib.sha256(Path(row[field]).read_bytes()).hexdigest()==row[field+'_sha256']
  row['skin_scale_authored']=value;row['skin_scale']=struct.unpack('<f',struct.pack('<I',bits))[0];row['skin_scale_bits']=bits
scale_proof=dict(passed=True,complete=False,updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),native_sha256=digest,native_addresses=len(visited),cases=cases,limits=['Actual9648BC SkinScale reader default1 and model+4 write execute; configuration scalar lookup supplied from original resource fields. File IO/hierarchy remains adapted.'])
(r/'data/4.20/grass_model_scale_contract.json').write_text(json.dumps(scale_proof,indent=2)+'\n',encoding='utf-8')
for c in prior['cases']:
 if c['name'] in catalog:c.update(skin_scale_authored=catalog[c['name']]['skin_scale_authored'],skin_scale=catalog[c['name']]['skin_scale'],skin_scale_bits=catalog[c['name']]['skin_scale_bits'])
prior['mesh_scan_proof_sha256']=hashlib.sha256(archive.read_bytes()).hexdigest();prior['model_scale_proof']='grass_model_scale_contract.json';prior['model_scale_native_cases']=len(cases)
proof_path.write_text(json.dumps(prior,indent=2)+'\n',encoding='utf-8');(r/'data/4.20/native_grass_model_bounds.json').write_text(json.dumps(catalog,indent=2)+'\n',encoding='utf-8');print(json.dumps(dict(cases=len(cases),missing=sum(c['authored'] is None for c in cases),native_addresses=len(visited))))
