from pathlib import Path
import itertools,json,hashlib,datetime,shutil
r=Path('E:/OpenLeague');exec(compile((r/'tools/qualify_native_config_cache_policy.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'mapped native prerequisites','exec'))
config=owner;argbase=owner+0x12000;vectorbuf=owner+0x14000;calls=[];binary_results=(False,False);binary_index=0;text_result=False;compare_result=0;gate_result=0;stat_success=False;timestamp=(0,0)
def ctor_hook(uc,a,size,user):
 global binary_index
 sp=uc.reg_read(UC_X86_REG_ESP);this=uc.reg_read(UC_X86_REG_ECX)
 if a==thread_stub:finish(1);return
 if a==0x6ea890:finish(this,8);return
 if a==0x8b9f20:finish(this,4);return
 if a==0x564c20:ssowrite(this,bytes(u.mem_read(read(sp+4),read(sp+8))));finish(this,8);return
 if a==0x8b0380:
  calls.append(dict(kind='binary_loader',path=cbytes(read(sp+4)).decode()));value=binary_results[binary_index];binary_index+=1;finish(value,4);return
 if a==0xca0085:calls.append(dict(kind='command_line_boundary',path=cbytes(read(sp+4)).decode()));finish(0);return
 if a==0xc9cf31:finish(compare_result);return
 if a==0x9938c0:calls.append(dict(kind='command_line_gate',path=cbytes(this).decode()));finish(gate_result);return
 if a==0xc9f355:
  calls.append(dict(kind='file_metadata',path=cbytes(read(sp+4)).decode()));buf=read(sp+8);w(buf+0x28,timestamp[0]);w(buf+0x2c,timestamp[1]);finish(0 if stat_success else -1);return
 if a==0x8aeb70:
  calls.append(dict(kind='text_loader',requested=ssoread(this+0x14c).decode(),active=ssoread(this+0x164).decode()));finish(text_result);return
 if a==0xc975f5:finish(uc.reg_read(UC_X86_REG_EAX));return
 assert 0x8ad5b0<=a<0x8adb27,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,ctor_hook)
cases=[]
for paths,binary_results,text_result,compare_result,gate_result,stat_success,timestamp in itertools.product([(b'config/game.cfg',b'config/defaults/game.cfg',b'Config/Game.cfg'),(b'',b'',b'')],[(False,False),(False,True),(True,False),(True,True)],[False,True],[0,1],[0,1],[False,True],[(0,0),(0xffffffff,0x7fffffff)]):
 allocation=0x41000000;binary_index=0;calls.clear();u.mem_write(config,b'\xa5'*0x180)
 w(0x2d8aa78,15);u.mem_write(vectorbuf,b'\0'*0x100)
 for address in [0x2d858e4,0x2d83fac,0x2d858d8]:w(address,vectorbuf);w(address+4,vectorbuf);w(address+8,vectorbuf+0x100)
 ssowrite(0x2d83fc0,b'');w(stack,end)
 for i,path in enumerate(paths):p=argbase+i*0x200;u.mem_write(p,path+b'\0');w(stack+4+i*4,p)
 u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,config);u.emu_start(0x8ad5b0,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_EAX)==config
 proceed=not binary_results[0] or (compare_result==0 and gate_result!=0)
 expected_binary=[paths[2]]+([] if binary_results[0] else [paths[1]])
 assert [c['path'].encode() for c in calls if c['kind']=='binary_loader']==expected_binary
 assert bool(u.mem_read(config+0x148,1)[0])==(binary_results[0] or binary_results[1])
 assert bool(u.mem_read(config+0x149,1)[0])==(not binary_results[0] and binary_results[1])
 assert bool(u.mem_read(config+0x14a,1)[0])==(proceed and text_result)
 assert (ssoread(config+0x14c),ssoread(config+0x164))==((paths[2],paths[1]) if proceed else (b'',b''))
 actual_timestamp=(read(config+0x54),read(config+0x58));assert actual_timestamp==((timestamp if stat_success else (0,0)) if proceed else (0xffffffff,0xffffffff))
 assert u.mem_read(config+0x5c,2)==b'\0\0'
 cases.append(dict(paths=[p.decode() for p in paths],primary_binary=binary_results[0],fallback_binary=binary_results[1],text_result=text_result,compare_result=compare_result,gate_result=gate_result,stat_success=stat_success,timestamp=list(timestamp),calls=calls.copy(),binary_loaded=bool(u.mem_read(config+0x148,1)[0]),fallback_loaded=bool(u.mem_read(config+0x149,1)[0]),text_loaded=bool(u.mem_read(config+0x14a,1)[0]),stored_requested=ssoread(config+0x14c).decode(),stored_active=ssoread(config+0x164).decode(),stored_timestamp=list(actual_timestamp)))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,entry='0x8ad5b0',native_sha256=hashlib.sha256(raw).hexdigest(),case_count=len(cases),native_addresses=len(visited),cases=cases,adapters=['Container/string/thread/cookie initialization adapted; constructor field writes and branches execute original PE instructions.','Binary loader8B0380 and text loader8AEB70 return supplied booleans; parsing/I/O not executed in this constructor probe.','Process-global helper initialization already marked initialized. Command-line parser/comparison/gate and file metadata return controlled results, without real process/Windows I/O.'],limits=['Constructor orchestration and field/call contract only; actual command-line parser/gate, initial container/global allocation, text/binary file handling, error cleanup and concurrency remain open.','File metadata timestamp layout supplied; full real stat semantics not qualified.','No live options/menu/cache/persistence or complete game acceptance proof.'])
(r/'data/4.20/native_config_constructor_contract.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(cases=len(cases),native_addresses=len(visited))))
