from pathlib import Path
import json,struct,hashlib,datetime
r=Path('E:/OpenLeague')
prefix=(r/'tools/probe_native_grass_quad.py').read_text(encoding='utf-8').split('u.hook_add(')[0]
exec(compile(prefix,'native setup','exec'));u.mem_map(0,0x1000)
storage=a+0x9000;visited=set();reserves=[]
def capture(uc,addr,size,user):
 if addr==0x5c3e00:
  vector=u.reg_read(UC_X86_REG_ECX);capacity=args(1)[0];assert capacity<=8
  begin=read(vector);used=read(vector+4)-begin if begin else 0
  w(vector,storage);w(vector+4,storage+used);w(vector+8,storage+64);reserves.append(capacity);finish(4);return
 visited.add(addr)
u.hook_add(unicorn.UC_HOOK_CODE,capture)
cases=[];assert read(0x2d79378)==0
for sentinel in [0,0xaa,0x55]:
 reserves=[];u.mem_write(storage,bytes([sentinel])*64)
 w(stack,end);w(stack+4,0x10d3fb4);w(stack+8,a+0xa000)
 u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,driver)
 u.emu_start(0x9c2880,0x9c2a30,count=1000);assert u.reg_read(UC_X86_REG_EIP)==0x9c2a30
 begin=u.reg_read(UC_X86_REG_ESI);end_ptr=u.reg_read(UC_X86_REG_EDX);assert end_ptr-begin==24
 elements=[list(struct.unpack('<HH4B',u.mem_read(begin+i*8,8))) for i in range(3)]
 assert elements==[[0,0,2,0,0,0],[0,12,4,0,10,0],[0,16,1,0,5,0]]
 cases.append(dict(initial_storage_byte=sentinel,reserve_adapter_calls=list(reserves),d3d_elements=elements))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entry='0x9c2880',stop='0x9c2a30',original_instruction_addresses=len(visited),method0_table_value=read(0x2d79378),cases=cases,runtime_adapters=['Vector reserve helper supplies64byte preallocated storage; existing data retained. Originaltranslation/tablelookups/vectorappendexecute.'],limits=['Stops after3translated elements before terminator append and actualCreateVertexDeclaration API/COMwrapper; those remainopen.','Only originalquad declaration with method0table value0; otherlayouts/methods notqualified.','No originalGPU or livegrass integration.'])
(r/'data/4.20/grass_declaration_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(cases=len(cases),native_addresses=len(visited),d3d_elements=elements)))
