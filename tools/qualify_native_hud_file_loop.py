from pathlib import Path
import json,struct,hashlib,datetime,zipfile
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_hud_formatted_scanner.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'HUD file loop prerequisites','exec'))
owner=vector+0x6000;fs=vector+0x7000;fs_vt=vector+0xe000;stream=vector+0xf000;stream_vt=vector+0x10000;file_name=vector+0x11000;prop_node=vector+0x12000;sentinel=vector+0x12100
source_ptr=0x50000000;arena=0x51000000;node_arena=0x51100000;lists=0x51200000
u.mem_map(source_ptr,0x100000);u.mem_map(arena,0x300000);next_obj=arena;next_node=node_arena;size=0;nodes={};created=[];accepted=[];rejected=[];warnings=0;closed=0;header_count=None
callbacks={v['name'].encode():int(v['callback'],16) for v in json.loads((r/'data/4.20/native_hud_property_registry_contract.json').read_text(encoding='utf-8'))['registrations']}
def cbytes(ptr,limit=1024):return bytes(u.mem_read(ptr,limit)).split(b'\0')[0]
def snapshot(ptr):
 kind=read(ptr+0x40);length={1:0x228,2:0x284,3:0x30c}[kind]
 return dict(name=cbytes(ptr,32).decode('ascii'),kind=kind,output_hex=bytes(u.mem_read(ptr,length)).hex())
def file_loop_hook(uc,a,n,user):
 global next_obj,next_node,warnings,closed,header_count
 sp=uc.reg_read(UC_X86_REG_ESP)
 if a==vector+0x5000:finish(stream,8);return
 if a==vector+0x5010:finish(source_ptr);return
 if a==vector+0x5020:finish(size);return
 if a==vector+0x5030:closed+=1;finish(0,4);return
 if a==0x564c20:
  target=uc.reg_read(UC_X86_REG_ECX);ptr=read(sp+4);length=read(sp+8);assert length<=1023;u.mem_write(target,b'\0'*24)
  if length<16:u.mem_write(target,bytes(u.mem_read(ptr,length))+b'\0');w(target+20,15)
  else:w(target,ptr);w(target+20,length)
  w(target+16,length);finish(target,8);return
 if a==0x6e8d90:
  out=read(sp+4);key_obj=read(sp+8);length=read(key_obj+16);ptr=read(key_obj) if read(key_obj+20)>=16 else key_obj;key=bytes(u.mem_read(ptr,length));w(prop_node+0x20,callbacks.get(key,0));w(out,prop_node if key in callbacks else sentinel);finish(out,8);return
 if a==0xc98528:finish(0);return
 if a in [0x9aa4d0,0x9aa6f0,0x9aa5e0]:
  ptr=next_obj;next_obj+=0x400;assert next_obj<node_arena;u.mem_write(ptr,b'\xa5'*0x400);created.append(ptr);finish(ptr);return
 if a==0x9a6250:
  key=cbytes(read(sp+4),32)
  if key not in nodes:nodes[key]=next_node;u.mem_write(next_node,b'\0'*0x40);next_node+=0x40
  finish(nodes[key],4);return
 if a==0x9a6340:finish(0,4);return
 if a==0x5bd2f0:finish(0,4);return
 if a==0x9a3211:header_count=uc.reg_read(UC_X86_REG_EAX)
 if a==0x9a336a:rejected.append(snapshot(uc.reg_read(UC_X86_REG_EDI)))
 if a==0x9a3374:
  accepted.append(snapshot(uc.reg_read(UC_X86_REG_EDI)))
  # Preserve the complete file/record loop, but stop resource/owner group resolution at its explicit boundary.
  uc.reg_write(UC_X86_REG_EIP,0x9a32fd);return
 if a==0x5642d0:warnings+=1
 scanner_hook(uc,a,n,user)
u.hook_add(unicorn.UC_HOOK_CODE,file_loop_hook);w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(0xca1da7,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
w(fs,fs_vt);w(fs_vt+0x14,vector+0x5000);w(stream,stream_vt);w(stream_vt+0x10,vector+0x5010);w(stream_vt+8,vector+0x5020);w(stream_vt,vector+0x5030)
audit=json.loads((r/'data/4.20/native_hud_layout_source_audit.json').read_text(encoding='utf-8'));inputs=[]
with zipfile.ZipFile(r/'data/4.20/archives/menu/HUD.zip') as z:
 for f in audit['files']:inputs.append((f['path'],'original',z.read(f['path'])))
manifest=json.loads((r/'data/4.20/hud_restored/manifest.json').read_text(encoding='utf-8'))
for asset in manifest['assets']:
 data=(r/asset['restored_path']).read_bytes();assert hashlib.sha256(data).hexdigest()==asset['restored_sha256'];inputs.append((asset['requested'],'restored',data))
cases=[]
for path,variant,data in inputs:
 u.mem_write(source_ptr,data+b'\0'*128);size=len(data);u.mem_write(file_name,path.encode()+b'\0');u.mem_write(owner,b'\0'*0x300);w(owner+4,vector+0x13000);w(owner+0x1c4,sentinel);w(0,0);next_obj=arena;next_node=node_arena;nodes.clear();created.clear();accepted.clear();rejected.clear();warnings=closed=0;header_count=None
 for off,storage in [(0x24,lists),(0x30,lists+0x10000)]:w(owner+off,storage);w(owner+off+4,storage);w(owner+off+8,storage+0xff00)
 w(0x14ae664,0);w(0x1222f40,0);w(stack,end);w(stack+4,file_name);w(stack+8,fs);w(stack+12,0);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,owner);u.reg_write(UC_X86_REG_FPCW,0x027f);u.reg_write(UC_X86_REG_FPSW,0);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80)
 u.emu_start(0x9a3080,end,count=30000000);assert u.reg_read(UC_X86_REG_EIP)==end
 live=[read(ptr) for ptr in range(read(owner+0x24),read(owner+0x28),4)];effects=[read(ptr) for ptr in range(read(owner+0x30),read(owner+0x34),4)]
 assert len(live)==len(accepted) and len(effects)==sum(v['kind']==2 for v in accepted)
 cases.append(dict(path=path,variant=variant,input_hex=data.hex(),input_sha256=hashlib.sha256(data).hexdigest(),header_assignments=header_count,accepted=list(accepted),rejected=list(rejected),warnings=warnings,closed_stream_calls=closed,live_general_list_count=len(live),live_effect_list_count=len(effects)))
 print(json.dumps(dict(file=path,variant=variant,accepted=len(accepted),rejected=len(rejected))),flush=True)
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),case_count=len(cases),native_addresses=len(visited),cases=cases,runtime_adapters=['Whole9A3080file loop, header/name/factory/hash/property/validation/UV logic and original vectors/removal/memmove execute.','Filesystem stream/pool/named registry/property lookup/string ownership and pool release boundaries supplied.','At9A3374accepted element snapshot, resource/font/effect/owner-group resolution deliberately bypassed to9A32FD; it is NOT qualified.','C locale/thread/DecodePointer/cookie/errno/logger and floating state supplied.'],limits=['Full structural file control flow with raw original32files and2derived repairs; replacement-mode loading not covered.','Resource binding and owner-group association/postload color-param transfer deliberately excluded; runtime loader must implement/qualify them separately.','Container collision/lifetime, actual filesystem preprocessing, rendering/interactions and full game remain open.'])
(r/'data/4.20/native_hud_file_loop_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(dict(passed=True,cases=len(cases),native_addresses=len(visited))))
