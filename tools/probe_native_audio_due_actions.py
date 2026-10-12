from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
common=vector+0x6000;nodes=[vector+0x7000+i*0x20 for i in range(4)];commands=[vector+0x8000+i*0x100 for i in range(4)];actions=[vector+0x9000+i*0x100 for i in range(4)];action_vt=vector+0xa000;command_vt=vector+0xa100;free_node=vector+0xb000
entries={vector+0xc000:'query',vector+0xc020:'execute',vector+0xc040:'release',vector+0xc060:'destroy'}
w(action_vt+0x2c,vector+0xc000);w(action_vt+0x20,vector+0xc020);w(action_vt+8,vector+0xc040);w(command_vt+4,vector+0xc060)
calls=[];freed=[];visited=set()
def hook(uc,a,size,data):
 sp=u.reg_read(UC_X86_REG_ESP);receiver=u.reg_read(UC_X86_REG_ECX)
 if 0x78b360<=a<0x78b367:return
 if a in entries:
  kind=entries[a];event={'kind':kind,'reference':receiver}
  if kind=='query':
   out=read(sp+4);assert bytes(u.mem_read(out,4))==bytes(4);u.mem_write(out,bytes([0x5a])*68)
  if kind=='execute':event['command']=read(sp+4)
  if kind=='destroy':event['flags']=read(sp+4)
  calls.append(event);finish(1,4 if kind in ['query','execute','destroy']else 0);return
 if a==0xaf52e0:calls.append({'kind':'release_playing','reference':receiver,'id':read(sp+4)});finish(0,4);return
 if a==0xada3e0:
  pool,ref=read(sp+4),read(sp+8);calls.append({'kind':'free','pool':pool,'reference':ref});assert ref not in freed;freed.append(ref);finish(0);return
 assert 0xb07e50<=a<0xb07f28,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
def snapshot():return {'common':bytes(u.mem_read(common,0x98)).hex(),'nodes':[{'reference':n,'raw':bytes(u.mem_read(n,12)).hex()}for n in nodes+[free_node]],'commands':[{'reference':n,'raw':bytes(u.mem_read(n,44)).hex(),'freed':n in freed}for n in commands],'actions':[{'reference':n,'raw':bytes(u.mem_read(n,153)).hex()}for n in actions],'processed':read(0x14a82e0)}
rows=[]
for pattern,profile,kind,eligible,playing,spare,processed in itertools.product([0,0xa5],['none','first','two','all','wrap'],[0,0x403,0x503,0x103,0xffff],[0,1,255],[0,123],[0,1],[0,0xffffffff]):
 calls.clear();freed.clear();u.mem_write(common,bytes([pattern])*0x98);now=5 if profile!='wrap'else 0;deadlines={'none':[6,7,8,9],'first':[5,6,7,8],'two':[0,5,6,7],'all':[0,0,5,5],'wrap':[0,1,0xfffffffe,0xffffffff]}[profile]
 w(common+0x44,nodes[0]);w(common+0x48,nodes[-1]);w(common+0x4c,free_node if spare else 0);w(common+0x58,4);w(common+0x7c,now);u.mem_write(free_node,bytes([pattern])*12);w(free_node,0)
 for i,(n,c,act)in enumerate(zip(nodes,commands,actions)):
  u.mem_write(n,bytes([pattern])*12);w(n,nodes[i+1]if i<3 else 0);w(n+4,deadlines[i]);w(n+8,c)
  u.mem_write(c,bytes([pattern])*44);w(c,command_vt);w(c+4,act);w(c+40,playing)
  u.mem_write(act,bytes([pattern])*153);w(act,action_vt);u.mem_write(act+32,struct.pack('<H',kind));u.mem_write(act+0x98,bytes([eligible]))
 w(0x12100dc,0xffffffff);w(0x14a7a2c,vector+0xd000);w(0x14a82e0,processed);before=snapshot();w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,common);u.emu_start(0xb07e50,end,count=4000);assert u.reg_read(UC_X86_REG_EIP)==end
 rows.append({'pattern':pattern,'profile':profile,'action_kind':kind,'eligible':eligible,'playing':playing,'before':before,'after':snapshot(),'calls':list(calls)})
proof={'passed':True,'complete':False,'case_count':len(rows),'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0xb07e50','end':'0xb07f28','body_sha256':hashlib.sha256(pe.get_data(0xb07e50-base,0xd8)).hexdigest(),'native_addresses':len(visited),'cases':rows,'adapters':['Actual B07E50 and78B360 eligibility byte getter; unsigned due-queue dequeue/recycle/count updates and ordered action query/execute/playing-release/action-release/command-destruction/poolfree execute. Action virtual bodies, playing release and physical poolfree are explicit controlled interfaces.'],'limits':['Normal action scheduling insertion producers and concrete action bodies/playing lifetimes remain required; caller qualification does not qualify these interfaces or complete normal frame.']}
(r/'data/4.20/audio_due_actions_preparation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'native due-action dequeue/recycle/release sequences')
