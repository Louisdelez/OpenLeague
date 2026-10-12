from pathlib import Path
import shutil,json
r=Path('E:/OpenLeague');stage=Path(__file__).parent
shutil.copy2(stage/'native_zip_local_header.rs',r/'crates/client/src/native_zip_local_header.rs')
p=r/'crates/client/src/main.rs';text=p.read_text(encoding='utf-8')
if 'mod native_zip_local_header;' not in text:text='mod native_zip_local_header;\n'+text
p.write_text(text,encoding='utf-8')
for p in [r/'crates/client/src/native_archive_index.rs',r/'tools/native_archive_index.rs',r/'tools/port_native_archive_index.py',r/'tools/qualify_native_archive_index_lookup.py']:
 text=p.read_text(encoding='utf-8').replace('RAF mounting','ZIP mounting').replace('RAF index mounting','ZIP index mounting').replace('actual RAF index insertion','actual ZIP index insertion')
 p.write_text(text,encoding='utf-8')
p=r/'data/4.20/native_archive_index_lookup_contract.json';d=json.loads(p.read_text(encoding='utf-8'));d['limits']=[s.replace('actual RAF index insertion','actual ZIP index insertion') for s in d['limits']];d['archive_format_evidence']='8B9390 local signature 04034B50; 8B97F0 central signature 02014B50. Corrected previous unverified RAF terminology; lookup execution unchanged.';p.write_text(json.dumps(d,indent=2)+'\n',encoding='utf-8')
for name in ['native_zip_local_header.rs','port_native_zip_local_header.py']:shutil.copy2(stage/name,r/'tools'/name)
print('ZIP local header port registered; archive provider integration still open.')
