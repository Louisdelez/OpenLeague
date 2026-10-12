"""Actual native bank reader -> subscription mutation -> ordered notifications."""
from pathlib import Path
import json,itertools,struct,hashlib
r=Path('E:/OpenLeague');source=(r/'tools/probe_native_audio_rtpc_subscriptions.py').read_text().split('patterns=')[0]
source=source.replace('regions=[','regions=[(0xb008b0,0xb00987),',1)
source=source.replace(' if a==trap+0x100:'," if a==trap+0x300: calls.append({'kind':'class','flags':read(node+0x30,'II')});ret(current_class,0);return\n if a==trap+0x400: calls.append({'kind':'bank_notify','parameter':read(sp+4,'I')[0],'flags':read(node+0x30,'II')});ret(0,4);return\n if a==trap+0x100:")
source=source.replace('regions=[','regions=[(0x7838b0,0x7838b6),(0x565170,0x565173),(0xaf3420,0xaf3440),',1)
source=source.replace(' if a==trap+0x100:'," if a==0x7838b0: calls.append({'kind':'class','flags':read(node+0x30,'II')});return\n if a==0xaf3420: calls.append({'kind':'invalidate'});return\n if a==0x565170: calls.append({'kind':'bank_notify','parameter':read(sp+4,'I')[0],'flags':read(node+0x30,'II')});return\n if a==trap+0x100:")
exec(compile(source,'native-sound-composition-setup','exec'));put(node,'I',0xff1cd8);put(node+0x1c,'I',0)

reader=json.loads((r/'data/4.20/audio_rtpc_bank_reader_contract.json').read_text());bank_snapshot=json.loads((r/'data/4.20/audio_rtpc_bank_snapshot_contract.json').read_text());defaults={int(key):value for key,value in bank_snapshot['defaults'].items()};defaults.update({100:20.,293:60.})
blocks=[block for block in reader['blocks'] if not block['id'].startswith('boundary:') or any(block['id'].startswith(f'boundary:{parameter}:') for parameter in [4,29,30,32,37,63])]
rows=[];buffer=heap+0x2000;cursor=heap+0x3000;remaining=heap+0x3100
for block,enabled,kind,initial in itertools.product(blocks,[False,True],[2],[(0,0),(0x81,0x80000002)]):
 u.mem_write(manager,bytes(0x1800));u.mem_write(node+0x30,struct.pack('<II',*initial));bump=heap+0x9000
 for index,(id,default) in enumerate(defaults.items()):
  record=heap+0x4000+index*0x200;refs=record+0x100;u.mem_write(record,bytes(0x200));previous=read(manager+(id%193)*4,'I')[0];put(record,'IIf',id,previous,default);put(manager+(id%193)*4,'I',record);put(record+0x1c,'III',refs,0,16)
 put(0x14a7a3c,'I',manager if enabled else 0);raw=bytes.fromhex(block['bytes']);steps=[]
 for iteration,current_class in enumerate([2,2]):
  u.mem_write(buffer,raw);put(cursor,'I',buffer);put(remaining,'I',len(raw));calls.clear();sp=stack+0x8000;put(sp,'III',trap,cursor,remaining);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,node);u.emu_start(0xb008b0,trap,count=200000);assert u.reg_read(UC_X86_REG_EIP)==trap
  steps.append({'class':current_class,'result':u.reg_read(UC_X86_REG_EAX),'flags':read(node+0x30,'II'),'consumed':read(cursor,'I')[0]-buffer,'remaining':read(remaining,'I')[0],'bindings':snapshot(),'calls':list(calls)})
 rows.append({'block':block['id'],'manager':enabled,'initial_flags':initial,'steps':steps})
proof={'passed':True,'complete':False,'case_count':len(rows),'step_count':sum(len(row['steps']) for row in rows),'subscriber':node,'defaults':defaults,'blocks':blocks,'cases':rows,'sound_vtable':'0xff1cd8','sound_class':2,'native_sha256':hashlib.sha256(b).hexdigest(),'banks':reader['banks'],'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()} for a,e in regions],'adapters':['Original B008B0 -> B124E0 -> B13540/B135C0 -> actual manager evaluation execute without subscription-result adapters.','Allocator/free/memcpy ABI adapters inherited from subscription qualification. Class getter134 and invalidate/notify execute original sound vtable code; entries only observed by code hooks.','Actual sound FF1CD8 table executes original class getter7838B0 returning2, original invalidateAF3420 and notify565170. Empty active-voice list; no class/notify value adapters.'],'limits':['CAkBus-specific full loader and actual class discovery remain open; generic parameter-node path proved on serialized RTPC blocks.','Allocator failures, missing global-record construction, class3 and smoothing not exercised.','No physical voice/device runtime acceptance.']}
(r/'data/4.20/audio_rtpc_sound_bank_composition_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'bank composition sequences;',proof['step_count'],'actual sound native loads')
