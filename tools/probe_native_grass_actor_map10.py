from pathlib import Path
import json,struct,datetime
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_fow_map10_owned.py').read_text(encoding='utf-8').split('counts=heap')[0],'original Map10 terrain','exec'))
actor=terrain+0x260000;motion=terrain+0x270000;query_calls=[]
def record(uc,a,size,user):
 if a==0x8f3390:
  s=u.reg_read(UC_X86_REG_ESP);query_calls.append(list(struct.unpack('<3I',u.mem_read(s+4,12))))
u.hook_add(unicorn.UC_HOOK_CODE,record)
cases=[]
for wanted in [False,True]:
 candidates=[i for i,flag in enumerate(flags) if bool(flag&1)==wanted and not flag&2]
 index=min(candidates,key=lambda i:(minimum[0]+(i%width+.5)*cell_size-7700.)**2+(minimum[2]+(i//width+.5)*cell_size-7000.)**2)
 position=[minimum[0]+(index%width+.5)*cell_size,123.,minimum[2]+(index//width+.5)*cell_size]
 for radius in [0.,34.,35.,64.,500.,501.]:
  u.mem_write(actor,bytes(0x2100));u.mem_write(motion,bytes(0x338));write32(actor+0x18b8,motion);write32(motion+0x70,0x1094490)
  u.mem_write(motion+0x2aa,struct.pack('<3f',*position));f(actor+0x37c,radius)
  frames=[]
  for repeat in range(2):
   query_calls.clear();write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,actor)
   u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_FPSW,0)
   u.emu_start(0x6197b0,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end
   frames.append(dict(result=u.reg_read(UC_X86_REG_EAX)&255,query_calls=list(query_calls),cache_bits=list(struct.unpack('<3I',u.mem_read(actor+0x20c0,12)))))
  assert len(frames[0]['query_calls'])==1 and not frames[1]['query_calls']
  assert frames[0]['result']==frames[1]['result']
  cases.append(dict(cell_index=index,cell_flags=flags[index],position=position,radius=radius,frames=frames))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,native_map10_sha256=hashlib.sha256(nav_raw).hexdigest(),entry='0x6197b0',terrain_query='0x8f3390',native_addresses=len(visited),cases=cases,runtime_adapters=[],limits=['Original actor cache, motion getter and terrain predicate execute against verified original Map10 packed56byte cell grid. Actor position/radius fields explicitly supplied.','12 radius/position scenarios with repeated calls; not exhaustive terrain boundaries, actual actor field producers or live renderer integration.'])
(r/'data/4.20/grass_actor_map10_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(cases=len(cases),native_addresses=len(visited),results=[(c['cell_flags'],c['radius'],c['frames'][0]['result']) for c in cases])))
