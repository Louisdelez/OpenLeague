"""Original RTPC manager lookup, owner fallback and native curve accumulation."""
from pathlib import Path
import json,struct,itertools,hashlib
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_object_registration.py')
exec(compile(Path(__file__).read_text().split('u.hook_add(')[0],'setup','exec'))
manager=heap;binding=heap+0x2000;collision=heap+0x2100;curve_array=heap+0x3000;out=heap+0x7000
u.mem_write(trap+0x100,b'\xdb\xe3');u.mem_write(trap+0x200,b'\xd9\x1d'+struct.pack('<I',out))
calls=[];curve_ids={}
def guard(uc,a,n,d):
 if a==0xadecf0:
  sp=u.reg_read(UC_X86_REG_ESP);calls.append(dict(curve=curve_ids[u.reg_read(UC_X86_REG_ECX)],input_bits=read(sp+4,'I')[0]))
 assert any(lo<=a<hi for lo,hi in [(0xb11040,0xb11090),(0xb110a0,0xb111e1),(0xb11320,0xb113c3),(0xb1eed0,0xb1ef4e),(0xadecf0,0xadf05a),(0xadf570,0xadf587),(0xadf697,0xadf6b4),(trap+0x100,trap+0x102),(trap+0x200,trap+0x206)]),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,guard)
def invoke(address,args):
 sp=stack+0x8000;put(sp,'I',trap+0x200)
 for i,value in enumerate(args):put(sp+4+i*4,'I',value)
 u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,manager);u.emu_start(address,trap+0x206,count=20000)
rows=[];layouts=[[],[100],[100,293],[100,100,293]];states=[{}, {0:25.}, {77:75.}, {0:25.,77:75.}, {0xffffffff:50.}, {0:25.,77:75.,0xffffffff:50.}]
for found,subscriber,parameter,owner,layout,global_case,overrides,selector in itertools.product([False,True],[0x10203040,0xffffffff],[29,30],[0,77,0xffffffff],range(4),['none','both','only100'],states,[None,100,293]):
 u.mem_write(manager,bytes(0x1800));u.mem_write(binding,bytes(0x200));u.mem_write(curve_array,bytes(0x500))
 bad_subscriber=subscriber+193 if subscriber<0xffffff00 else subscriber-193
 bucket=((subscriber+parameter)&0xffffffff)%193
 put(collision,'III',bad_subscriber,parameter,binding if found else 0);put(binding,'III',subscriber,parameter,0)
 put(manager+0x614+bucket*4,'I',collision)
 curves=[];curve_ids.clear()
 for index,rtpc in enumerate(layouts[layout]):
  point=heap+0x4000+index*0x100;begin=float(index*2-5);points=[dict(from_value=0.,to=begin,interp=4),dict(from_value=100.,to=begin+10.,interp=4)]
  put(point,'ffIffI',0.,begin,4,100.,begin+10.,4)
  entry=curve_array+index*20;put(entry,'IIIII',0,rtpc,point,2,0);curve_ids[entry+8]=index
  curves.append(dict(rtpc=rtpc,scaling=0,points=[{'from':v['from_value'],'to':v['to'],'interp':v['interp']} for v in points]))
 put(binding+0x14,'II',curve_array,len(curves))
 records=[]
 for index,rtpc in enumerate([100,293]):
  if global_case=='none' or (global_case=='only100' and rtpc!=100):continue
  address=heap+0x5000+index*0x200;items=address+0x80;u.mem_write(address,bytes(0x200));default=20. if rtpc==100 else 60.
  current=read(manager+(rtpc%193)*4,'I')[0];put(address,'IIf',rtpc,current,default);put(manager+(rtpc%193)*4,'I',address)
  pairs=sorted((key,value+(0. if rtpc==100 else 10.)) for key,value in overrides.items())
  put(address+0xc,'III',items,len(pairs),len(pairs))
  for j,(key,value) in enumerate(pairs):put(items+j*8,'If',key,value)
  records.append(dict(rtpc=rtpc,default=default,overrides=[dict(owner=key,value=value) for key,value in pairs]))
 calls.clear();u.emu_start(trap+0x100,trap+0x102)
 if selector is None:invoke(0xb11040,[subscriber,parameter,owner])
 elif found:invoke(0xb110a0,[binding,owner,selector])
 else:continue
 assert u.reg_read(UC_X86_REG_EIP)==trap+0x206
 rows.append(dict(found=found,subscriber=subscriber,parameter=parameter,owner=owner,selector=selector,curves=curves,records=records,result_bits=read(out,'I')[0],calls=list(calls)))
proof=dict(passed=True,complete=False,native_sha256=hashlib.sha256(b).hexdigest(),case_count=len(rows),cases=rows,entries=['B11040','B110A0','B11320','B1EED0','ADECF0'],regions=[dict(start=hex(a),end=hex(e),sha256=hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()) for a,e in [(0xb11040,0xb11090),(0xb110a0,0xb111e1),(0xb11320,0xb113c3),(0xb1eed0,0xb1ef4e)]],adapters=['Constructed manager193-bucket tables, collision chains, sorted owner-value arrays and serialized curve records only. All lookup/fallback/interpolation/accumulation executes original code without value adapters.'],limits=['Binding creation/update/smoothing, bank ParamID mapping and real runtime ownership remain to connect.','Curve fixtures use qualified scaling0/linear4; broader curves have separate audio_curve_contract qualification.','No physical audio admission or audible runtime proof.'])
(r/'data/4.20/audio_rtpc_manager_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print('PASS',len(rows),'whole native RTPC manager cases')
