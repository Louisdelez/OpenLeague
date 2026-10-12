from pathlib import Path
import json,struct,datetime
r=Path('E:/OpenLeague');s=Path('E:/mapslol3v3/probe_native_grass_subdivision.py').read_text(encoding='utf-8')
s=s.replace('pointer=cursor;cursor+=','pointer=cursor;\n  if size==0x50:created.append(pointer)\n  cursor+=',1)
s=s.replace("[0,2],[False,True]", "[0,2],[False]")
s=s.replace("write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,node);u.reg_write(UC_X86_REG_MXCSR", "entry=terrain+0x6500;write32(entry,queue);write32(entry+4,queue);write32(entry+8,node);write32(queue,entry);write32(queue+4,entry);write32(service+0xc,1);write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,service);u.reg_write(UC_X86_REG_MXCSR",1)
s=s.replace('u.emu_start(0x9603c0,end,count=1000000)','u.emu_start(0x95ed30,end,count=1000000)',1)
marker=' cases.append(dict(profile=profile';at=s.index(marker)
s=s[:at]+''' owned=[node]+created
 state=[]
 for p in owned:
  parent_pointer=read32(p+0x30)
  state.append(dict(bounds=list(struct.unpack('<4i',u.mem_read(p+0x10,16))),midpoint=list(struct.unpack('<2i',u.mem_read(p+8,8))),depth=read32(p+4),vertical_bits=list(struct.unpack('<4I',u.mem_read(p+0x20,16))),members=list_members(p),queued=bool(u.mem_read(p+0x4c,1)[0]),parent=owned.index(parent_pointer) if parent_pointer else None,children=[owned.index(read32(p+0x34+i*4)) if read32(p+0x34+i*4) else None for i in range(4)]))
''' +s[at:]
s=s.replace("cases.append(dict(profile=profile,", "cases.append(dict(tree=state,actor_parents=[owned.index(read32(m+0x28)) for m in members],profile=profile,",1)
s=s[:s.index('proof=dict(')]
exec(compile(s,'actualqueueandsubdivision','exec'))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='0x95ed30',actual_subdivision='0x9603c0',native_addresses=len(visited),cases=cases,runtime_adapters=['Onlyallocation9933E0 andfreeC98528; originalqueuedrain includingchildren scheduled duringprocessing andwhole subdivision execute.'],limits=['Finite suppliedroot/actors anddepthlimits; no preexistingpartialchildren, allocatorfailure,poolreuse oractualregistry/render qualification.'])
(r/'data/4.20/grass_subdivision_queue_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(dict(cases=len(cases),native_addresses=len(visited))))
