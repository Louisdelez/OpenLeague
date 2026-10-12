from pathlib import Path
import itertools,json,hashlib,datetime,shutil
r=Path('E:/OpenLeague')
exec(compile((r/'tools/qualify_native_archive_index_lookup.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'native archive index prerequisites','exec'))
mount_archive=0x40015000;records=0x40016000;record_name=0x41020000;node=nodes;keyptr=0x41021000;decision=None
def mount_hook(uc,a,size,user):
 global decision
 if a in [0x8b7403,0x8b7478]:decision='insert_boundary' if a==0x8b7403 else 'overwrite';uc.emu_stop();return
 if 0x8b73d2<=a<0x8b7478:visited.add(a);return
 archive_hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,mount_hook);w(0x14ae870,0)
cases=[]
for existing,requested,count,ordinal in itertools.product([b'Textures/',b'HUD/defaults/Chat.ini'],[b'Textures/',b'textures/',b'HUD/defaults/CHAT.INI',b'NotFound'],[0,1,65535],[0,1,2]):
 decision=None;queries.clear();u.mem_write(provider,b'\0'*0x40);w(provider+4,0x40017000);w(provider+8,0x40017000+count*4);w(table,head);w(table+8,buckets);w(table+0x14,7);w(table+0x18,8)
 u.mem_write(keyptr,existing+b'\0');u.mem_write(record_name,requested+b'\0');w(node,head);w(node+4,head);w(node+8,keyptr);w(node+12,0x12345678);w(head,node);w(head+4,node)
 for i in range(8):w(buckets+i*8,head);w(buckets+i*8+4,head)
 bucket=hkey(existing)&7;w(buckets+bucket*8,node);w(buckets+bucket*8+4,node)
 w(mount_archive+0x108,records);w(records+ordinal*32+28,record_name);w(stack+0x24,ordinal)
 u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_EDI,provider);u.reg_write(UC_X86_REG_EBX,mount_archive);u.reg_write(UC_X86_REG_EDX,ordinal*32)
 u.emu_start(0x8b73d2,end,count=10000)
 matched=existing.lower()==requested.lower();assert decision==('overwrite' if matched else 'insert_boundary')
 expected=((count<<16)|ordinal) if matched else 0x12345678;assert read(node+12)==expected and cbytes(read(node+8))==existing
 cases.append(dict(existing=list(existing),requested=list(requested),archive_count=count,entry_ordinal=ordinal,matched=matched,decision=decision,packed_id_after=read(node+12),key_unchanged=True))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,entry='0x8b73d2..0x8b7478',case_count=len(cases),native_addresses=len(visited),native_sha256=hashlib.sha256(raw).hexdigest(),cases=cases,adapters=['Original mount-loop lookup, native hash/C-locale comparison and existing-node packed-ID assignment execute. Valid single-node bucket table and archive/record loop state supplied. Cookie adapted.','Missing-key branch stops before native insertion; full mount loop/alias registration/archive vector insertion not executed.'],limits=['Existing duplicate key keeps first stored spelling and receives latest archive/entry ID. Full insertion/rehash/alias index and process mount order remain open.','Valid16-bit archive/entry components only; overflow and oversized archive catalogs unqualified.'])
(r/'data/4.20/native_zip_duplicate_index_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(cases=len(cases),native_addresses=len(visited))))
