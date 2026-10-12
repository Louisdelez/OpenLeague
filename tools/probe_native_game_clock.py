from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
obj=vector+0x6000;mode=vector+0x7000;out=vector+0x8000;thunk=vector+0x9000
w(0x2d79104,mode);w(mode+0x10,0)
def call(address,receiver,args=b''):
 w(stack,end);u.mem_write(stack+4,args or b'\0'*8);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,receiver);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.emu_start(address,end,count=300);assert u.reg_read(UC_X86_REG_EIP)==end

def getter(address):
 entry=thunk+(0x20 if address==0x6416e0 else 0)
 u.mem_write(entry,b'\xe8'+struct.pack('<i',address-entry-5)+b'\xdd\x1d'+struct.pack('<I',out)+b'\xc3');call(entry,obj);return bytes(u.mem_read(out,8)).hex()
rows=[]
for scale,start,dt in itertools.product([0.,.5,1.,2.],[0.,.125,4096.],[0.,1/64,.125,1.,2.]):
 u.mem_write(obj,b'\0'*0x50);call(0x99c410,obj);assert read(obj)==0x10deb08 and read(obj+0x20)==0x10dea8c
 u.mem_write(obj+0x10,struct.pack('<d',scale));u.mem_write(obj+0x2c,struct.pack('<f',start));frames=[];expected=start
 for _ in range(8):
  call(0x99c5e0,obj+0x20,struct.pack('<d',dt));expected=struct.unpack('<f',struct.pack('<f',expected+dt*scale))[0]
  assert struct.unpack('<f',u.mem_read(obj+0x2c,4))[0]==expected
  assert struct.unpack('<f',u.mem_read(obj+0x30,4))[0]==dt*scale
  frames.append(dict(time_bits=read(obj+0x2c),delta_bits=read(obj+0x30),virtual4_f64=getter(0x99c4e0),virtual8_f64=getter(0x6416e0)))
 rows.append(dict(scale=scale,start=start,delta=dt,frames=frames))
proof=dict(complete=False,passed=True,native_sha256=hashlib.sha256(raw).hexdigest(),constructor='0x99c410',update='0x99c5e0',receiver_offset='0x20',vtable='0x10deb08',cases=rows,limits=['Normal mode only: global2D79104 flags1000000 cleared, callback null.','Source delta supplied; scheduler, wall-time resynchronization, callback and native pause controller not yet qualified.','Exact dyadic finite arithmetic profiles.'])
(r/'data/4.20/game_clock_source_contract.json').write_text(json.dumps(proof,indent=2)+'\n');print(json.dumps({'passed':True,'sequences':len(rows),'native_frames':sum(len(x['frames']) for x in rows)}))
