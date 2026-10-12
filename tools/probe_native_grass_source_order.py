from pathlib import Path
import json,struct,hashlib,datetime
r=Path('E:/OpenLeague')
source=(r/'tools/probe_native_grass_mask_sources.py').read_text(encoding='utf-8').split('u.hook_add(')[0]
exec(compile(source,'collector setup','exec'))
actors=[arena+0x6000+i*0x300 for i in range(5)];wrappers=[arena+0x2000+i*0x20 for i in range(5)]
rectangles=[[10,20,30,40],[0,0,99,99],[1,2,3,4],[-1,-1,0,0],[50,70,20,10]]
for i,address in enumerate(actors):
 w(wrappers[i]+4,address);w(address,vt);u.mem_write(address+0xad,b'\1');w(address+0xb0,0x20 if i==1 else 0);u.mem_write(address+0xe0,b'\x40');u.mem_write(address+0x95,struct.pack('<6f',i,1.,2.,3.,4.,5.))
for slot,callback in [(0x74,arena+0x5000),(0x1e0,arena+0x5010),(0x90,arena+0x5020)]:w(vt+slot,callback)
projection_calls=[]
def multi_hook(uc,a,size,user):
 if a in [arena+0x5000,arena+0x5010,arena+0x5020]:
  index=actors.index(u.reg_read(UC_X86_REG_ECX));finish(result=0 if a==arena+0x5020 and index==2 else 1);return
 if a==0x744440:records.clear();finish(4);return
 if a==0x744460:
  pointer=read(u.reg_read(UC_X86_REG_ESP)+4);records.append(list(struct.unpack('<4i',u.mem_read(pointer,16))));finish(4);return
 if a==0x986510:
  index=actors.index(u.reg_read(UC_X86_REG_ECX)-0x95);destination=read(u.reg_read(UC_X86_REG_ESP)+4)
  assert read(u.reg_read(UC_X86_REG_ESP)+8)==0x3e99999a;projection_calls.append(index);u.mem_write(destination,struct.pack('<4i',*rectangles[index]));finish(result=destination);return
 if a==0xc975f5:finish(result=u.reg_read(UC_X86_REG_EAX));return
 visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,multi_hook)
cases=[]
for indices in [[],[0],[1,2],[3,4],[4,3,0],[0,0,3,3],[1,0,2,4,3],[4,3,2,1,0,4,0]]:
 for i,index in enumerate(indices):w(registry+i*4,wrappers[index])
 w(0x2d628e8,registry);w(0x2d628ec,registry+len(indices)*4);w(stack,end)
 u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,out);records=[];projection_calls=[]
 u.emu_start(0x73ad90,end,count=3000);assert u.reg_read(UC_X86_REG_EIP)==end
 eligible=[i for i in indices if i not in [1,2]];assert projection_calls==eligible and records==[rectangles[i] for i in eligible]
 cases.append(dict(registry_indices=indices,eligible_indices=eligible,rectangles=list(records)))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entry='0x73ad90',original_instruction_addresses=len(visited),margin_bits=0x3e99999a,actor_aabbs=[[float(i),1.,2.,3.,4.,5.] for i in range(5)],actor_rectangles=rectangles,cases=cases,runtime_adapters=['Originalcollectorloops/gateorder execute; virtualgates explicit, vectorclear/append recording boundaries.','Projectioncallbacksupplies distinctsignedrectangles peractor; sentinel/inverted rectangles andduplicates preserved.'],limits=['Actualregistry/eligibilitysemantic/AABB andcamera producers remainopen; projectioncallback notactualcamera.','Proves collectorordering/preservation, not normalsceneintegration.'])
(r/'data/4.20/grass_source_order_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(cases=len(cases),native_addresses=len(visited))))
