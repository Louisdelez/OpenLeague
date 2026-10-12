"""Original gain-entry lookup/replace/append AE EBB0 + AE D0B0."""
from pathlib import Path
import json,struct,itertools,hashlib
r=Path(__file__).resolve().parents[1];__file__=str(r/'tools/qualify_native_audio_object_registration.py');exec(compile(Path(__file__).read_text().split('u.hook_add(')[0],'setup','exec'))
vector=heap+0x1000;array=heap+0x2000;regions=[(0xaeebb0,0xaeec4f),(0xaed0b0,0xaed0f9)]
def guard(uc,a,n,d):assert any(lo<=a<hi for lo,hi in regions),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,guard)
rows=[]
for existing,key,flags,bits in itertools.product([False,True],[0,101,202,303,404,0xffffffff],[0,1,2,3,0xa4,0xa5,0xffffffff],[0,0x80000000,0x3f000000,0x3f800000,0x40000000]):
 before=[] if not existing else [{'id':101,'flags':0xa4,'gain_bits':0x3f000000},{'id':202,'flags':3,'gain_bits':0x3f800000},{'id':101,'flags':1,'gain_bits':0x40000000},{'id':303,'flags':0,'gain_bits':0x40400000}]
 u.mem_write(array,bytes(16*12));put(vector,'III',array,len(before),16)
 for i,e in enumerate(before):put(array+i*12,'III',e['id'],e['flags'],e['gain_bits'])
 expected=[dict(v) for v in before];index=next((i for i,v in enumerate(expected) if v['id']==key and (v['flags']^flags)&1==0),len(expected))
 if index==len(expected):expected.append({'id':key,'flags':flags,'gain_bits':bits})
 else:expected[index]['gain_bits']=bits
 sp=stack+0x8000;put(sp,'IIII',trap,key,flags,bits);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,vector);u.emu_start(0xaeebb0,trap,count=10000);assert u.reg_read(UC_X86_REG_EIP)==trap and read(vector+4,'I')[0]==len(expected);assert u.reg_read(UC_X86_REG_EAX)==array+index*12+8
 after=[{'id':read(array+i*12,'I')[0],'flags':read(array+i*12+4,'I')[0],'gain_bits':read(array+i*12+8,'I')[0]} for i in range(len(expected))];assert after==expected
 rows.append({'before':before,'id':key,'flags':flags,'gain_bits':bits,'after':after,'selected_index':index})
proof={'passed':True,'complete':False,'case_count':len(rows),'cases':rows,'native_sha256':hashlib.sha256(b).hexdigest(),'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()} for a,e in regions],'adapters':['Original lookup and gain write/append execute unchanged. No consumer result adapters; only constructed valid vector with spare capacity. Key matches exact id and flags bit0 only; replaces gain in first match while preserving old flags, otherwise appends full incoming flags.'],'limits':['Vector allocation/growth/failure/destruction not exercised. Native actor/bus caller state10 flag construction and whole refresh gain consumption remain to integrate.']}
(r/'data/4.20/audio_gain_entries_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'original gain-entry lookup/replace/append cases')
