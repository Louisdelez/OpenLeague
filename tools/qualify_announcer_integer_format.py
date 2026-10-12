from pathlib import Path
import itertools,json,shutil
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_legacy_paths.py')
source=Path(__file__).read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','')
exec(compile(source,__file__,'exec'))
output=heap+0x1000;type_pointer=heap+0x2000
def capture(uc,a,size,user):assert 0x5fd120<=a<0x5fd1aa,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,capture);cases=[]
for base,showpos,showbase,uppercase,other,type_text in itertools.product([0,0x200,0x400,0x800,0x600,0xa00,0xc00,0xe00],[0,0x20],[0,8],[0,4],[0,1,0x80000000,0x40001000],['ld','lu','Ld','Lu']):
 flags=base|showpos|showbase|uppercase|other;u.mem_write(output,b'\xcc'*32);u.mem_write(type_pointer,type_text.encode()+b'\0');sp=stack+0xc000;write32(sp,end);write32(sp+4,0);write32(sp+8,output);write32(sp+12,type_pointer);write32(sp+16,flags);u.reg_write(UC_X86_REG_ESP,sp)
 u.emu_start(0x5fd120,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_EAX)==output
 text=cbytes(output).decode('ascii');expected='%'+('+' if showpos else '')+('#' if showbase else '')+('I64' if type_text[0]=='L' else type_text[0])+('o' if base==0x400 else ('X' if uppercase else 'x') if base==0x800 else type_text[1]);assert text==expected
 cases.append({'flags':flags,'type_text':type_text,'format':text})
proof={'native_sha256':digest,'passed':True,'complete':False,'cases':cases,'limits':['Original5FD120 integer printf-format selection executes without primitive/result adapters. ExactE00 base mask, showpos20, showbase8, uppercase4 and native L->I64 conversion qualified.','This selects format text only; original C981A0 snprintf, num_put grouping/padding/locale, writer storage/failure handling and full native integer insertion remain incomplete.']}
(r/'data/4.20/audio_announcer_integer_format_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
shutil.copy2(Path('E:/mapslol3v3/qualify_announcer_integer_format.py'),r/'tools/qualify_announcer_integer_format.py')
print(json.dumps({'native_integer_format_cases_prepared':len(cases)}))
