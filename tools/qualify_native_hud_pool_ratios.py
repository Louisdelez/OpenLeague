from pathlib import Path
import struct,json,hashlib,datetime,math,itertools
exec(Path('E:/OpenLeague/tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0])
actor=vector+0x6000;owner=vector+0x8000;frame=stack-0x1000;w(actor+0x124,vt);w(vt+4,end)
def f32(x):return struct.unpack('<f',struct.pack('<f',x))[0]
def bits(x):return struct.unpack('<I',struct.pack('<f',x))[0]
visited=set()
def hook_code(uc,address,length,unused):
 assert 0x7d6ec4<=address<0x7d6f79 or 0x7d736d<=address<0x7d7397 or 0x7d7572<=address<0x7d759b,hex(address)
 visited.add(address)
u.hook_add(unicorn.UC_HOOK_CODE,hook_code)
u.reg_write(UC_X86_REG_MXCSR,0x1f80)
cases=[]
for current,maximum,matched in itertools.product([0,0.001,0.5,0.999,1,1.001,12.5,123.75,334,999.9],[1,12.5,300.25,334.0,1000.9],[True,False]):
 c,m=f32(current),f32(maximum)
 w(actor+0x1a8,2);w(actor+0x1ac,bits(c));w(actor+0x1bc,bits(m))
 u.reg_write(UC_X86_REG_ECX,actor);u.reg_write(UC_X86_REG_ESI,2 if matched else 3);u.reg_write(UC_X86_REG_EBP,frame);u.reg_write(UC_X86_REG_ESP,stack)
 u.reg_write(UC_X86_REG_XMM5,bits(8388608.0));u.reg_write(UC_X86_REG_XMM6,0x80000000)
 u.emu_start(0x7d6ec4,0x7d6f79,count=150);assert u.reg_read(UC_X86_REG_EIP)==0x7d6f79
 ci,mi=read(frame-0x18),u.reg_read(UC_X86_REG_ESI)
 assert (ci,mi)==(math.floor(c),math.floor(m)) if matched else (ci,mi)==(0,0)
 cases.append(dict(current_f32=c,maximum_f32=m,resource_type_matches=matched,current_integer=ci,maximum_integer=mi))
ratios=[]
for kind,pairs in [('health',[(0,514.4),(.001,514.4),(123.75,456.5),(514.4,514.4),(616.6,1000.1)]),('mana',[(0,334),(12.5,300.25),(123.75,456.5),(334,334),(616.6,1000.1)])]:
 for current,maximum in pairs:
  c,m=f32(current),f32(maximum);ci=math.ceil(c) if kind=='health' else math.floor(c);mi=math.ceil(m) if kind=='health' else math.floor(m)
  u.reg_write(UC_X86_REG_EDI,owner);u.reg_write(UC_X86_REG_EBP,frame);u.reg_write(UC_X86_REG_ESP,stack)
  if kind=='health':
   w(frame-0x30,mi);u.reg_write(UC_X86_REG_ESI,ci);start,stop,out=0x7d7572,0x7d759b,owner+0x68c
  else:
   u.reg_write(UC_X86_REG_ECX,ci);u.reg_write(UC_X86_REG_ESI,mi);start,stop,out=0x7d736d,0x7d7397,owner+0x694
  u.emu_start(start,stop,count=50);assert u.reg_read(UC_X86_REG_EIP)==stop
  actual=read(out);expected=bits(f32(f32(ci)/f32(mi)));assert actual==expected
  ratios.append(dict(kind=kind,current_f32=c,maximum_f32=m,current_integer=ci,maximum_integer=mi,fraction_bits=actual))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),resource_conversion_slice=['0x7d6ec4','0x7d6f79'],health_fraction_slice=['0x7d7572','0x7d759b'],mana_fraction_slice=['0x7d736d','0x7d7397'],case_count=len(cases)+len(ratios),native_addresses=len(visited),conversions=cases,ratios=ratios,findings=['Matching resource type: positive finite mana values floor to signed integers; mismatching type supplies zero counters.','Health bar fraction divides ceil current by ceil maximum. Mana bar fraction divides floor current by floor maximum. Both native scalar f32 divisions compared bit-for-bit.'],limits=['Original instruction slices executed with supplied actor fields/register context. Native actor accessors, resource enum production, death flags, renderer callbacks and full HUD caller remain open.','Only positive finite ordinary pools tested. Native out-of-range behavior, zero-capacity display branch and special resources remain open.','Captured frame and gameplay integration require separate qualification.'])
(r/'data/4.20/native_hud_pool_ratios_contract.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(cases=proof['case_count'],native_addresses=len(visited),passed=True)))
