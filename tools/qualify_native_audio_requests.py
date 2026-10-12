"""Bounded native particle sound request callbacks; backend is explicitly stubbed."""
from pathlib import Path
import sys,json,struct,hashlib
r=Path(__file__).resolve().parents[1];sys.path.insert(0,str(r/'tools/pythonlibs'))
import pefile,capstone,unicorn
from unicorn.x86_const import UC_X86_REG_ESP,UC_X86_REG_ECX,UC_X86_REG_EIP,UC_X86_REG_EAX
ctx=json.loads((r/'data/4.20/ambient_audio_context.json').read_text())
exe=next(p for p in Path(ctx['banks'][0]['path']).parents if p.name=='deploy')/'League of Legends.exe'
raw=exe.read_bytes();pe=pefile.PE(data=raw);base=pe.OPTIONAL_HEADER.ImageBase
assert pe.FILE_HEADER.Machine==0x14c
md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32)
regions=[]
for start,end in [(0x93ed60,0x93ee2e),(0x93ee30,0x93eedd),(0x9214f0,0x921dd7)]:
 off=pe.get_offset_from_rva(start-base);blob=raw[off:off+end-start];ins=list(md.disasm(blob,start));assert sum(i.size for i in ins)==len(blob)
 regions.append({'start':hex(start),'end':hex(end),'sha256':hashlib.sha256(blob).hexdigest(),'instructions':[{'address':hex(i.address),'bytes':i.bytes.hex(),'mnemonic':i.mnemonic,'operands':i.op_str} for i in ins]})
anchors={0x93ed63:'83beac010000ff',0x93ed6c:'83be8c01000000',0x93ed85:'f30f5c86a8000000',0x93eda0:'ff5210',0x93edab:'8986ac010000',0x93ee37:'f687dc01000020',0x93ee64:'766b',0x93ee8c:'ff5218',0x93eed1:'808fdc01000020',0x921573:'ff5214',0x921746:'ff5018',0x921993:'ff501c',0x9219b3:'ff5020',0x921cd8:'ff5024'}
for va,data in anchors.items():assert raw[pe.get_offset_from_rva(va-base):][:len(data)//2].hex()==data,hex(va)
particles=[]
for p in sorted((r/'data/4.20/particles').glob('Audio-Emitter_*.json')):
 x=json.loads(p.read_text());assert hashlib.sha256(Path(x['native_file']).read_bytes()).hexdigest()==x['source_sha256']
 s=x['sections']['System'];assert not s.get('SoundOnDestroy')
 particles.append({'asset':p.name,'source_sha256':x['source_sha256'],'create':s.get('SoundOnCreate',''),'persistent':s.get('SoundPersistent','')})
assert len(particles)==5
heap=0x30000000;stack=0x31000000;tramp=0x32000000
u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);img=pe.get_memory_mapped_image();u.mem_map(base,(len(img)+4095)&~4095);u.mem_write(base,img)
for a in [heap,stack,tramp]:u.mem_map(a,0x1000)
u.mem_write(tramp+0x100,b'\xdb\xe3')
calls=[];answer=42
def guard(uc,addr,size,user):
 if addr in [tramp+0x10,tramp+0x18]:
  sp=uc.reg_read(UC_X86_REG_ESP);ret,string,pos,age=struct.unpack('<IIIf',uc.mem_read(sp,16))
  assert string in [heap+0x14c,heap+0x17c] and pos==heap+0x90
  calls.append({'slot':addr-tramp,'event':event_names[string],'position':list(struct.unpack('<fff',uc.mem_read(pos,12))),'age':age})
  uc.reg_write(UC_X86_REG_EAX,answer&0xffffffff);uc.reg_write(UC_X86_REG_ESP,sp+16);uc.reg_write(UC_X86_REG_EIP,ret);return
 assert 0x93ed60<=addr<0x93ee2e or 0x93ee30<=addr<0x93eedd or tramp+0x100<=addr<tramp+0x102,hex(addr)
u.hook_add(unicorn.UC_HOOK_CODE,guard)
cases=[]
sequences=[('normal',[('create',0.0,0.0),('create',0.25,0.0),('persistent',0.25,0.0),('persistent',2.0,0.0)]),('boundary',[('create',1.0,0.0),('create',0.0,0.0),('persistent',1.0,0.0)]),('late',[('create',1.001,0.0),('persistent',5.0,0.0)]),('negative_age',[('create',2.0,3.0),('persistent',2.0,3.0)]),('rounding',[('create',1000000.5,1000000.0),('persistent',1000000.5,1000000.0)])]
for particle in particles:
 for name,seq in sequences:
  for answer in [42,0,-1]:
   u.mem_write(heap,b'\0'*0x1000);u.mem_write(heap,struct.pack('<I',heap+0x400));u.mem_write(heap+0x404,struct.pack('<I',heap+0x500))
   for slot in [0x10,0x18]:u.mem_write(heap+0x500+slot,struct.pack('<I',tramp+slot));u.mem_write(tramp+slot,b'\xc3')
   for offset,event in [(0x14c,particle['create']),(0x17c,particle['persistent'])]:u.mem_write(heap+offset+16,struct.pack('<I',len(event)))
   u.mem_write(heap+0x1ac,struct.pack('<ii',-1,-1));event_names={heap+0x14c:particle['create'],heap+0x17c:particle['persistent']}
   calls.clear();steps=[]
   for method,clock,birth in seq:
    position=[100.0+len(steps),-2.0,45.0];u.mem_write(heap+0x90,struct.pack('<fff',*position));u.mem_write(heap+0xa8,struct.pack('<f',birth));u.mem_write(heap+0xb0,struct.pack('<f',clock))
    u.emu_start(tramp+0x100,tramp+0x102);u.mem_write(stack+0xf00,struct.pack('<I',tramp));u.reg_write(UC_X86_REG_ESP,stack+0xf00);u.reg_write(UC_X86_REG_ECX,heap)
    u.emu_start(0x93ed60 if method=='persistent' else 0x93ee30,tramp,count=10000);assert u.reg_read(UC_X86_REG_EIP)==tramp
    steps.append({'method':method,'clock':clock,'birth':birth,'position':position})
   cases.append({'asset':particle['asset'],'sequence':name,'returned_handle':answer,'steps':steps,'calls':list(calls),'final_handle':struct.unpack('<i',u.mem_read(heap+0x1ac,4))[0],'creation_checked':bool(u.mem_read(heap+0x1dc,1)[0]&32)})
result={'schema':1,'particles':particles,'cases':cases,'provenance':{'executable':str(exe),'sha256':hashlib.sha256(raw).hexdigest(),'unicorn_version':unicorn.__version__},'limits':['Original request functions executed; audio backend callbacks stubbed. No audible playback, voice lifetime, mixer, listener or full game acceptance.','Secondary persistent actor sound and SoundOnDestroy excluded: absent from the five native ambient emitter systems covered here.','Boolean backend update is distinct from release. Its audible pause/resume semantics remain unqualified.']}
(r/'data/4.20/audio_request_contract.json').write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8')
receipt={'passed':True,'native_request_cases':len(cases),'native_request_steps':sum(len(c['steps']) for c in cases),'native_instruction_anchors':len(anchors),'regions':regions,'provenance':result['provenance'],'limits':result['limits'],'complete':False}
(r/'docs/map_ambient_audio_request_validation.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
print({k:v for k,v in receipt.items() if k not in ['regions','provenance','limits']})
