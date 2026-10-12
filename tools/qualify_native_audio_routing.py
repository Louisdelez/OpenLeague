"""Execute original particle backend routing with engine queue stubs."""
from pathlib import Path
import sys,json,struct,hashlib
r=Path(__file__).resolve().parents[1];sys.path.insert(0,str(r/'tools/pythonlibs'))
import pefile,capstone,unicorn
from unicorn.x86_const import UC_X86_REG_ESP,UC_X86_REG_ECX,UC_X86_REG_EIP,UC_X86_REG_EAX
c=json.loads((r/'data/4.20/ambient_audio_context.json').read_text());exe=next(p for p in Path(c['banks'][0]['path']).parents if p.name=='deploy')/'League of Legends.exe'
b=exe.read_bytes();p=pefile.PE(data=b);base=p.OPTIONAL_HEADER.ImageBase
def native(a,n):return b[p.get_offset_from_rva(a-base):][:n]
md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32)
areas=[(0x6ce270,0x6ce2ca),(0x706e60,0x706e90),(0xaeb0a0,0xaeb0d7),(0xaf6270,0xaf6284),(0xb09d90,0xb09df8),(0xb07474,0xb0748a),(0x6ce2d0,0x6ce336)]
regions=[]
for a,end in areas:
 blob=native(a,end-a);ins=list(md.disasm(blob,a));assert sum(i.size for i in ins)==len(blob)
 regions.append({'start':hex(a),'end':hex(end),'sha256':hashlib.sha256(blob).hexdigest(),'instructions':[{'address':hex(i.address),'bytes':i.bytes.hex(),'mnemonic':i.mnemonic,'operands':i.op_str} for i in ins]})
anchors={0x6cee0d:'a3a48ad702',0x928b16:'8b35a48ad702',0x928bcf:'894608',0x92083e:'8906',0x6cdcb0:'c706e4480a01',0x704b40:'c70684f30a01',0x706cb4:'c70638f30a01',0x706e77:'384508',0x706e7a:'0f94c0',0xaeb0a6:'b80e000000',0xb07480:'e80b290000',0xaf6276:'81496000000040',0xaf627d:'88410a',0x6ce2c3:'ff500c',0x6ce321:'ff5018'}
for a,data in anchors.items():assert native(a,len(data)//2).hex()==data,hex(a)
vtables=[]
for a,count in [(0x10d6e74,12),(0x10a48e4,23),(0x10af384,17),(0x10af338,11)]:
 values=list(struct.unpack('<'+'I'*count,native(a,count*4)));vtables.append({'address':hex(a),'entries':[hex(v) for v in values]})
assert vtables[1]['entries'][8]=='0x6ce270' and vtables[3]['entries'][3]=='0x706e60'
assert struct.unpack('<I',native(0xb07d78+14*4,4))[0]==0xb07474
heap=0x30000000;stack=0x31000000;tramp=0x32000000
u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);img=p.get_memory_mapped_image();u.mem_map(base,(len(img)+4095)&~4095);u.mem_write(base,img)
for a in [heap,stack,tramp]:u.mem_map(a,0x2000)
u.mem_write(tramp,b'\xf4');u.mem_write(heap+0x800,struct.pack('<4I',0,0,0,0x706e60))
def put(a,fmt,*vals):u.mem_write(a,struct.pack('<'+fmt,*vals))
calls=[];available=True
def return_call(uc,value,cleanup):
 sp=uc.reg_read(UC_X86_REG_ESP);ret=struct.unpack('<I',uc.mem_read(sp,4))[0];uc.reg_write(UC_X86_REG_EAX,value);uc.reg_write(UC_X86_REG_ESP,sp+4+cleanup);uc.reg_write(UC_X86_REG_EIP,ret)
def guard(uc,a,size,data):
 if a==0xaea6b0:return_call(uc,int(available),0);return
 if a==0x7de9b0:return_call(uc,56,0);return
 if a==0xb05ed0:
  sp=uc.reg_read(UC_X86_REG_ESP);msg,n=struct.unpack('<II',uc.mem_read(sp+4,8));assert n==56
  payload=uc.mem_read(msg,16);assert struct.unpack_from('<H',payload,2)[0]==14
  obj,mask=struct.unpack_from('<II',payload,8);calls.append({'object_id':obj,'listener_mask':mask});return_call(uc,1,8);return
 assert any(start<=a<end for start,end in areas[:4]),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,guard)
cases=[]
for raw in [0,1,2,255]:
 for found in [False,True]:
  for actor in [0,9]:
   for obj in [-1,123]:
    for available in [False,True]:
     u.mem_write(heap,b'\0'*0x800);put(heap+4,'I',heap+0x100)
     head=heap+0x100;node=heap+0x200;voice=heap+0x400
     put(head,'III',head,node if found else head,head);put(head+0xd,'B',1)
     put(node,'III',head,head,head);put(node+0x10,'II',42,voice);put(node+0x1c,'I',actor)
     put(voice,'I',heap+0x800);put(voice+8,'i',obj);put(0x14a7a28,'I',heap+0x900)
     calls.clear();put(stack+0x1800,'III',tramp,42,raw);u.reg_write(UC_X86_REG_ESP,stack+0x1800);u.reg_write(UC_X86_REG_ECX,heap)
     u.emu_start(0x6ce270,tramp,count=10000);assert u.reg_read(UC_X86_REG_EIP)==tramp
     cases.append({'disable_raw':raw,'found':found,'actor_id':actor,'object_id':obj,'engine_available':available,'calls':list(calls)})
mask_cases=[]
for mask in [0,1,127,255]:
 for dirty in [0,0x12345678,0xffffffff]:
  put(heap+0x60,'I',dirty);put(stack+0x1800,'II',tramp,mask);u.reg_write(UC_X86_REG_ESP,stack+0x1800);u.reg_write(UC_X86_REG_ECX,heap);u.emu_start(0xaf6270,tramp,count=10000)
  assert u.reg_read(UC_X86_REG_EIP)==tramp
  actual=u.mem_read(heap+0xa,1)[0];flags=struct.unpack('<I',u.mem_read(heap+0x60,4))[0];assert actual==mask and flags==dirty|0x40000000
  mask_cases.append({'input_mask':mask,'prior_dirty':dirty,'native_mask':actual,'native_dirty':flags})
limits=['Backend routing, original boolean inversion and mask storage executed; audio queue insertion stubbed. No audible playback or pause/resume equivalence implied.','Mask acts on registered audio object and associated listener routing. Symbol name SetActiveListeners inferred from native bitmask flow and contemporary official release notes; no matching debug symbols recovered.','Native voice release may post an end event before fallback action; not replaced by a pause or unconditional stop.','Native mixer virtualization/timeline while detached remains unqualified.']
result={'schema':1,'provenance':{'executable':str(exe),'sha256':hashlib.sha256(b).hexdigest(),'unicorn_version':unicorn.__version__},'cases':cases,'mask_cases':mask_cases,'limits':limits}
(r/'data/4.20/audio_routing_contract.json').write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8')
receipt={'passed':True,'native_routing_cases':len(cases),'native_mask_storage_cases':len(mask_cases),'instruction_anchors':len(anchors),'jump_table_entries':1,'regions':regions,'vtables':vtables,'provenance':result['provenance'],'limits':limits,'reference':'https://www.audiokinetic.com/files/?get=2014.1.6_5318%2FWwise_v2014.1.6_ReleaseNotes.pdf','complete':False}
(r/'docs/map_ambient_audio_routing_validation.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
print({k:v for k,v in receipt.items() if k not in ['regions','vtables','provenance','limits','reference']})
