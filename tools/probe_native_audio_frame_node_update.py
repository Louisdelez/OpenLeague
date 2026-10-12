from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');setup=(r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0];exec(compile(setup,'setup','exec'))
header=vector+0x6000;table=vector+0x7000;objects=[vector+0x8000+i*64 for i in range(10)];calls=[];did_append=False;visited=set()
def hook(uc,a,size,data):
 global did_append
 if a==0xb1bd10:
  receiver=u.reg_read(UC_X86_REG_ECX);sp=u.reg_read(UC_X86_REG_ESP);calls.append({'reference':receiver,'frame':read(sp+4)})
  if append and not did_append:
   count=read(header+4);w(table+count*4,objects[9]);w(header+4,count+1);did_append=True
  finish(1,4);return
 assert 0xb14140<=a<0xb1417a,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[]
for pattern,count,layout,append,frame in itertools.product([0,0xa5],[0,1,2,4,8],['all','none','alternating'],[0,1],[0,1,0xffffffff]):
 calls.clear();did_append=False;u.mem_write(header,bytes([pattern])*12);w(header,table);w(header+4,count);w(header+8,10);u.mem_write(table,bytes([pattern])*40)
 for i,o in enumerate(objects):u.mem_write(o,bytes([pattern])*48);w(o,1 if i==9 or layout=='all'or(layout=='alternating'and i%2==0)else 2)
 for i in range(count):w(table+i*4,objects[i])
 def snapshot():return {'header':bytes(u.mem_read(header,12)).hex(),'table':bytes(u.mem_read(table,40)).hex(),'objects':[{'reference':o,'raw':bytes(u.mem_read(o,48)).hex()}for o in objects]}
 before=snapshot();w(stack,end);w(stack+4,frame);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,header);u.emu_start(0xb14140,end,count=2000);assert u.reg_read(UC_X86_REG_EIP)==end;rows.append({'append':append,'frame':frame,'before':before,'after':snapshot(),'calls':list(calls)})
proof={'passed':True,'complete':False,'case_count':len(rows),'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0xb14140','body_sha256':hashlib.sha256(pe.get_data(0xb14140-base,0x3a)).hexdigest(),'native_addresses':len(visited),'cases':rows,'adapters':['Actual B14140 forward traversal and class1 filtering execute. B1BD10 node update is a mandatory controlled interface; callback may append one entry within owned capacity, proving live count reload.'],'limits':['Node timed-update body, allocation/relocation/removal producers and full frame integration remain required. Stable backing vector with capacity10 only; no arbitrary relocation acceptance.']}
(r/'data/4.20/audio_frame_node_update_preparation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'native live vector class1 frame-update sequences')
