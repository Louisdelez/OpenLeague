"""Actual sound bank notifications -> active voice flags, plus original refresh gate."""
from pathlib import Path
import json,itertools,struct,hashlib
r=Path('E:/OpenLeague');setup=(r/'tools/probe_native_audio_rtpc_sound_bank_composition.py').read_text().split('reader=json.loads')[0]
needle="exec(compile(source,'native-sound-composition-setup','exec'))"
replacement=r"""source=source.replace('regions=[','regions=[(0xaee780,0xaee78f),(0xaedc60,0xaedc77),(trap+0x600,trap+0x601),',1)
source=source.replace(' if a==trap+0x100:'," if a==0xaee780: calls.append({'kind':'voice_invalidate','voice':voice_ids[u.reg_read(UC_X86_REG_ECX)]});return\n if a==trap+0x600: gate_calls.append(voice_ids[u.reg_read(UC_X86_REG_ECX)]);return\n if a==trap+0x100:")
exec(compile(source,'active-voice-setup','exec'))"""
assert needle in setup;exec(compile(setup.replace(needle,replacement),'setup-wrapper','exec'))
voices=[heap+0x7000+i*0x200 for i in range(3)];voice_ids={address:index for index,address in enumerate(voices)};voice_table=heap+0x7900;node_state=heap+0x7800;put(voice_table+0x3c,'I',trap+0x600);u.mem_write(trap+0x600,b'\xc3');gate_calls=[]
reader=json.loads((r/'data/4.20/audio_rtpc_bank_reader_contract.json').read_text());native=json.loads((r/'data/4.20/audio_rtpc_bank_snapshot_contract.json').read_text());defaults={int(key):value for key,value in native['defaults'].items()};defaults.update({100:20.,293:60.})
blocks=[block for block in reader['blocks'] if (not block['id'].startswith('boundary:') and len(bytes.fromhex(block['bytes']))>2) or block['id'] in ['boundary:29:2','boundary:30:0']];assert len(blocks)==5
buffer=heap+0x2000;cursor=heap+0x3000;remaining=heap+0x3100;rows=[]
for block,enabled,layout,initial in itertools.product(blocks,[False,True],[None,[],[0,1,2],[2,0,1]],[(0,0),(0x20,0x40),(0xff,0xff),(0xa5,0x95)]):
 u.mem_write(manager,bytes(0x1800));put(node+0x30,'II',0,0);bump=heap+0x9000
 for index,(id,default) in enumerate(defaults.items()):
  record=heap+0x4000+index*0x200;refs=record+0x100;u.mem_write(record,bytes(0x200));previous=read(manager+(id%193)*4,'I')[0];put(record,'IIf',id,previous,default);put(manager+(id%193)*4,'I',record);put(record+0x1c,'III',refs,0,16)
 put(node+0x1c,'I',0 if layout is None else node_state);put(node_state+0xc,'I',voices[layout[0]] if layout else 0)
 initial_voice_flags=[]
 for index,address in enumerate(voices):
  u.mem_write(address,bytes(0x200));put(address,'I',voice_table);flags=[initial[0]^(index*17),0x5a,initial[1]^(index*33),0xa5];u.mem_write(address+0x12c,bytes(flags));initial_voice_flags.append(flags);put(address+0x10,'I',voices[layout[layout.index(index)+1]] if layout and index in layout and layout.index(index)+1<len(layout) else 0)
 put(0x14a7a3c,'I',manager if enabled else 0);raw=bytes.fromhex(block['bytes']);steps=[]
 for iteration in range(2):
  u.mem_write(buffer,raw);put(cursor,'I',buffer);put(remaining,'I',len(raw));calls.clear();sp=stack+0x8000;put(sp,'III',trap,cursor,remaining);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,node);u.emu_start(0xb008b0,trap,count=200000);assert u.reg_read(UC_X86_REG_EIP)==trap
  flags=[list(u.mem_read(address+0x12c,4)) for address in voices];events=list(calls);gate_calls.clear()
  for address in voices:
   put(sp,'I',trap);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,address);u.emu_start(0xaedc60,0xaedc77,count=100);assert u.reg_read(UC_X86_REG_EIP)==0xaedc77
  steps.append({'voices':flags,'calls':events,'refresh_calls':list(gate_calls)})
 rows.append({'block':block['id'],'manager':enabled,'layout':layout,'initial_voice_flags':initial_voice_flags,'steps':steps})
proof={'passed':True,'complete':False,'case_count':len(rows),'step_count':sum(len(row['steps']) for row in rows),'blocks':blocks,'defaults':defaults,'subscriber':node,'cases':rows,'native_sha256':hashlib.sha256(b).hexdigest(),'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()} for a,e in regions if not trap<=a<trap+0x1000],'adapters':['Actual FF1CD8 class2 getter/bank reader/subscriptions/AF3420 active list walk/AEE780 invalidation execute original instructions.','Allocator/free/memcpy inherited explicit ABI adapters; active voices/linked list/Init defaults supplied.','Original AEDC60 refresh gate executed only until AEDC77. Virtual3C is explicit ret-only callback; full recomputation/mixer not executed or supplied.'],'limits':['No active list mutation or cyclic native list fixture; Rust rejects malformed graphs explicitly.','Full AEE790 recomputation/aggregation, secondary cache40 consumer and device output remain open.','No audible/normal client runtime claim.']}
(r/'data/4.20/audio_active_voice_cache_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'active voice sequences;',proof['step_count'],'bank invalidation/gate steps')
