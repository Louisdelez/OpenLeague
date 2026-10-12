from pathlib import Path
import json,hashlib,datetime,itertools,shutil
r=Path('E:/OpenLeague');setup=(r/'tools/qualify_native_user_config_directory.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0];exec(compile(setup,'native cache prefix prerequisites','exec'))
owner=vector+0x8000;pair=vector+0x9000;primary=vector+0xa000;overlay=vector+0xb000;sentinel=vector+0xc000;node=vector+0xd000;path_buffer=vector+0xe000;thread_stub=end+0x180;w(0xfa4378,thread_stub);u.mem_write(thread_stub,b'\xcc');dictionary_exists=False;dictionary_queries=[];decision=None
def hook_cache(uc,a,size,user):
 global decision
 sp=uc.reg_read(UC_X86_REG_ESP);this=uc.reg_read(UC_X86_REG_ECX)
 if a in [0x8acff7,0x8ad4a4]:decision='reload' if a==0x8acff7 else 'reuse';uc.emu_stop();return
 if a==thread_stub:finish(1);return
 if a==0x564c20:ssowrite(this,bytes(u.mem_read(read(sp+4),read(sp+8))));finish(this,8);return
 if a==0x5648a0:ssowrite(this,cbytes(read(sp+4)));finish(this,4);return
 if a==0x564900:finish(uc.reg_read(UC_X86_REG_EAX));return
 if a==0x5c6700:
  dest=read(sp+4);dictionary_queries.append(ssoread(read(sp+8)).decode('latin1'));w(dest,node if dictionary_exists else sentinel);finish(dest,8);return
 assert 0x8acef0<=a<0x8acff7 or 0x993780<=a<0x9937d3,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook_cache)
paths=[(b'Game.cfg',b'Game.cfg'),(b'GAME.CFG',b'game.cfg'),(b'Config/Game.cfg',b'Config\\Game.cfg'),(b'',b''),(b'DATA/CFG/defaults/Game.cfg',b'DATA/CFG/defaults/Game.cfg'),(b'Config/Game.cfg',b'DATA/CFG/Game.cfg')]
cases=[]
for (requested,last_path),last_exists,dictionary_exists,primary_dirty,overlay_dirty,flag in itertools.product(paths,[False,True],[False,True],[None,False,True],[None,False,True],[0,1,256,257,4294967295]):
 allocation=0x41000000;dictionary_queries.clear();decision=None;u.mem_write(owner,b'\0'*0x100);u.mem_write(pair,b'\0'*8);u.mem_write(primary,b'\0'*0x80);u.mem_write(overlay,b'\0'*0x80)
 ssowrite(owner+0x28,last_path);w(owner+4,sentinel);w(owner+0x24,pair if last_exists else 0);w(node+0x20,pair)
 w(pair,primary if primary_dirty is not None else 0);w(pair+4,overlay if overlay_dirty is not None else 0)
 u.mem_write(primary+0x5c,bytes([bool(primary_dirty)]));u.mem_write(overlay+0x5c,bytes([bool(overlay_dirty)]));u.mem_write(path_buffer,requested+b'\0');w(stack,end);w(stack+4,path_buffer);w(stack+8,flag)
 u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,owner);u.emu_start(0x8acef0,end,count=10000);assert decision is not None
 same=requested.lower()==last_path.lower();found=last_exists if same else dictionary_exists;dirty=bool(primary_dirty) or bool(overlay_dirty);expected='reuse' if found and flag&255==0 and not dirty else 'reload'
 assert decision==expected and dictionary_queries==([] if same else [requested.decode('latin1')]),(requested,last_path,decision,expected)
 if decision=='reuse':assert u.reg_read(UC_X86_REG_EAX)==pair
 assert ssoread(owner+0x28)==(last_path if same else requested)
 cases.append(dict(requested=requested.decode('latin1'),last_path=last_path.decode('latin1'),last_exists=last_exists,dictionary_exists=dictionary_exists,primary_dirty=primary_dirty,overlay_dirty=overlay_dirty,flag=flag,decision=decision,resolved_pair_found=found,dictionary_queries=list(dictionary_queries),stored_last_path=ssoread(owner+0x28).decode('latin1')))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,entry='0x8acef0',reload_boundary='0x8acff7',reuse_boundary='0x8ad4a4',native_path_compare='0x993780',native_sha256=hashlib.sha256(raw).hexdigest(),case_count=len(cases),native_addresses=len(visited),cases=cases,adapters=['Cache owner, pair/config dirty bytes and dictionary lookup result supplied. Original ASCII-insensitive path comparison, last-entry shortcut, dirty/force-byte checks and decision branches execute.','Standard strings and thread-ID import adapted; original dictionary/storage insertion and reload/constructor/filesystem branches not executed.'],limits=['Cache decision prefix only; full8ACEF0 reload, constructor, ownership/insertion and filesystem pipeline remain open.','Case-insensitive last-path equality does not normalize slashes at this prefix. Only low flag byte controls forced reload.','No runtime cache/menu/persistence or complete game acceptance proof.'])
(r/'data/4.20/native_config_cache_policy_contract.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name);print(json.dumps(dict(cases=len(cases),native_addresses=len(visited),scope='cache decision prefix')))
