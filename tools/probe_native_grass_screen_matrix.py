from pathlib import Path
import struct,json,hashlib,datetime,itertools
r=Path('E:/OpenLeague')
prefix=(r/'tools/probe_native_grass_quad.py').read_text(encoding='utf-8').split('u.hook_add(')[0]
exec(compile(prefix,'native setup','exec'))
visited=set()
def capture(uc,addr,size,user):
 assert 0x980da0<=addr<=0x980f15,hex(addr)
 visited.add(addr)
u.hook_add(unicorn.UC_HOOK_CODE,capture)
u.reg_write(UC_X86_REG_FPCW,0x037f)
cases=[]
for width,height,api in itertools.product([0,1,200,803,16777217,2147483648,4294967295],[0,1,150,607,16777217,2147483648,4294967295],[0,1,2,3]):
 initial=[0x3e800000+i for i in range(16)]
 u.mem_write(manager+0x244,struct.pack('<16I',*initial))
 w(manager+0x20328,width);w(manager+0x2032c,height);w(0x1225c58,api)
 w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,manager)
 u.emu_start(0x980da0,end,count=200)
 assert u.reg_read(UC_X86_REG_EIP)==end
 actual=list(struct.unpack('<16I',u.mem_read(manager+0x244,64)))
 if api==3:assert actual==initial
 else:assert actual[15]==0x3f800000 and all(actual[i]==0 for i in [1,2,3,4,6,7,8,9,11])
 cases.append(dict(width=width,height=height,api_flag=api,initial_bits=initial,matrix_bits=actual))
constants={hex(addr):read(addr) for addr in [0x1139280,0x1138df8,0x1139320,0x11392ec,0x1138c74]}
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entry='0x980da0',matrix_offset='renderer+0x244',original_instruction_addresses=len(visited),constants_bits=constants,x87_control_word=0x037f,cases=cases,runtime_adapters=[],limits=['Original standalone screen-matrix producer executes with supplied renderer dimensions and API flag.','x87 controlword037F explicit; historical initialization and GPU matrix transpose/clip adaptation remain unqualified.','Target push/restore viewport, vertex constant upload and original vertex buffers not executed; no normal match integration.','Zero dimensions preserve native IEEE infinity outputs, not accepted as valid GPU target dimensions.'])
(r/'data/4.20/grass_screen_matrix_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(cases=len(cases),native_addresses=len(visited),constants=constants,samples=[c for c in cases if c['width']==803 and c['height']==607])))
