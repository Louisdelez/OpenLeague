from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_game_clock.py').read_text().split('\nrows=[]')[0],'setup','exec'))
owner=vector+0xc000;driver=vector+0xc100;primary=vector+0xc300;secondary=vector+0xc500;calls=[]
table=vector+0xc700;layer=vector+0xc800;node=vector+0xd000;clip=vector+0xd100
def capture(uc,a,size,user):
 if a in [0x88ff70]:
  calls.append({'entry':hex(a),'receiver':hex(u.reg_read(UC_X86_REG_ECX)),'delta_bits':read(u.reg_read(UC_X86_REG_ESP)+4)});finish(1,4)
u.hook_add(unicorn.UC_HOOK_CODE,capture)
rows=[]
for scale,dt,extra,has_primary in itertools.product([0.,.5,1.,2.],[.015625,.125,1.],[False,True],[False,True]):
 u.mem_write(obj,b'\0'*0x50);call(0x99c410,obj);w(0x2d791a8,obj);u.mem_write(obj+0x10,struct.pack('<d',scale));call(0x99c5e0,obj+0x20,struct.pack('<d',dt))
 u.mem_write(driver,b'\0'*0x100);w(owner+0x20,driver);w(driver+0x14,primary if has_primary else 0);w(driver+0x18,secondary if extra else 0)
 u.mem_write(primary,b'\0'*0x100);u.mem_write(layer,b'\0'*0x100);u.mem_write(table,b'\0'*0x18);w(primary+0x10,1);w(primary+0x7c,table);w(table+4,layer);w(layer+0x34,node);w(layer+0x3c,4);u.mem_write(node,b'\0'*0x80);u.mem_write(clip,b'\0'*0x30);w(node,0x10c8918);w(node+0x2c,clip);w(clip+8,100);u.mem_write(clip+0xc,struct.pack('<f',1.));u.mem_write(node+0xc,struct.pack('<f',.25));u.mem_write(node+0x10,struct.pack('<f',.5))
 calls.clear();u.reg_write(UC_X86_REG_ESI,owner);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff)
 u.emu_start(0x878e73,0x878e8c,count=1024);assert u.reg_read(UC_X86_REG_EIP)==0x878e8c
 expected=int(extra) if has_primary else 0;assert len(calls)==expected
 assert all(c['delta_bits']==read(obj+0x30) for c in calls)
 assert read(driver+0x68)&255==int(has_primary)
 delta=struct.unpack('<f',u.mem_read(obj+0x30,4))[0];expected_time=.25+delta*.5 if has_primary else .25
 assert struct.unpack('<f',u.mem_read(node+0xc,4))[0]==expected_time
 assert struct.unpack('<f',u.mem_read(layer+0x7c,4))[0]==(delta if has_primary else 0.)
 rows.append({'node_time_bits':read(node+0xc),'layer_time_bits':read(layer+0x7c),'scale':scale,'input_delta':dt,'primary':has_primary,'secondary':extra,'clock_delta_bits':read(obj+0x30),'calls':list(calls)})
proof={'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'producer_range':'0x878e73..0x878e8c','driver':'0x886760','executed_graph_loop':'0x88e770','executed_layer':'0x891930','executed_node':'0x889180','cases':rows,'findings':['Native GameClock virtual8 delta is rounded to f32 then forwarded unchanged through actual primary88e770, layer891930 and simple node889180; node speed.5 and initialtime.25 produce expected time, unchanged at scale0.','No primary prevents both updates. Primary update marks driver+68 dirty even at zero delta.'],'limits':['Only secondary88ff70 is captured. Primary graph, layer and actual simple-node update execute; one active layer, no queued transition, active flags4, long duration100. End/transition/event branches not qualified here.','Pose setup before878e73, driver ownership/callers and full clip transitions still to qualify.','Scale0 models stopped clock; native pause receiver already independently qualified.']}
(r/'data/4.20/levelprop_animation_node_delta_contract.json').write_text(json.dumps(proof,indent=2));print('PASS native animation delta dispatch',len(rows),'cases')
