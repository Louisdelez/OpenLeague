from pathlib import Path
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
import struct,itertools,json,hashlib
source=vector+0x1000;manager=vector+0x3000;binding=vector+0x6000;collision=vector+0x6100;curves=vector+0x7000;points=vector+0x8000
regions=[('source',source,120),('manager',manager,0x1800),('binding',binding,32),('collision',collision,32),('curves',curves,80),('points',points,48)]
def snapshot():return {n:bytes(u.mem_read(a,z)).hex()for n,a,z in regions}
calls=[];visited=set()
def hook(uc,a,z,data):
 if a==0xb11040:
  sp=u.reg_read(UC_X86_REG_ESP);calls.append({'kind':'rtpc_manager','receiver':u.reg_read(UC_X86_REG_ECX),'arguments':[read(sp+4),read(sp+8),read(sp+12)],'at_call':snapshot()})
 if a==0xadecf0:
  sp=u.reg_read(UC_X86_REG_ESP);calls.append({'kind':'curve','receiver':u.reg_read(UC_X86_REG_ECX),'input_bits':read(sp+4),'at_call':snapshot()})
 assert 0xaff3d0<=a<0xaff429 or 0xb11040<=a<0xb11090 or 0xb110a0<=a<0xb111e1 or 0xb11320<=a<0xb113c3 or 0xb1eed0<=a<0xb1ef4e or 0xadecf0<=a<0xadf05a,hex(a)
 visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
layouts=[[],[0x3f800000],[0x3f800000,0xb3000000],[0xbf800000,0x33000000],[0x47800000,0xbb000000],[0x7f800000],[0xff800000],[0x7fc00000],[0x7f7fffff],[0x3f800000,0xbf800000,0x3f7fffff,0x33800000]]
rows=[]
for pattern,static_type,dynamic,found,values in itertools.product([0,0xa5],[0,1,65535],[0,0x200],[False,True],layouts):
 for n,a,z in regions:u.mem_write(a,bytes([pattern])*z)
 u.mem_write(manager,bytes(0x1800));u.mem_write(curves,bytes(80));u.mem_write(points,bytes(48));w(source,0xff1cd8);u.mem_write(source+44,struct.pack('<H',static_type));w(source+48,dynamic)
 w(binding,source);w(binding+4,9);w(binding+8,0);w(binding+20,curves);w(binding+24,len(values));w(collision,source+193);w(collision+4,9);w(collision+8,binding if found else 0);w(manager+0x614+((source+9)%193)*4,collision)
 for i,value in enumerate(values):
  at=curves+i*20;point=points+i*12;w(at,0);w(at+4,100+i);w(at+8,point);w(at+12,1);w(at+16,0);w(point,0);w(point+4,value);w(point+8,4)
 w(0x14a7a3c,manager);u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80);calls.clear();before=snapshot();w(stack,end);w(stack+4,0);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,source);u.emu_start(0xaff3d0,end,count=15000);assert u.reg_read(UC_X86_REG_EIP)==end;assert u.reg_read(UC_X86_REG_FPCW)==0x037f
 rows.append({'pattern':pattern,'static_type':static_type,'flags':dynamic,'found':found,'constant_curve_bits':values,'result':u.reg_read(UC_X86_REG_EAX)&65535,'before':before,'after':snapshot(),'calls':list(calls)})
proof={'passed':True,'complete':False,'case_count':len(rows),'native_sha256':hashlib.sha256(raw).hexdigest(),'regions':[{'name':n,'reference':a,'size':z}for n,a,z in regions],'native_addresses':len(visited),'floating_control':{'x87_control_word':895,'mxcsr':8064},'cases':rows,'limits':['Actual AFF3D0 -> B11040/B110A0/B11320/ADECF0 and final towards-zero retained-x87 FISTP/low16 execute without callback/value adapters. Constructed193-bucket manager bindings and first collision, missing/found binding,0..4 one-point constant scaling0 curves and absent RTPC records supplied. Static type/flag gates, finite near-integer cancellation, overflow/NaN/Inf and low16 truncation captured.','Owner/global overrides, interpolation/scaling curves, resource/bank producers, startup and actual owner60/input98 composition remain to qualify. Explicit FPcontrols supplied; actual source selector restores its caller x87 control word. Rust replay pending.']}
(r/'data/4.20/audio_dynamic_input_owner_selector_preparation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'actual dynamic selector/RTPC/retained-x87 FISTP cases')
for row in rows:
 if row['pattern']==0 and row['static_type']==1 and row['flags']==512 and row['found'] and row['constant_curve_bits']in[[0x3f800000,0xb3000000],[0xbf800000,0x33000000]]:print(row['constant_curve_bits'],'native low16=',row['result'])
