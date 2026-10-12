"""Native routing gate/context allocation/constructor; AF1900 consumer explicitly adapted."""
from pathlib import Path
import json,struct,itertools,hashlib
r=Path(__file__).resolve().parents[1];__file__=str(r/'tools/qualify_native_audio_object_registration.py');exec(compile(Path(__file__).read_text().split('u.hook_add(')[0],'setup','exec'))
voice=heap+0x1000;sound=heap+0x2000;manager=heap+0x3000;optional=heap+0x4000;context=heap+0x5000;eligibility=heap+0x6000;vtable=heap+0x7000
regions=[(0xaef360,0xaef40c),(0xb15530,0xb1555d),(0xafeb10,0xafeb1b),(0xb1ad70,0xb1ade0),(0xb1aa50,0xb1aaf5)]
calls=[];allocation_fail=False

def hook(uc,a,n,d):
 if a==0xada610:
  pool,size,alignment=read(u.reg_read(UC_X86_REG_ESP)+4,'III');calls.append({'kind':'allocate','size':size,'alignment':alignment});ret(0 if allocation_fail else context,0);return
 if a==trap+0x100:
  ctx,source,owner,last=read(u.reg_read(UC_X86_REG_ESP)+4,'IIII');calls.append({'kind':'context_consumer','context':ctx,'source':source,'owner':owner,'last':last});ret(1,16);return
 assert any(lo<=a<hi for lo,hi in regions),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
rows=[]
for present,outputs,eligible,flags,existing,packed,mask,has_optional,allocation_fail in itertools.product([False,True],[[],[0],[0,0x80000000]],[None,0,7],[0x15,0x95],[False,True],[0,5,15],[0,8,3,0x10001],[False,True],[False,True]):
 u.mem_write(heap,bytes(0x8000));u.mem_write(context,b'\xa5'*0x1000);calls.clear();put(0x14a7e4c,'I',manager if present else 0);put(manager+0x4d,'B',len(outputs))
 for i,v in enumerate(outputs):put(manager+0x10+i*12,'I',v)
 put(voice+0x60,'IIII',sound,0xabcdef,77,optional if has_optional else 0);put(voice+0x74,'I',mask);put(optional+0x128,'I',mask);put(voice+0x12b,'B',packed);put(voice+0x12e,'B',flags);put(voice+0x18c,'I',context if existing else 0)
 put(sound,'I',vtable);put(vtable+0x108,'I',0xafeb10);put(vtable+0x100,'I',trap+0x100);put(sound+0x38,'I',eligibility if eligible is not None else 0);put(eligibility,'I',eligible or 0)
 sp=stack+0x8000;put(sp,'I',trap);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,voice);u.emu_start(0xaef360,trap,count=10000);assert u.reg_read(UC_X86_REG_EIP)==trap
 result=read(voice+0x18c,'I')[0]
 gate=present and any(outputs);attempt=gate and not existing and (bool(eligible) or flags&0x80!=0);channels=mask&0xfffffff7;allocate=attempt and channels!=0;created=allocate and not allocation_fail
 assert result==(context if existing or created else 0)
 assert read(voice+0x12e,'B')[0]==(flags|0x40 if gate else flags)
 expected=[]
 if allocate:
  multiplier=len(outputs) if packed&3==1 and (packed>>2)&3==1 else 1
  expected.append({'kind':'allocate','size':((multiplier*channels.bit_count()-1)*64+112)&0xffffffff,'alignment':16})
 if gate and result:expected.append({'kind':'context_consumer','context':context,'source':0xabcdef,'owner':77,'last':1})
 assert calls==expected
 prefix=bytearray(b'\xa5'*48)
 if created:
  for offset in range(0,24,4):struct.pack_into('<I',prefix,offset,0)
  for offset in range(24,40,4):struct.pack_into('<I',prefix,offset,0x3f800000)
  struct.pack_into('<I',prefix,40,0)
  struct.pack_into('<H',prefix,44,mask&0xfff7)
  header=(0xa5a5&~0x70)|((multiplier<<4)&0x70)
  header=(header&0xfff0)|((mask&0xfff7).bit_count()&15)|0x80
  struct.pack_into('<H',prefix,46,header)
 assert bytes(u.mem_read(context,48))==bytes(prefix)
 rows.append({'manager_present':present,'outputs':outputs,'eligibility':eligible,'flags':flags,'existing':existing,'packed':packed,'mask':mask,'optional':has_optional,'allocation_fail':allocation_fail,'context_reference':context,'result_reference':result,'result_flags':read(voice+0x12e,'B')[0],'context_prefix':bytes(u.mem_read(context,48)).hex() if result else None,'calls':calls.copy()})
proof={'complete':False,'passed':True,'case_count':len(rows),'cases':rows,'native_sha256':hashlib.sha256(b).hexdigest(),'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()} for a,e in regions],'adapters':['Only allocator result and AF1900 context consumer are explicit adapters. Original AEF360/B15530/AFEB10/B1AD70/B1AA50 execute unchanged. Allocator returns aligned A5-filled memory or null; native constructor prefix captured.'],'limits':['AF1900 consumer is not exercised here; existing inherited controls port remains to connect to routing context. Physical device routing remains open. Constructed snapshots do not prove normal runtime ownership/allocation/lifecycle.']}
(r/'data/4.20/audio_routing_context_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'native routing/context creation cases')
