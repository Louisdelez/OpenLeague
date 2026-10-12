from pathlib import Path
import struct,json,hashlib,datetime,shutil
exec(Path('E:/OpenLeague/tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0])
owner=vector+0x6000;frame=stack-0x1000;device=vector+0x7000;w(owner+0x14,device);events=[]
def hook(uc,a,n,unused):
 if a==0x9c54a0:
  sp=u.reg_read(UC_X86_REG_ESP);events.append(dict(d3d_primitive=u.reg_read(UC_X86_REG_EDX),device=u.reg_read(UC_X86_REG_ECX),args=[read(sp+4+i*4) for i in range(5)]));finish(0);return
 assert 0x9c2435<=a<0x9c2456,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
cases=[]
for descriptor in [[0,4,0,2,0],[4,3,6,2,3]]:
 minimum,vertices,index,primitives,kind=descriptor;events.clear()
 for i,v in enumerate([kind,0,minimum,vertices,index,primitives]):w(frame+8+i*4,v)
 for reg,v in [(UC_X86_REG_ESP,stack),(UC_X86_REG_EBP,frame),(UC_X86_REG_ESI,owner)]:u.reg_write(reg,v)
 u.emu_start(0x9c2435,0x9c2456,count=100);assert len(events)==1 and events[0]['device']==device and events[0]['args']==[0,minimum,vertices,index,primitives]
 cases.append(dict(descriptor=descriptor,**events[0]))
assert [c['d3d_primitive'] for c in cases]==[4,3],cases
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),slice=['0x9c2435','0x9c2456'],mapping_table='0x10e2b0c',cases=cases,findings=['Native descriptor0 maps to D3D9TRIANGLELIST4 for two basequad triangles; descriptor3 maps to D3D9LINESTRIP3 for two line segments through the three line vertices.','Trait is an indexed line strip, not a filled triangle. Original UI effect draw99F850 passes prepared source descriptors to this graphics interface.'],limits=['Prior graphics preparation9C22E0/debug branches bypassed; D3D wrapper captures primitive and arguments instead of executing a device draw.','Actual rasterizer line coverage, effect blend/render states and complete GPU framebuffer still unqualified.'])
(r/'data/4.20/native_hud_recharge_topology_contract.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(passed=True,d3d_primitives=[c['d3d_primitive'] for c in cases])))
