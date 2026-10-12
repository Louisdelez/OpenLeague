from pathlib import Path
import itertools,json,shutil
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_legacy_paths.py')
source=Path(__file__).read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','')
exec(compile(source,__file__,'exec'))
input_address=heap+0x1000;output=heap+0x2000;streams={};fmt_offset=0x58+0x14;assert read32(0x1084eec+4)==0x58
def capture(uc,a,size,user):
 global alloc_cursor
 sp=u.reg_read(UC_X86_REG_ESP);ecx=u.reg_read(UC_X86_REG_ECX)
 if a==0x5f8590:
  core=ecx+16;streams[core]='';write32(core+fmt_offset,initial_flags);finish(8,ecx);return
 if a in [0x9933e0,0xce0d77]:
  alloc_cursor+=16;finish(eax=alloc_cursor);return
 if a in [0x5f8670,0x5f95b0,0xce15c9,0xc975f5]:finish(eax=u.reg_read(UC_X86_REG_EAX));return
 if a==0x5fd260:
  value=read32(sp+4);flags=read32(ecx+fmt_offset);assert value<=255;text=format(value,'x') if flags&0x800 else str(value);streams[ecx]+=text;ops.append({'op':'integer','value':value,'flags':flags,'supplied_output':text});finish(4,ecx);return
 if a==0x5fd400:
  stream,src=read32(sp+4),read32(sp+8);text=cbytes(src).decode('ascii');streams[stream]+=text;ops.append({'op':'literal','text':text});finish(eax=stream);return
 if a==0x5fe070:
  stream,src=read32(sp+4),read32(sp+8);text=string(src);streams[stream]+=text;ops.append({'op':'string','text':text});finish(eax=stream);return
 if a==0x5f99e0:
  dest=read32(sp+4);text=streams[ecx+16];put(dest,text);finish(4,dest);return
 if a==0xc98528:finish();return
 assert 0x400000<=a<0x1000000,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,capture);cases=[]
inputs=[0,0xffffffff,0xffffff,0x11223344,0x80000000,0x123456]
for alpha,channel,value in itertools.product([0,255],range(3),range(256)):inputs.append((alpha<<24)|((0x123456&~(255<<(channel*8)))|(value<<(channel*8))))
bindings=[(0x8e19a0,value,flags) for value,flags in itertools.product(range(256),[0,0x201])]+[(entry,value,flags) for entry,value,flags in itertools.product([0x8e1db0,0x8e1b30],inputs,[0,0x201])]
for entry,value,initial_flags in bindings:
 cursor=heap+0x8000;alloc_cursor=heap+0x6000;streams.clear();ops=[];put(output,'prior');write32(input_address,value);sp=stack+0xc000;write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,output);u.reg_write(UC_X86_REG_EDX,value if entry==0x8e19a0 else input_address)
 u.emu_start(entry,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_EAX)==output
 channels=[(value>>s)&255 for s in [16,8,0]];expected=format(value,'02x') if entry==0x8e19a0 else ' '.join(map(str,channels)) if entry==0x8e1db0 else ''.join(format(v,'02x') for v in channels)
 assert string(output)==expected,(hex(entry),value,ops,string(output),expected)
 cases.append({'entry':hex(entry),'input':value,'initial_flags':initial_flags,'output':string(output),'ops':ops.copy()})
proof={'native_sha256':digest,'passed':True,'complete':False,'cases':cases,'limits':['Original8E19A0 byte-hex,8E1DB0 RGB-decimal and8E1B30 RGB-hex bodies execute together, including nested byte helpers and actual format-flag mutation. All256 values per channel and alpha0/255 tested.','Explicit stream construction/storage, integer insertion, literal/string insertion, extraction, allocation/destruction/security supplied. Integer insertion renders decimal or lowercase hex according to supplied normal flags; this qualifies orchestration, channel order, zero prefix and raw flags, not native num_put/locale internals.','Initial format flags0 and201 explicitly supplied; actual fresh native stream-default provenance, exceptional allocation/stream/locale behavior and live palette integration remain unqualified.']}
(r/'data/4.20/audio_announcer_color_stream_control_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
shutil.copy2(Path('E:/mapslol3v3/qualify_announcer_color_stream_control.py'),r/'tools/qualify_announcer_color_stream_control.py')
print(json.dumps({'native_color_stream_control_cases_prepared':len(cases)}))
