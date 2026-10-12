from pathlib import Path
import struct,json,hashlib,datetime,itertools
r=Path('E:/OpenLeague')
source=(r/'tools/probe_native_grass_target_viewport.py').read_text(encoding='utf-8').split('matrices=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,capture)','hook_handle=u.hook_add(unicorn.UC_HOOK_CODE,capture)')
exec(compile(source,'viewport setup','exec'));u.hook_del(hook_handle)
surface=a+0xa000;surfacevt=a+0xb000;w(manager+0x1c,surface);w(surface,surfacevt);w(surfacevt+0x10,callbacks+0x18)
def restore_hook(uc,addr,size,user):
 if addr==callbacks+0x18:
  output=args(1)[0];events.append(dict(surface_descriptor=True));u.mem_write(output,b'\0'*32);w(output+0x18,size_pair[0]);w(output+0x1c,size_pair[1]);finish(4);return
 capture(uc,addr,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,restore_hook)
matrices=json.loads((r/'data/4.20/grass_screen_matrix_contract.json').read_text(encoding='utf-8'))
lookup={(c['width'],c['height'],c['api_flag']):c['matrix_bits'] for c in matrices['cases']};cases=[]
for size_pair,present,slot,flag in itertools.product([(0,0),(1,1),(200,150),(803,607),(4294967295,4294967295)],[False,True],[0,1],[0,1,2]):
 events=[];initial=matrices['cases'][0]['initial_bits'];u.mem_write(manager+0x244,struct.pack('<16I',*initial))
 w(manager+0x20328,2000);w(manager+0x2032c,1000);w(manager+0x20,a+0x9000)
 w(target+0x10,a+0x7000 if present else 0);w(target+0x28,slot);w(0x1225c58,flag)
 w(stack,end);w(stack+4,0xdeadbeef);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,target)
 u.emu_start(0x9889d0,end,count=2000);assert u.reg_read(UC_X86_REG_EIP)==end
 actual=list(struct.unpack('<16I',u.mem_read(manager+0x244,64)))
 update=present and slot==0;viewport=[e['device_viewport_bits'] for e in events if 'device_viewport_bits' in e]
 assert viewport==([[0,0,*size_pair,0,0x3f800000]] if update else [])
 assert actual==(lookup[(*size_pair,flag)] if update else initial)
 cases.append(dict(backbuffer_size=size_pair,texture_present=present,saved_slot=slot,api_flag=flag,events=list(events),matrix_bits=actual,renderer_dimensions=[read(manager+0x20328),read(manager+0x2032c)]))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entry='0x9889d0',original_instruction_addresses=len(visited),cases=cases,runtime_adapters=['Render/depthsurface bindings recorded; backbufferGetDesc virtual10supplies descriptor dimensions.','D3DSetViewport API boundary records6DWORDandreturnsS_OK; TLSandsecurityprerequisites explicit.'],limits=['Only2Drestore with supplied valid handles; no actualswapchain/D3Dcapability or normalmatchintegration.','Restoresbackbuffer dimensions, not arbitrarypreviousnestedtarget. Callerextraargument ignored by originalcode.'])
(r/'data/4.20/grass_restore_viewport_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(cases=len(cases),native_addresses=len(visited))))
