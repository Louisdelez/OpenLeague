from pathlib import Path
import json,struct,datetime,hashlib,itertools
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'native emulator base','exec'))
descriptor=vector+0x9000;output=vector+0xa000
visited=set()
def hook(uc,a,size,user):
 assert 0x9c46b0<=a<0x9c474f,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
msaa=[read(0x10e2b00+i*4) for i in range(8)]
assert msaa==[0,2,4,4,5,6,3,1],msaa
cases=[]
for sample,quality,windowed,depth,flags in itertools.product(range(8),[0,1,7],[0,1,255],[0,2],[0,1]):
 u.mem_write(descriptor,b'\0'*64)
 for offset,value in [(0,1280),(4,800),(8,2),(12,1),(16,sample),(20,quality),(24,0),(28,0x12345678),(36,8),(40,flags),(44,60),(48,0)]:w(descriptor+offset,value)
 u.mem_write(descriptor+32,bytes([windowed,depth]));u.mem_write(output,b'\xaa'*56)
 w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,descriptor);u.reg_write(UC_X86_REG_EDX,output)
 u.emu_start(0x9c46b0,end,count=100)
 assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_ESP)==stack+4
 fields=list(struct.unpack('<14I',u.mem_read(output,56)))
 expected=[1280,800,read(0x10e2b90+2*4),1,msaa[sample],quality,read(0x10e2b60),0x12345678,windowed,int(depth!=0),read(0x10e2b90+8*4),2 if flags else 0,60,0]
 assert fields==expected
 cases.append(dict(sample_id=sample,quality=quality,windowed=windowed,depth_byte=depth,flags=flags,presentation_words=fields))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entry='0x9c46b0',case_count=len(cases),native_addresses=len(visited),multisample_table=msaa,supplied_type_ids=list(range(8)),cases=cases,limits=['Original complete presentation descriptor converter executed without call adapters; input descriptors supplied.', 'Multisample type is translated through the native table from descriptor offset10; quality is copied from offset14. Their actual game initialization and selected default remain unqualified.', 'No CreateDevice, presentation, reset or actual MSAA raster/resolve execution.'])
(r/'data/4.20/native_presentation_descriptor_contract.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(passed=True,cases=len(cases),native_addresses=len(visited))))


