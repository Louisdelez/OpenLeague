from pathlib import Path
import json,hashlib
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_projectile_team_visibility.py').read_text().split('\nrows=[]')[0],'setup','exec'))
assert read(0x10afe8c+0xb0)==0x718ad0
rows=[]
for value in [0,1,2,127,128,255]:
 u.mem_write(root+0x122,bytes([value]));observed=run(0x718ad0,root,[])&255;assert observed==value
 rows.append(dict(manager_byte_122=value,returned_byte=observed,enabled=bool(observed)))
proof=dict(complete=False,passed=True,native_sha256=hashlib.sha256(raw).hexdigest(),cases=rows,provenance=['58FE22 allocates188 bytes;58FE44 calls72A3B0;58FE54 stores result in2D787B8.','72A3F4 writes primary vtable10AFE8C. Its B0 slot contains718AD0.','718AD0 reads byte[ecx+122] and returns.'],limits=['Constructor allocation and whole manager lifecycle not emulated here; association established by inspected native instructions.','Writer and initialization of manager byte122 remain unknown; no defaultfalse claim.','Team mask15C producer and normal match integration remain open.'])
(r/'data/4.20/projectile_root_filter_contract.json').write_text(json.dumps(proof,indent=2)+'\n');print('PASS6 root filter byte cases')
