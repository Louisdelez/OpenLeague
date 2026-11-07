import argparse,hashlib,json,pathlib,struct,sys
S=pathlib.Path(__file__).parent;R=pathlib.Path('E:/OpenLeague');source=S/'exercise_native_rank_constructor.py'
prefix=source.read_text(encoding='utf-8').split('\nsynthetic=[]')[0]
needle='u.hook_add(unicorn.UC_HOOK_CODE,hook)';assert prefix.count(needle)==1
env={'__file__':str(source),'__name__':'native_rank_setup'};exec(compile(prefix.replace(needle,'rank_hook='+needle),str(source)+' [setup only]','exec'),env)
u=env['u'];uni=env['unicorn'];u.hook_del(env['rank_hook']);w=env['w'];rd=env['rd'];rf=env['rf'];wf=env['wf'];text=env['text'];leave=env['leave'];hashkey=env['hashkey'];numeric=env['numeric'];read=env['read']
from unicorn.x86_const import *
obj=env['obj'];config=env['config'];frame=env['frame'];stack=env['stack'];stub=env['float_stub'];init=env['init'];scratch=env['float_value'];start=0x767427;stop=0x7674a4
active={};calls=[];visited=set()
def hook(uc,a,n,unused):
 if a==0xc9811c:
  sp=u.reg_read(UC_X86_REG_ESP);out=rd(sp+4);fmt=text(rd(sp+8));effect=rd(sp+12);level=rd(sp+16)
  assert fmt=='Effect%dLevel%dAmount' and 1<=effect<=10 and 0<=level<=6
  v=(fmt%(effect,level)).encode();u.mem_write(out,v+b'\0');leave(len(v));return
 if a==0x8b2780:
  sp=u.reg_read(UC_X86_REG_ESP);field=text(rd(sp+8));default=rf(sp+12);assert default==0 and u.reg_read(UC_X86_REG_ECX)==config and text(u.reg_read(UC_X86_REG_EDX))=='SpellData'
  value=active.get(hashkey('SpellData',field));result=default if value is None else numeric(value)
  calls.append({'field':field,'present':value is not None,'native_raw':value,'original_constructor_default':default,'result':result});wf(scratch,result);u.reg_write(UC_X86_REG_EIP,stub);return
 assert start<=a<stop or stub<=a<stub+7 or init<=a<init+2,hex(a)
 if start<=a<stop:visited.add(a)
u.hook_add(uni.UC_HOOK_CODE,hook)
def run(values):
 global active,calls
 active=values;calls=[];u.mem_write(obj,bytes(0x1000));u.mem_write(frame-0x200,bytes(0x300));w(frame-0xc4,15);u.mem_write(frame-0xd8,b'SpellData\0')
 for reg in [UC_X86_REG_EAX,UC_X86_REG_EBX,UC_X86_REG_ECX,UC_X86_REG_EDX]:u.reg_write(reg,0)
 for reg,value in [(UC_X86_REG_ESI,obj),(UC_X86_REG_EDI,config),(UC_X86_REG_EBP,frame),(UC_X86_REG_ESP,stack)]:u.reg_write(reg,value)
 u.emu_start(init,init+2,count=4);u.emu_start(start,stop,count=20000);assert u.reg_read(UC_X86_REG_EIP)==stop
 result={f'Effect{e}Level{l}Amount':rf(obj+0x84+((e-1)*7+l)*4) for e in range(1,11) for l in range(7)};assert len(calls)==70;return result,list(calls)
empty,emptycalls=run({});assert set(empty.values())=={0.}
override,oc=run({hashkey('SpellData','Effect4Level5Amount'):9.25,hashkey('SpellData','Effect2Level1Amount'):-.25});assert override['Effect4Level5Amount']==9.25 and override['Effect2Level1Amount']==-.25
ref=json.loads((R/'docs/reference_client_4_20.json').read_bytes());p=pathlib.Path(ref['source_root'])/'RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/DATA/Characters/Jayce/Spells/JayceToTheSkies.inibin'
comparison=json.loads((R/'docs/fidelity_catalogue_comparison_4_20.json').read_bytes());row=next(x for x in comparison['rows'] if x['family']=='champion_spell_effect' and x['subject']=='Jayce:0' and x['field']=='effect4:5');p=pathlib.Path(row['native_path'])
values=read(p);assert hashkey('SpellData','Effect4Level5Amount') not in values;actual,calls_actual=run(values);assert actual['Effect4Level5Amount']==row['catalogue']==0
image=env['image'];base=env['base'];fragment=image[start-base:stop-base]
proof={'schema':'openleague_original_effect_constructor/v1','passed':True,'binary':env['result']['binary'] if 'result' in env else {'path':str(env['binary']),'sha256':env['expected'],'version':'4.20.0.315'},'fragment':{'start':hex(start),'stop':hex(stop),'sha256':hashlib.sha256(fragment).hexdigest(),'bytes':len(fragment),'native_addresses_exercised':len(visited)},
 'synthetic_cases':[{'name':'all_absent_effects_use_original_zero_default','expected':0,'observed':empty,'passed':True},{'name':'explicit_values_preserved_and_not_defaulted','expected':{'Effect4Level5Amount':9.25,'Effect2Level1Amount':-.25},'observed':override,'passed':True}],
 'actual_source':{'path':str(p),'sha256':hashlib.sha256(p.read_bytes()).hexdigest()},'actual_subject':'Jayce:0','actual_field':'Effect4Level5Amount','actual_result':actual['Effect4Level5Amount'],'actual_getter_calls':calls_actual,
 'adapters':'Same explicit sprintf and INIBIN lookup adapters as rank-constructor execution; original effect iteration/FLDZ default/array stores execute. Lookup/cache/override implementation is not executed.',
 'original_instructions_executed_in_isolated_memory':True,'historical_game_process_launched':False,'gameplay_qualified':False}
parser=argparse.ArgumentParser();parser.add_argument('--output',required=True);args=parser.parse_args();output=pathlib.Path(args.output)
if output.exists():parser.error('Output already exists; preserve prior evidence and choose a new output file.')
proof['producer']={'path':str(pathlib.Path(__file__).resolve()),'sha256':hashlib.sha256(pathlib.Path(__file__).read_bytes()).hexdigest(),'command_line':[sys.executable,*sys.argv]}
output.parent.mkdir(parents=True,exist_ok=True);output.write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'passed':True,'actual_subject':proof['actual_subject'],'actual_field':proof['actual_field'],'observed':proof['actual_result'],'synthetic_cases':2,'original_native_addresses':len(visited),'game_process_launched':False}))
