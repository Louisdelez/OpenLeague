from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
owner=vector+0x1000;bindings=vector+0x2000;actions=vector+0x3000;vtable=vector+0x4000;callback=vector+0x1f000
regions=[('owner',owner,56),('bindings',bindings,12),('actions',actions,88)]
def snap():return {n:bytes(u.mem_read(a,z)).hex()for n,a,z in regions}
calls=[];visited=set()
def hook(uc,a,size,data):
 if a==callback:
  sp=u.reg_read(UC_X86_REG_ESP);calls.append({'kind':'action_virtual0','receiver':u.reg_read(UC_X86_REG_ECX),'arguments':[read(sp+4),read(sp+8),read(sp+12)&255],'at_call':snap()});finish(0,12);return
 assert 0xb20ee0<=a<0xb21038 or 0xadf570<=a<0xadf7ac,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[]
timings=[('before',24,40,0),('start',24,40,24),('first',24,40,25),('middle',24,40,44),('last',24,40,63),('end',24,40,64),('after',24,40,200),('zero_duration',24,0,24),('wrapped_end_before',0xfffffff0,32,5),('wrapped_end_at_start',0xfffffff0,32,0xfffffff0),('wrapped_end_at_end',0xfffffff0,32,16),('zero_before',24,0,23),('large_unsigned_duration',0,0xffffffff,0x7ffffff0)]
values=[('zero',0,0x80000000),('rise',0xbf800000,0x40400000),('fall',0x40000000,0xbf800000),('tiny',0x0da24260,0x0554ad2e),('nan',0x7fc01234,0x3f800000),('infinity',0x7f800000,0xff800000)]
for pattern,flags,timing,curve,value,count in itertools.product([0,0xa5],[0,1,2,3],timings,list(range(10))+[0xffffffff],values,[0,3]):
 for n,a,z in regions:u.mem_write(a,bytes([pattern])*z)
 name,start,duration,time=timing;value_kind,initial,target=value
 for off,v in[(0,5),(4,initial),(8,target),(12,0x3f000000),(16,start),(20,duration),(24,0x3e800000),(28,123),(32,bindings),(36,count),(40,3),(44,curve),(48,1)]:w(owner+off,v)
 u.mem_write(owner+52,bytes([(pattern&0xfc)|flags,3]));w(bindings,actions);w(bindings+4,actions+44);w(bindings+8,actions);w(actions,vtable);w(actions+44,vtable);w(vtable,callback)
 u.reg_write(UC_X86_REG_FPCW,0x037f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80);before=snap();calls.clear();w(stack,end);w(stack+4,time);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,owner);u.emu_start(0xb20ee0,end,count=5000);assert u.reg_read(UC_X86_REG_EIP)==end
 rows.append({'pattern':pattern,'flags':flags,'timing':name,'start':start,'duration':duration,'time':time,'curve':curve,'value_kind':value_kind,'initial_bits':initial,'target_bits':target,'binding_count':count,'before':before,'after':snap(),'calls':list(calls),'finished':u.reg_read(UC_X86_REG_EAX)&255})
import capstone
md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32);md.detail=True;addresses=set()
for address,size in[(0xadf570,0xadf7ac-0xadf570),(0xb20ee0,0xb21038-0xb20ee0)]:
 for i in md.disasm(bytes(u.mem_read(address,size)),address):
  for op in i.operands:
   if op.type==capstone.x86_const.X86_OP_MEM and op.mem.base==0 and op.mem.index==0:addresses.add(op.mem.disp)
constants={hex(a):hex(read(a))for a in sorted(addresses)}
d={'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'case_count':len(rows),'cases':rows,'native_addresses':len(visited),'floating_control':{'x87_control_word':895,'mxcsr':8064},'curve_dispatch':[hex(read(0xadf7ac+i*4))for i in range(9)],'constants':constants,'functions_sha256':{hex(a):hashlib.sha256(bytes(u.mem_read(a,z))).hexdigest()for a,z in[(0xadf570,0xadf7ac-0xadf570),(0xb20ee0,0xb21038-0xb20ee0)]},'limits':['Actual B20EE0 owner unsigned timing/wrap, ADF570 all9 curves plus default, retained x87 interpolation, native inverse gain conversion, current value/flags, empty and duplicate3-binding propagation execute. Full owner/binding/action memory and each callback snapshot compared.','Action virtual0 is a controlled ABI callback without mutations; finish low byte compared, native stack upper bytes excluded. Explicit PC64 nearest037f/MXCSR1f80 supplied. Mutable binding/owner callbacks, game floating-state producer, real frame/clock/creation/attachment/output and Rust replay remain open.']}
(r/'data/4.20/audio_property_owner_progression_preparation.json').write_text(json.dumps(d,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'actual owner progression/9 curves/unsigned wrap/inverse gain/callback physical cases; dispatch',d['curve_dispatch'],'constants',constants)
