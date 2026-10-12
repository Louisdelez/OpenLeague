from pathlib import Path
import json,itertools,random,shutil
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_legacy_paths.py')
source=Path(__file__).read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','')
exec(compile(source,__file__,'exec'))
def capture(uc,a,size,user):assert 0x99c030<=a<=0x99c26e,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,capture)
src=heap+0x2000;result=heap+0x3000;dest=heap+0x5040
def call(entry,units,args):
 data=b''.join(struct.pack('<H',v) for v in units);u.mem_write(src,data+b'\xcc'*32)
 u.mem_write(result,b'\xaa'*16);sp=stack+0xc000;write32(sp,end)
 for i,v in enumerate([src+len(data)]+args):write32(sp+4+i*4,v)
 u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,result);u.reg_write(UC_X86_REG_EDX,src)
 u.emu_start(entry,end,count=1000000);assert u.reg_read(UC_X86_REG_EIP)==end
 assert u.reg_read(UC_X86_REG_EAX)==result
 return [read32(result+i*4) for i in range(4)]
rng=random.Random(420);inputs=[[0],[0x41,0], [0xc9,0x732b,0],[0xd83d,0xde00,0]]
inputs += [[v,0] for v in [1,0x7f,0x80,0x7ff,0x800,0xd7ff,0xd800,0xdbff,0xdc00,0xdfff,0xe000,0xffff]]
inputs += [[a,b,0] for a,b in itertools.product([0xd800,0xdbff],[1,0x41,0xd800,0xdbff,0xdc00,0xdfff,0xffff])]
inputs += [[rng.randrange(1,65536) for _ in range(rng.randrange(1,9))]+[0] for _ in range(50)]
inputs=list(dict.fromkeys(tuple(v) for v in inputs));cases=[]
for units in inputs:
 preflight=call(0x99c1f0,units,[0,0]);size=preflight[1]
 for capacity in sorted(set([0,1,2,3,4,8,64,size])):
  assert capacity<=128;u.mem_write(dest-8,b'\xcc'*144)
  state=call(0x99c030,units,[dest,capacity,0,0]);assert state[:2]==[dest,capacity]
  observed=bytes(u.mem_read(dest-8,144));assert observed[:7]==b'\xcc'*7 and observed[8+capacity:]==b'\xcc'*(136-capacity)
  cases.append({'input_utf16_units':list(units),'preflight_bytes':size,'capacity_bytes':capacity,'returned_position':state[2],'returned_flag_word':state[3],'output_buffer_hex':observed[8:8+capacity].hex(),'preceding_byte_hex':observed[7:8].hex()})
proof={'native_sha256':digest,'functions':['0x99C1F0','0x99C030'],'passed':True,'complete':False,'input_count':len(inputs),'cases':cases,'limits':['Actual original UTF16-to-multibyte sizing and write bodies execute without result adapters. Returned state and every output byte captured.','Zero-capacity primitive may overwrite the byte immediately before destination; this is recorded, not exposed as safe Rust behavior. Original99AB40 calls the writer only when sized bytes are positive.','Source ranges include terminalUTF16NUL with32byteCCpadding; surrogate pairs, isolated surrogates and non-surrogate followers captured without assuming modern Unicode validation.','Higher-level string resizing, trim/search, full99AB40/99AD50 callers, exceptional unwinding and live actor storage remain work.']}
(r/'data/4.20/audio_announcer_name_wide_encoder_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
shutil.copy2(Path('E:/mapslol3v3/qualify_announcer_name_wide_encoder.py'),r/'tools/qualify_announcer_name_wide_encoder.py')
print(json.dumps({'native_wide_encoder_inputs':len(inputs),'native_wide_encoder_cases':len(cases)}))
