from pathlib import Path
import json,struct,datetime,shutil
r=Path('E:/OpenLeague')
source=(r/'tools/qualify_native_audio_announcer_names.py').read_text(encoding='utf-8').split('cases=[]')[0]
__file__=str(r/'tools/qualify_native_audio_announcer_names.py')
exec(compile(source,str(r/'tools/qualify_native_audio_announcer_names.py'),'exec'))
assert cbytes(0x10ac1f4)==b'Female1'
print('startup configuration key',cbytes(0x10ac40c))
graph=json.loads((r/'data/4.20/announcer_audio_graph.json').read_text(encoding='utf-8'));registry={e['id']:b['bank'] for b in graph['banks'] for e in b['events']}
def event_hash(name):
 h=2166136261
 for b in name.lower().encode('ascii'):h=((h*16777619)&0xffffffff)^b
 return h
cases=[]
for mode,voice,filename in itertools.product([0,1],['','Female1','CustomVoice'],['OnAce','OnFirstBlood','OnVictory','OnDefeat','OnStartGameMessage1','OnStartGameMessage1ModeSnowdowShowdown']):
 path='LoL_Audio_en_US/Dialogue/Announcer/Global/2D/'+filename
 cursor=heap+0x4000;put(0x123da8c,voice);u.mem_write(heap,path.encode()+b'\0');put(heap+0xd00,'Before');write32(heap+0x410,0x7024a0 if mode else 0x6008b0)
 u.mem_write(heap+0x600,b'\0'*64);u.mem_write(heap+0x60d,b'\1');write32(heap+0x604,heap+0x600)
 sp=stack+0xc000;u.mem_write(sp,struct.pack('<III',end,heap+0xd00,heap));u.reg_write(UC_X86_REG_ESP,sp);u.emu_start(0x7042c0,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end
 output=string(heap+0xd00);expected='' if not mode else 'play_vo_announcer_Global_'+(voice+'_' if voice else '')+filename;assert output==expected
 identity=event_hash(output) if output else None
 cases.append({'mode':mode,'voice':voice,'path':path,'output':output,'event_id':identity,'bank':registry.get(identity)})
proof={'saved_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'native_sha256':digest,'passed':True,'complete':False,'namespace_global':'0x123DA8C','startup_voice_literal':{'address':'0x10AC1F4','value':cbytes(0x10ac1f4).decode()},'startup_configuration_key':{'address':'0x10AC40C','value':cbytes(0x10ac40c).decode()},'startup_config_call':'0x6F65CD -> 0x8B0630','cases':cases,'limits':['Original7042C0/6F7360/7024A0 executed after explicit namespace-global initialization; storage/CRT/formatting adapters as documented in prior qualification.','Startup configuration call observed statically with Female1 literal; whole startup function and option override not executed here.','Bank membership and name composition do not prove announcement trigger, queueing, mixing or audible playback.']}
(r/'data/4.20/audio_initialized_announcer_namespace_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path('E:/mapslol3v3/qualify_initialized_announcer_namespace.py'),r/'tools/qualify_initialized_announcer_namespace.py')
print(json.dumps({'native_cases':len(cases),'bank_confirmed':sum(c['bank'] is not None for c in cases)}))
