from pathlib import Path
import json,struct,datetime,hashlib
exec(compile(Path('E:/mapslol3v3/probe_search_context_defaults.py').read_text(encoding='utf-8').split('\nproof=dict')[0],'native default context','exec'))
resource=0x40008400;u.mem_write(resource,bytes(32));write32(resource,0x10d62c8);invoke(0x5c7630,resource+8);write32(resource+8,u.reg_read(UC_X86_REG_EAX))
folders=[]
def directory_boundary(uc,a,size,user):
 if a in [0x905620,0x905810,0x905a00]:
  top=u.reg_read(UC_X86_REG_ESP)
  folders.append({'method':hex(a),'folder':native_string(u.reg_read(UC_X86_REG_ECX)),'pattern':native_string(u.reg_read(UC_X86_REG_EDX)),'table':hex(read32(top+4))})
  finish()
u.hook_add(unicorn.UC_HOOK_CODE,directory_boundary)
invoke(0x907930,resource)
assert len(folders)>10 and any(row['folder']=='DATA/Shaders/Texture' for row in folders),folders
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='0x907930',native_addresses=len(visited),folders=folders,default_fields=fields,limits=['Original global population orchestration, context tree cache creation, default-root concatenation and directory request order execute.','905620/905810/905A00 enumeration boundaries explicitly return empty directories while recording native folder/pattern/table arguments. File insertion and actual directory iteration are not executed in this probe.','Actual default context initialized through native906487branch; extracted deploy lacksToolsConfig.xml. Command-line/launch-directory overrides remain unqualified.','Recorded requests do not prove selected fog texture or populated table. Population from actual extracted directories and alias/order conflicts remains next work.'])
(r/'data/4.20/global_resource_folders_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(proof))
