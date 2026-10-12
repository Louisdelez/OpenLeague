from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_game_clock.py').read_text().split('\nrows=[]')[0],'setup','exec'))
owner=vector+0xc000;driver=vector+0xc100;primary=vector+0xc300;secondary=vector+0xc500;calls=[]
def capture(uc,a,size,user):
 if a in [0x88e770,0x88ff70]:
  calls.append({'entry':hex(a),'receiver':hex(u.reg_read(UC_X86_REG_ECX)),'delta_bits':read(u.reg_read(UC_X86_REG_ESP)+4)});finish(1,4)
u.hook_add(unicorn.UC_HOOK_CODE,capture)
rows=[]
for scale,dt,extra,has_primary in itertools.product([0.,.5,1.,2.],[.015625,.125,1.],[False,True],[False,True]):
 u.mem_write(obj,b'\0'*0x50);call(0x99c410,obj);w(0x2d791a8,obj);u.mem_write(obj+0x10,struct.pack('<d',scale));call(0x99c5e0,obj+0x20,struct.pack('<d',dt))
 u.mem_write(driver,b'\0'*0x100);w(owner+0x20,driver);w(driver+0x14,primary if has_primary else 0);w(driver+0x18,secondary if extra else 0)
 calls.clear();u.reg_write(UC_X86_REG_ESI,owner);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff)
 u.emu_start(0x878e73,0x878e8c,count=128);assert u.reg_read(UC_X86_REG_EIP)==0x878e8c
 expected=1+int(extra) if has_primary else 0;assert len(calls)==expected
 assert all(c['delta_bits']==read(obj+0x30) for c in calls)
 assert read(driver+0x68)&255==int(has_primary)
 rows.append({'scale':scale,'input_delta':dt,'primary':has_primary,'secondary':extra,'clock_delta_bits':read(obj+0x30),'calls':list(calls)})
proof={'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'producer_range':'0x878e73..0x878e8c','driver':'0x886760','cases':rows,'findings':['Native GameClock virtual8 delta is rounded to f32 then forwarded unchanged to primary88e770 and optional secondary88ff70.','No primary prevents both updates. Primary update marks driver+68 dirty even at zero delta.'],'limits':['Animation graph update endpoints88e770/88ff70 are captured boundaries; their bodies not executed.','Pose setup before878e73, driver ownership/callers and full clip transitions still to qualify.','Scale0 models stopped clock; native pause receiver already independently qualified.']}
(r/'data/4.20/levelprop_animation_delta_contract.json').write_text(json.dumps(proof,indent=2));print('PASS native animation delta dispatch',len(rows),'cases')
