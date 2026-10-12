"""Native particle-position routing and point-only game source packing."""
from pathlib import Path
import sys,json,struct,hashlib,itertools
r=Path(__file__).resolve().parents[1];sys.path.insert(0,str(r/'tools/pythonlibs'))
import pefile,capstone,unicorn
from unicorn.x86_const import *
c=json.loads((r/'data/4.20/audio_pcm_contract.json').read_text());b=Path(c['provenance']['executable']).read_bytes();assert hashlib.sha256(b).hexdigest()==c['provenance']['sha256'];p=pefile.PE(data=b);base=p.OPTIONAL_HEADER.ImageBase
areas=[(0x6ce200,0x6ce261),(0x706df0,0x706e52),(0xaeb1c0,0xaeb1da),(0xaeb1e0,0xaeb237)];md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32);regions=[]
for start,end in areas:
 blob=p.get_data(start-base,end-start);ins=list(md.disasm(blob,start));assert sum(i.size for i in ins)==len(blob),(hex(start),hex(end),sum(i.size for i in ins),len(blob))
 regions.append({'start':hex(start),'end':hex(end),'sha256':hashlib.sha256(blob).hexdigest(),'instructions':[{'address':hex(i.address),'bytes':i.bytes.hex(),'mnemonic':i.mnemonic,'operands':i.op_str} for i in ins]})
assert struct.unpack('<I',p.get_data(0x10a48e4+0x1c-base,4))[0]==0x6ce200
assert struct.unpack('<I',p.get_data(0x10af338+8-base,4))[0]==0x706df0
heap,stack,trap=0x30000000,0x31000000,0x32000000;u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);img=p.get_memory_mapped_image();u.mem_map(base,(len(img)+4095)&~4095);u.mem_write(base,img)
for a in [heap,stack,trap]:u.mem_map(a,0x10000)
available=True;messages=[];refresh=[]
def return_call(uc,value,cleanup):
 sp=uc.reg_read(UC_X86_REG_ESP);ret=struct.unpack('<I',uc.mem_read(sp,4))[0];uc.reg_write(UC_X86_REG_EAX,value);uc.reg_write(UC_X86_REG_ESP,sp+4+cleanup);uc.reg_write(UC_X86_REG_EIP,ret)
def hook(uc,a,n,d):
 if a==0xaea6b0:return_call(uc,int(available),0);return
 if a==0x706d70:refresh.append(True);return_call(uc,1,0);return
 if a in [0x87cd10,0xc975f5]:return_call(uc,56,0);return
 if a==0xb05ed0:
  sp=uc.reg_read(UC_X86_REG_ESP);ptr,n=struct.unpack('<II',uc.mem_read(sp+4,8));assert n==56;msg=u.mem_read(ptr,56);assert struct.unpack_from('<H',msg,2)[0]==13
  messages.append({'object_id':struct.unpack_from('<I',msg,8)[0],'position_bits':list(struct.unpack_from('<3I',msg,12)),'opaque_orientation_words':list(struct.unpack_from('<3I',msg,24))});return_call(uc,1,8);return
 assert any(x<=a<z for x,z in areas),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);cases=[]
for seed,found,actor,obj,available in itertools.product([0,0x3f800000,0x7fc00000],[False,True],[0,9],[-1,0,123],[False,True]):
 u.mem_write(heap,b'\0'*0x1000);u.mem_write(stack,struct.pack('<I',seed)*(0x10000//4));head,node,voice=heap+0x100,heap+0x200,heap+0x400
 u.mem_write(heap+4,struct.pack('<I',head));u.mem_write(head,struct.pack('<III',head,node if found else head,head));u.mem_write(head+0xd,b'\1');u.mem_write(node,struct.pack('<III',head,head,head));u.mem_write(node+0x10,struct.pack('<II',42,voice));u.mem_write(node+0x1c,struct.pack('<I',actor));u.mem_write(voice,struct.pack('<I',heap+0x800));u.mem_write(heap+0x800,struct.pack('<III',0,0x706d70,0x706df0));u.mem_write(voice+8,struct.pack('<i',obj));position=[7400.,1500.,7700.];u.mem_write(heap+0x600,struct.pack('<3f',*position));messages.clear();refresh.clear()
 sp=stack+0x8000;u.mem_write(sp,struct.pack('<III',trap,42,heap+0x600));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,heap);u.emu_start(0x6ce200,trap,count=10000);assert u.reg_read(UC_X86_REG_EIP)==trap
 expected=found and actor==0 and obj not in [-1,0] and available;assert len(messages)==int(expected);assert len(refresh)==int(found and actor==0)
 if messages:
  assert messages[0]['position_bits']==list(struct.unpack('<3I',struct.pack('<3f',*position)));assert messages[0]['opaque_orientation_words']==[seed]*3
 cases.append({'stack_seed_word':seed,'found':found,'actor_id':actor,'object_id':obj,'engine_available':available,'position':position,'messages':messages.copy(),'refresh_calls':len(refresh)})
result={'passed':True,'cases':cases,'regions':regions,'provenance':c['provenance'],'vtable_anchors':{'particle_position':'10a48e4+1c->6ce200','voice_position':'10af338+08->706df0'},'position_layout':'Queued message13: object u32 offset8, positionXYZ offset12..23, three opaque stack words offset24..35.','stubs':['AEA6B0 availability;706D70 voice refresh captures invocation;87CD10 returns message size56;C975F5 security check;B05ED0 queue captures and returns1. Native route lookup, position copier and packet formatter executed.'],'limits':['Native game routine706DF0 copies only XYZ into a six-word source structure; three following words are uninitialized local stack and vary with injected seed. No default orientation inferred.','Voice-refresh/RTPC side effects and downstream queue/object registration not executed.','No claim of emitter orientation, cone/panning behavior or audible PCM integration.'],'complete':False}
(r/'data/4.20/audio_emitter_position_contract.json').write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8');print('Native emitter positions:',len(cases),'cases;3 stack seeds; orientation tail confirmed opaque')
