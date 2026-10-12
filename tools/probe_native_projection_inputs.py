from pathlib import Path
import json,datetime
r=Path('E:/OpenLeague')
prefix=(r/'tools/probe_native_simple_cycle.py').read_text(encoding='utf-8').split('frames=[]')[0]
exec(compile(prefix,'native setup','exec'))
bp=stack+0x6000
def run(start,stop):
 u.reg_write(UC_X86_REG_EBP,bp)
 u.reg_write(UC_X86_REG_ESP,sp)
 u.emu_start(start,stop,count=10000)
 assert u.reg_read(UC_X86_REG_EIP)==stop
cases=[]
for scale in [.25,500.,123.456]:
 for emitter,c0,bc in [(1.,1.,1.),(2.,.5,3.),(.75,1.25,.5)]:
  for bias in [[1.,1.],[2.,.5]]:
   for angle in [0.,90.]:
    f(system+0xc0,c0);f(system+0xbc,bc)
    u.reg_write(UC_X86_REG_EBX,system);run(0x931235,0x93124a)
    f(read32(container+0x44),scale);f(read32(container+0x5c),angle)
    for i,x in enumerate([100.,200.,300.]):f(read32(container+0x2c)+4*i,x)
    u.reg_write(UC_X86_REG_ECX,container);u.reg_write(UC_X86_REG_EBX,0);u.reg_write(UC_X86_REG_EDI,0)
    u.reg_write(UC_X86_REG_XMM1,int.from_bytes(struct.pack('<f',emitter),'little'))
    write32(bp-0x48,7);run(0x9312bd,0x931306)
    write32(bp-0x18,definition)
    f(definition+0x1d4,bias[0]);f(definition+0x1d8,bias[1]);run(0x931354,0x931389)
    cases.append(dict(particle_scale=floats(read32(container+0x44),1)[0],emitter_scale=emitter,system_c0=c0,system_bc=bc,bias=bias,angle=angle,combined_system_scale=floats(bp-0x54,1)[0],particle_emitter_scale=floats(bp-0x34,1)[0],render_angle=floats(bp-0x30,1)[0],half_size=floats(bp-0x64,2),position=floats(read32(bp-0x14),3)))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),native_sha256=digest,passed=True,complete=False,ranges=[['0x931235','0x93124a'],['0x9312bd','0x931306'],['0x931354','0x931389']],runtime_adapters=[],original_instruction_addresses=len(visited),cases=cases,limits=['Executes original render-input arithmetic segments only; bypasses D3D calls and traversal.','Factors supplied explicitly; system C0/BC producer and runtime owner binding remain unqualified.','No complete native renderer or current GPU fidelity claimed.'])
(r/'data/4.20/projected_inputs_contract.json').write_text(json.dumps(proof,indent=2)+'\n')
print(json.dumps(dict(cases=len(cases),native_addresses=len(visited))))
