from pathlib import Path
import json,struct,hashlib,datetime,itertools
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'projection prerequisites','exec'))
owner=vector+0x6000;stop=0x99f51d
def hook(uc,a,size,user):
 assert 0x99f4bb<=a<stop,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
f=lambda x:struct.unpack('<f',struct.pack('<f',x))[0];bits=lambda x:struct.unpack('<I',struct.pack('<f',x))[0]
matrices=[[1.,0.,0.,0.,0.,1.,0.,0.,0.,0.,1.,0.,0.,0.,0.,1.],[0.125,-0.25,0.5,0.75,1.,-1.25,1.5,1.75,2.,2.25,2.5,2.75,-0.5,0.25,3.5,3.75]]
cases=[]
for dimensions,scale,matrix in itertools.product([[1024,768],[1280,800],[1920,1080]],[0.5,1.,f(1.0652174),f(1.15),2.],matrices):
 w(owner+0x10,dimensions[0]);w(owner+0x14,dimensions[1]);u.mem_write(owner+0x1c,struct.pack('<f',scale));u.mem_write(stack+0x28,struct.pack('<16f',*matrix));u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_EBX,owner);u.emu_start(0x99f4bb,stop,count=100)
 assert u.reg_read(UC_X86_REG_EIP)==stop and u.reg_read(UC_X86_REG_ESP)==stack-4
 expected=list(matrix);expected[0]=f(matrix[0]*scale);expected[5]=f(matrix[5]*scale);expected[12]=f(matrix[12]*dimensions[0]);expected[13]=f(matrix[13]*dimensions[1]);actual=list(struct.unpack('<16I',u.mem_read(stack+0x28,64)));assert actual==[bits(x) for x in expected]
 cases.append(dict(viewport=dimensions,scale_bits=bits(scale),matrix_bits=[bits(x) for x in matrix],output_bits=actual))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entry='0x99f4bb',stop='0x99f51d',case_count=len(cases),native_addresses=len(visited),cases=cases,findings=['Native matrix preparation scales diagonal entries0/5 by renderer+1C with SSE f32 multiplication, translations12/13 by physical width/height through x87 then f32 store. Other entries unchanged.'],limits=['Matrix supplied at original stack position; suffix only, stops before original matrix multiply/upload. Base matrix producer, clip projection, shader input declaration and original framebuffer mapping remain open.','Positive finite selected scales/viewports; this does not prove whole projection or normal HUD fidelity.'])
(r/'data/4.20/native_hud_text_projection_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(dict(passed=True,cases=len(cases),native_addresses=len(visited))))
