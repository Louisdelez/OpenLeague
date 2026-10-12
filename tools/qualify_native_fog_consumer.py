from pathlib import Path
import json,struct,datetime,hashlib
r=Path('E:/OpenLeague')
prefix=Path(__file__).with_name('qualify_native_fog_value_reads.py').read_text().split('\nqueries=[]')[0]
exec(compile(prefix,'native fog typed config prerequisites','exec'))
native_code_ranges.extend([(0x986fd0,0x987830),(0x8b1a80,0x8b1b52),(0x8b1f50,0x8b2026),(0x8e51a0,0x8e5300)])
cache_pair=0x40009b00;write32(cache_pair,config);write32(cache_pair+4,0);write32(0x2d83fb8,1)
requests=[];conversions=[]
stub=end+0x700;cell=end+0x800;u.mem_write(stub,b'\xd9\x05'+struct.pack('<I',cell)+b'\xc3');native_code_ranges.append((stub,stub+7))
def boundary(uc,a,size,user):
 if a==0x8acef0:
  top=uc.reg_read(UC_X86_REG_ESP);path=text(read32(top+4));flag=read32(top+8);assert path.lower()=='levels/map10/terrain.ini' and flag==0;requests.append(dict(path=path,flag=flag));returned(cache_pair,8)
 elif a==0xc99987:
  top=uc.reg_read(UC_X86_REG_ESP);s=text(read32(top+4));value=float(s);conversions.append(dict(text=s,result=value));u.mem_write(cell,struct.pack('<f',value));uc.reg_write(UC_X86_REG_EIP,stub)
u.hook_add(unicorn.UC_HOOK_CODE,boundary)
def invalid(uc,access,address,size,value,user):
 print(json.dumps(dict(invalid=hex(address),eip=hex(uc.reg_read(UC_X86_REG_EIP)),requests=requests,ecx=hex(uc.reg_read(UC_X86_REG_ECX)))),flush=True);return False
u.hook_add(unicorn.UC_HOOK_MEM_INVALID,invalid)
invoke(0x986fd0,0,b'');assert u.mem_read(0x14be79f,1)==b'\0'
filename_object=0x40009c00;write32(filename_object,path_buffer);write32(filename_object+0x10,22);write32(filename_object+0x14,31)
frame=stack+0x8000;u.mem_write(frame-0x80,bytes(0x100));u.reg_write(UC_X86_REG_EBP,frame);u.reg_write(UC_X86_REG_ESP,frame-0x60);u.reg_write(UC_X86_REG_ESI,filename_object);u.emu_start(0x9870e9,0x98734e,count=30000);assert u.reg_read(UC_X86_REG_EIP)==0x98734e
enabled=bool(u.mem_read(0x14be79f,1)[0]);rgb=list(u.mem_read(0x123f8e4,3))[::-1];opacity=struct.unpack('<f',u.mem_read(0x14beec0,4))[0];mask=bool(u.mem_read(0x2d7905d,1)[0]);assert enabled and rgb==[34,62,84] and opacity==1. and mask
fields={hex(a):list(struct.unpack('<4f',u.mem_read(a,16))) for a in [0x14beed4,0x14beee4]}
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,source=str(source),source_sha256=hashlib.sha256(contents).hexdigest(),initializer='0x986fd0',consumer_entry='0x9870e9',consumer_stop='0x98734e',integer_getter='0x8b1a80',float_getter='0x8b1f50',fog_enabled=enabled,fog_rgb=rgb,opacity=opacity,opacity_map=mask,shader_field_vectors=fields,config_requests=requests,crt_conversions=conversions,adapters=['Original binary INIBIN disk read/allocator/mutex/thread/cookie boundaries reused. Native config loader, typed lookups, high-level getters, key hash and fog consumer execute.','Config cache lookup returns supplied wrapper pointing to actual native-loaded Map10 config; no text overlay.','Entered consumer after Terrain.ini resource filename resolution; supplied native std::string storage and stack frame; stopped before function cleanup.','CRT atof conversion of ASCII1.0000 adapted to Python float and x87 FLD/RET; original locale/thread CRT not executed.','Initial renderer listener vector empty; native init, setters and parameter arithmetic execute without GPU/listener objects.'],limits=['Cache/overrides/listeners/full original renderer frame and postprocessing not qualified.','Configured fog clear state agrees with prior isolated128-case clear contract, but this does not explain uncovered regions or fix their final compositing.'])
(r/'data/4.20/native_fog_consumer_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(dict(enabled=enabled,rgb=rgb,opacity=opacity,opacity_map=mask,requests=len(requests),fields=fields)))
