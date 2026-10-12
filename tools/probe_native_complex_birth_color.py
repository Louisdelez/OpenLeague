"""Compose original emitter-age, RGBA table-selection and birth-caller fragments."""
from pathlib import Path
import json,struct,datetime,shutil
r=Path('E:/OpenLeague');setup=(r/'tools/probe_native_color_consumers.py').read_text().split('\ncases=[];samples=[]')[0];exec(compile(setup,'color setup','exec'))
instance=heap+0xc000;config=heap+0xd000;owner=heap+0xe000;cases=[]
age_inputs=[struct.unpack('<I',struct.pack('<f',v))[0] for v in [-.1,0.,.25,.5,.99999,1.,1.1]]+[0x80000000,0x7fc00000,0x7f800000,0xff800000,0x7f7fffff,0xff7fffff]
for name,channels in profiles:
 bind(channels)
 for count in [1,3,16,256]:
  colors=[[f32(i*.1),f32(-i*.2),f32(i+.5),f32(.25-i*.01)] for i in range(count)]
  u.mem_write(table,struct.pack('<'+'f'*(count*4),*(v for rgba in colors for v in rgba)));write32(colorobj,table);write32(colorobj+4,table+count*16)
  for time_bits in age_inputs:
   seed_rng(42);initial=state();u.mem_write(instance,b'\0'*0x100);u.mem_write(config,b'\0'*0x584);u.mem_write(owner,b'\0'*0xb0);write32(instance+4,owner);write32(instance+8,config);write32(instance+0x7c,0x3f800000);write32(config+0x308,0x40000000);write32(config+0x30c,0x40400000);u.mem_write(config+0x164,bytes(u.mem_read(colorobj,32)))
   sp=stack+0x8000;write32(sp,end);write32(sp+4,time_bits);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,instance);u.emu_start(0x934860,0x9348e1,count=1000);assert u.reg_read(UC_X86_REG_EIP)==0x9348e1;normalized=u.reg_read(UC_X86_REG_XMM1)&0xffffffff;duration=read32(u.reg_read(UC_X86_REG_EAX));frame=u.reg_read(UC_X86_REG_EBP)
   u.reg_write(UC_X86_REG_ESI,config);u.emu_start(0x934fef,0x93504f,count=1000);assert u.reg_read(UC_X86_REG_EIP)==0x93504f
   selected=[read32(frame+offset) for offset in [-0x23c,-0x1f4,-0x1c8,-0x1d0]]
   u.emu_start(0x9357d3,0x935810,count=100000);assert u.reg_read(UC_X86_REG_EIP)==0x935810
   cases.append({'name':name,'channels':channels,'colors':colors,'time_bits':hex(time_bits),'config_308_bits':'0x40000000','config_30c_bits':'0x40400000','instance_7c_bits':'0x3f800000','owner_a8_bits':'0x0','offset_bits':'0x0','selected_duration_bits':hex(duration),'normalized_age_bits':hex(normalized),'selected_color_bits':[hex(v) for v in selected],'output_bits':[hex(v) for v in struct.unpack('<4I',bytes(u.mem_read(frame-0x2a4,16)))],'seed':42,'initial_rng':initial,'rng':state()})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'fragments':[['0x934860','0x9348e1'],['0x934fef','0x93504f'],['0x9357d3','0x935810']],'cases':cases,'adapters':['Legal instance/config/owner/table/probability fixtures supplied. Original age producer, original Complex RGBA table selection, original caller arguments and full birth multiplier helper/RNG execute. ESI restored to the configuration supplied to the table-selection fragment.'],'limits':['Fragments composed, not the entire birth function: intervening non-color field evaluation and mutations excluded. Full global RNG call order for other fields remains unqualified.','e-period/e-active native names statically identified at config308/30C; actual decoded-field defaults and instance lifetime producer remain to qualify.','No full per-particle age/color update or ordinary graphical renderer integration.']}
(r/'data/4.20/complex_birth_color_contract.json').write_text(json.dumps(proof,indent=2)+'\n')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'cases':len(cases),'passed':True}))
