from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
source=vector+0x4000;owner=vector+0x5000;voices=vector+0x6000;calls=[];visited=set()
def hook(uc,a,size,data):
 if a==0xafe9c0:calls.append({'kind':'release_empty_source','source':u.reg_read(UC_X86_REG_ECX),'owner_at_call':bytes(u.mem_read(owner,56)).hex()});finish(1);return
 assert 0xaeea00<=a<=0xaeea6e,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[]
for pattern,count,match,gate in itertools.product([0,0xa5],[0,1,3],['first','middle','last','missing'],range(6)):
 calls.clear();u.mem_write(source,bytes([pattern])*96);w(source+28,owner);u.mem_write(owner,bytes([pattern])*56);w(owner+4,1 if gate==5 else 0);w(owner+12,voices if count else 0);u.mem_write(voices,bytes([pattern])*1536)
 for i in range(4):u.mem_write(owner+48+i*2,(1 if gate==i+1 else 0).to_bytes(2,'little'))
 for i in range(3):w(voices+i*512+16,voices+(i+1)*512 if i+1<count else 0)
 target=vector+0x8000 if match=='missing'or count==0 else voices+(0 if match=='first'else min(count-1,1)if match=='middle'else count-1)*512
 def snap():return {'source':bytes(u.mem_read(source,96)).hex(),'owner':bytes(u.mem_read(owner,56)).hex(),'voices':bytes(u.mem_read(voices,1536)).hex()}
 before=snap();w(stack,end);w(stack+4,target);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,source);u.emu_start(0xaeea00,end,count=2000);assert u.reg_read(UC_X86_REG_EIP)==end
 rows.append({'pattern':pattern,'count':count,'match':match,'gate':gate,'target':target,'before':before,'after':snap(),'calls':list(calls)})
proof={'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0xaeea00','case_count':len(rows),'cases':rows,'native_addresses':len(visited),'limits':['Actual AEEA00 removes voice from source28 owner intrusive list via voice16, preserving removed next pointers. Empty-source release requires all four half48/50/52/54, head12 and count4 zero. Last-source AFE9C0 controlled explicitly; real source/owner producers, actual destructor/reference semantics, malformed cycles and Rust integration remain required.']}
(r/'data/4.20/audio_path_voice_source_removal_preparation.json').write_text(json.dumps(proof,indent=2)+'\n');print('PASS',len(rows),'native source voice removal and empty-owner gates')
