from pathlib import Path
import json,struct,hashlib,datetime,zipfile,shutil
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_hud_formatted_scanner.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'HUD file header prerequisites','exec'))
owner=vector+0x6000;fs=vector+0x7000;fs_vt=vector+0xe000;stream=vector+0xf000;stream_vt=vector+0x10000;file_name=vector+0x11000;source_ptr=0x50000000
u.mem_map(source_ptr,0x100000);size=0;outcome=None;assignments=None;origin_bits=None
def file_hook(uc,a,n,user):
 global outcome,assignments,origin_bits
 sp=uc.reg_read(UC_X86_REG_ESP)
 if a==vector+0x5000:finish(stream,8);return
 if a==vector+0x5010:finish(source_ptr);return
 if a==vector+0x5020:finish(size);return
 if a==vector+0x5030:finish(0,4);return
 if a==0x564c20:
  target=uc.reg_read(UC_X86_REG_ECX);ptr=read(sp+4);length=read(sp+8);u.mem_write(target,b'\0'*24);w(target,ptr);w(target+16,length);w(target+20,max(16,length));finish(target,8);return
 if a==0xc98528:finish(0);return
 if a==0x9a3211:
  assignments=uc.reg_read(UC_X86_REG_EAX);bp=uc.reg_read(UC_X86_REG_EBP);origin_bits=[read(bp-0x468),read(bp-0x464)]
 if a==0x9a321a:
  outcome='passed_header_boundary';uc.reg_write(UC_X86_REG_EIP,end);return
 scanner_hook(uc,a,n,user)
u.hook_add(unicorn.UC_HOOK_CODE,file_hook);w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(0xca1da7,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
w(fs,fs_vt);w(fs_vt+0x14,vector+0x5000);w(stream,stream_vt);w(stream_vt+0x10,vector+0x5010);w(stream_vt+8,vector+0x5020);w(stream_vt,vector+0x5030)
audit=json.loads((r/'data/4.20/native_hud_layout_source_audit.json').read_text(encoding='utf-8'));cases=[]
with zipfile.ZipFile(r/'data/4.20/archives/menu/HUD.zip') as z:
 for file in audit['files']:
  data=z.read(file['path']);assert hashlib.sha256(data).hexdigest()==file['sha256'];size=len(data);u.mem_write(source_ptr,data+b'\0'*64);u.mem_write(file_name,file['path'].encode('ascii')+b'\0');u.mem_write(owner,b'\0'*0x300);w(0,0);outcome=None;assignments=None;origin_bits=None
  w(stack,end);w(stack+4,file_name);w(stack+8,fs);w(stack+12,0);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,owner)
  u.emu_start(0x9a3080,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end and assignments is not None
  if outcome is None:outcome='returned_without_header_acceptance'
  cases.append(dict(path=file['path'],file_sha256=file['sha256'],first_line_hex=data.split(b'\n',1)[0].hex(),scanner_assignments=assignments,origin_bits=origin_bits,outcome=outcome))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entry='0x9a3080',case_count=len(cases),native_addresses=len(visited),cases=cases,runtime_adapters=['Filesystem virtual get/stream data/size supplied with exact source bytes; source wrapper preprocessing not qualified.','Filename string ownership adapted; original file prefix line reader/BaseOffset scanner/branch execute.','For valid headers execution deliberately stops at9A321Abefore element loop; invalid header path reaches native return.','C locale/thread/DecodePointer/cookie/errno/logger boundaries reused.'],limits=['Raw-stream header guard only; no complete file loader or upstream provider behavior claim.','LossOfControlUI lacksBaseOffset; inspect upstream transformation/alternative loader before deciding intended treatment.','Resources, owner registry, drawing and complete game remain open.'])
(r/'data/4.20/native_hud_file_header_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(passed=True,cases=len(cases),accepted=sum(c['outcome']=='passed_header_boundary' for c in cases),rejected=[c['path'] for c in cases if c['outcome']!='passed_header_boundary'])))
