"""Execute native92E130 math prefix and92DF10 bounds without replacing any math."""
from pathlib import Path
import sys,json,struct,itertools,datetime,hashlib
r=Path('E:/OpenLeague')
source=(r/'tools/qualify_native_audio_legacy_paths.py').read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','').replace('Path(__file__).resolve().parents[1]', "Path('E:/OpenLeague')")
exec(compile(source,'native setup','exec'))
visited=set();stopped=False
def hook(uc,a,size,user):
    global stopped
    visited.add(a)
    if a==0x92e2cd:
        stopped=True;u.emu_stop();return
    if a==0xc975f5:
        finish();return # Stack security cookie only; no mathematical replacement.
    assert (0x92e130<=a<0x92e2cd or 0x92df10<=a<0x92e127 or 0x8de400<=a<0x8e1000),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
center=heap+0x100;scale=heap+0x200
cases=[]
inputs=list(itertools.product([(0.,0.),(5100.,8700.),(-250.,9300.)],[(500.,500.),(120.,300.),(-100.,200.),(1.,1.)],[-360.,-90.,-45.,0.,30.,45.,90.,180.,360.]))
# Preserve original zero-scale arithmetic in bit form rather than inventing a clamp.
inputs += [((100.,200.),s,a) for s in [(0.,500.),(500.,0.),(0.,0.)] for a in [0.,45.]]
for xy,sc,angle in inputs:
    stopped=False
    u.mem_write(center,struct.pack('<2f',*xy));u.mem_write(scale,struct.pack('<2f',*sc))
    sp=stack+0x8000
    args=[end,heap+0x1000,heap+0x1100,heap+0x1200,0,center,scale,heap+0x1300,struct.unpack('<I',struct.pack('<f',angle))[0],0,0,0]
    u.mem_write(sp,struct.pack('<12I',*args));u.reg_write(UC_X86_REG_ESP,sp)
    u.emu_start(0x92e130,end,count=100000)
    assert stopped and u.reg_read(UC_X86_REG_EIP)==0x92e2cd
    bp=u.reg_read(UC_X86_REG_EBP)
    values={k:list(struct.unpack('<'+str(count)+'I',u.mem_read(bp+offset,count*4))) for k,offset,count in [('uv_matrix_bits',-0xa4,16),('rotation_matrix_bits',-0xe4,16),('world_bounds_bits',-0x20,4)]}
    cases.append({'center_xz':xy,'half_size_xz':sc,'angle_degrees':angle,**values})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'native_sha256':digest,'passed':True,'complete':False,'cases':cases,'unique_original_instruction_addresses':len(visited),'stop_address':'0x92e2cd','adapted_calls':['0xC975F5 stack-cookie check only'],'limits':['Native92E130 prefix executes original matrix constructors/multiplication/rotation/scale and original92DF10 bounds; no math adapters.','Stopped before native terrain/FOW state mutation92DDF0 and geometry submit. Entire92E130 is not qualified.','Caller scale/angle/lifetime/texture resolution and projected shader constant binding remain open. Zero scales retained as IEEE bit results, not accepted renderer inputs.','These are native world-to-UV matrices and footprint bounds, not a live rendered particle or full champion qualification.']}
(r/'data/4.20/particle_projection_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(f'Native particle projection math: {len(cases)} cases, {len(visited)} original instructions, no math replacement.')
