"""Native93F353 lifetime gate,93F908 child completion fold,93F9EB finish guard."""
from pathlib import Path
import json,struct,itertools
r=Path(__file__).resolve().parents[1]
source=(r/'tools/qualify_native_audio_legacy_paths.py').read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','')
exec(compile(source,'native setup','exec'))
actor=heap+0x8000;config=heap+0x6000;first=heap+0x1000;second=heap+0x2000;childbase=heap+0x3000

def gate_hook(uc,a,size,user):
 if a in [0x93f3be,0x93f983,0x93fa01]:u.emu_stop();return
 assert 0x93f353<=a<0x93f3be or 0x93f908<=a<0x93f983 or 0x93f9eb<=a<0x93fa01,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,gate_hook)
def setup(flags):
 u.mem_write(actor,b'\0'*0x200);u.mem_write(actor+0x1dc,bytes([flags]));u.reg_write(UC_X86_REG_ESI,actor);u.reg_write(UC_X86_REG_EBP,stack+0x8000);u.reg_write(UC_X86_REG_ESP,stack+0x7000)
def run(start,stop):
 u.emu_start(start,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==stop
 return u.mem_read(actor+0x1dc,1)[0]
def final(flags):return flags&253 if flags&1 and not flags&16 else flags
cases=[]
for flags,predicate,properties,source_flags,age in itertools.product(list(range(32))+[64,255],[0,1],[0,2,64],[0,1],[-1.,0.,.999,1.,2.,float('nan')]):
 setup(flags);write32(actor+0xe8,config);u.mem_write(actor+0x70,bytes([properties]));u.mem_write(config+0x1bc,bytes([source_flags]));u.mem_write(actor+0xa8,struct.pack('<f',0.));u.mem_write(actor+0xb4,struct.pack('<f',1.));u.mem_write(stack+0x8008,struct.pack('<f',age));u.reg_write(UC_X86_REG_EAX,predicate)
 gate=run(0x93f353,0x93f3be);suppressed=u.mem_read(stack+0x800f,1)[0];out=run(0x93f9eb,0x93fa01)
 expected=flags;skip=(predicate!=0 or properties&64!=0) and flags&8==0
 if not flags&2 and not skip and (flags&16 or (not flags&1 and not properties&2 and not source_flags&1 and age>=1.)):expected|=2
 assert gate==expected and bool(suppressed)==skip and out==final(expected)
 cases.append({'flags':flags,'predicate_raw':predicate,'property_flags':properties,'source_flags':source_flags,'age':'NaN' if age!=age else age,'gate_flags':gate,'suppressed_raw':suppressed,'final_flags':out})
children=[];groups=[[],[0],[1],[2],[255],[1,0],[1,1]]
for flags,a,b in itertools.product([0,1,2,3,64,128,255],groups,groups):
 setup(flags)
 for header,base,values,field in [(actor+8,first,a,12),(actor+0x38,second,b,8)]:
  write32(header,base);write32(header+4,base+len(values)*4)
  for i,value in enumerate(values):
   child=childbase+(0 if field==12 else 0x100)+i*0x20;write32(base+i*4,child);u.mem_write(child+field,bytes([value]))
 folded=run(0x93f908,0x93f983);out=run(0x93f9eb,0x93fa01);expected=(flags|2) if all(v&1 for v in a+b) else flags&253;assert folded==expected and out==final(expected)
 children.append({'flags':flags,'first_raw':a,'second_raw':b,'folded_flags':folded,'final_flags':out})
proof={'native_sha256':digest,'passed':True,'gate_cases':cases,'children_cases':children,'complete':False,'limits':['Actual93F353..3BE lifetime gate,93F908..983 child status fold and93F9EB..FA01 final guard executed as bounded native fragments.','PredicateAL normally comes from8E36B0; supplied explicitly, no geometry semantics assumed. Flags/property/source config supplied, extraction not qualified.','First child byteC and second child byte8 bit0 must all be set. Active bit1 with no stop bit10 clears finished bit2.','Full particle update, child status producer, clock/birth/lifetime/config bindings and runtime cleanup integration remain unqualified.']}
(r/'data/4.20/audio_emitter_finish_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(f'Original emitter finish {len(cases)} gate / {len(children)} child cases passed')
