from pathlib import Path
import struct,itertools,json,hashlib
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_audio_bus_gain_consumers.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
u.hook_add(unicorn.UC_HOOK_CODE,coupled_guard);rows=[]
for prop,exponent,small_exponent,sign in itertools.product([0,4],[45,53,60,63,64,80,100],[-10,0,10],[1,-1]):
 big=sign*2.**exponent;small=2.**small_exponent;node=nodes[0];u.mem_write(node,bytes(200));put(node,'I',0xff1380);put(node+0x30,'I',1<<prop);put(node+0x28,'I',heap+0x5000);u.mem_write(heap+0x5000,bytes([1,prop,0,0]));put(heap+0x5004,'f',-big)
 u.mem_write(manager,bytes(0x1800));u.mem_write(record,bytes(0x180));put(manager+(100%193)*4,'I',record);put(record,'IIf',100,0,0.);put(0x14a7a3c,'I',manager)
 binding=bindings;bucket=(node+prop)%193;put(binding,'IIIIIIII',node,prop,0,0,0,curves,2,2);put(manager+0x614+bucket*4,'I',binding)
 for i,value in enumerate([big,small]):
  ps=points+i*0x40;put(curves+i*20,'IIIII',1000+i,100,ps,1,0);put(ps,'ffI',0.,value,4)
 calls.clear();u.emu_start(trap+0x200,trap+0x202);sp=stack+0x8000;put(sp,'III',trap+0x300,0,prop);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,node);u.emu_start(0xb02ce0,trap+0x306,count=30000);assert u.reg_read(UC_X86_REG_EIP)==trap+0x306
 narrowed=struct.unpack('<f',struct.pack('<f',big+small))[0];bits=struct.unpack('<I',struct.pack('<f',narrowed-big))[0]
 rows.append({'property':prop,'big_bits':struct.unpack('<I',struct.pack('<f',big))[0],'small_bits':struct.unpack('<I',struct.pack('<f',small))[0],'result_bits':read(out,'I')[0],'premature_f32_result_bits':bits})
proof={'passed':True,'complete':False,'case_count':len(rows),'cases':rows,'premature_f32_mismatches':sum(c['result_bits']!=c['premature_f32_result_bits']for c in rows),'native_sha256':hashlib.sha256(b).hexdigest(),'adapters':['Actual B02CE0/AFEF40 and manager/curve code execute; two single-point scaling0 constant curves, no result adapters.'],'limits':['Finite curve constants and native nearest-even x87. Retained logarithmic scaling2 and runtime curve bindings remain separately unqualified.']}
assert proof['premature_f32_mismatches']>0
(r/'data/4.20/audio_bus_gain_rtpc_precision_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'native RTPC precision cases;',proof['premature_f32_mismatches'],'differ from prematurely rounded RTPC')
