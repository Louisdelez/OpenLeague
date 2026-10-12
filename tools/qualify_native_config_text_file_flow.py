from pathlib import Path
import itertools,json,hashlib,datetime,shutil
r=Path('E:/OpenLeague');exec(compile((r/'tools/qualify_native_game_cfg_parser.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'native parsing prerequisites','exec'))
u.mem_map(0,0x1000);file_object=owner+0x2000;vtable=owner+0x2100;stub_size=end+0x400;stub_close=end+0x420;stub_seek=end+0x440;stub_read=end+0x460
for p in [stub_size,stub_close,stub_seek,stub_read]:u.mem_write(p,b'\xcc')
w(file_object,vtable);w(vtable,stub_close);w(vtable+8,stub_size);w(vtable+0x1c,stub_seek);w(vtable+0x24,stub_read)
inputs={};active=b'';calls=[]
def file_hook(uc,a,size,user):
 global active,frame
 sp=uc.reg_read(UC_X86_REG_ESP);this=uc.reg_read(UC_X86_REG_ECX)
 if a==0x6eb840:slots.clear();records.clear();finish(this);return
 if a==0x5ed390:finish(read(sp+4),16);return
 if a==0x8b4ef0:
  path=cbytes(read(sp+4));mode=cbytes(read(sp+8));data=inputs[path];calls.append(dict(kind='open',path=path.decode(),mode=mode.decode(),present=data is not None));active=data or b'';finish(0 if data is None else file_object,8);return
 if a==stub_size:finish(len(active));return
 if a==stub_seek:finish(0,8);return
 if a==stub_read:
  dest=read(sp+4);length=read(sp+8);assert length==len(active)
  if length:u.mem_write(dest,active)
  finish(length,12);return
 if a==stub_close:calls.append(dict(kind='close'));finish(0,4);return
 if a==0x9933e0:finish(alloc(b'\0'*read(sp+4)));return
 if a==0xca1d00:
  if read(sp+12):u.mem_write(read(sp+4),bytes([read(sp+8)&255])*read(sp+12))
  finish(read(sp+4));return
 if a==0xca1ef0:
  if read(sp+12):u.mem_write(read(sp+4),bytes(u.mem_read(read(sp+8),read(sp+12))))
  finish(read(sp+4));return
 if a==0x5f82a0:ssowrite(this,ssoread(this)+bytes([read(sp+8)&255])*read(sp+4));finish(this,8);return
 if a in [0x570a30,0xc975f5]:finish(uc.reg_read(UC_X86_REG_EAX));return
 if a==0x8aed5d:frame=uc.reg_read(UC_X86_REG_EBP)
 if any(begin<=a<stop for begin,stop in [(0x8aeb70,0x8af285),(0x8a3be0,0x8a3c20),(0x5ebcd0,0x5ebd1c),(0x8b5030,0x8b5079)]):
  if 0x8aed5d<=a<0x8af242:native_hook(uc,a,size,user)
  else:visited.add(a)
  return
 native_hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,file_hook)
old=json.loads((r/'data/4.20/native_config_text_merge_contract.json').read_text(encoding='utf-8'));cases=[]
for c in old['cases']:
 allocation=heap;slots.clear();records.clear();warnings=0;exception=None;calls.clear();u.mem_write(owner,b'\0'*0x180);w(owner+4,sentinel);w(owner+0xc,sentinel);w(0x2d78db4,owner+0x2200)
 ssowrite(owner+0x14c,b'user.cfg');ssowrite(owner+0x164,b'defaults.cfg');inputs={b'user.cfg':None if c['primary'] is None else bytes(c['primary']),b'defaults.cfg':None if c['baseline'] is None else bytes(c['baseline'])}
 w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,owner);u.emu_start(0x8aeb70,end,count=5000000);assert exception is None and u.reg_read(UC_X86_REG_EIP)==end
 opened=bool(u.reg_read(UC_X86_REG_EAX)&255);assert opened==any(bool(value) for value in inputs.values())
 result=dict(entries=[dict(row) for row in records],warnings=warnings,error=exception);assert result==c['result']
 assert len([x for x in calls if x['kind']=='close'])==sum(value is not None for value in inputs.values())
 cases.append(dict(primary=c['primary'],baseline=c['baseline'],calls=calls.copy(),loaded=opened,result=result))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,entry='0x8aeb70 + 0x8aec00',case_count=len(cases),native_addresses=len(visited),native_sha256=hashlib.sha256(raw).hexdigest(),cases=cases,adapters=['Original dual-read8AEB70, file-loader8AEC00, buffer constructor8A3BE0/5EBCD0, read8B5030, parser/hash and cleanup branches execute.','Resource open8B4EF0 supplies null or a virtual file with size/read/seek/close adapters. CRT allocation/memcpy/memset and standard strings/containers/diagnostics/cookie adapted; no real filesystem operations.','Global resource initialization preinitialized; successful allocation/read only.'],limits=['Original resource open and underlying filesystem/archive providers, stream failure/partial reads, allocation exceptions, text parse exceptions and concurrent lifetime remain open.','Zero-byte file opens/closes but text-load status is false because native buffer remains null; previous parser-entry-only merge status did not cover this I/O behavior.','No binary-overlay/cache/menu/persistence or full game proof.'])
(r/'data/4.20/native_config_text_file_flow_contract.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(cases=len(cases),native_addresses=len(visited),empty_file_loaded=False)))
