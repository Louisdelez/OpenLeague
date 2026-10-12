from pathlib import Path
import json,struct,datetime,hashlib
setup=Path('E:/mapslol3v3/probe_recursive_resource_files.py').read_text(encoding='utf-8').split('\ncases=[]')[0]
setup=setup.replace(';exec(compile(prefix',";prefix=prefix.replace('0x70100000','0x72000000').replace('u.mem_map(0x70000000,0x100000)','u.mem_map(0x70000000,0x2000000)');exec(compile(prefix")
exec(compile(setup,'native recursive collector prerequisites','exec'))
paths=sorted(p for p in (source/'DATA/Shared').rglob('*') if p.is_file())
rows=[{'name':p.name,'folder':str(p.parent.relative_to(source)).replace('\\','/')} for p in paths]
allocation_cursor=0x70000000;u.mem_write(mapping,bytes(16));invoke(0x6542a0,mapping);write32(mapping,u.reg_read(UC_X86_REG_EAX));sso(folder,'DATA/Shared',0x40009000);sso(pattern,'*',0x40009200)
write32(sp,end);write32(sp+4,mapping);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,folder);u.reg_write(UC_X86_REG_EDX,pattern)
u.emu_start(0x905810,end,count=20000000);assert u.reg_read(UC_X86_REG_EIP)==end
head=read32(mapping);entries={}
def walk(node):
 if node==head:return
 walk(read32(node));entries[string(node+0x10)]=string(node+0x28);walk(read32(node+8))
walk(read32(head+4))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='0x905810',native_addresses=len(visited),iterator_rows=rows,entries=entries,sources=[{'path':str(p),'sha256':hashlib.sha256(p.read_bytes()).hexdigest()} for p in paths],limits=['All extracted Shared files supplied as sorted iterator rows; original recursive collector loop and original905090insertion execute for each.','8B4B30and virtual iterator accessors are explicit filesystem adapters. Native OS/archive enumeration order and iterator ownership/destruction unqualified.','Shared table is isolated; merging its ordered insertions with direct folders/level/character directories must be qualified separately. No production overlay selection or live GPU acceptance inferred.'])
(r/'data/4.20/shared_resource_catalog_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'files':len(rows),'entries':len(entries),'native_addresses':len(visited)}),flush=True)
