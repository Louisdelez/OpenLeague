from pathlib import Path
import json, struct, hashlib, datetime
r=Path('E:/OpenLeague')
prefix=(r/'tools/probe_native_inibin_loader.py').read_text(encoding='utf-8').split('\nqueries=[]')[0]
prefix=prefix.replace('terrain.inibin','Gamma.inibin').replace('terrain.ini','Gamma.ini')
exec(compile(prefix,'native Gamma INIBIN prerequisites','exec'))
native_code_ranges.extend([(0x741130,0x741280),(0x741380,0x74145e),(0x8b1f50,0x8b2026),(0x8e51a0,0x8e5300),(0xca2fa0,0xca3200),(0xcb0000,0xcc0000)])
cache_pair=0x40009b00;write32(cache_pair,config);write32(cache_pair+4,0);write32(0x2d83fb8,1)
requests=[];conversions=[]
stub=end+0x700;cell=end+0x800;u.mem_write(stub,b'\xd9\x05'+struct.pack('<I',cell)+b'\xc3');native_code_ranges.append((stub,stub+7))
def boundary(uc,a,size,user):
 if a==0x8acef0:
  top=uc.reg_read(UC_X86_REG_ESP);path=text(read32(top+4));flag=read32(top+8)
  assert path.lower()=='levels/map10/gamma.ini' and flag==0
  requests.append(dict(path=path,flag=flag));returned(cache_pair,8)
 elif a==0xc99987:
  top=uc.reg_read(UC_X86_REG_ESP);s=text(read32(top+4));value=float(s)
  conversions.append(dict(text=s,value=value));u.mem_write(cell,struct.pack('<f',value));uc.reg_write(UC_X86_REG_EIP,stub)
u.hook_add(unicorn.UC_HOOK_CODE,boundary)
def invalid(uc,access,address,size,value,user):
 print(json.dumps(dict(invalid=hex(address),eip=hex(uc.reg_read(UC_X86_REG_EIP)))),flush=True);return False
u.hook_add(unicorn.UC_HOOK_MEM_INVALID,invalid)
sp=stack+0x8000
obj=0x40009c00;u.mem_write(obj,bytes(48));write32(obj,path_buffer);write32(obj+0x10,22);write32(obj+0x14,31)
invoke(0x741130,obj)
params=list(struct.unpack('<4f',u.mem_read(obj+0x18,16)))
assert len(requests)==4 and read32(obj+0x28)==1
parsed=parser['ini'](source)
for name,value in zip(['Level','Gamma','Brightness','Contrast'],params):
 expected=float(parsed[str(parser['hashkey']('Gamma',name))]);assert struct.pack('<f',value)==struct.pack('<f',expected)
print(json.dumps(dict(parameters=params,conversions=conversions)),flush=True)
table=0x4000a000
invoke(0x7411e0,table,struct.pack('<I',obj+0x18))
values=list(struct.unpack('<256f',u.mem_read(table,1024)))
assert all(0<=x<=1 for x in values) and all(a<=b for a,b in zip(values,values[1:]))
pow_addresses=sorted(a for a in visited if 0xca2fa0<=a<0xca3200 or 0xcb0000<=a<0xcc0000)
assert 0xca2fa0 in pow_addresses
wrapper=0x4000a500;texture=0x4000a600;device=0x4000a800;vtable=0x4000a900;pixels=0x4000b000
u.mem_write(wrapper,bytes(16));u.mem_write(texture,bytes(256));write32(wrapper,texture);write32(texture+0x90,device);write32(device,vtable)
upload_calls=[]
for off in [0x24,0x28,0x14]:
 addr=end+0xa00+off;write32(vtable+off,addr);u.mem_write(addr,b'\xcc');native_code_ranges.append((addr,addr+1))
def upload_boundary(uc,a,size,user):
 top=uc.reg_read(UC_X86_REG_ESP)
 if a==end+0xa24:
  args=[read32(top+i*4) for i in range(1,5)];assert args[0]==0 and args[2:]==[0,8]
  u.mem_write(args[1],struct.pack('<II',1024,pixels));upload_calls.append(dict(kind='lock',args=args));returned(0,16)
 elif a==end+0xa28:
  assert read32(top+4)==0;upload_calls.append(dict(kind='unlock',level=0));returned(0,4)
 elif a==end+0xa14:upload_calls.append(dict(kind='upload'));returned(0,0)
u.hook_add(unicorn.UC_HOOK_CODE,upload_boundary)
invoke(0x741380,wrapper,struct.pack('<I',table))
argb=list(struct.unpack('<256I',u.mem_read(pixels,1024)))
scale=struct.unpack('<f',u.mem_read(0x1139104,4))[0];assert scale==255
expected=[0xff000000|(int(x*255)*0x10101) for x in values];assert argb==expected
assert [x['kind'] for x in upload_calls]==['lock','unlock','upload']
initial_upload_calls=list(upload_calls)
native_code_ranges.extend([(0x739869,0x7398e6),(0x984e60,0x984e61),(0x741c50,0x741c51)])
manager=0x4000c000;queue=0x4000c100;target=0x4000c200
write32(manager,obj);write32(manager+8,table);write32(manager+12,wrapper);write32(0x14b1b74,manager)
write32(0x2d78c38,queue);write32(target+0x10,texture)
selection_events=[]
def selector_boundary(uc,a,size,user):
 top=uc.reg_read(UC_X86_REG_ESP)
 if a==0x984e60:
  selection_events.append(dict(kind='copy',texture=uc.reg_read(UC_X86_REG_ECX),args=[read32(top+4),read32(top+8)]));returned(0,0)
 elif a==0x741c50:
  selection_events.append(dict(kind='gamma_pass',wrapper=uc.reg_read(UC_X86_REG_ECX),args=[read32(top+4),read32(top+8),read32(top+12)]));returned(0,0)
 elif a in [0x73989c,0x7398e6]:uc.emu_stop()
u.hook_add(unicorn.UC_HOOK_CODE,selector_boundary)
selection_cases=[]
for enabled in [False,True]:
 for queued in [False,True]:
  for dirty in [False,True]:
   u.mem_write(0x1224dd9,bytes([enabled]));write32(queue,0x1234);write32(queue+4,0x1238 if queued else 0x1234)
   write32(obj+0x28,3);write32(manager+4,2 if dirty else 3)
   selection_events.clear();upload_calls.clear();frame=stack+0x8000
   u.reg_write(UC_X86_REG_EBP,frame);u.reg_write(UC_X86_REG_ESP,frame-0x70);u.reg_write(UC_X86_REG_EDI,target)
   u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_FPSW,0)
   u.emu_start(0x739869,0x7398f6,count=200000)
   gamma=enabled or queued
   assert len(selection_events)==1 and selection_events[0]['kind']==('gamma_pass' if gamma else 'copy')
   assert len(upload_calls)==(3 if gamma and dirty else 0)
   assert read32(manager+4)==(3 if gamma else (2 if dirty else 3))
   selection_cases.append(dict(enabled=enabled,queued=queued,revision_changed=dirty,gamma_selected=gamma,lut_refreshed=bool(upload_calls),events=list(selection_events)))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,
 native_sha256=digest,source=str(source),source_sha256=hashlib.sha256(contents).hexdigest(),source_bytes=len(contents),
 loader_entry='0x8b0380',consumer_entry='0x741130',table_entry='0x7411e0',pow_entry='0xca2fa0',
 parameters=dict(zip(['Level','Gamma','Brightness','Contrast'],params)),parameter_bits=list(struct.unpack('<4I',u.mem_read(obj+0x18,16))),
 config_requests=requests,crt_string_conversions=conversions,lut=values,lut_bits=list(struct.unpack('<256I',u.mem_read(table,1024))),
 table_step=1/256,native_instructions=len(visited),native_pow_addresses=[hex(a) for a in pow_addresses],
 upload_entry='0x741380',upload_calls=initial_upload_calls,lut_argb_u32=argb,lut_u8=[x&255 for x in argb],
 selector_entry='0x739869',selector_cases=selection_cases,
 adapters=['File read, allocator, mutex, thread and cookie boundaries supplied. Native binary loader, float getters, hash and gamma consumer execute.',
 'Config cache wrapper points to actual native-loaded Gamma.inibin; overlays absent. Native filename object supplied.',
 'CRT atof for observed .9 string adapted to Python numeric conversion and x87 FLD/RET. Original pow math executes without a pow adapter.',
 'Texture storage, lock/unlock/upload callbacks supplied; original pixel conversion writes all256 ARGB words.',
 'Selector entered at739869 after alternative rendering branch. Controlled enabled byte1224DD9, queue span and revision; final copy/gamma draw calls adapted to observations and stopped before cleanup. Native producer/conversion/upload run on revision change.'],
 limits=['Enabled flag producer, queued object semantics, user overrides, physical texture allocation/GPU upload, sampler filtering and complete framebuffer composition remain unqualified.','No claim that gamma removes background regions or completes map rendering.'])
(r/'data/4.20/native_map10_gamma_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(passed=True,samples=len(values),first=values[0],middle=values[128],last=values[-1],pow_native=True,argb_words=len(argb),selector_cases=len(selection_cases),upload_calls=initial_upload_calls)))
