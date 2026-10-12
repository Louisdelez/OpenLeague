from pathlib import Path
import shutil
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'setup','exec'))
body=vector+0x6000;config=vector+0x9000
def hook(uc,a,size,user):visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
cases=[]
for moving,prior,gravity in itertools.product([[0.,0.,0.],[100.,200.,300.],[-55.,24.,-90.],[-0.,0.,-0.]],[[900.,800.,700.],[-5.,4.,3.],[0.,0.,0.]],[0.,1.,-1.]):
 u.mem_write(body,b'\0'*0x600);u.mem_write(config,b'\0'*0x800)
 w(body+0x57c,body);w(body+0x140,config)
 u.mem_write(body+0x544,struct.pack('<3f',*moving));u.mem_write(body+0x60,struct.pack('<3f',*prior))
 u.mem_write(config+0x5a4,struct.pack('<f',gravity))
 w(stack,end);w(stack+4,0);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,body)
 u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80)
 u.emu_start(0x7631c0,end,count=1000)
 assert u.reg_read(UC_X86_REG_EIP)==end
 actual=list(struct.unpack('<3I',u.mem_read(body+0x60,12)));expected=list(struct.unpack('<3I',struct.pack('<3f',*moving)))
 assert actual==expected
 cases.append(dict(moving_words=expected,previous_words=list(struct.unpack('<3I',struct.pack('<3f',*prior))),gravity=gravity,owner_position_words=actual))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entries=['0x7631c0','0x7648c0'],native_instruction_addresses=len(visited),cases=cases,adapters=[],limits=['Finite coordinates; zero gravity or null target span. Original routines execute without helper substitutions.','Nonzero gravity with valid target uses interpolation and remains unqualified.','No client integration or rendered acceptance.'])
(r/'data/4.20/missile_position_sync_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(passed=True,cases=len(cases),native_instruction_addresses=len(visited))))
