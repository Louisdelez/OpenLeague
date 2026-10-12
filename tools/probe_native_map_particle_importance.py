from pathlib import Path
import sys,struct,json,hashlib,datetime,shutil
r=Path('E:/OpenLeague');source=(r/'tools/qualify_native_audio_legacy_paths.py').read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','').replace('Path(__file__).resolve().parents[1]',"Path('E:/OpenLeague')");exec(compile(source,'native setup','exec'));base=p.OPTIONAL_HEADER.ImageBase;visited=set()
def hook(uc,a,size,user):
 assert any(base+s.VirtualAddress<=a<base+s.VirtualAddress+s.Misc_VirtualSize for s in p.sections if s.Characteristics&0x20000000),hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);cases=[]
for text in ['','Low','Medium','High','low','medium','high','LOW','MEDIUM','HIGH','Basic','Simple','Complex','Critical',' Medium','Medium ','x'*32]:
 ptr=heap+0x3000;u.mem_write(ptr,text.encode()+b'\0');sp=stack+0x8000;write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,ptr);u.emu_start(0x918ac0,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end;cases.append({'input':text,'importance_code':u.reg_read(UC_X86_REG_EAX)})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'complete':False,'passed':True,'native_sha256':digest,'entry':'0x918ac0','cases':cases,'original_instruction_addresses':len(visited),'adapters':[],'default_caller_argument':{'address':'0x10d7d8c','value':cbytes(0x10d7d8c).decode('ascii'),'caller':'0x919044'},'limits':['Original importance parser and its comparison instructions execute without adapters. Input C-string supplied.','Missing-field reader composition, quality culling, class initialization and actual emitter rendering not covered by this importance-only probe.']};(r/'data/4.20/map_particle_importance_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'cases':cases,'passed':True,'native_addresses':len(visited)}))
