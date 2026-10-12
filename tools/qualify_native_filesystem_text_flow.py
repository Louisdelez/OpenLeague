from pathlib import Path
import itertools,json,hashlib,datetime,shutil
r=Path('E:/OpenLeague');exec(compile((r/'tools/qualify_native_game_cfg_parser.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'native parsing prerequisites','exec'))
u.mem_map(0,0x1000);file_object=owner+0x2000;vtable=owner+0x2100;stub_size=end+0x400;stub_close=end+0x420;stub_seek=end+0x440;stub_read=end+0x460
for p in [stub_size,stub_close,stub_seek,stub_read]:u.mem_write(p,b'\xcc')
w(file_object,vtable);w(vtable,stub_close);w(vtable+8,stub_size);w(vtable+0x1c,stub_seek);w(vtable+0x24,stub_read)
inputs={};active=b'';calls=[];streams={};stream_next=0x40018000;provider=0x40019000;w(provider,0x10c9854);w(0x2d6e4a0,provider);w(0x2d6e4b0,1)
def file_hook(uc,a,size,user):
 global active,frame,stream_next
 sp=uc.reg_read(UC_X86_REG_ESP);this=uc.reg_read(UC_X86_REG_ECX)
 if a==0x6eb840:slots.clear();records.clear();finish(this);return
 if a==0x5ed390:finish(read(sp+4),16);return
 if a==0xc9f6c9:
  path=cbytes(read(sp+4));result=0 if inputs[path] is not None else -1;calls.append(dict(kind='access',path=path.decode(),flags=read(sp+8),result=result));finish(result);return
 if a==0xc99533:
  out=read(sp+4);path=cbytes(read(sp+8));mode=cbytes(read(sp+12));data=inputs[path];calls.append(dict(kind='open',path=path.decode(),mode=mode.decode(),present=data is not None))
  p=0
  if data is not None:p=stream_next;stream_next+=16;streams[p]=dict(data=data,position=0)
  w(out,p);finish(0 if p else 2);return
 if a==0xc9f39b:finish(alloc(b'\0'*read(sp+4)));return
 if a==0x564c20:ssowrite(this,bytes(u.mem_read(read(sp+4),read(sp+8))));finish(this,8);return
 if a==0xc9b375:
  assert read(sp+8)==0 and read(sp+12)==0 and read(sp+16)==64000;finish(0);return
 if a==0xc9cd17:finish(streams[read(sp+4)]['position']);return
 if a==0xc9ce75:
  stream=streams[read(sp+4)];offset=read(sp+8);offset=offset if offset<0x80000000 else offset-0x100000000;origin=read(sp+12);assert origin in [0,1,2];stream['position']=offset+([0,stream['position'],len(stream['data'])][origin]);finish(0);return
 if a==0xc9973d:
  dest=read(sp+4);element=read(sp+8);count=read(sp+12);stream=streams[read(sp+16)];chunk=stream['data'][stream['position']:stream['position']+element*count]
  if chunk:u.mem_write(dest,chunk)
  stream['position']+=len(chunk);finish(0 if element==0 else len(chunk)//element);return
 if a==0xc99855:
  del streams[read(sp+4)];calls.append(dict(kind='close'));finish(0);return
 if a==0xc98528:finish(uc.reg_read(UC_X86_REG_EAX));return
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
 if any(begin<=a<stop for begin,stop in [(0x8aeb70,0x8af285),(0x8a3be0,0x8a3c20),(0x5ebcd0,0x5ebd1c),(0x8b5030,0x8b5079),(0x8b4ef0,0x8b4f5b),(0x8b5f90,0x8b6380),(0x71eca0,0x71eca4)]):
  if 0x8aed5d<=a<0x8af242:native_hook(uc,a,size,user)
  else:visited.add(a)
  return
 native_hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,file_hook)
old=json.loads((r/'data/4.20/native_config_text_merge_contract.json').read_text(encoding='utf-8'));cases=[]
for c in old['cases']:
 allocation=heap;streams.clear();stream_next=0x40018000;w(0x2d77b20,1);w(0x14bef58,0);w(0x14bef40,0);slots.clear();records.clear();warnings=0;exception=None;calls.clear();u.mem_write(owner,b'\0'*0x180);w(owner+4,sentinel);w(owner+0xc,sentinel);w(0x2d78db4,owner+0x2200)
 ssowrite(owner+0x14c,b'user.cfg');ssowrite(owner+0x164,b'defaults.cfg');inputs={b'user.cfg':None if c['primary'] is None else bytes(c['primary']),b'defaults.cfg':None if c['baseline'] is None else bytes(c['baseline'])}
 w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,owner);u.emu_start(0x8aeb70,end,count=5000000);assert exception is None and u.reg_read(UC_X86_REG_EIP)==end
 opened=bool(u.reg_read(UC_X86_REG_EAX)&255);assert opened==any(bool(value) for value in inputs.values())
 result=dict(entries=[dict(row) for row in records],warnings=warnings,error=exception);assert result==c['result']
 assert not streams
 assert len([x for x in calls if x['kind']=='close'])==sum(value is not None for value in inputs.values())
 cases.append(dict(primary=c['primary'],baseline=c['baseline'],calls=calls.copy(),loaded=opened,result=result))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,entry='0x8aeb70 + 0x8aec00',case_count=len(cases),native_addresses=len(visited),native_sha256=hashlib.sha256(raw).hexdigest(),cases=cases,adapters=['Original dual-read8AEB70, file-loader8AEC00, buffer constructor8A3BE0/5EBCD0, read8B5030, parser/hash and cleanup branches execute.','Resource open8B4EF0 supplies null or a virtual file with size/read/seek/close adapters. CRT allocation/memcpy/memset and standard strings/containers/diagnostics/cookie adapted; no real filesystem operations.','Global resource initialization preinitialized; successful allocation/read only.'],limits=['Original resource open and underlying filesystem/archive providers, stream failure/partial reads, allocation exceptions, text parse exceptions and concurrent lifetime remain open.','Zero-byte file opens/closes but text-load status is false because native buffer remains null; previous parser-entry-only merge status did not cover this I/O behavior.','No binary-overlay/cache/menu/persistence or full game proof.'])
proof['filesystem_provider_executed']=True
proof['adapters']=['Original resource dispatch8B4EF0, simple provider8B6280/8B6360, file constructor8B5F90, size/seek/read/destructor, text loader/parser and cleanup execute original instructions.','CRT access/fopen_s/setvbuf/ftell/fseek/fread/fclose, allocation/free, strings/containers/memcpy/cookie adapted with controlled in-memory streams; no real filesystem operations.','Provider array contains the native simple-filesystem vtable, resource subsystem already initialized; archive provider absent.']
proof['limits']=['Native C++ provider/stream control flow only; actual CRT/Windows encoding/file permissions/failure/partial-read behavior and archive provider still open.','Successful open/read/seek/allocation plus missing/empty files; error cleanup, concurrent modifications and process-global initialization not fully qualified.','No complete configuration cache/menu/persistence or full game proof.']
(r/'data/4.20/native_filesystem_text_flow_contract.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(cases=len(cases),native_addresses=len(visited),empty_file_loaded=False)))
