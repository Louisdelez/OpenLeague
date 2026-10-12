from pathlib import Path
import json,struct,datetime,hashlib
base=Path('E:/mapslol3v3/probe_search_context_defaults.py').read_text(encoding='utf-8').split('\nproof=dict')[0]
base=base.replace(';exec(compile(prefix',";prefix=prefix.replace('0x70100000','0x72000000').replace('u.mem_map(0x70000000,0x100000)','u.mem_map(0x70000000,0x2000000)');exec(compile(prefix")
exec(compile(base,'native default context expanded allocator','exec'))
population=Path('E:/mapslol3v3/probe_global_resource_folders.py').read_text(encoding='utf-8').split('\nresource=',1)[1].split('\nproof=dict')[0]
exec(compile('resource='+population,'native global folder orchestration','exec'))
table=next(int(row['table'],16) for row in folders if row['method']=='0x905620')
folder_string=0x40008800;file_string=0x40008900
def input_string(at,value,storage):
 b=value.encode('ascii');u.mem_write(at,bytes(24));write32(at+0x10,len(b))
 if len(b)<16:u.mem_write(at,b+b'\0');write32(at+0x14,15)
 else:write32(at,storage);u.mem_write(storage,b+b'\0');write32(at+0x14,len(b))
sources=[];batches=[]
for row in folders:
 if row['method']!='0x905620':continue
 folderpath=source/row['folder'];paths=sorted(p for p in folderpath.iterdir() if p.is_file()) if folderpath.exists() else []
 input_string(folder_string,row['folder'],0x40009000)
 for path in paths:
  input_string(file_string,path.name,0x40009400)
  write32(sp,end);write32(sp+4,table);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,folder_string);u.reg_write(UC_X86_REG_EDX,file_string)
  u.emu_start(0x905090,end,count=2000000);assert u.reg_read(UC_X86_REG_EIP)==end,str(path)
  sources.append(str(path.relative_to(source)).replace('\\','/'))
 batches.append({'folder':row['folder'],'files':len(paths)})
 print(json.dumps(batches[-1]),flush=True)
head=read32(table);entries={}
def walk(node):
 if node==head:return
 assert len(entries)<100000;walk(read32(node));entries[native_string(node+0x10)]=native_string(node+0x28);walk(read32(node+8))
walk(read32(head+4))
(r/'data/4.20/global_resource_population_checkpoint.json').write_text(json.dumps({'complete':False,'input_files':sources,'folder_batches':batches,'entries':entries,'native_addresses':len(visited)},indent=2)+'\n',encoding='utf-8')
query=0x40008a00;lookups=[]
write32(0x2d8de80,1);u.mem_write(0x2d8de30,bytes(24));write32(0x2d8de44,15);write32(0x2d8de60,1);u.mem_write(0x2d8de48,bytes(24));write32(0x2d8de5c,15)
for key in ['FOWTexture','DefaultFogOfWarOverlay.dds','defaultfogofwaroverlay.TGA']:
 input_string(query,key,0x40009800);invoke(0x904ec0,resource,struct.pack('<I',query));present=bool(u.reg_read(UC_X86_REG_EAX)&255)
 invoke(0x904cd0,resource,struct.pack('<I',query));resolved=native_string(u.reg_read(UC_X86_REG_EAX));lookups.append({'key':key,'present':present,'resolved':resolved})
assert lookups[0]['present']==False and lookups[1]['present']==True
assert lookups[1]['resolved']=='DATA/Shaders/Texture/DefaultFogOfWarOverlay.dds'
selected=source/lookups[1]['resolved'];assert selected.exists()
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,native_addresses=len(visited),default_context=fields,folder_batches=batches,input_files=sources,entries=entries,lookups=lookups,selected_source={'path':str(selected),'sha256':hashlib.sha256(selected.read_bytes()).hexdigest()},limits=['Original context constructor/global directory orchestration and original905090file parsing/alias/tree insertion execute on actual extracted direct-directory filenames; original derived search methods resolve resulting table.','Filename enumeration uses sorted extracted filesystem order; archive iteration and conflicting alias precedence in original order remain unqualified.','Shared recursive enumeration905810 and level/character directory enumeration905A00 still omitted. Full inherited table and production fog selection are not complete.','ToolsConfig.xml absent in supplied deploy; command-line and launch-directory overrides unqualified. Selected_source is qualified in this partial table only.'])
(r/'data/4.20/global_resource_catalog_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'files':len(sources),'entries':len(entries),'native_addresses':len(visited),'lookups':lookups}),flush=True)
