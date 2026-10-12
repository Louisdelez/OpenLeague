from pathlib import Path
import json,struct,hashlib,datetime,re,zipfile
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_hud_formatted_scanner.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'HUD source record prerequisites','exec'))
owner=vector+0x6000;cursor=vector+0xe000;prop_node=vector+0xf000;sentinel=vector+0xf100;named_registry=vector+0xf200;named_node=vector+0xf300;all_list=vector+0x17000;effect_list=vector+0x18000;kind_ptr=vector+0xe100;name_ptr=vector+0xe200
u.mem_map(0x50000000,0x100000);source_ptr=0x50000000;current_kind=0;warnings=0;events=[]
registry=json.loads((r/'data/4.20/native_hud_property_registry_contract.json').read_text(encoding='utf-8'));callbacks={v['name'].encode('ascii'):int(v['callback'],16) for v in registry['registrations']}
def source_hook(uc,a,size,user):
 global warnings
 sp=uc.reg_read(UC_X86_REG_ESP)
 if a in [0x9aa4d0,0x9aa6f0,0x9aa5e0]:assert a=={1:0x9aa4d0,2:0x9aa6f0,3:0x9aa5e0}[current_kind];finish(obj);return
 if a==0x9a6250:finish(named_node,4);return
 if a==0x564c20:
  target=uc.reg_read(UC_X86_REG_ECX);ptr=read(sp+4);length=read(sp+8);assert length<=1023;u.mem_write(target,b'\0'*24)
  if length<16:u.mem_write(target,bytes(u.mem_read(ptr,length))+b'\0');w(target+20,15)
  else:w(target,ptr);w(target+20,length)
  w(target+16,length);finish(target,8);return
 if a==0x6e8d90:
  out=read(sp+4);key_obj=read(sp+8);length=read(key_obj+16);ptr=read(key_obj) if read(key_obj+20)>=16 else key_obj;key=bytes(u.mem_read(ptr,length));events.append(key.decode('ascii'))
  w(prop_node+0x20,callbacks.get(key,0));w(out,prop_node if key in callbacks else sentinel);finish(out,8);return
 if a==0xc98528:finish(0);return
 if a==0x5642d0:warnings+=1
 scanner_hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,source_hook);w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(0xca1da7,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
def invoke(entry,args,ecx=0):
 w(stack,end)
 for i,v in enumerate(args):w(stack+4+i*4,v)
 u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,ecx);u.emu_start(entry,end,count=2000000);assert u.reg_read(UC_X86_REG_EIP)==end,hex(u.reg_read(UC_X86_REG_EIP))
audit=json.loads((r/'data/4.20/native_hud_layout_source_audit.json').read_text(encoding='utf-8'));archive=r/'data/4.20/archives/menu/HUD.zip';cases=[];file_headers=[];source_files=[]
with zipfile.ZipFile(archive) as z:
 for file in audit['files']:
  data=z.read(file['path']);assert hashlib.sha256(data).hexdigest()==file['sha256'];u.mem_write(source_ptr,data+b'\0'*128)
  first=data.split(b'\n',1)[0].replace(b'\r',b'');u.mem_write(text,first+b'\0');u.mem_write(origin,b'\0'*8)
  invoke(0x993ba0,[text,0x10df57c,origin,origin+4]);header_assignments=u.reg_read(UC_X86_REG_EAX);base_offset=0
  if header_assignments!=2:
   # Per-record comparison needs a supplied origin. Do not claim the outer loader accepts a comment preface.
   base_match=re.search(rb'(?m)^BaseOffset:[^\r\n]*',data)
   if base_match:
    base_offset=base_match.start();u.mem_write(text,base_match.group()+b'\0');invoke(0x993ba0,[text,0x10df57c,origin,origin+4]);assert u.reg_read(UC_X86_REG_EAX)==2
   else:
    base_offset=None;u.mem_write(origin,b'\0'*8) # supplied per-record origin; not a native full-file fallback
  file_headers.append(dict(path=file['path'],first_line_scan_assignments=header_assignments,origin_scanned_line_offset=base_offset,origin_supplied_zero=base_offset is None,outer_preface_handling_qualified=False))
  source_files.append(dict(path=file['path'],input_hex=data.hex(),sha256=file['sha256']))
  origin_bits=list(struct.unpack('<2I',u.mem_read(origin,8)))
  for m in re.finditer(rb'(?m)^Type:',data):
   warnings=0;events.clear();u.mem_write(owner,b'\0'*0x300);w(owner+4,named_registry);w(owner+0x1c4,sentinel);u.mem_write(obj,b'\xa5'*0x400)
   for offset,storage in [(0x24,all_list),(0x30,effect_list)]:w(owner+offset,storage);w(owner+offset+4,storage);w(owner+offset+8,storage+64)
   w(cursor,source_ptr+m.start());w(cursor+4,len(data)-m.start());u.mem_write(name_ptr,b'\xa5'*64);w(kind_ptr,0)
   u.reg_write(UC_X86_REG_FPCW,0x027f);u.reg_write(UC_X86_REG_FPSW,0);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80)
   invoke(0x9a5570,[cursor,kind_ptr,name_ptr]);assert u.reg_read(UC_X86_REG_EAX)&255==1;current_kind=read(kind_ptr);name=bytes(u.mem_read(name_ptr,32)).split(b'\0')[0];header_consumed=read(cursor)-source_ptr-m.start()
   w(0x14ae664,0);w(0x1222f40,0);invoke(0x9a52a0,[name_ptr,current_kind],owner);assert u.reg_read(UC_X86_REG_EAX)==obj
   # Native outer file loop9A3347 supplies aspect1 before invoking the property driver; whole loop not executed here.
   w(obj+0x1d8,0x3f800000);invoke(0x9a1a60,[cursor,obj,origin],owner)
   size={1:0x228,2:0x284,3:0x30c}[current_kind];consumed=read(cursor)-source_ptr-m.start();assert consumed>=header_consumed
   cases.append(dict(path=file['path'],file_sha256=file['sha256'],offset=m.start(),header_consumed=header_consumed,kind=current_kind,name_hex=name.hex(),origin_bits=origin_bits,aspect_bits=0x3f800000,accepted=bool(u.reg_read(UC_X86_REG_EAX)&255),consumed=consumed,warnings=warnings,property_keys=list(events),output_hex=bytes(u.mem_read(obj,size)).hex()))
assert len(cases)==703
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),source_archive_sha256=hashlib.sha256(archive.read_bytes()).hexdigest(),case_count=len(cases),accepted_count=sum(c['accepted'] for c in cases),native_addresses=len(visited),cases=cases,runtime_adapters=['Original header reader, named factory/copy/hash/vector append,28property callbacks, property driver and UV post-validation execute.','String object construction/cleanup and exact property lookup supplied; owner-pool and named-entry lookup supplied. Original registry allocation/hash collisions and string ownership not qualified.','Original BaseOffset scanner executes; aspect1 supplied at outer-loop boundary9A3347. Full file loop/resource/font/effect handles not executed.','C locale/thread/DecodePointer/cookie/errno/logger and floating state boundaries retained.'],limits=['Per-record source parsing with actual byte tails from32files; full outer file loop and resource handle resolution remain open.','Native captured outputs require Rust comparison; all records accepted does not prove rendered UI or interaction.','Runtime integration and complete game remain open.'])
proof.update(source_files=source_files,file_headers=file_headers)
proof['limits'].append('LossOfControlUI begins with comments and has noBaseOffset line. Origin0,0 explicitly supplied for per-record comparison; original full-file acceptance/alternative loading path not qualified.')
(r/'data/4.20/native_hud_source_records_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(passed=True,cases=703,accepted=proof['accepted_count'],native_addresses=len(visited),warnings=sum(c['warnings'] for c in cases))))
