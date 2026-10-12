from pathlib import Path
import json,struct,itertools,hashlib
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_audio_bus_gain_aggregation.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
def precision_guard(uc,a,n,d):
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==0xafef40:
  dest,mask=read(sp+4,'II');put(dest+(0 if mask==1 else 0x10),'f',0.);ret(0,8);return
 assert any(lo<=a<hi for lo,hi in regions),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,precision_guard)
rows=[]
for exponent,small_exponent,sign,prop in itertools.product([45,53,60,63,64,80,100],[-10,0,10],[1,-1],[0,4]):
 values=[-sign*2.**exponent,2.**small_exponent,sign*2.**exponent]
 for i,node in enumerate(nodes):
  u.mem_write(node,bytes(200));put(node,'I',0xff1380);put(node+0x24,'I',nodes[i+1] if i<2 else 0)
  table=heap+0x5000+i*0x100;u.mem_write(table,bytes([1,prop,0,0]));put(table+4,'f',values[i]);put(node+0x28,'I',table)
 u.emu_start(trap+0x200,trap+0x202);sp=stack+0x8000;put(sp,'III',trap+0x300,1,prop);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,nodes[0]);u.emu_start(0xb02ce0,trap+0x306,count=10000);assert u.reg_read(UC_X86_REG_EIP)==trap+0x306
 result=read(out,'I')[0];narrow=struct.unpack('<I',struct.pack('<f',(float(values[2])+float(values[1]))+float(values[0])))[0]
 rows.append({'property':prop,'local_bits':[struct.unpack('<I',struct.pack('<f',v))[0]for v in values],'result_bits':result,'f64_result_bits':narrow})
proof={'passed':True,'complete':False,'case_count':len(rows),'cases':rows,'f64_mismatches':sum(c['result_bits']!=c['f64_result_bits']for c in rows),'native_sha256':hashlib.sha256(b).hexdigest(),'adapters':['Actual B02CE0 parent recursion, state zero via explicit AFEF40 interface, static values; x87 FINIT and final f32 store.'],'limits':['Finite cancellation cases only; runtime state and parameter source ownership remain separate.']}
assert proof['f64_mismatches']>0
(r/'data/4.20/audio_bus_gain_precision_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print('PASS',len(rows),'native cancellation cases;',proof['f64_mismatches'],'differ from f64')

