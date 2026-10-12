from pathlib import Path
import json,datetime
r=Path('E:/OpenLeague')
prefix=(r/'tools/probe_native_simple_cycle.py').read_text(encoding='utf-8').split('frames=[]')[0]
exec(compile(prefix,'native setup','exec'))
write32(system+0xe8,metadata);matrix_arg=heap+0x1e000;position_arg=heap+0x1e080
cases=[]
for extent in [0.,.25,500.]:
 for position in [[0.,0.,0.],[100.,200.,300.],[-99.5,27.25,640.125],[10800.,500.,8300.]]:
  for matrix in [identity,yaw90]:
   supplied=list(matrix);supplied[12:15]=[123.,456.,789.]
   for i,x in enumerate(supplied):f(matrix_arg+4*i,x)
   for i,x in enumerate(position):f(position_arg+4*i,x)
   f(metadata+0x138,extent)
   for entry,arg in [(0x921f20,matrix_arg),(0x921f60,position_arg)]:
    write32(sp,end);write32(sp+4,arg);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,system)
    u.emu_start(entry,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
   cases.append(dict(extent=extent,position=position,input_matrix=supplied,system_position=floats(system+0x90,3),system_orientation=floats(system+0xf0,16),bounds=floats(system+0x130,6)))
# Drive the already-qualified full Simple frame routine using original owner pose setters.
frames=[];f(metadata+0x138,500.)
for age in [0.,.125,.25,.5,1.,1.5,1.999,2.,2.125]:
 for i,x in enumerate(identity if age<.5 else yaw90):f(matrix_arg+4*i,x)
 for i,x in enumerate([100.+age*100.,200.,300.]):f(position_arg+4*i,x)
 for entry,arg in [(0x921f20,matrix_arg),(0x921f60,position_arg)]:
  write32(sp,end);write32(sp+4,arg);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,system);u.emu_start(entry,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
 write32(sp,end);f(sp+4,10.+age);f(sp+8,.125);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,instance);u.emu_start(0x9437e0,end,count=200000);assert u.reg_read(UC_X86_REG_EIP)==end
 n=(read32(container+0xc)-read32(container+8))//4
 frames.append(dict(age=age,system_position=floats(system+0x90,3),system_orientation=floats(system+0xf0,16),position=floats(read32(container+0x2c),n*3),normalized_age=floats(read32(container+0x20),n),current_scale=floats(read32(container+0x44),n),current_rotation=floats(read32(container+0x5c),n),active_count=read32(container+0xa4),emitter_finished=u.mem_read(instance+8,1)[0]))
baseline=json.loads((r/'data/4.20/simple_cycle_contract.json').read_text())
for actual,expected in zip(frames,baseline['frames'],strict=True):
 for field in ['age','position','normalized_age','active_count','emitter_finished']:assert actual[field]==expected[field],field
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),native_sha256=digest,complete=False,passed=True,pose_entries=['0x921f20','0x921f60'],frame_entry='0x9437e0',original_instruction_addresses=len(visited),runtime_adapters=[],cases=cases,frames=frames,birth_calls=birth_calls,bounds_constants={hex(a):floats(a,1)[0] for a in [0x1138be0,0x1138df8]},limits=['Owner interface supplies explicit position/matrix and metadata extent; original setters and full Simple update execute.','Exact missile owner adapter, bone/animation provider and orientation-dependent projection size/angle remain to integrate and qualify.','No current normal Projected GPU activation claimed.'])
(r/'data/4.20/simple_owner_pose_contract.json').write_text(json.dumps(proof,indent=2)+'\n')
print(json.dumps({'pose_cases':len(cases),'native_frames':len(frames),'births':birth_calls,'constants':proof['bounds_constants'],'native_addresses':len(visited)}))
