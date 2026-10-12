from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_game_clock.py').read_text().split('\nrows=[]')[0],'setup','exec'))
container=vector+0x10000;playlist=vector+0x11000;table=vector+0x12000;countfn=vector+0x13000;idfn=countfn+32;outindex=vector+0x14000;outid=outindex+8;target=vector+0x15000
w(container+0x68,playlist);w(playlist,table);w(table+12,countfn);w(table+16,idfn)
def ret(value,pop):
 sp=u.reg_read(UC_X86_REG_ESP);addr=read(sp);u.reg_write(UC_X86_REG_EAX,value);u.reg_write(UC_X86_REG_ESP,sp+4+pop);u.reg_write(UC_X86_REG_EIP,addr)
def adapter(uc,a,n,d):
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==countfn:ret(1,0)
 elif a==idfn:assert read(sp+4)==0;ret(sound,4)
 else:assert read(sp+4)==sound and read(sp+8)==0;ret(target,8)
for a in [countfn,idfn,0xaf6480]:u.hook_add(unicorn.UC_HOOK_CODE,adapter,begin=a,end=a)
rows=[]
contract=json.loads((r/'data/4.20/ambient_audio_selection.json').read_text())
for c in contract['containers']:
 if len(c['playlist'])!=1:continue
 sound=c['playlist'][0]['sound'];w(outindex,0xffffffff);w(outid,0)
 call(0xb1d960,container,struct.pack('<III',0,outindex,outid))
 assert u.reg_read(UC_X86_REG_EAX)==target and read(outid)==sound and u.mem_read(outindex,2)==b'\0\0'
 rows.append(dict(container=c['id'],sound=sound,index=0))
proof=dict(passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entry='0xb1d960',cases=rows,limits=['Playlist count/id accessors and target registry adapted; actual single-child native dispatch executed. No random/history path invoked.','Target availability and playback admission not qualified here.'])
(r/'data/4.20/audio_native_single_child.json').write_text(json.dumps(proof,indent=2)+'\n');print(json.dumps(dict(passed=True,cases=len(rows))))
