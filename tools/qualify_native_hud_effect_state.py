from pathlib import Path
import struct,json,itertools,datetime,hashlib,shutil
exec(Path('E:/OpenLeague/tools/qualify_native_hud_icon_state.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0])
def hook(uc,a,n,unused):
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==0xc975f5:finish(0);return
 if a==render_callback:
  assert read(sp+4)==device;events.append(dict(state=read(sp+8),value=read(sp+12)));finish(0,12);return
 assert 0x99f3a0<=a<=0x99f645 or 0x9abc90<=a<0x9abee0 or 0x9abee0<=a<=0x9ac085,hex(a)
 visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);w(0x2d79078,manager);w(manager+0x14,device);w(device,vtbl);w(vtbl+0xe4,render_callback);w(0x2d794b0,device);u.mem_write(0x2d79470,b'\0')
cases=[]
for old,mode in itertools.product([0,1,2,3],[0,1,2,3,0xffffffff]):
 events.clear();u.mem_write(renderer,b'\0'*0x500);w(renderer+0x430,2);w(renderer+0x434,2);w(renderer+0x438,old);w(renderer+0x43c,mode);w(renderer+0x4d0,88);w(renderer+0x4d4,88);w(renderer+0x4c8,0xffffffff);w(renderer+0x4cc,0xffffffff);w(0x123ff20,0x8000000 if old&1 else 0)
 w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,renderer);u.emu_start(0x99f3a0,end,count=800)
 expected=[dict(state=27,value=mode&1)] if (old&1)!=(mode&1) else []
 assert events==expected and read(renderer+0x438)==mode and read(renderer+0x430)==2 and read(0x123ff20)==(0x8000000 if mode&1 else 0)
 cases.append(dict(old_mode=old,mode=mode,events=list(events),final_flags=read(0x123ff20)))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entry='0x99f3a0',case_count=len(cases),cases=cases,findings=['Original packet setup for kind2 preserves cached target/matrix/tint/declaration then enables/disables D3D9 alpha blend state27 from modebit1 only; cache hit produces no state call.','Effect producer always mode1. Previously qualified reset99F170 sets RGB/alpha factors ONE/INVSRCALPHA, ADD and separate-alpha enabled; effect packet does not change factors.'],limits=['Supplied equal zero matrices and cached target/tint/declaration bypass their upload branches, not qualified in this harness. Alpha helpers and their original state cache execute. D3D state captured, no device draw. Stack cookieC975F5 is an adapted boundary, not executed original validation.','Projection matrices, gamma, samplers, viewport and native line rasterizer/full framebuffer remain open.'])
(r/'data/4.20/native_hud_effect_state_contract.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(passed=True,state_cases=len(cases))))
