from pathlib import Path
import json,struct,itertools,datetime
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_fow_source_release.py').read_text().split('\ncases=[]')[0],'release prerequisites','exec'))
player=0x40008000;context=0x40009000;camera_root=0x4000a000;camera=0x4000b000;pending_storage=0x40006000
captures=[];generated=[];adapters=[]
def pending_state():
 return [dict(identity=next(i for i,(obj,_) in enumerate(sources) if obj==read32(a)),priority_bits=read32(a+4)) for a in range(read32(view+0x3c),read32(view+0x40),8)]
def scheduling_boundaries(uc,a,size,user):
 if a==0x62b380:adapters.append('entity_lookup_absent');finish(eax=0)
 elif a==0x6b439b:adapters.append('spectator_false');u.reg_write(UC_X86_REG_EAX,0);u.reg_write(UC_X86_REG_EIP,0x6b439d)
 elif a==0x993d0f:adapters.append('clock_once_init');u.reg_write(UC_X86_REG_EIP,0x993d14)
 elif a==0x993d24:
  adapters.append('performance_counter');top=u.reg_read(UC_X86_REG_ESP);pointer=read32(top);u.mem_write(pointer,struct.pack('<q',ticks));u.reg_write(UC_X86_REG_ESP,top+4);u.reg_write(UC_X86_REG_EIP,0x993d2a)
 elif a==0x6b4526:captures.append(dict(pending=pending_state(),pending_flags=[bool(u.mem_read(obj+0x5c,1)[0]) for obj,_ in sources]))
 elif a==0x6b14e0:
  obj=u.reg_read(UC_X86_REG_ECX);generated.append(next(i for i,(source,_) in enumerate(sources) if source==obj));adapters.append('mask_generation_boundary');finish(16)
u.hook_add(unicorn.UC_HOOK_CODE,scheduling_boundaries)
cases=[]
for delta,previous_delta,force,dirty,applied,now,radius in itertools.product([.01,.033,.2,1.,2.,3.],[0.,.033,.2],[False,True],[False,True],[False,True],[4.999,5.001],[200.,2000.]):
 allocation_cursor=heap+0x19000;captures.clear();generated.clear();adapters.clear();sources=[];ticks=round(now*1000)
 for pointer,size in [(manager,64),(entries,32),(output,24),(view,0x100),(player,0x1000),(context,256),(camera_root,16),(camera,0x200)]:u.mem_write(pointer,bytes(size))
 write32(manager+4,entries);write32(manager+8,entries);write32(manager+0xc,entries+32)
 for address,value in [(0x2d77f48,player),(0x2d787b8,context),(0x2d798ac,manager),(0x2d78d24,camera_root),(0x2d7c06c,7),(0x2d7c074,0),(player+0x18,100),(camera_root,camera),(view+0x10,8),(view+0x14,counts),(view+0x18,pixels),(view+0x3c,pending_storage),(view+0x40,pending_storage),(view+0x44,pending_storage+64),(0x14bef50,1000),(0x14bef54,0),(0x14bef48,0),(0x14bef4c,0)]:write32(address,value)
 u.mem_write(0x2d7c078,bytes([1]));u.mem_write(view+0x1c,bytes([force]));f(view+0xc,15398.671875);f(view+0x4c,previous_delta);u.mem_write(counts,bytes(64));u.mem_write(pixels,bytes(64))
 for i,center in enumerate([[0.,0.],[1000.,0.],[10000.,10000.]]):
  invoke(0x6b1b20,manager,struct.pack('<5IfI5f',output+8*i,0,55+i,66,100,radius,0,128.,64.,0.,*center))
  obj=read32(output+8*i);control=read32(output+8*i+4);sources.append((obj,control));u.mem_write(obj+0x45,bytes([dirty]))
  bp=bits+i*0x100;u.mem_write(bp,struct.pack('<2I',0x55555555,0x55555555));write32(obj+0x40,bp)
  for off,val in [(0xc,1),(0x10,5),(0x14,2),(0x18,6)]:write32(obj+0x40+off,val)
  if applied:invoke(0x6b2d80,obj+0x40,struct.pack('<7I',8,pixels,view+0x14,1,5,2,6))
 invoke(0x6b3fa0,view,struct.pack('<f',delta))
 assert len(captures)==1 and all(read32(control+4)==1 for _,control in sources)
 assert len(generated)+len(pending_state())==len(captures[0]['pending'])
 cases.append(dict(delta=delta,previous_delta=previous_delta,force=force,dirty=dirty,initial_applied=applied,now=now,radius=radius,before_processing=captures[0],generated=list(generated),pending_after=pending_state(),pending_flags_after=[bool(u.mem_read(obj+0x5c,1)[0]) for obj,_ in sources],smoothed_delta_bits=read32(view+0x4c),adapters=sorted(set(adapters))))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='0x6b3fa0',native_addresses=len(visited-{0xc9f39b,0x9933e0,0xc98528,0x9941b0,0x994210,0xc975f5,0x62b380,0x6b439b,0x993d0f,0x993d24,0x6b14e0}),cases=cases,limits=['Original source enumeration, dirty/applied/pending gates, circle effective-radius getter, distance approximation, priority calculation, heap enqueue/pop and frame budget execute.','Entity lookup supplied absent, spectator query supplied false, QPC/clock initialization adapted, mask generation boundary records requests without generating/applying masks. All sources belong to local tag100; original view initialization and actual entities are not executed.','Allocator boundaries adapted; camera/world extent supplied. No live gameplay/GPU integration.'])
(r/'data/4.20/fow_frame_schedule_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(cases=len(cases),native_addresses=proof['native_addresses'],sample=cases[0])))
