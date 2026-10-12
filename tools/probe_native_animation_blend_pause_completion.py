from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_game_clock.py').read_text().split('\nrows=[]')[0],'setup','exec'))
owner=vector+0xc000;driver=vector+0xc100;primary=vector+0xc300;secondary=vector+0xc500;calls=[]
table=vector+0xc700;layer=vector+0xc800;node=vector+0xd000;clip=vector+0xd100
def capture(uc,a,size,user):
 if a in [0x88ff70]:
  calls.append({'entry':hex(a),'receiver':hex(u.reg_read(UC_X86_REG_ECX)),'delta_bits':read(u.reg_read(UC_X86_REG_ESP)+4)});finish(1,4)
u.hook_add(unicorn.UC_HOOK_CODE,capture)
def f(a):return struct.unpack('<f',u.mem_read(a,4))[0]
def put(a,v):u.mem_write(a,struct.pack('<f',v))
def incoming_weight():
 entry=thunk+0x140;address=0x88d750
 u.mem_write(entry,b'\xe8'+struct.pack('<i',address-entry-5)+b'\xd9\x1d'+struct.pack('<I',out)+b'\xc3');call(entry,layer+0x4c);return f(out)
rows=[]
for speed,dt in itertools.product([.5,1.,2.],[.015625,.125,1.]):
 for a,n in [(obj,0x50),(driver,0x100),(primary,0x100),(layer,0x100),(table,0x18),(node,0x80),(clip,0x30)]:u.mem_write(a,b'\0'*n)
 call(0x99c410,obj);w(0x2d791a8,obj);w(owner+0x20,driver);w(driver+0x14,primary);w(primary+0x10,1);w(primary+0x7c,table);w(table+4,layer);w(layer+0x34,node);w(layer+0x3c,4)
 w(node,0x10c8918);w(node+0x2c,clip);w(clip+8,100);put(clip+0xc,1.);put(node+0xc,.25);put(node+0x10,speed)
 w(layer+0x5c,layer+0x30);put(layer+0x40,3.*dt*speed)
 frames=[];total=0.
 for scale in [1.,1.,0.,0.,0.,1.,1.]:
  u.mem_write(obj+0x10,struct.pack('<d',scale));call(0x99c5e0,obj+0x20,struct.pack('<d',dt))
  u.reg_write(UC_X86_REG_ESI,owner);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff)
  u.emu_start(0x878e73,0x878e8c,count=2048);assert u.reg_read(UC_X86_REG_EIP)==0x878e8c
  total+=dt*scale;weight=incoming_weight()
  assert f(node+0xc)==.25+total*speed
  assert f(layer+0x7c)==total
  complete=total>=3.*dt
  assert f(layer+0x64)==(0. if complete else total)
  assert weight==(0. if complete else struct.unpack('<f',struct.pack('<f',total/(3.*dt)))[0])
  assert read(layer+0x5c)==(0 if complete else layer+0x30)
  assert read(layer+0x34)==node
  assert read(layer+0x58)==0 and read(layer+0x68)==0
  frames.append(dict(scale=scale,node_time=f(node+0xc),layer_time=f(layer+0x7c),blend_time=f(layer+0x64),weight=weight))
 assert frames[1]['weight']==frames[4]['weight'] and frames[5]['weight']==0. and frames[5]['node_time']>frames[4]['node_time']
 rows.append(dict(speed=speed,delta=dt,frames=frames))
proof=dict(passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),cases=rows,findings=['Actual GameClock producer, driver, graph, node, layer and blend completion predicate execute together; incoming weight read via native88d750.','Three zero-scale updates freeze incoming blend; first resumed update reaches exact completion, executes890ea0 and clears layer+58/+5c/+64/+68 while retaining active node. Following update continues node time.'],limits=['Incoming-only blend duration3*dt*speed and clip100; outgoing release, queued replacement and events excluded.','Producer owner/caller remains unqualified; this is native execution evidence, not Rust integration.'])
(r/'data/4.20/animation_blend_pause_completion_contract.json').write_text(json.dumps(proof,indent=2)+'\n');print('PASS native blend pause/completion',len(rows),'sequences',sum(len(x['frames']) for x in rows),'frames')
