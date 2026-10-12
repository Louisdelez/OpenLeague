from pathlib import Path
import itertools,json,shutil
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_legacy_paths.py')
source=Path(__file__).read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','');exec(compile(source,__file__,'exec'))
inventory=json.loads((r/'data/4.20/audio_announcer_dispatch_inventory.json').read_text());tables=inventory['tables'];patterns={};callbacks=set()
for form,table in tables.items():
 for b in table['bindings']:
  pattern=b['literal_pattern'] or (' have | has@' if b['matcher']=='0x6ed260' else ' dampener lane@');patterns[(form,b['ordinal'])]=pattern.encode();callbacks.add(int(b['callback'],16))
callbacks.add(0x6d3030);input_address=heap+0x1000;output=heap+0x2000;marker=heap+0x3000
def capture(uc,a,size,user):
 if a in callbacks:
  observed.append(a);u.mem_write(marker,f'MARK_{a:x}'.encode()+b'\0');finish(eax=marker);return
 if a==0x5fda30:
  sp=u.reg_read(UC_X86_REG_ESP);pointer,n=read32(sp+4),read32(sp+8);outputs.append(bytes(u.mem_read(pointer,n)).decode('ascii'));finish(8,output);return
 assert 0x400000<=a<0x1000000,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,capture)
inputs=[]
for p in dict.fromkeys(patterns.values()):inputs.extend([p,p.upper(),p+b'tail',p[:-1]])
inputs.extend([b'',b' unknown@',b'name@',b' name\0@',b' champion@tail\xff',b' bounty@\0tail'])
cases=[]
for form,input_bytes in itertools.product(tables,inputs):
 observed=[];outputs=[];u.mem_write(input_address,input_bytes+b'\0');sp=stack+0xc000;write32(sp,end);write32(sp+4,output);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,input_address);u.reg_write(UC_X86_REG_EDX,0)
 u.emu_start(int(tables[form]['entry'],16),end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end and len(observed)==len(outputs)==1
 match=next((b for b in tables[form]['bindings'] if input_bytes[:len(patterns[(form,b['ordinal'])])].lower()==patterns[(form,b['ordinal'])].lower()),None)
 expected=int(match['callback'],16) if match else 0x6d3030
 assert observed==[expected] and outputs==[f'MARK_{expected:x}']
 cases.append({'form':form,'input_hex':input_bytes.hex(),'selected_ordinal':None if match is None else match['ordinal'],'callback':hex(observed[0]),'marker_output':outputs[0]})
proof={'native_sha256':digest,'passed':True,'complete':False,'cases':cases,'limits':['Original30plain23localized dispatchers, actual ordered matcher control and original C9EC65 case-insensitive comparison execute. Special6ED260/6ED2C0 fixed patterns included. Callback identities supplied as distinguishable markers; this proof qualifies selection/fallback, not callback contents.','All named patterns plus uppercase/trailing/truncated inputs, unknown/missing-space/NUL inputs included. Actual exhausted callback6D3030 retained for both forms. Physical output storage supplied.','Individual callback ports have independent native contracts; complete production composition/live callback registry and playback remain separate verification.']}
(r/'data/4.20/audio_announcer_ordered_selection_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path('E:/mapslol3v3/qualify_announcer_ordered_selection.py'),r/'tools/qualify_announcer_ordered_selection.py');print(json.dumps({'native_ordered_selection_cases':len(cases)}))
