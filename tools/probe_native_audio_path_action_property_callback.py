from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
action=vector+0x1000;properties=vector+0x2000;source=vector+0x3000;owner=vector+0x4000;regions=[('action',action,44),('properties',properties,48),('source',source,120),('owner',owner,60)];calls=[];freed=[];faults=[];visited=set()
def snap():return {n:bytes(u.mem_read(a,z)).hex()for n,a,z in regions}
def hook(uc,a,size,data):
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==0xada3e0:
  pool=read(sp+4);ref=read(sp+8);calls.append({'kind':'free','pool':pool,'reference':ref,'at_call':snap()});assert ref not in freed;freed.append(ref);finish(0);return
 if a==0xafe5b0:calls.append({'kind':'input_virtual9c','receiver':u.reg_read(UC_X86_REG_ECX),'selector':read(sp+4),'at_call':snap()})
 if a==0x5642d0:calls.append({'kind':'source_virtualcc','receiver':u.reg_read(UC_X86_REG_ECX),'at_call':snap()})
 assert 0xb01250<=a<0xb012b4 or 0xafe5b0<=a<0xafe64e or 0xafe9c0<=a<0xafea21 or 0xafde90<=a<0xafdf1b or a==0x5642d0,hex(a);visited.add(a)
def invalid(uc,access,address,size,value,data):faults.append({'address':address,'size':size,'value':value&0xffffffff});return False
u.hook_add(unicorn.UC_HOOK_CODE,hook);u.hook_add(unicorn.UC_HOOK_MEM_WRITE_UNMAPPED,invalid);rows=[]
for pattern,layout,ty,finished,value_bits,gate in itertools.product([0,0xa5],['regular','duplicate','zero_present','absent'],[0,1,0x100,0xff],[0,1,256,257],[0x3f800000,0x80000000,0x7fc01234],['absent','zero_wrap','one_empty','two','ffff']):
 for n,a,z in regions:u.mem_write(a,bytes([pattern])*z)
 w(action,0xff10ec);w(action+12,source);w(action+16,0 if layout=='absent'else properties);types=[0,0,1]if layout=='duplicate'else[0,1,2];count=0 if layout=='zero_present'else 3;u.mem_write(properties,bytes([count]+types));base=properties+((count+4)&~3)
 for i in range(max(count,1)):w(base+i*8,0x40000000+i);w(base+i*8+4,0xcafebabe+i)
 w(source,0xff10f0);w(source+28,0 if gate=='absent'else owner);w(source+32,0);w(source+36,0);w(source+56,0)
 for off in[0,4,12,16,36]:w(owner+off,0)
 u.mem_write(owner+48,bytes(8));u.mem_write(owner+50,({'zero_wrap':0,'one_empty':1,'two':2,'ffff':65535}.get(gate,0)).to_bytes(2,'little'));w(0x12100dc,19)
 before=snap();calls.clear();freed.clear();faults.clear();w(stack,end)
 for i,arg in enumerate([ty,value_bits,finished]):w(stack+4+i*4,arg)
 u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,action);error=None
 try:u.emu_start(0xb01250,end,count=6000)
 except unicorn.UcError as e:assert e.errno==unicorn.UC_ERR_WRITE_UNMAPPED and faults and faults[-1]['address']==0;error='native_null_property_write'
 if error is None:assert u.reg_read(UC_X86_REG_EIP)==end
 rows.append({'pattern':pattern,'layout':layout,'type_argument':ty,'finished_argument':finished,'value_bits':value_bits,'input_gate':gate,'before':before,'after':snap(),'calls':list(calls),'freed':list(freed),'fault':error,'invalid_writes':list(faults)})
d={'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'case_count':len(rows),'cases':rows,'native_addresses':len(visited),'limits':['Actual B01250 action virtual0 low-byte type/first duplicate/zero-count padding lookup, raw float publication, finished low-byte check, original Source9C owner counter/empty retirement/destructor/free, owner-pair clear AFTER input9C and actual base-class CC execute. Missing property native NULL write captured as explicit fault with partial physical state. All banks and every free/input/CC snapshot captured.','Root source FF10F0 and no parent chain/buffers supplied; actual free is ABI adapter with physical snapshots. Nonempty active source voice invalidation, real transition-owner binding/action/source producers, recursive source ancestry and full frame/playback integration remain open. Rust replay pending.']}
(r/'data/4.20/audio_path_action_property_callback_preparation.json').write_text(json.dumps(d,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'actual Action0 value publication/finished low byte/input9C/free-before-owner-clear/CC/null fault cases')
