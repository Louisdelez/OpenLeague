from pathlib import Path
import json,struct,itertools,shutil
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_legacy_paths.py')
source=(r/'tools/qualify_native_audio_legacy_paths.py').read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','')
exec(compile(source,__file__,'exec'))
actor=heap+0x7000;local=heap+0x8000;table=heap+0x9000;getter=end+0x200
write32(actor+0x124,table);write32(local+0x124,table);write32(table+12,getter);calls=[]
pattern_address=read32(0x6d4c29);pattern=cbytes(pattern_address).decode();assert pattern==' you | hero | minion | turret@'
assert bytes(u.mem_read(0x6d4c22,5))==b'\x68'+struct.pack('<I',0x6d3240)
def capture(uc,a,size,user):
 if a==getter:
  assert u.reg_read(UC_X86_REG_ECX)==actor+0x124;calls.append('actor');finish(eax=team);return
 assert 0x6d3240<=a<0x6d32f5,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,capture);cases=[]
for identity,local_kind,flags,team,mode in itertools.product(['null','actor'],['null','actor','other'],[0,0x800,0x1000,0x2000,0x1800,0x2800,0x3000,0x3800,0xffffffff],[100,200,300],[0,1,2,4]):
 calls=[];write32(actor+0x1c,flags);write32(0x2d77f48,{'null':0,'actor':actor,'other':local}[local_kind]);write32(0x2d79058,mode)
 sp=stack+0x8000;u.mem_write(sp,struct.pack('<II',end,0 if identity=='null' else actor));u.reg_write(UC_X86_REG_ESP,sp);u.emu_start(0x6d3240,end,count=1000);assert u.reg_read(UC_X86_REG_EIP)==end
 address=u.reg_read(UC_X86_REG_EAX);value=cbytes(address).decode('ascii')
 cases.append({'actor':identity,'local':local_kind,'flags':flags,'team':team,'mode':mode,'output':value,'output_address':hex(address),'getter_calls':list(calls)})
proof={'native_sha256':digest,'function':'0x6D3240','binding':'0x6D4C22','pattern':pattern,'passed':True,'complete':False,'cases':cases,'limits':['Original control flow and returned native literals executed; actor team virtual getter supplied.','Actor flags provided as native raw field1C; mapping live game actors into those flags remains unqualified.','Binding bytes/literal checked; full template scanner and announcements not executed.']}
(r/'data/4.20/audio_announcer_actor_tokens_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path('E:/mapslol3v3/qualify_announcer_actor_tokens.py'),r/'tools/qualify_announcer_actor_tokens.py');print(json.dumps({'native_cases':len(cases),'outputs':sorted({c['output'] for c in cases})}))
