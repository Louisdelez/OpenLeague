from pathlib import Path
import struct,json,hashlib,datetime
r=Path('E:/OpenLeague')
source=Path('E:/mapslol3v3/probe_native_grass_declaration.py').read_text(encoding='utf-8').split('cases=[];assert')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,capture)','first_hook=u.hook_add(unicorn.UC_HOOK_CODE,capture)')
exec(compile(source,'declaration setup','exec'));u.hook_del(first_hook)
device=a+0x36000;devicevt=a+0x37000;api=a+0x38000
w(driver+0x14,device);w(device,devicevt);w(devicevt+0x158,api);w(0x2c,a+0x39000);w(a+0x39000,a+0x39100)
api_calls=[]
def api_capture(uc,addr,size,user):
 if addr==api:
  receiver,elements,out=args(3);assert receiver==device
  values=[list(struct.unpack('<HH4B',u.mem_read(elements+i*8,8))) for i in range(4)]
  assert values==[[0,0,2,0,0,0],[0,12,4,0,10,0],[0,16,1,0,5,0],[255,0,17,0,0,0]]
  api_calls.append(values);w(out,a+0xb000);finish(12);return
 if addr==0xc975f5:finish(value=u.reg_read(UC_X86_REG_EAX));return
 capture(uc,addr,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,api_capture)
cases=[]
for sentinel in [0,0xaa,0x55]:
 reserves=[];api_calls=[];u.mem_write(storage,bytes([sentinel])*64)
 w(stack,end);w(stack+4,0x10d3fb4);w(stack+8,a+0xa000);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,driver)
 u.emu_start(0x9c2880,0x9c2a6d,count=20000);assert u.reg_read(UC_X86_REG_EIP)==0x9c2a6d
 assert len(api_calls)==1 and u.reg_read(UC_X86_REG_EAX)==0
 cases.append(dict(initial_storage_byte=sentinel,api_elements=api_calls[0],reserve_calls=list(reserves)))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entry='0x9c2880',stop='0x9c2a6d',original_instruction_addresses=len(visited),cases=cases,runtime_adapters=['Vector reserve supplies64byte storage; originaltranslation/appendincludingterminator executes.','D3DCreateVertexDeclaration APIboundary records4elements, supplieshandleandreturnsS_OK; TLS/security prerequisites explicit.'],limits=['Stops afterAPI beforeCOMwrapper allocation/ownership; actualoriginalGPUdeclarationacceptance notclaimed.','Only originalquad layout, noothervertexformats; no livegrassintegration.'])
(r/'data/4.20/grass_declaration_api_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(cases=len(cases),native_addresses=len(visited),api_elements=cases[0]['api_elements'])))
