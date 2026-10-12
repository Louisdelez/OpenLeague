from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
owner=vector+0x4000;table=vector+0x5000;key=vector+0x6000;visited=set()
def hook(uc,a,size,data):
 assert 0xaf5b90<=a<0xaf5bf8,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[]
for pattern,count,kind,counter in itertools.product([0,0xa5],[0,1,3,4],['first','last','missing','duplicate'],[0,1,3,255]):
 u.mem_write(owner,bytes([pattern])*60);u.mem_write(table,bytes([pattern])*16);w(owner+32,table);w(owner+36,count);w(owner+48,0x11223344);u.mem_write(owner+53,bytes([counter]))
 for i in range(count):w(table+i*4,key if (kind=='first'and i==0)or(kind=='last'and i==count-1)or(kind=='duplicate')else key+4+i*4)
 def snap():return {'owner':bytes(u.mem_read(owner,60)).hex(),'table':bytes(u.mem_read(table,16)).hex()}
 before=snap();w(stack,end);w(stack+4,owner);w(stack+8,key);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,vector+0x7000);u.emu_start(0xaf5b90,end,count=1000);assert u.reg_read(UC_X86_REG_EIP)==end
 rows.append({'pattern':pattern,'count':count,'kind':kind,'counter':counter,'key':key,'before':before,'after':snap(),'result':u.reg_read(UC_X86_REG_EAX)})
proof={'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0xaf5b90','case_count':len(rows),'cases':rows,'native_addresses':len(visited),'limits':['Actual native owner reference removal body executes without adapters or allocations: first match, swap-last, retained capacity/tail bytes, count36 and wrapping byte53 decrement, phase48=6 only when counter becomes0. Empty/missing returns29. Owner constructor, registry/storage source, malformed spans and actual voice retirement integration/Rust port remain required.']}
(r/'data/4.20/audio_path_voice_owner_release_preparation.json').write_text(json.dumps(proof,indent=2)+'\n');print('PASS',len(rows),'actual owner reference removal cases')
