from pathlib import Path
import json,struct,datetime,hashlib
r=Path('E:/OpenLeague');prefix=(r/'tools/probe_fow_event_creation_generated.py').read_text(encoding='utf-8').split('\ncases=[]')[0];exec(compile(prefix,'native prerequisites','exec'))
allocation_cursor=0x70000000
folder=0x40008000;filename=0x40008100;mapping=0x40008200;string_cursor=0x40009000
def sso(at,text):
 global string_cursor
 b=text.encode('ascii');u.mem_write(at,bytes(24));write32(at+0x10,len(b))
 if len(b)<16:u.mem_write(at,b+b'\0');write32(at+0x14,15)
 else:write32(at,string_cursor);u.mem_write(string_cursor,b+b'\0');string_cursor+=0x200;write32(at+0x14,len(b))
def string(at):
 ptr=read32(at) if read32(at+0x14)>=16 else at
 return bytes(u.mem_read(ptr,read32(at+0x10))).decode('ascii')
def populate(names):
 global allocation_cursor,string_cursor
 allocation_cursor=0x70000000;string_cursor=0x40009000;u.mem_write(mapping,bytes(16));invoke(0x6542a0,mapping);write32(mapping,u.reg_read(UC_X86_REG_EAX));sso(folder,'Levels/Map10')
 for name in names:
  sso(filename,name);write32(sp,end);write32(sp+4,mapping);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,folder);u.reg_write(UC_X86_REG_EDX,filename)
  u.emu_start(0x905090,end,count=2000000);assert u.reg_read(UC_X86_REG_EIP)==end,name
 head=read32(mapping);entries={}
 def walk(node):
  if node==head:return
  assert len(entries)<1000;walk(read32(node));entries[string(node+0x10)]=string(node+0x28);walk(read32(node+8))
 walk(read32(head+4));return entries
deploy=Path(json.loads((r/'docs/native_projection_discovery.json').read_text())['source']).parent
paths=sorted(p for p in (deploy/'LEVELS/Map10').iterdir() if p.is_file());names=[p.name for p in paths]
cases=[]
for label,files in [('map10-original-files',names),('diagnostic-extension-routing',['.','..','a.inibin','b.luaobj','c.scb','d.sco','e.dds','f.tga','g.gfx','h.swf','plain.dat'])]:
 output=populate(files);cases.append(dict(name=label,input_filenames=files,entries=output));print(json.dumps(dict(name=label,entries=output)),flush=True)
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,native_addresses=len(visited),entry='0x905090',tree_constructor='0x6542A0',cases=cases,sources=[dict(path=str(p),sha256=hashlib.sha256(p.read_bytes()).hexdigest()) for p in paths],limits=['Original file-to-resource insertion routine executes with native string parsing/alias handling and native tree insertion. Actual Map10 extracted root filenames supplied as file-enumeration adapter.','OS/archive enumeration, recursive directory traversal, inherited resource table and whole per-map constructor remain unqualified.','Allocator and free/stack cookie boundaries use established adapters; no file/string/tree lookup adapters.','Supplied sorted filesystem order is explicit; native archive enumeration precedence for conflicting aliases remains open.'])
(r/'data/4.20/map_resource_population_contract.json').write_text(json.dumps(proof,indent=2)+'\n');print(json.dumps(dict(cases=len(cases),map10_files=len(paths),native_addresses=len(visited))))
