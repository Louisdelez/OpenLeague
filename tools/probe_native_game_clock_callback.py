from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_game_clock.py').read_text().split('rows=[]')[0],'setup','exec'))
callback=vector+0xc000;vtable=callback+0x100;active_stub=callback+0x200;update_stub=callback+0x210
w(callback,vtable);w(vtable,update_stub);w(vtable+0x10,active_stub)
events=[];active=False

def observe(uc,address,size,user):
 if address==active_stub:
  events.append({'kind':'active','receiver':u.reg_read(UC_X86_REG_ECX)});finish(int(active));return
 if address==update_stub:
  sp=u.reg_read(UC_X86_REG_ESP);events.append({'kind':'update','receiver':u.reg_read(UC_X86_REG_ECX),'delta':struct.unpack('<d',u.mem_read(sp+4,8))[0]});finish(0,8)
u.hook_add(unicorn.UC_HOOK_CODE,observe)
rows=[]
for scale,present,active,dt in itertools.product([-1.,0.,.5,1.,2.],[False,True],[False,True],[0.,.016,.125]):
 u.mem_write(obj,b'\0'*0x50);call(0x99c410,obj);u.mem_write(obj+0x10,struct.pack('<d',scale));w(obj+0x28,callback if present else 0);events.clear()
 call(0x99c5e0,obj+0x20,struct.pack('<d',dt))
 expected=(['active']+(['update'] if active else [])) if scale==0 and present else []
 assert [e['kind'] for e in events]==expected,(scale,present,active,events)
 assert all(e['receiver']==callback for e in events)
 assert all(e.get('delta',dt)==dt for e in events)
 rows.append(dict(scale=scale,present=present,active=active,delta=dt,events=list(events)))
proof=dict(complete=False,passed=True,native_sha256=hashlib.sha256(raw).hexdigest(),update='0x99c5e0',cases=rows,findings=['Only zero scale queries callback virtual+10; true result dispatches original unscaled f64 delta to callback virtual+0.','Nonzero scale does not query or invoke callback.'],limits=['Callback implementations supplied by observable ABI stubs; their gameplay behavior is not qualified.','Finite normal mode only; no live integration claimed.'])
(r/'data/4.20/game_clock_callback_contract.json').write_text(json.dumps(proof,indent=2)+'\n')
print(json.dumps(dict(passed=True,cases=len(rows))))
