from pathlib import Path
import itertools,json,shutil,re
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_legacy_paths.py')
source=Path(__file__).read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','')
exec(compile(source,__file__,'exec'))
actor=heap+0x1000;other=heap+0x2000;vtable=heap+0x6000;getter=end+0x100;input_address=heap+0x4000;output=heap+0x4100
write32(actor,vtable);write32(vtable+0x258,getter)
path=r/'data/4.20/font_configuration/menu/fontconfig_en_US.txt'
translations=dict(re.findall(r'^tr "(game_announcement_replace_[^"]+)" = "([^"]*)"',path.read_text(encoding='utf-8-sig'),re.M))
def capture(uc,a,size,user):
 if a==getter:
  assert u.reg_read(UC_X86_REG_ECX)==actor
  value=values[len(reads)];reads.append(value);finish(eax=value);return
 if a==0x78d0d0:
  key=cbytes(u.reg_read(UC_X86_REG_ECX)).decode('ascii');localizations.append(key);u.mem_write(heap+0xa000,translations[key].encode()+b'\0');finish(eax=heap+0xa000);return
 if a==0x5fda30:
  sp=u.reg_read(UC_X86_REG_ESP);pointer,n=read32(sp+4),read32(sp+8);assert u.reg_read(UC_X86_REG_ECX)==output
  outputs.append(bytes(u.mem_read(pointer,n)).hex());finish(8,output);return
 assert 0x400000<=a<0x1000000,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,capture);cases=[]
bindings=[(0x6d4a10,' have | has@'),(0x6d4dc0,' have | has@'),(0x6d4a10,' dampener lane@'),(0x6d4dc0,' dampener lane@')]
assert cbytes(0x10a7110)==b' have | has@' and cbytes(0x10a71f4)==b' dampener lane@'
for (entry,pattern),exists,local,first,second,variant in itertools.product(bindings,[False,True],['none','self','other'],[0,1,2,0xffffffff],[0,1,2,0xffffffff],['exact','upper','tail']):
 reads=[];outputs=[];localizations=[];values=[first,second];input=pattern.upper() if variant=='upper' else pattern+'tail' if variant=='tail' else pattern
 write32(0x2d77f48,{'none':0,'self':actor,'other':other}[local]);u.mem_write(input_address,input.encode()+b'\0')
 sp=stack+0xc000;write32(sp,end);write32(sp+4,output);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,input_address);u.reg_write(UC_X86_REG_EDX,actor if exists else 0)
 u.emu_start(entry,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end and len(outputs)==1
 assert reads==([] if not exists or pattern==' have | has@' else [first] if first==0 else [first,second])
 cases.append({'entry':hex(entry),'pattern':pattern,'input':input,'exists':exists,'local':local,'first':first,'second':second,'output_hex':outputs[0],'getter_calls':reads.copy(),'localization_calls':localizations.copy()})
proof={'native_sha256':digest,'passed':True,'complete':False,'fixed_matchers':{'0x6ed260':{'pattern':' have | has@','compare_length':12},'0x6ed2c0':{'pattern':' dampener lane@','compare_length':15}},'translations':translations,'cases':cases,'limits':['Original ordered dispatchers, special matchers and callbacks executed. Caller ECX dummy operand is not a dynamic pattern: matcher bodies compare fixed internal literals.','Dampener lane reads virtual getter+258 once or twice with independent returns; no turret lane-owner field substituted.','Actor/vtable, local identity, translations and output storage supplied; live ownership, callback registration and playback remain incomplete.']}
(r/'data/4.20/audio_announcer_fixed_matchers_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
shutil.copy2(Path('E:/mapslol3v3/qualify_announcer_fixed_matchers.py'),r/'tools/qualify_announcer_fixed_matchers.py')
print(json.dumps({'native_fixed_matcher_cases':len(cases)}))
