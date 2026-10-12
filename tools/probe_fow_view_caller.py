from pathlib import Path
import json,struct,datetime,itertools
r=Path('E:/OpenLeague')
caller_prerequisites=(r/'tools/probe_fow_event_creation_generated.py').read_text(encoding='utf-8').split('\ncases=[]')[0]
exec(compile(caller_prerequisites,'native view caller prerequisites','exec'))
bounds_proof=json.loads((r/'data/4.20/fow_level_bounds_contract.json').read_text(encoding='utf-8'))
captured=[]
def capture_constructor(uc,a,size,user):
 if a==0x6b3b80:
  top=u.reg_read(UC_X86_REG_ESP);captured.append(dict(first_arg_bits=read32(top+4),extent_arg_bits=read32(top+8)))
u.hook_add(unicorn.UC_HOOK_CODE,capture_constructor)
cases=[]
for bounds_case,config,stack_pattern in itertools.product(bounds_proof['cases'],[0.25,2000.],[0,0xcccccccc]):
 allocation_cursor=0x70000000;allocations.clear();captured.clear()
 head=heap+0x18100;u.mem_write(manager,bytes(64));u.mem_write(head,bytes(64));u.mem_write(head+0xd,b'\x01')
 for off in [0,4,8]:write32(head+off,head)
 write32(manager+0x1c,head);write32(0x2d798ac,manager);write32(0x2d5f468,77)
 frame=sp+0x1000;u.mem_write(sp-0x1000,struct.pack('<I',stack_pattern)*0x1000)
 u.reg_write(UC_X86_REG_EBP,frame);u.reg_write(UC_X86_REG_ESP,sp);write32(frame-0x48,struct.unpack('<I',struct.pack('<f',config))[0])
 u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_FPSW,0)
 # Original FLD initializes the fixture x87 input normally returned by config reader.
 u.emu_start(0x6b348d,0x6b3490,count=10);assert u.reg_read(UC_X86_REG_EIP)==0x6b3490
 write32(0x2d6dd48,bounds_case['view_extent_bits'])
 u.emu_start(0x6b3462,0x6b349e,count=200000);assert u.reg_read(UC_X86_REG_EIP)==0x6b349e
 view_object=u.reg_read(UC_X86_REG_EAX);assert read32(frame-0x54)==view_object
 assert len(captured)==1 and captured[0]['extent_arg_bits']==bounds_case['view_extent_bits']
 assert read32(view_object+0xc)==bounds_case['view_extent_bits'];assert read32(view_object+0x10)==128
 config_bits=struct.unpack('<I',struct.pack('<f',config))[0];assert read32(frame-0x44)==config_bits
 event_node=read32(head+4);event_body=read32(event_node+0x14);event_list=read32(event_body+0xc)
 assert read32(manager+0x20)==1 and (read32(event_list+4)-read32(event_list))//20==1
 cases.append(dict(bounds_bits=bounds_case['bounds_bits'],config_bits=config_bits,stack_pattern=stack_pattern,**captured[0],extent_bits=read32(view_object+0xc),dimension=128,event_count=1,subscriber_count=1,counts_zero=not any(u.mem_read(read32(view_object+0x14),16384)),pixels_zero=not any(u.mem_read(read32(view_object+0x18),16384))))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='0x6b3462',stop='0x6b349e',constructor='0x6b3b80',native_addresses=len(visited-{0xc9f39b,0x9933e0,0xc98528,0x9941b0,0x994210,0xc975f5,0x66d282}),cases=cases,limits=['Original caller fragment reads native global extent, allocates view and passes X extent as second argument to original constructor. Original empty event creation and subscription execute.','Upstream config reader, resource lookup and whole6B3180 initialization are not executed. Fixture x87 config value supplied using original FLD instruction; extent global supplied from separately qualified bounds producer.','First argument retains supplied stack contents and is unused by constructor. Config value is stored separately atEBP-44 and does not become extent.','Native constructor accepts zero extent; Rust explicitly rejects invalid extent before live startup. No allocation failure, complete view activation or GPU fog qualification.','Allocator, mutex and InitializeCriticalSection boundaries adapted as documented by event-construction prerequisite.'])
(r/'data/4.20/fow_view_caller_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(cases=len(cases),native_addresses=proof['native_addresses'],sample=cases[0])))
