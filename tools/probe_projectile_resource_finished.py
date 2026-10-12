from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_projectile_factory_pose.py').read_text().split('rows=[]')[0],'factory setup','exec'))
rows=[]
for resource_live,ended,finished in itertools.product([False,True],[0,1],[0,1,2,128]):
 for a,n in [(wrapper,0x200),(troy,0x180),(control,0x20)]:u.mem_write(a,bytes(n))
 live=resource_live;events=[];u.mem_write(nameptr,b'AnnieQ.troy\0');u.mem_write(posptr,struct.pack('<3f',500.,600.,700.));run(0x93fd60,troy,[0,nameptr,0])
 w(wrapper,0x10a4960);w(wrapper+0xb0,0x212);w(0x2d628c0,0);run(0x7172b0,0,[0,posptr,0,0,0],nameptr)
 w(wrapper+0x124,ended);u.mem_write(troy+0x2d,bytes([finished]))
 getter=run(0x928490,troy,[])&255;assert getter==finished
 value=bool(run(0x6c97b0,wrapper,[0])&255)
 assert value==(resource_live and not ended and not finished),(resource_live,ended,finished,value)
 rows.append(dict(resource_live=resource_live,ended=ended,resource_finished_byte=finished,getter=getter,continues=value))
instance=vector+0x1b000
copies=[]
def stop_copy(uc,a,size,user):
 if a==0x940d32:uc.reg_write(UC_X86_REG_EIP,end);uc.emu_stop()
u.hook_add(unicorn.UC_HOOK_CODE,stop_copy)
for flags in range(256):
 w(troy+0x114,instance);w(instance+0x70,0);u.mem_write(instance+0x1dc,bytes([flags]));u.reg_write(UC_X86_REG_EDI,troy)
 run(0x940d19,0,[]);value=u.mem_read(troy+0x2d,1)[0];assert value==((flags>>1)&1),(flags,value,hex(instance),hex(stack),hex(u.reg_read(UC_X86_REG_ECX)),hex(u.reg_read(UC_X86_REG_EDI)))
 copies.append(dict(instance_flags=flags,resource_finished=value))
proof=dict(complete=False,passed=True,native_sha256=hashlib.sha256(raw).hexdigest(),cases=rows,finish_publication_cases=copies,findings=['Concrete Troy virtual14 is928490 and reads byte2D. Wrapper6C97B0 rejects any nonzero byte before owner/provider callbacks.'],limits=['Original940D19..940D32 copies instance1DC bit1 to resource2D after simulation; 256 flag values verified. Full940570 frame still has other branches.','Factory allocation/container adapters and supplied weak counts are inherited; no full lifecycle or renderer qualification.'])
(r/'data/4.20/projectile_resource_finished_contract.json').write_text(json.dumps(proof,indent=2)+'\n');print('PASS',len(rows),'native resource finish gate cases')


