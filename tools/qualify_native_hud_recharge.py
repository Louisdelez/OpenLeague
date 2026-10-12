from pathlib import Path
import json,struct,itertools,hashlib,datetime,shutil
exec(Path('E:/OpenLeague/tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0])
owner=vector+0x8000;frame=stack-0x2000;handle=vector+0xa000;iface=vector+0xa100;callback=vector+0xc000;duration_ptr=vector+0xb000
f=lambda a,x:u.mem_write(a,struct.pack('<f',x))
w(handle+0x20,iface);w(handle+0x24,123);w(iface,vt);w(vt+0x38,callback)
captured=[];visited=set()
def hook(uc,a,n,unused):
 if a==callback:
  sp=u.reg_read(UC_X86_REG_ESP);assert read(sp+4)==123
  captured.append(struct.unpack('<4f',u.mem_read(read(sp+8),16)));finish(0,8);return
 assert 0x7d7ffc<=a<0x7d8054 or 0x7d7e4f<=a<0x7d7ea8,hex(a)
 visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);u.reg_write(UC_X86_REG_MXCSR,0x1f80)
tau=struct.unpack('<f',u.mem_read(0x1138f8c,4))[0]
f32=lambda v:struct.unpack('<f',struct.pack('<f',v))[0]
cases=[]
for route,slot,remaining,total in itertools.product(['cooldown','ammo'],range(4),[0,1/30,.65,1,5,10,60,120],[1,10,60,120]):
 captured.clear();f(duration_ptr,total);w(frame-0x128,duration_ptr);w(frame-0x124,handle);w(frame-0xf8,handle);w(frame-0xec,struct.unpack('<I',struct.pack('<f',remaining))[0]);f(frame-0xe4,remaining);f(frame-0x14,total)
 for reg,value in [(UC_X86_REG_EBP,frame),(UC_X86_REG_ESP,stack),(UC_X86_REG_EDI,slot),(UC_X86_REG_EAX,duration_ptr)]:u.reg_write(reg,value)
 start,stop=(0x7d7ffc,0x7d8054) if route=='cooldown' else (0x7d7e4f,0x7d7ea8)
 u.emu_start(start,stop,count=150);assert len(captured)==1
 expected=f32(f32(f32(remaining)/f32(total))*tau)
 assert captured[0]==(expected,0.,0.,0.),(route,remaining,total,captured,expected)
 cases.append(dict(route=route,slot=slot,remaining=f32(remaining),total=f32(total),params=list(captured[0])))
source=json.loads((r/'data/4.20/native_hud_source_records_contract.json').read_text(encoding='utf-8'))
effects=[]
for c in source['cases']:
 if c['kind']!=2 or not c['accepted']:continue
 data=bytes.fromhex(c['output_hex']);name=data[:32].split(b'\0')[0].decode()
 if name in [f'SpellCooldownFX{i}' for i in range(4)]:effects.append(dict(name=name,path=c['path'],storage_hex=data.hex()))
assert len(effects)==4
deploy=p.parent/'DATA/Shaders/HLSL/UI';shader_dir=r/'data/4.20/shaders/UI';shader_dir.mkdir(parents=True,exist_ok=True)
shaders=[]
for name in ['Cooldown.ps_2_0','Cooldown.vs_2_0','CooldownLine.ps_2_0','CooldownLine.vs_2_0']:
 src=deploy/name;dest=shader_dir/name;shutil.copy2(src,dest);shaders.append(dict(name=name,source=str(src),asset=str(dest.relative_to(r)).replace('\\','/'),sha256=hashlib.sha256(src.read_bytes()).hexdigest()))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),tau_bits=read(0x1138f8c),tau=tau,cooldown_slice=['0x7d7ffc','0x7d8054'],ammo_slice=['0x7d7e4f','0x7d7ea8'],case_count=len(cases),native_addresses=len(visited),cases=cases,source_effects=effects,shaders=shaders,limits=['Original SSE slices execute unchanged with finite supplied remaining/total values and a captured virtual parameter setter. Visibility, duration producers and timer interpolation are not executed here.','Values outside remaining<=total are intentionally retained: original division/multiplication does not clamp. Invalid totals are rejected by the Rust API, not claimed as original validation.','Source HLSL copied byte-for-byte; CPU shader port can be compared with source math. Compiled shader bytecode equivalence, native render states/geometry, GPU transport and full framebuffer identity remain open.','No gameplay, complete HUD or champion completion claim.'])
(r/'data/4.20/native_hud_recharge_contract.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
shutil.copy2(Path('E:/mapslol3v3/inspect_native_hud_recharge.py'),r/'tools/inspect_native_hud_recharge.py')
print(json.dumps(dict(passed=True,cases=len(cases),source_effects=len(effects),shaders=len(shaders),tau=tau)))
