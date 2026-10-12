from pathlib import Path
import json,hashlib,datetime,itertools,shutil
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'texture creation prerequisites','exec'))
manager=vector+0x14000;query=vector+0x6000;resource=vector+0x7000;loader=vector+0x8000;descriptor=vector+0x9000;head=vector+0xa000;loader_head=vector+0xb000;cell=vector+0xc000;loader_cell=cell+4;calls=[]
def hook(uc,address,size,user):
 sp=uc.reg_read(UC_X86_REG_ESP);ecx=uc.reg_read(UC_X86_REG_ECX)
 if address==0x9a9ee0:calls.append('texture_pool');finish(resource);return
 if address==0x9a9dc0:calls.append('descriptor_pool');finish(descriptor);return
 if address==0x5bd9b0:
  calls.append('insert_texture' if ecx==manager+8 else 'insert_descriptor');finish(cell if ecx==manager+8 else loader_cell,4);return
 visited.add(address)
u.hook_add(unicorn.UC_HOOK_CODE,hook);w(0x14ae664,0);w(0x1222f40,0)
names=[n.encode() for n in json.loads((r/'data/4.20/native_hud_texture_cache_contract.json').read_text())['source_texture_names']]+[b'',b'x'*31,b'aq',b'ba'];cases=[]
for name,prefill in itertools.product(names,[0,0xa5]):
 calls.clear();u.mem_write(manager,b'\0'*0x100);u.mem_write(loader,b'\0'*0x100)
 for ptr in [head,loader_head]:u.mem_write(ptr,b'\0'*0x40);u.mem_write(ptr+0xd,b'\1');w(ptr+4,ptr)
 w(manager+8,head);w(manager+4,loader);w(loader,loader_head)
 u.mem_write(resource,bytes([prefill])*0x38);u.mem_write(descriptor,bytes([prefill])*0x2c);u.mem_write(query,name+b'\0');w(stack,end);w(stack+4,query);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,manager);u.emu_start(0x99e040,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
 assert u.reg_read(UC_X86_REG_EAX)==resource and read(cell)==resource and read(loader_cell)==descriptor
 assert read(resource+0x20)==0 and read(resource+0x34)&255==0
 assert read(descriptor+0x20)==manager and read(descriptor+0x24)==resource and read(descriptor+0x28)==0
 assert calls==['texture_pool','insert_texture','descriptor_pool','insert_descriptor'],calls
 cases.append(dict(name_hex=name.hex(),prefill=prefill,texture_hex=bytes(u.mem_read(resource,0x38)).hex(),descriptor_name_hex=bytes(u.mem_read(descriptor,32)).hex(),descriptor_default_pointer=read(descriptor+0x20),calls=list(calls)))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),case_count=len(cases),native_addresses=len(visited),cases=cases,limits=['Original99E040missing branch and9A6250descriptor creation execute including native hash/stringcopy/field initialization and association.','Pool allocations and ordered-tree insertion supplied with zero/A5storage and empty trees; allocator/tree lifecycle not qualified.','Descriptor name/default pointer field20 is overwritten by texture manager association; no GPU loading/rendering or post-load event qualified.'])
(r/'data/4.20/native_hud_texture_creation_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name);print(json.dumps(dict(passed=True,cases=len(cases),native_addresses=len(visited))))
