from pathlib import Path
import shutil
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'setup','exec'))
obj=vector+0x6000;config=vector+0x7000
u.hook_add(unicorn.UC_HOOK_CODE,lambda uc,a,size,user:(visited.add(a),finish(0,4) if a==0x93e9a0 else None))
f32=lambda x:struct.unpack('<f',struct.pack('<f',x))[0]
bits=lambda x:struct.unpack('<I',struct.pack('<f',x))[0]
rows=[]
for fill,clock,offset,radius in itertools.product([0,0xa5,0xff],[-0.,0.,0.125,1.,100.,100000.,16777216.,-1.],[-0.,0.,0.25,1.],[0.,2.,128.]):
 u.mem_write(obj,bytes([fill])*0x200);u.mem_write(config,b'\0'*0x200);w(obj+0xe8,config);w(config+0x138,bits(radius))
 u.mem_write(stack-0x100,b'\0'*0x300);w(stack,end);w(stack+4,bits(clock));w(stack+8,bits(offset));u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,obj)
 u.emu_start(0x93e5d0,end,count=500);assert u.reg_read(UC_X86_REG_EIP)==end
 out=dict(clock_words=[read(obj+0xa8+4*i) for i in range(3)],offset_words=read(obj+0xec),previous_words=[read(obj+0x84+4*i) for i in range(3)],position_words=[read(obj+0x90+4*i) for i in range(3)],minimum_words=[read(obj+0x130+4*i) for i in range(3)],maximum_words=[read(obj+0x13c+4*i) for i in range(3)])
 assert out['clock_words']==[bits(f32(f32(clock)-f32(offset)))]*3
 assert out['offset_words']==0 and out['previous_words']==out['position_words']==[0]*3
 rows.append(dict(memory_fill=fill,clock_words=bits(clock),offset_words=bits(offset),radius_words=bits(radius),result=out))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entry='0x93e5d0',native_instruction_addresses=sum(base<=a<base+len(image) for a in visited),cases=rows,findings=['93E5D0 writes clocksA8/AC/B0 = supplied clock minus supplied offset with one original SSE subtraction.','Resets fieldEC, previous84..8C and position90..98 to zero; recomputes bounds with native resource coefficient.','Signed zero and large-clock rounding cases are included.'],adapters=['93E9A0 direction matrix initialization omitted; matrix state is not captured or qualified.','Clock/offset/radius supplied; original clock virtual producer and binding to live renderer still open.'],limits=['Qualified initial time state only; does not prove updates, completion, particle emission or graphics fidelity.','Nonfinite values and overflow unqualified; resource parser and children remain separate.'])
(r/'data/4.20/troy_start_time_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(passed=True,cases=len(rows),native_instruction_addresses=proof['native_instruction_addresses'])))
