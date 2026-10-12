"""Original6F61E0 initial voice-position preparation with explicit engine query."""
from pathlib import Path
import sys,json,struct,hashlib,itertools
r=Path(__file__).resolve().parents[1];sys.path.insert(0,str(r/'tools/pythonlibs'))
import pefile,unicorn
from unicorn.x86_const import *
c=json.loads((r/'data/4.20/ambient_audio_context.json').read_text());e=next(p for p in Path(c['banks'][0]['path']).parents if p.name=='deploy')/'League of Legends.exe';raw=e.read_bytes();digest=hashlib.sha256(raw).hexdigest();assert digest=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
p=pefile.PE(data=raw);u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);img=p.get_memory_mapped_image();u.mem_map(0x400000,(len(img)+4095)&~4095);u.mem_write(0x400000,img)
heap=0x30000000;stack=0x31000000;end=0x32000000
for a in [heap,stack,end]:u.mem_map(a,0x10000)
query=end+0x100;u.mem_write(query,b'\xc3');u.mem_write(0x2d78b98,struct.pack('<I',heap+0x400));u.mem_write(heap+0x400,struct.pack('<I',heap+0x500));u.mem_write(heap+0x570,struct.pack('<I',query));queries=0;enabled=False
def hook(uc,a,size,user):
 global queries
 if a==query:
  queries+=1;sp=u.reg_read(UC_X86_REG_ESP);target=struct.unpack('<I',u.mem_read(sp,4))[0];u.reg_write(UC_X86_REG_EAX,int(enabled));u.reg_write(UC_X86_REG_ESP,sp+4);u.reg_write(UC_X86_REG_EIP,target);return
 assert 0x6f61e0<=a<0x6f62b6,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
maximum=struct.unpack('<f',p.get_data(0x1139294-0x400000,4))[0];assert maximum==struct.unpack('<f',bytes.fromhex('ffff7f7f'))[0]
positions=[[1.,2.,3.],[maximum]*3,[maximum,2.,3.],[1.,maximum,3.],[1.,2.,maximum],[1.,-0.,3.]];cases=[]
for position,mode,enabled,height in itertools.product(positions,[0,1,255],[False,True],[500.,1250.]):
 u.mem_write(heap,struct.pack('<fff',*position));u.mem_write(0x2d78bac,struct.pack('<f',height));u.mem_write(heap+0x100,b'\xa5'*12)
 sp=stack+0x8000;u.mem_write(sp,struct.pack('<II',end,mode));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_EDX,heap);u.reg_write(UC_X86_REG_ECX,heap+0x100);queries=0
 u.emu_start(0x6f61e0,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
 bits=list(struct.unpack('<III',u.mem_read(heap+0x100,12)));expected=position.copy();all_sentinel=position==[maximum]*3
 if not all_sentinel:
  if mode==0:expected[1]=-2500.
  elif enabled:expected[1]=height
 assert bits==list(struct.unpack('<III',struct.pack('<fff',*expected)))
 assert queries==int(not all_sentinel and mode!=0)
 cases.append({'input_bits':list(struct.unpack('<III',struct.pack('<fff',*position))),'mode_raw':mode,'engine_height_override':enabled,'height_bits':struct.unpack('<I',struct.pack('<f',height))[0],'output_bits':bits,'engine_queries':queries})
proof={'passed':True,'cases':cases,'native_sha256':digest,'sentinel_bits':0x7f7fffff,'limits':['Original6F61E0 executed. Engine virtual70 query adapted; global2D78BAC set to explicit test heights. Actual initialization/runtime meaning of this height policy still unqualified.','Finite inputs including all/partial maximum-float sentinel and signed-zero tested; NaN/infinite native behavior not qualified.','Position preparation only; no event posting, actual voice playback, resampling or full physical factory acceptance.'],'complete':False}
(r/'data/4.20/audio_voice_position_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('Original voice-position72 cases passed')
