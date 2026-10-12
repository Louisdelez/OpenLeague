from pathlib import Path
import json,struct,datetime
base=Path('E:/mapslol3v3/probe_search_context_defaults.py').read_text(encoding='utf-8').split('\nproof=dict')[0]
base=base.replace(';exec(compile(prefix',";prefix=prefix.replace('0x70100000','0x72000000').replace('u.mem_map(0x70000000,0x100000)','u.mem_map(0x70000000,0x2000000)');exec(compile(prefix")
exec(compile(base,'native context expanded allocator','exec'))
population=Path('E:/mapslol3v3/probe_global_resource_folders.py').read_text(encoding='utf-8').split('\nresource=',1)[1].split('\nproof=dict')[0]
population=population.replace('[0x905620,0x905810,0x905a00]','[0x905620,0x905810]').replace('invoke(0x907930,resource)','write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,resource);u.emu_start(0x907930,end,count=20000000);assert u.reg_read(UC_X86_REG_EIP)==end')
iterator=0x4000a000;vtable=0x4000a100;rows=[];index=0;directory_inputs=[]
for offset,address in [(0,0x901ed0),(4,0x901ee0),(8,0x901ef0),(0xc,0x901f00)]:write32(vtable+offset,address)
write32(iterator,vtable)
def cstr(at):
 out=bytearray()
 while True:
  b=u.mem_read(at+len(out),1)[0]
  if not b:return out.decode('ascii')
  out.append(b);assert len(out)<2048
def dir_boundary(uc,a,size,user):
 global rows,index
 if a==0x8b4830:
  request=cstr(u.reg_read(UC_X86_REG_EDX));root=request.rsplit('/',1)[0];paths=sorted((source/root).iterdir())
  rows=[{'name':p.name,'directory':p.is_dir()} for p in paths];index=0;directory_inputs.append({'root':root,'rows':rows})
  wrapper=u.reg_read(UC_X86_REG_ECX);write32(wrapper,iterator);write32(wrapper+4,0);finish(eax=wrapper)
 elif a==0x901ed0:finish(eax=int(index<len(rows)))
 elif a==0x901ee0:index+=1;finish()
 elif a==0x901ef0:u.mem_write(0x4000f000,rows[index]['name'].encode('ascii')+b'\0');finish(eax=0x4000f000)
 elif a==0x901f00:finish(eax=int(rows[index]['directory']))
u.hook_add(unicorn.UC_HOOK_CODE,dir_boundary)
exec(compile('resource='+population,'native full directory orchestration','exec'))
assert len(directory_inputs)==2 and any(row['folder']=='Levels/Map10/Scripts' for row in folders)
assert len(folders)==14+5+453
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,native_addresses=len(visited),folders=folders,directory_inputs=directory_inputs,limits=['Original global orchestration, directory collector905A00, tree iteration and derived Scripts/Items/Icons2D requests execute for actual extracted5Levels and453Characters directories.','8B4830/virtual iterator accessors adapt sorted extracted filenames and directory flags. Native archive directory order/iterator ownership unqualified.','File collectors905620/905810 return empty while recording native path/pattern/table arguments. Actual file insertion/Shared merge remains separate.'])
(r/'data/4.20/global_directory_requests_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'directory_requests':len(folders),'native_addresses':len(visited),'nonempty_direct_requests':sum(1 for row in folders if row['method']=='0x905620' and (source/row['folder']).exists() and any(p.is_file() for p in (source/row['folder']).iterdir()))}))
