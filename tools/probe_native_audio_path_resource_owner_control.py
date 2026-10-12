from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
owner=vector+0x4000;resource=vector+0x5000;point=vector+0xa000;descriptor=vector+0xb000;auxiliary=vector+0xc000;calls=[];freed=[];allocations=[];visited=set();vtable=vector+0x10000;notify=vector+0x11000
def hook(uc,a,size,data):
 if a==notify:
  sp=u.reg_read(UC_X86_REG_ESP);calls.append({'kind':'property_notification','receiver':u.reg_read(UC_X86_REG_ECX),'arguments':[read(sp+4+i*4)for i in range(4)],'owner_at_call':bytes(u.mem_read(owner,96)).hex()});finish(1,16);return
 if a==0xada670:
  sp=u.reg_read(UC_X86_REG_ESP);pool,size=read(sp+4),read(sp+8);assert pool==17 and size==72;ref=0 if failure else resource;calls.append({'kind':'allocate','pool':pool,'bytes':size,'reference':ref})
  if ref:u.mem_write(ref,bytes([pattern])*72);allocations.append({'reference':ref,'size':72})
  finish(ref);return
 if a==0xada3e0:
  sp=u.reg_read(UC_X86_REG_ESP);pool,ref=read(sp+4),read(sp+8);assert pool==17 and ref not in freed and ref in [resource,point,descriptor,auxiliary];freed.append(ref);calls.append({'kind':'free','pool':pool,'reference':ref,'owner_at_call':bytes(u.mem_read(owner,96)).hex(),'resource_at_call':bytes(u.mem_read(resource,72)).hex()});finish(1);return
 assert 0xaf0640<=a<0xaf069f or 0xb1b0f0<=a<0xb1b173 or 0xaf22a0<=a<0xaf234a or 0xb1b1f0<=a<0xb1b212 or 0xb1b430<=a<0xb1b47d or 0xaefde0<=a<0xaefe01 or 0xb1b180<=a<0xb1b1ba,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[]
for pattern,present,enable,skip,first,second,failure in itertools.product([0,0xa5],[False,True],[0,1],[0,1],[0,3],[0,2],[False,True]):
 has_aux=False;blocks='none'
 calls.clear();freed.clear();allocations.clear();u.mem_write(owner,bytes([pattern])*96);w(owner,vtable);w(vtable+0x118,notify);w(owner+68,resource if present else 0);u.mem_write(resource,bytes([pattern])*72);w(resource,0xff0d28);w(resource+60,0);w(resource+64,0);w(resource+68,auxiliary if has_aux else 0);w(resource+40,point if blocks in ['point','both']else 0);w(resource+44,3);w(resource+48,descriptor if blocks in ['descriptor','both']else 0);w(resource+52,2);w(0x12100dc,17)
 for i,v in enumerate([0x3f800000,0,0xbf800000]):w(0x121026c+i*4,v)
 if present:
  allocations.append({'reference':resource,'size':72})
  for ref,size,enabled in [(point,48,blocks in ['point','both']),(descriptor,32,blocks in ['descriptor','both']),(auxiliary,16,has_aux)]:
   if enabled:u.mem_write(ref,bytes([0x33])*size);allocations.append({'reference':ref,'size':size})
 def snap():return {'owner':bytes(u.mem_read(owner,96)).hex(),'resource':bytes(u.mem_read(resource,72)).hex(),'allocations':[{**v,'raw':bytes(u.mem_read(v['reference'],v['size'])).hex(),'freed':v['reference']in freed}for v in allocations]}
 before=snap();w(stack,end)
 for i,v in enumerate([enable,skip,first,second]):w(stack+4+i*4,v)
 u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,owner);u.emu_start(0xaf22a0,end,count=3000);assert u.reg_read(UC_X86_REG_EIP)==end
 rows.append({'enable':enable,'skip_notification':skip,'first':first,'second':second,'failure':failure,'pattern':pattern,'present':present,'has_aux':has_aux,'blocks':blocks,'before':before,'after':snap(),'calls':list(calls),'freed':list(freed)})
proof={'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0xaf22a0','counts':{'enable':sum(c['enable']==1 for c in rows),'disable':sum(c['enable']==0 for c in rows)},'case_count':len(rows),'cases':rows,'native_addresses':len(visited),'limits':['Actual AF22A0 enable/disable and real acquisition AF0640/B1B0F0 execute. Property virtual notification is mandatory controlled capture of exact receiver/arguments/owner bytes, not a qualified property implementation. Allocator/free are controlled transports; root auxiliary and word60 virtual reference are null. Property implementation and upstream producer/refcount/lifetime remain required.']}
(r/'data/4.20/audio_path_resource_owner_control_preparation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'native owner enable/disable/acquisition/property-notification control cases')
