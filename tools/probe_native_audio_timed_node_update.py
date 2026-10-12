from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');setup=(r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0];exec(compile(setup,'setup','exec'))
node=vector+0x6000;table=vector+0x7000;links=[vector+0x8000+i*64 for i in range(3)];targets=[vector+0x9000+i*64 for i in range(3)];calls=[];visited=set()
def hook(uc,a,size,data):
 if a==0xb1b680:calls.append({'kind':'finish_node','reference':u.reg_read(UC_X86_REG_ECX)});finish(1);return
 assert 0xb1bd10<=a<0xb1bde1,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);rows=[]
for pattern,frame,scale,bias,count,flags,deadline in itertools.product([0,0xa5],[0,1,1024,0x80000000,0xffffffff],[0.,2**-10,-2**-10,2**-32],[-1.,.5,1.],[0,1,3],[0,4],[0,1024,0xffffffff]):
 calls.clear();u.mem_write(node,bytes([pattern])*96);w(node,1);w(node+32,table);w(node+36,count);w(node+52,deadline);u.mem_write(node+60,struct.pack('<2f',scale,bias));u.mem_write(node+72,struct.pack('<6f',1.,-2.,3.,2.,4.,-8.));u.mem_write(table,bytes([pattern])*12)
 for i,(link,target)in enumerate(zip(links,targets)):u.mem_write(link,bytes([pattern])*52);w(link+48,target);u.mem_write(target,bytes([pattern])*60);u.mem_write(target+56,bytes([flags if i%2==0 else 0]));w(table+i*4,link)
 def snapshot():return {'node':bytes(u.mem_read(node,96)).hex(),'table':bytes(u.mem_read(table,12)).hex(),'links':[{'reference':n,'raw':bytes(u.mem_read(n,52)).hex()}for n in links],'targets':[{'reference':n,'raw':bytes(u.mem_read(n,60)).hex()}for n in targets]}
 before=snapshot();w(stack,end);w(stack+4,frame);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,node);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.emu_start(0xb1bd10,end,count=2000);assert u.reg_read(UC_X86_REG_EIP)==end;rows.append({'frame':frame,'before':before,'after':snapshot(),'calls':list(calls)})
proof={'passed':True,'complete':False,'case_count':len(rows),'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0xb1bd10','body_sha256':hashlib.sha256(pe.get_data(0xb1bd10-base,0xd1)).hexdigest(),'native_addresses':len(visited),'cases':rows,'adapters':['Actual B1BD10 unsigned frame conversion/x87 time progression, clamp, separate SSE float32 XYZ multiply/add and flag4-gated bound target writes execute. B1B680 finish-node is a mandatory controlled interface.'],'limits':['Finite dyadic scales/bias/XYZ and native default round-nearest x87/MXCSR profile only; arbitrary/nonfinite arithmetic and original binding/configuration producers remain required. Finish-node body, node life-cycle and full-frame integration remain required. Rust timed-body replay not yet performed.']}
(r/'data/4.20/audio_timed_node_update_preparation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'native timed node XYZ/gated binding/unsigned end sequences')
