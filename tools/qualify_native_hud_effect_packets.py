from pathlib import Path
import struct,json,itertools,datetime,hashlib,shutil
exec(Path('E:/OpenLeague/tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0])
owner=vector+0x6000;element=vector+0x7000;packet=vector+0x8000;list_=vector+0x9000;elements=vector+0xa000
events=[]
def hook(uc,a,n,unused):
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==0x9aaa50:assert u.reg_read(UC_X86_REG_ECX)==owner+0xc0;finish(packet);return
 if a==0x5bdcb0:
  assert read(read(sp+4))==packet;count=(read(owner+0x5c)-list_)//4;w(list_+count*4,packet);w(owner+0x5c,list_+(count+1)*4);finish(0,4);return
 if a==0x9a8990:events.append(read(sp+4));finish(0,4);return
 assert 0x9a88b0<=a<=0x9a88ed or 0x9a88f0<=a<=0x9a898b,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
cases=[]
for flags,index,count,textures in itertools.product([0,1,0x101,0xffffffff],[0,3],[0,2],[False,True]):
 events.clear();u.mem_write(packet,b'\xa5'*0x80);w(owner+0x4c,elements);w(elements+index*4,element);w(owner+0x58,list_);w(owner+0x5c,list_+count*4);w(element+0x48,flags);w(element+0x200,1234);w(element+0x25c,5678 if textures else 0);w(element+0x260,9012 if textures else 0)
 w(stack,end);w(stack+4,index);w(stack+8,77);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,owner);u.emu_start(0x9a88f0,end,count=250)
 fields={hex(off):read(packet+off) for off in [0,4,8,0xc,0x10,0x14,0x18,0x1c,0x20,0x24,0x38,0x3c]}
 expected={0:2,4:2*(flags&1),8:count,0xc:index,0x10:77,0x14:owner,0x18:1,0x1c:1234,0x20:5678 if textures else 0,0x24:9012 if textures else 0,0x38:0,0x3c:0}
 assert fields=={hex(k):v for k,v in expected.items()} and events==[count]
 cases.append(dict(flags=flags,element_index=index,existing_packets=count,textures=textures,fields=fields))
updates=[]
for enabled,old in itertools.product([False,True],[0,2,4,6,0xffffffff]):
 events.clear();w(owner+0x58,list_);w(list_,packet);w(owner+0x4c,elements);w(elements,element);w(packet+0xc,0);w(packet+4,old);w(element+0x48,int(enabled));w(stack,end);w(stack+4,0);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,owner);u.emu_start(0x9a88b0,end,count=100)
 actual=read(packet+4);assert actual==((old|2) if enabled else (old&0xfffffffd)) and events==[0];updates.append(dict(enabled=enabled,old_flags=old,new_flags=actual))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entries=['0x9a88f0','0x9a88b0'],packet_cases=len(cases),visibility_cases=len(updates),cases=cases,visibility_updates=updates,findings=['Native Effect packets have kind2, enabled bit2 from source enabled bit1, blend mode1 unconditionally, source effect instance and two optional texture handles. Vertex/index buffers initially zero and geometry builder invoked for new/existing packets.','Visibility refresh only toggles packet bit2; other flags preserved. Geometry builder called even when disabled; draw dispatcher later filters enabled bit2.'],limits=['Pool allocation/vector append supplied/captured. Geometry builder9A8990 is a boundary; native cooldown geometry separately qualified. Native allocation/capacity/device creation not executed.','Packet blendmode1 establishes requested alpha-enable; render-state tail/reset qualified separately. Complete renderer/GPU framebuffer still open.'])
(r/'data/4.20/native_hud_effect_packets_contract.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name);shutil.copy2(Path('E:/mapslol3v3/inspect_effect_packet_producer.py'),r/'tools/inspect_effect_packet_producer.py')
print(json.dumps(dict(passed=True,packet_cases=len(cases),visibility_cases=len(updates))))
