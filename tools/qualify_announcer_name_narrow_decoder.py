from pathlib import Path
import json
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_legacy_paths.py')
source=Path(__file__).read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','')
exec(compile(source,__file__,'exec'))
def capture(uc,a,size,user):
 if a==0xc975f5:finish(eax=u.reg_read(UC_X86_REG_EAX));return
 assert 0x99b000<=a<0x99d000,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,capture)
def call(data,out,capacity):
 u.mem_write(heap+0x2000,data+b'\0'+b'\xcc'*32);sp=stack+0xc000;write32(sp,end);write32(sp+4,out);write32(sp+8,capacity)
 u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,heap+0x2000);u.reg_write(UC_X86_REG_EDX,0xffffffff)
 u.emu_start(0x99b230,end,count=1000000);assert u.reg_read(UC_X86_REG_EIP)==end
 return u.reg_read(UC_X86_REG_EAX)
import random,shutil
rng=random.Random(420)
inputs=[bytes([i]) for i in range(256)]+[s.encode('utf-8') for s in ['', 'Garen','Loïc','É猫','😀','LongNameMoreThanSmallStringCapacity','\u007f','\u0080','\u07ff','\u0800','\ud7ff','\ue000','\uffff','\U00010000','\U0010ffff']]+[bytes.fromhex(h) for h in ['c080','c1bf','e08080','eda080','edbfbf','f0808080','f4908080','f7bfbfbf','f888808080','fcbfbfbfbfbf','e282','f09f98','c2','e2','f0','ff','fe','c241','e24141','f0414141']]+[bytes(rng.randrange(1,256) for _ in range(rng.randrange(1,12))) for _ in range(50)]
inputs=list(dict.fromkeys(inputs));cases=[]
for data in inputs:
 n=call(data,0,0)
 for capacity in sorted(set([0,1,2,3,4,8,64,n])):
  assert capacity<=128;u.mem_write(heap+0x5000,b'\xcc'*258);actual=call(data,heap+0x5000,capacity)
  observed=bytes(u.mem_read(heap+0x5000,258));assert observed[capacity*2:]==b'\xcc'*(258-capacity*2),(data.hex(),capacity,actual)
  cases.append({'input_hex':data.hex(),'preflight_units':n,'capacity_units':capacity,'returned_units':actual,'output_buffer_hex':observed[:capacity*2].hex()})
proof={'native_sha256':digest,'function':'0x99B230','passed':True,'complete':False,'input_count':len(inputs),'cases':cases,'limits':['Actual native narrow-to-UTF16 conversion99B230 and nested decoder bodies execute without conversion-result adapter. Only security-check boundary, if reached, supplied.','C-string mode EDX=-1 includes first NUL; source has declared32byteCCpadding after terminator, destination initializedCC; all bytes beyond capacity verified unchanged.','Legacy malformed-sequence behavior captured, including overlong sequences and isolated surrogate output. Do not replace these cases with a standards-compliant UTF8 decoder.','Explicit source-length mode, caller exception paths, full wide-to-multibyte encoder and live actor ownership remain unqualified.']}
p=r/'data/4.20/audio_announcer_name_narrow_decoder_contract.json';p.write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
shutil.copy2(Path('E:/mapslol3v3/qualify_announcer_name_narrow_decoder.py'),r/'tools/qualify_announcer_name_narrow_decoder.py')
print(json.dumps({'native_narrow_decoder_inputs':len(inputs),'native_narrow_decoder_cases':len(cases)}))
