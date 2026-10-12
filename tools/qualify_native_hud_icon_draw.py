from pathlib import Path
import itertools,struct,json,hashlib,datetime,shutil
exec(Path('E:/OpenLeague/tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0])
renderer=vector+0x6000; packet=vector+0x7000; texture=vector+0x8000; manager=vector+0x9000; device=vector+0xa000; vtable=vector+0xb000
callbacks={vector+0xc000+n:(offset,args) for n,(offset,args) in enumerate([(0x84,4),(0x90,4),(0x3c,16),(0x50,4),(0x20,24)])}
calls=[]
def hook_draw(uc,address,length,data):
    if address==0x99f3a0:
        calls.append({'kind':'state_setup_boundary','packet_kind':read(renderer+0x434),'mode':read(renderer+0x43c),'declaration':read(renderer+0x4d4)});finish(0);return
    if address==0x983cb0:
        sp=u.reg_read(UC_X86_REG_ESP);calls.append({'kind':'texture_boundary','handle':read(sp+4),'slot':read(sp+8)});finish(0,8);return
    if address in callbacks:
        offset,args=callbacks[address];sp=u.reg_read(UC_X86_REG_ESP);calls.append({'kind':hex(offset),'args':[read(sp+4+n) for n in range(0,args,4)]});finish(0,args);return
    assert 0x99f710<=address<=0x99f842,hex(address);visited.add(address)
u.hook_add(unicorn.UC_HOOK_CODE,hook_draw)
w(0x2d79078,manager);w(manager+0x14,device);w(device,vtable)
for address,(offset,args) in callbacks.items():w(vtable+offset,address)
cases=[]
for primitives,texture_present,ready,packet_flags,mode in itertools.product([0,2],[False,True],[False,True],[0,2,4,6],[0,1,2,3]):
    u.mem_write(renderer,bytes(0x500));u.mem_write(packet,bytes(0x30));u.mem_write(texture,bytes(0x38));calls=[]
    handles={0x2c:101,0xac:201,0x12c:202,0x1ac:203,0x22c:204}
    for off,value in handles.items():w(renderer+off,value)
    w(renderer+0x20,88);w(packet+0x2c,primitives);w(packet+0x28,4);w(packet+4,packet_flags);w(packet+0x18,mode)
    w(packet+0x1c,texture if texture_present else 0);w(texture+0x20,77 if ready else 0);w(packet+0x20,301);w(packet+0x24,302)
    w(stack,end);w(stack+4,packet);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,renderer);u.emu_start(0x99f710,end,count=500);assert u.reg_read(UC_X86_REG_EIP)==end
    skipped=primitives==0 or texture_present and not ready
    expected=[]
    if not skipped:
        if texture_present:expected.append(dict(kind='texture_boundary',handle=77,slot=0))
        expected.append(dict(kind='state_setup_boundary',packet_kind=1,mode=mode,declaration=88))
        expected.append(dict(kind='0x84',args=[101]))
        ps=204 if packet_flags&4 else (201 if mode&1 else 202) if texture_present else 203
        expected.extend([dict(kind='0x90',args=[ps]),dict(kind='0x3c',args=[0,301,0,24]),dict(kind='0x50',args=[302]),dict(kind='0x20',args=[0,0,0,4,0,primitives])])
    assert calls==expected,(primitives,texture_present,ready,packet_flags,mode,calls,expected)
    cases.append(dict(primitives=primitives,texture_present=texture_present,texture_ready=ready,packet_flags=packet_flags,mode=mode,calls=calls))
native=Path(p);folder=native.parent/'DATA/Shaders/HLSL/UI';artifacts=[]
for src in sorted(folder.iterdir()):
    if not src.is_file():continue
    dest=r/'data/4.20/shaders/UI'/src.name;dest.parent.mkdir(parents=True,exist_ok=True)
    if dest.exists():assert dest.read_bytes()==src.read_bytes()
    else:shutil.copy2(src,dest)
    artifacts.append(dict(source=str(src),archive=str(dest.relative_to(r)),sha256=hashlib.sha256(src.read_bytes()).hexdigest()))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entry='0x99f710',case_count=len(cases),native_addresses=len(visited),cases=cases,shader_artifacts=artifacts,static_constructor_links={'UI_Alpha.ps_2_0':'99EDA6 receiver+0xA8; renderer shader+0xAC','UI_Opaque.ps_2_0':'99EDE8 receiver+0x128; renderer shader+0x12C','UI_Clear.ps_2_0':'99EE2A receiver+0x1A8; renderer shader+0x1AC','UI_Blit.ps_2_0':'99EE6C receiver+0x228; renderer shader+0x22C'},runtime_adapters=['99F3A0 state/projection setup captured as a boundary; not executed here.','983CB0 texture binding and graphics virtual calls captured; no real device/GPU.','Shader handles, declaration, VB/IB and prepared texture supplied by caller.'],limits=['Native packet guards, shader branch selection and ordered graphics calls qualified only.','Constructor linkage is static discovery; native shader creation/compiler macros, blend/sampler/gamma and projection remain unqualified.','Does not prove final framebuffer or integrated ordinary Icon HUD.'])
(r/'data/4.20/native_hud_icon_draw_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(case_count=len(cases),native_addresses=len(visited),source_shader_files=len(artifacts))))
