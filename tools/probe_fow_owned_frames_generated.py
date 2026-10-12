from pathlib import Path
import json,struct,itertools,datetime,hashlib
r=Path('E:/OpenLeague')
prefix=(r/'tools/probe_fow_frame_schedule.py').read_text().split('\ncases=[]')[0]
prefix=prefix.replace("adapters.append('mask_generation_boundary');finish(16)","pass").replace('count=200000','count=4000000')
exec(compile(prefix,'native complete frame prerequisites','exec'))
def invoke(entry,this,args=b''):
 write32(sp,end);u.mem_write(sp+4,args);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,this)
 u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_FPSW,0)
 u.emu_start(entry,end,count=4000000);assert u.reg_read(UC_X86_REG_EIP)==end,hex(u.reg_read(UC_X86_REG_EIP))
u.mem_map(0x50000000,0x10000);counts=0x50000000;pixels=0x50004000;bits=0x50008000
terrain=0x60000000;cells=terrain+0x1000;u.mem_map(terrain,0x300000)
nav_proof=json.loads((r/'data/4.20/fow_map10_owned_contract.json').read_text());nav_meta=nav_proof['terrain'];nav_raw=Path(nav_meta['source']).read_bytes();assert hashlib.sha256(nav_raw).hexdigest()==nav_meta['sha256']
u.mem_write(cells,nav_raw[39:39+56*nav_meta['width']*nav_meta['height']]);write32(terrain+0x20,cells)
for off,val in [(7,nav_meta['origin'][0]),(0xb,nav_meta['origin'][1]),(0xf,nav_meta['origin'][2]),(0x314,nav_meta['cell_size']),(0x318,1./nav_meta['cell_size']),(0x320,nav_meta['cell_size']*.5)]:f(terrain+off,val)
write32(terrain+0x30c,nav_meta['width']);write32(terrain+0x310,nav_meta['height']);write32(0x14c7f1c,terrain)
u.mem_map(0x70000000,0x20000);actors=[0x70000000+i*0x4000 for i in range(3)];characters=[0x7000c000+i*0x400 for i in range(3)]
queries=[]
def generation_trace(uc,a,size,user):
 if a==0x8f3390:queries.append(list(struct.unpack('<3f',u.mem_read(u.reg_read(UC_X86_REG_ESP)+4,12))))
u.hook_add(unicorn.UC_HOOK_CODE,generation_trace)
def state():
 return dict(pending=pending_state(),smoothed_delta_bits=read32(view+0x4c),counts=[[i,v] for i,v in enumerate(u.mem_read(counts,16384)) if v],pixels=[[i,v] for i,v in enumerate(u.mem_read(pixels,16384)) if v],sources=[dict(parameter_bits=[read32(obj+o) for o in [0xc,0x10,0x14,0x18,0x1c]],center=[struct.unpack('<f',u.mem_read(obj+o,4))[0] for o in [4,8]],radius=struct.unpack('<f',u.mem_read(obj+0xc,4))[0],applied=bool(u.mem_read(obj+0x44,1)[0]),dirty=bool(u.mem_read(obj+0x45,1)[0]),pending=bool(u.mem_read(obj+0x5c,1)[0]),rect=[read32(obj+o) for o in [0x4c,0x54,0x50,0x58]],words=list(struct.unpack('<512I',u.mem_read(read32(obj+0x40),2048)))) for obj,_ in sources])
cases=[]
centers=[nav_proof['cases'][0]['center'],nav_proof['cases'][12]['center'],[4000.,6000.]]
for radius,force,initial_applied,delta,owner_valid in itertools.product([200.,800.],[False,True],[True],[3.],[False,True]):
 allocation_cursor=heap+0x19000;sources=[];captures.clear();generated.clear();adapters.clear();queries.clear();ticks=4999
 for pointer,size in [(manager,64),(entries,32),(output,24),(view,256),(player,4096),(context,256),(camera_root,16),(camera,512)]:u.mem_write(pointer,bytes(size))
 for address,value in [(manager+4,entries),(manager+8,entries),(manager+0xc,entries+32),(0x2d77f48,player),(0x2d787b8,context),(0x2d798ac,manager),(0x2d78d24,camera_root),(0x2d7c06c,7),(0x2d7c074,0),(player+0x18,100),(camera_root,camera),(view+0x10,128),(view+0x14,counts),(view+0x18,pixels),(view+0x3c,pending_storage),(view+0x40,pending_storage),(view+0x44,pending_storage+64),(0x14bef50,1000),(0x14bef54,0),(0x14bef48,0),(0x14bef4c,0)]:write32(address,value)
 u.mem_write(0x2d7c078,bytes([1]));f(view+0xc,15398.671875);f(camera+0x104,7700.);f(camera+0x10c,7000.);u.mem_write(counts,bytes(16384));u.mem_write(pixels,bytes(16384))
 u.mem_write(table,bytes(16));write32(0x2d628c0,table);write32(0x2d628c4,4)
 for i,center in enumerate(centers):
  actor=actors[i];u.mem_write(actor,bytes(0x3000));write32(actor,0x1090ea8);write32(actor+0x3e0,0x10924dc);write32(actor+8,0x12340000+i);write32(actor+0x18,100 if owner_valid else 200);write32(table+i*4,actor)
  write32(actor+0x206c,characters[i]);f(characters[i]+0x1d8,radius);f(actor+0x37c,64.);f(actor+0x384,128.)
  invoke(0x6b1b20,manager,struct.pack('<5IfI5f',output+8*i,0,55+i,66,100,radius,actor,128.,64.,0.,*center))
  obj=read32(output+8*i);control=read32(output+8*i+4);sources.append((obj,control));write32(actor+0x2294,obj);write32(actor+0x2298,control);write32(control+8,read32(control+8)+1);bp=bits+i*2048;write32(obj+0x40,bp);write32(obj+0x48,512);u.mem_write(bp,bytes(2048))
  if initial_applied:invoke(0x6b14e0,obj,struct.pack('<IfII',128,15398.671875,pixels,view+0x14))
 initial=state();frames=[]
 for step in range(4):
  captures.clear();generated.clear();queries.clear();adapters.clear();ticks=4999+100*step
  if step==1:
   f(sources[0][0]+4,centers[0][0]+128.);u.mem_write(sources[0][0]+0x45,bytes([1]));f(characters[1]+0x1d8,radius*1.25)
  if step in [1,3]:
   for actor in actors:
    f(actor+0x77c,.5 if step==1 else 0.);f(actor+0x778,50. if step==1 else 0.);invoke(0x6198f0,actor)
  frame_force=force or step>=2;frame_delta=3. if step==3 else delta;u.mem_write(view+0x1c,bytes([frame_force]))
  invoke(0x6b3fa0,view,struct.pack('<f',frame_delta));assert len(captures)==1
  frames.append(dict(step=step,force=frame_force,delta=frame_delta,now=ticks/1000.,before_processing=captures[0],generated=list(generated),source_queries=list(queries),after=state(),adapters=sorted(set(adapters))))
 assert not frames[-1]['after']['pending'];assert all(not s['dirty'] and s['applied'] for s in frames[-1]['after']['sources'])
 cases.append(dict(owner_valid=owner_valid,radius=radius,force=force,initial_applied=initial_applied,delta=delta,initial=initial,frames=frames))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,native_addresses=len(visited-{0xc9f39b,0x9933e0,0xc98528,0x9941b0,0x994210,0xc975f5,0x62b380,0x6b439b,0x993d0f,0x993d24}),terrain=nav_meta,dimension=128,extent=15398.671875,camera=[7700.,7000.],centers=centers,cases=cases,limits=['Original complete frame6B3FA0 invokes original generation6B14E0, source query8F3390, fan/rays/circle predicates, counters, dirty clearing and heap processing; no mask-generation adapter.','Entity lookup supplied absent, spectator false, QPC/clock initialization and allocator boundaries adapted. Original terrain constructor, full view initialization, entities and camera/extent producers remain unqualified.','Source buffers preallocated. Owners use original resolver/getters and original6198F0 update with supplied actor/CharacterData fields and additional retained weak reference; actor construction and buff producers not executed. Local source tag100; matching/mismatching owner tag qualified. No live gameplay/GPU binding.'])
(r/'data/4.20/fow_owned_frames_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(sequences=len(cases),frames=sum(len(c['frames']) for c in cases),native_addresses=proof['native_addresses'],queries=sum(len(f['source_queries']) for c in cases for f in c['frames']))))
