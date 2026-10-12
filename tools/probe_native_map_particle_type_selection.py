"""Execute the original selector after a supplied native string read."""
from pathlib import Path
import sys,struct,json,hashlib,datetime,shutil
r=Path('E:/OpenLeague');source=(r/'tools/qualify_native_audio_legacy_paths.py').read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','').replace('Path(__file__).resolve().parents[1]',"Path('E:/OpenLeague')");exec(compile(source,'native setup','exec'))
visited=set();selected=None;calls=[]
def hook(uc,a,size,user):
 global selected
 visited.add(a)
 if a in (0x919147,0x919247):selected='Simple' if a==0x919147 else 'Complex';u.emu_stop();return
 assert any(base+s.VirtualAddress<=a<base+s.VirtualAddress+s.Misc_VirtualSize for s in p.sections if s.Characteristics&0x20000000),hex(a)
base=p.OPTIONAL_HEADER.ImageBase;u.hook_add(unicorn.UC_HOOK_CODE,hook);cases=[]
values=['Complex','Simple','simple','SIMPLE','sImPlE','','S','Simpl','Simplex',' Simple','Simple ','Basic','High','Low','Medium','complex','x'*20,'Simple'+'x'*20]
for text in values:
 selected=None;sp=stack+0x7000;u.mem_write(sp,b'\0'*0x400);cursor=heap+0x4000;put(sp+0x74,text);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,0);u.reg_write(UC_X86_REG_EDI,0);u.emu_start(0x9190f3,end,count=100000)
 assert selected is not None,(text,hex(u.reg_read(UC_X86_REG_EIP)));cases.append({'input':text,'selection':selected,'landing':hex(u.reg_read(UC_X86_REG_EIP))})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'native_sha256':digest,'complete':False,'passed':True,'entry':'0x9190f3','native_comparator':'0x5fa6b0','cases':cases,'original_instruction_addresses':len(visited),'adapters':[],'default_type_argument':{'address':'0x10d7e40','value':cbytes(0x10d7e40).decode('ascii'),'caller':'0x91908e','reader':'0x8b0630','reader_execution_qualified':False},'limits':['Original selection and comparator instructions executed without comparator replacement. Input string storage supplied; upstream config read and string allocation not executed.','Default Complex literal supplied by original caller recovered, but absent-field reader behavior not yet executed in this probe.','Stops before original emitter allocation; constructor, field readers, spawning, pose and rendering remain unqualified.']};(r/'data/4.20/map_particle_type_selection_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'cases':cases,'native_addresses':len(visited),'passed':True}))
