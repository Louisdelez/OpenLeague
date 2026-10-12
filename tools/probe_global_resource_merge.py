from pathlib import Path
import json,struct,datetime,hashlib
r=Path('E:/OpenLeague');prefix=(r/'tools/probe_fow_event_creation_generated.py').read_text(encoding='utf-8').split('\ncases=[]')[0]
prefix=prefix.replace('0x70100000','0x72000000').replace('u.mem_map(0x70000000,0x100000)','u.mem_map(0x70000000,0x2000000)');exec(compile(prefix,'native merge prerequisites','exec'))
base=json.loads((r/'data/4.20/global_resource_catalog_contract.json').read_text());shared=json.loads((r/'data/4.20/shared_resource_catalog_contract.json').read_text());requests=json.loads((r/'data/4.20/global_directory_requests_contract.json').read_text());assert base['passed'] and shared['passed'] and requests['passed']
u.mem_map(0x50000000,0x2000000);seed_cursor=0x50000100;head=0x50000000;provider=0x40008300;mapping=provider+8
u.mem_write(head,bytes(64));u.mem_write(head+0xc,b'\1\1');u.mem_write(provider,bytes(32));write32(provider,0x10d6380);write32(mapping,head);write32(mapping+4,len(base['entries']))
def allocate(amount):
 global seed_cursor
 result=seed_cursor;seed_cursor+=(amount+15)&~15;assert seed_cursor<0x52000000;return result
def sso(at,value,storage=None):
 b=value.encode('ascii');u.mem_write(at,bytes(24));write32(at+0x10,len(b))
 if len(b)<16:u.mem_write(at,b+b'\0');write32(at+0x14,15)
 else:
  pointer=allocate(len(b)+1) if storage is None else storage;write32(at,pointer);u.mem_write(pointer,b+b'\0');write32(at+0x14,len(b))
def string(at):
 return bytes(u.mem_read(read32(at) if read32(at+0x14)>=16 else at,read32(at+0x10))).decode('ascii')
items=sorted(base['entries'].items(),key=lambda item:item[0].lower());red_level=0;m=len(items)-1
while m>=0:red_level+=1;m=m//2-1
def tree(lo,hi,level,parent):
 if lo>hi:return head
 middle=(lo+hi)//2;node=allocate(64);u.mem_write(node,bytes(64));write32(node+4,parent);u.mem_write(node+0xc,bytes([0 if level==red_level else 1,0]));sso(node+0x10,items[middle][0]);sso(node+0x28,items[middle][1]);write32(node,tree(lo,middle-1,level+1,node));write32(node+8,tree(middle+1,hi,level+1,node));return node
root=tree(0,len(items)-1,0,head);write32(head+4,root)
def extreme(node,offset):
 while read32(node+offset)!=head:node=read32(node+offset)
 return node
write32(head,extreme(root,0));write32(head+8,extreme(root,8))
def validate(node,parent):
 if node==head:return 1,0
 assert read32(node+4)==parent
 color=u.mem_read(node+0xc,1)[0]
 if color==0:assert u.mem_read(read32(node)+0xc,1)[0]==1 and u.mem_read(read32(node+8)+0xc,1)[0]==1
 left,nl=validate(read32(node),node);right,nr=validate(read32(node+8),node);assert left==right
 return left+color,nl+nr+1
assert validate(root,head)[1]==len(items)
source=Path(json.loads((r/'docs/native_projection_discovery.json').read_text())['source']).parent
tail=list(shared['iterator_rows']);batches=[{'kind':'Shared','files':len(tail)}]
for request in requests['folders'][14:]:
 if request['method']!='0x905620':continue
 folderpath=source/request['folder'];paths=sorted(p for p in folderpath.iterdir() if p.is_file()) if folderpath.exists() else []
 tail.extend({'name':p.name,'folder':request['folder']} for p in paths)
 if paths:batches.append({'folder':request['folder'],'files':len(paths)})
allocation_cursor=0x70000000;folder=0x40008800;name=0x40008900
for index,row in enumerate(tail):
 sso(folder,row['folder'],0x40009000);sso(name,row['name'],0x40009400);write32(sp,end);write32(sp+4,mapping);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,folder);u.reg_write(UC_X86_REG_EDX,name)
 u.emu_start(0x905090,end,count=2000000);assert u.reg_read(UC_X86_REG_EIP)==end
 if index%250==0:print(json.dumps({'merged_files':index+1,'total':len(tail)}),flush=True)
assert validate(read32(head+4),head)[1]==read32(mapping+4)
entries={}
def walk(node):
 if node==head:return
 walk(read32(node));entries[string(node+0x10)]=string(node+0x28);walk(read32(node+8))
walk(read32(head+4));assert len(entries)==read32(mapping+4)
write32(0x2d8de80,1);u.mem_write(0x2d8de30,bytes(24));write32(0x2d8de44,15);query=0x40008a00;lookups=[]
for key in ['FOWTexture','DefaultFogOfWarOverlay.dds','defaultfogofwaroverlay.TGA']:
 sso(query,key,0x40009800);invoke(0x90a4a0,provider,struct.pack('<I',query));present=bool(u.reg_read(UC_X86_REG_EAX)&255);invoke(0x90a480,provider,struct.pack('<I',query));lookups.append({'key':key,'present':present,'resolved':string(u.reg_read(UC_X86_REG_EAX))})
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,native_addresses=len(visited),seed_contract_sha256=hashlib.sha256((r/'data/4.20/global_resource_catalog_contract.json').read_bytes()).hexdigest(),seed_entries=len(items),tail_rows=tail,batches=batches,entries=entries,lookups=lookups,limits=['Direct directory entries from complete original native insertion proof seeded as an explicit valid balanced red-black cache tree; native construction of seed tree not re-executed. Parent/color/black-height/count invariants checked before and after merge.','Original905090merge/tree insertion and basic provider queries execute for all1328Shared files and22level script files in original global request order. Shared/directory IO order uses qualified sorted extracted row adapters.','No original OS/archive iterator ordering/ownership, whole global constructor, launch overrides or live normal fog rendered acceptance proved. Default context profile and merged cached contents are explicit.'])
(r/'data/4.20/global_resource_merge_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'seed_entries':len(items),'merged_files':len(tail),'entries':len(entries),'lookups':lookups}),flush=True)
