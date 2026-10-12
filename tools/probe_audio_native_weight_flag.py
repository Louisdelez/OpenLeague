from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_game_clock.py').read_text().split('\nrows=[]')[0],'setup','exec'))
container=vector+0xa000;playlist=vector+0xb000;table=vector+0xc000;containsfn=vector+0xd000;addfn=containsfn+0x20
w(playlist,table);w(table+0x20,containsfn);w(table+0x14,addfn)
def adapter(uc,a,n,d):
 sp=u.reg_read(UC_X86_REG_ESP);ret=read(sp)
 if a==addfn:inserted.append([read(sp+4),read(sp+8)])
 u.reg_write(UC_X86_REG_EAX,0 if a==containsfn else 1);u.reg_write(UC_X86_REG_ESP,sp+(8 if a==containsfn else 12));u.reg_write(UC_X86_REG_EIP,ret)
for a in [containsfn,addfn]:u.hook_add(unicorn.UC_HOOK_CODE,adapter,begin=a,end=a)
rows=[];contract=json.loads((r/'data/4.20/ambient_audio_selection.json').read_text())
fixtures=[(c['id'],[(p['sound'],p['weight']) for p in c['playlist']]) for c in contract['containers']]+[(0,[(1,x),(2,50000)]) for x in [0,1,49999,50000,50001]]
for ident,items in fixtures:
 u.mem_write(container,b'\0'*0xa0);w(container+0x68,playlist);inserted=[];states=[];active=False
 for sound,weight in items:
  call(0xb1d430,container,struct.pack('<II',sound,weight));assert u.reg_read(UC_X86_REG_EAX)==1
  active=active or weight!=50000;actual=bool(u.mem_read(container+0x91,1)[0]&8);assert actual==active;states.append(actual)
 assert inserted==[list(x) for x in items]
 rows.append(dict(id=ident,entries=items,weight_mode=states))
proof=dict(passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entry='0xb1d430',cases=rows,limits=['Playlist duplicate lookup and insertion adapted to successful fixture accessors; native weight flag branch and empty history invalidation executed.','Any inserted weight differing from50000 sets bit8; later50000 entries do not clear it. Does not qualify zero-weight selection or failed insertion rollback.'])
(r/'data/4.20/audio_native_weight_flag.json').write_text(json.dumps(proof,indent=2)+'\n');print(json.dumps(dict(passed=True,cases=len(rows),entries=sum(len(x['entries']) for x in rows))))
