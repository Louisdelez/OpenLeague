"""Original manager evaluation of the actual byte-verified bank RTPC curves/defaults."""
from pathlib import Path
import json,struct,itertools,hashlib
r=Path('E:/OpenLeague');__file__=str(r/'tools/probe_native_audio_rtpc_manager.py');exec(compile(Path(__file__).read_text().split('rows=[];layouts=')[0],'setup','exec'))
reader=json.loads((r/'data/4.20/audio_rtpc_bank_reader_contract.json').read_text());ctx=json.loads((r/'data/4.20/ambient_audio_context.json').read_text());defaults={};default_provenance=[]
for record in ctx['game_parameters']:
 raw=Path(record['bank']).read_bytes();assert hashlib.sha256(raw).hexdigest()==reader['banks'][record['bank']]
 id=struct.unpack_from('<I',raw,record['id_offset'])[0];value=struct.unpack_from('<f',raw,record['value_offset'])[0];assert id==record['id'] and value==record['default_value'];assert id not in defaults;defaults[id]=value;default_provenance.append(record)
blocks=[block for block in reader['blocks'] if not block['id'].startswith('boundary:') and len(bytes.fromhex(block['bytes']))>2];assert len(blocks)==3
rows=[]
for block,owner,state in itertools.product(blocks,[0,77,0xffffffff],[{}, {0:0.}, {0:25.}, {0:50.}, {0:75.}, {0:100.}, {0:25.,77:75.,0xffffffff:50.}]):
 raw=bytes.fromhex(block['bytes']);count=struct.unpack_from('<H',raw)[0];assert count==1;rtpc,parameter,curve_id,scaling,size=struct.unpack_from('<IIIBH',raw,2)
 u.mem_write(manager,bytes(0x1800));u.mem_write(binding,bytes(0x200));put(binding,'III',42,parameter,0);put(manager+0x614+((42+parameter)%193)*4,'I',binding);put(binding+0x14,'II',curve_array,1)
 point=heap+0x4000;u.mem_write(point,raw[17:]);put(curve_array,'IIIII',curve_id,rtpc,point,size,scaling);curve_ids.clear();curve_ids[curve_array+8]=0
 record=heap+0x5000;items=record+0x80;u.mem_write(record,bytes(0x200));put(record,'IIf',rtpc,0,defaults[rtpc]);put(manager+(rtpc%193)*4,'I',record);put(record+0xc,'III',items,len(state),len(state))
 for index,(id,value) in enumerate(sorted(state.items())):put(items+index*8,'If',id,value)
 calls.clear();u.emu_start(trap+0x100,trap+0x102);invoke(0xb11040,[42,parameter,owner]);assert u.reg_read(UC_X86_REG_EIP)==trap+0x206
 rows.append({'block':block['id'],'owner':owner,'rtpc':rtpc,'parameter':parameter,'overrides':[{"owner":id,"value":value} for id,value in sorted(state.items())],'result_bits':read(out,'I')[0],'calls':list(calls)})
proof={'passed':True,'complete':False,'case_count':len(rows),'cases':rows,'defaults':defaults,'default_provenance':default_provenance,'native_sha256':hashlib.sha256(b).hexdigest(),'reader_contract_sha256':hashlib.sha256((r/'data/4.20/audio_rtpc_bank_reader_contract.json').read_bytes()).hexdigest(),'banks':reader['banks'],'adapters':['Manager tables constructed using actual bank curves and byte-verified Init default records; subscriber42 explicit runtime reference. Original lookup/owner fallback/conversion executed without value adapters.'],'limits':['Initial bank subscriptions only; native update/smoothing and node notification side effects remain open.','Raw scaling2 bus controls evaluated without invented preprocessing; downstream bus aggregation/gain still separate.','No device/audio runtime acceptance.']}
(r/'data/4.20/audio_rtpc_bank_snapshot_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'actual native bank RTPC manager evaluations;',len(defaults),'verified defaults')
