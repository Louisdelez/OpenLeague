"""Original92CB07 stopped-emitter drain plus actual93E4C0 handle cleanup."""
from pathlib import Path
import json,struct,itertools
r=Path(__file__).resolve().parents[1]
source=(r/'tools/qualify_native_audio_inactive_queue.py').read_text(encoding='utf-8').split('u.hook_add(unicorn.UC_HOOK_CODE,queue_hook)')[0]
exec(compile(source,'queue setup','exec'));base_hook=queue_hook
engine=heap+0x5000;active_vector=heap+0x4000;audio_table=heap+0x7000;release=end+0x100;notifications=[];current=0

def drain_hook(uc,a,size,user):
 global current
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==0x92cc0a:u.emu_stop();return
 if a==0x93e350:
  current=u.reg_read(UC_X86_REG_ECX);notifications.append({'destroy':current});u.reg_write(UC_X86_REG_EIP,0x93e4c0);return
 if a==release:
  assert u.reg_read(UC_X86_REG_ECX)==engine+4;notifications.append({'release':struct.unpack('<i',u.mem_read(sp+4,4))[0],'owner':current});finish(4);return
 if a==0xc98528:notifications.append({'free':read32(sp+4)});finish();return
 if a==0x6e3080:
  header=u.reg_read(UC_X86_REG_ECX);write32(header+4,read32(header));finish(4);return
 if 0x92cb07<=a<=0x92cc0a or 0x92cc30<=a<=0x92cc3a or 0x93e4c0<=a<=0x93e5ce:return
 base_hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,drain_hook);cases=[];identities=[0,actor,actor+0x400,actor+0x800]
for mask,rotation,duplicate_active in itertools.product(range(16),range(4),[False,True]):
 initial=[v for i,v in enumerate(identities) if mask&(1<<i)];active=[v for v in identities if v];active=sorted(active*(2 if duplicate_active else 1));records=[]
 write32(engine+4,audio_table);write32(audio_table+0x20,release);write32(0x14bef40,0)
 for i,v in enumerate(identities[1:]):
  u.mem_write(v,b'\0'*0x200);write32(v,engine);flag=[0,2,64,66][(rotation+i)%4];u.mem_write(v+0x1dc,bytes([flag]));handles=[[-1,0],[41,42],[100,-1]][i]
  for off,h in zip([0x1ac,0x1b0],handles):write32(v+off,h&0xffffffff)
  records.append({'identity':v,'flags':flag,'handles':handles})
 write32(engine+0xd0,vector);write32(engine+0xd4,vector+4*len(initial));write32(engine+0xd8,vector+256)
 for i,v in enumerate(initial):write32(vector+i*4,v)
 write32(engine+0xc4,active_vector);write32(engine+0xc8,active_vector+4*len(active))
 for i,v in enumerate(active):write32(active_vector+i*4,v)
 notifications=[];sp=stack+0x8000;write32(sp+0x14,engine);write32(sp+0x1c,engine+0xc4);write32(sp+0x20,0);u.reg_write(UC_X86_REG_ESP,sp);u.emu_start(0x92cb07,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==0x92cc0a
 expected=[];removed=[]
 for v in initial:
  if not v:continue
  rec=next(x for x in records if x['identity']==v)
  if rec['flags']&2:
   expected.append({'destroy':v});expected += [{'release':h,'owner':v} for h in rec['handles'] if h!=-1];expected.append({'free':v});removed.append(v)
 assert notifications==expected,(mask,rotation,duplicate_active,notifications,expected)
 queued=[read32(vector+i*4) for i in range((read32(engine+0xd4)-vector)//4)];left=[read32(active_vector+i*4) for i in range((read32(engine+0xc8)-active_vector)//4)]
 assert queued==[v for v in initial if v not in removed];assert left==[v for v in active if v not in removed]
 cases.append({'pending':initial,'active':active,'objects':records,'notifications':notifications[:],'pending_after':queued,'active_after':left})
proof={'native_sha256':digest,'passed':True,'cases':cases,'complete':False,'limits':['Actual92CB07..92CC00 and92CC30..3A fragment executed, boundary at92CC0A. Actual93E4C0 empty-child-vector cleanup releases both handles except-1.','93E350 destructor entry explicitly redirects to93E4C0; other effect detachment/member destructors excluded. Free/logical release/CRTmemmove/vector clear adapted.','Only finished bit1DC&2 qualifies removal; null and nonfinished entries retained. Pending order preserved; active equal-range removes all matching references.','Native enclosing update/timing that sets finished bit, nonempty child cleanup and full destructor/allocator ownership remain unqualified.']}
(r/'data/4.20/audio_emitter_drain_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(f'Original emitter drain {len(cases)} cases passed')
