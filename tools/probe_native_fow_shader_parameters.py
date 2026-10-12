from pathlib import Path
import json,struct,datetime
r=Path('E:/OpenLeague');setup=(r/'tools/probe_fow_source_release.py').read_text(encoding='utf-8').split('\ncases=[]')[0];exec(compile(setup,'native FoW shader prerequisites','exec'))
shader=heap+0x1d000;native_view=shader+0x80;frame=sp+0x1000;lookups=[]
def text(ptr):return bytes(u.mem_read(ptr,100)).split(b'\0')[0].decode('ascii')
def binding(uc,a,size,user):
 if a==0x9763d0:
  top=u.reg_read(UC_X86_REG_ESP);name=text(read32(top+4));assert read32(top+8)==1 and u.reg_read(UC_X86_REG_ECX)==shader
  index=len(lookups);lookups.append(name);handle=shader+0x100+index*0x40;write32(handle+0xc,handle+0x10)
  ret=read32(top);u.reg_write(UC_X86_REG_EAX,handle);u.reg_write(UC_X86_REG_ESP,top+12);u.reg_write(UC_X86_REG_EIP,ret)
u.hook_add(unicorn.UC_HOOK_CODE,binding);write32(0x2d79034,shader);write32(0x2d78a40,native_view)
cases=[]
for name,extent,start,finish,enhance,tint in [('map10-native-default',15398.671875,-1000000.,-2000000.,0.,0.),('diagnostic-height-and-edge',1000.,.25,.75,.5,5.),('diagnostic-inverse-edge',1000.,10.,20.,2.,1.),('diagnostic-singular-edge',1000.,10.,20.,1.,0.)]:
 lookups.clear();u.mem_write(shader,bytes(0x400))
 for address,value in [(native_view+0xc,extent),(0x1223eb8,start),(0x1223eb4,finish),(0x2d78a30,enhance),(0x2d78a2c,tint)]:u.mem_write(address,struct.pack('<f',value))
 u.reg_write(UC_X86_REG_EBP,frame);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_MXCSR,0x1f80)
 u.emu_start(0x6b34f0,0x6b361f,count=20000);assert u.reg_read(UC_X86_REG_EIP)==0x6b361f
 assert lookups==['FOG_OF_WAR_PARAMS','FOW_HEIGHT_FADE','FOW_EDGE_CONTROL'],lookups
 result={key:list(struct.unpack('<4I',u.mem_read(shader+0x110+i*0x40,16))) for i,key in enumerate(lookups)}
 cases.append(dict(name=name,extent=extent,fade_start=start,fade_finish=finish,edge_enhancement=enhance,one_over_tint_point=tint,result_bits=result))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='0x6b34f0..0x6b361f',cases=cases,native_addresses=len({a for a in visited if 0x6b34f0<=a<0x6b361f}),limits=['Original SSE arithmetic and original shader parameter stores execute, including singular edge infinity; shader registry9763D0 returns explicit supplied buffers.','Original view/config constructor and GPU uniform transport not executed. Defaults from earlier actual INIBIN accessor proof; diagnostic overrides are explicit.','No live normal fog, native sampler/state, temporal fade/blur or material consumers completion claimed.'])
(r/'data/4.20/fow_shader_parameters_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(dict(cases=len(cases),native_addresses=proof['native_addresses'],map10=cases[0])))
