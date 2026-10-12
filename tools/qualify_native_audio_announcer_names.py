"""Original active/inactive announcer name service and native formatter."""
from pathlib import Path
import json,struct,itertools
r=Path(__file__).resolve().parents[1]
source=(r/'tools/qualify_native_audio_legacy_paths.py').read_text(encoding='utf-8').split("hash_inputs=")[0].replace("u.hook_add(unicorn.UC_HOOK_CODE,hook)","")
exec(compile(source,str(r/'tools/qualify_native_audio_legacy_paths.py'),'exec'))
legacy_hook=hook;executed=set()
def service_hook(uc,a,size,user):
 executed.add(a)
 if a==0xca2e99:
  sp=u.reg_read(UC_X86_REG_ESP);dest,capacity,fmt,args=[read32(sp+i) for i in (4,8,12,16)];assert cbytes(fmt)==b'%s',cbytes(fmt);value=cbytes(read32(args));assert len(value)<capacity;u.mem_write(dest,value+b'\0');finish(eax=len(value));return
 if a in (0x564c20,0x5648a0,0x564af0,0x564900,0xc975f5,0xc98c70,0xc99c00,0xc9c850):legacy_hook(uc,a,size,user);return
 assert 0x400000<=a<0x1000000,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,service_hook)
# Both globals are pointers to the verified original literals, not configuration.
assert cbytes(read32(0x1224d3c))==b'play_vo' and cbytes(read32(0x1224d34))==b'announcer'
cases=[]
for mode,namespace,filename,prefix in itertools.product([0,1],['','ns','VeryLongNamespaceHere'],['','Welcome_mp3','VeryLongAnnouncementFilename_mp3','%1_With_Underscore'],['','Classic','LongAnnouncerPrefixHere']):
 cursor=heap+0x4000;put(heap+0xa00,namespace);put(heap+0xb00,filename);put(heap+0xc00,prefix);put(heap+0xd00,'')
 sp=stack+0xc000;u.mem_write(sp,struct.pack('<IIIII',end,heap+0xd00,heap+0xa00,heap+0xb00,heap+0xc00));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,heap+0x300)
 try:u.emu_start(0x7024a0 if mode else 0x6008b0,end,count=100000)
 except Exception:
  print('fault',mode,namespace,filename,prefix,hex(u.reg_read(UC_X86_REG_EIP)));raise
 assert u.reg_read(UC_X86_REG_EIP)==end
 output=string(heap+0xd00);expected='' if not mode else 'play_vo_announcer_'+prefix+'_'+(namespace+'_' if namespace else '')+filename
 assert output==expected,(mode,namespace,filename,prefix,output,expected)
 cases.append({'mode':mode,'namespace':namespace,'filename':filename,'prefix':prefix,'output':output})
path_cases=[]
for mode,path in itertools.product([0,1],['Play_Test','/Dialogue/Announcer/Classic/Welcome.mp3','/Dialogue/Announcer/CLASSIC/Long.file.name.mp3','/Dialogue/Announcer//Welcome.mp3']):
 cursor=heap+0x4000;u.mem_write(heap,path.encode()+b'\0');put(heap+0xd00,'Before');write32(heap+0x410,0x7024a0 if mode else 0x6008b0)
 u.mem_write(heap+0x600,b'\0'*64);u.mem_write(heap+0x60d,b'\1');write32(heap+0x604,heap+0x600)
 sp=stack+0xc000;u.mem_write(sp,struct.pack('<III',end,heap+0xd00,heap));u.reg_write(UC_X86_REG_ESP,sp);u.emu_start(0x7042c0,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end
 output=string(heap+0xd00)
 expected=''
 if mode and '/Dialogue/Announcer/' in path:
  remainder=path.split('/Dialogue/Announcer/',1)[1];expected='play_vo_announcer_'+remainder.split('/',1)[0]+'_'+remainder.rsplit('/',1)[1].replace('.','_')
 assert output==expected,(mode,path,output)
 path_cases.append({'mode':mode,'path':path,'output':output})
proof={'native_sha256':digest,'passed':True,'cases':cases,'path_cases':path_cases,'complete':False,'executed_addresses':sorted(executed),'constants':{'verb':cbytes(read32(0x1224d3c)).decode(),'category':cbytes(read32(0x1224d34)).decode()},'limits':['Actual7024A0 active/6008B0 inactive service,709640/7096D0,99B680 formatting and stack-probe routines executed. String storage/security and CRT vsnprintf(%s) explicitly adapted.','Service mode selection/runtime initialization and cache population remain unqualified. ASCII/no-NUL bounded inputs only; no audio playback.']}
(r/'data/4.20/audio_announcer_names_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(f'Original announcer names {len(cases)} cases +{len(path_cases)} original path integrations passed; {len(executed)} original/adapted addresses observed')
