from pathlib import Path
import json,hashlib,datetime,shutil
r=Path('E:/OpenLeague');stage=Path('E:/mapslol3v3');source=Path(json.loads((r/'docs/native_projection_discovery.json').read_text(encoding='utf-8'))['source']).parent/'DATA/CFG/defaults/Game.cfg';raw=source.read_bytes();digest=hashlib.sha256(raw).hexdigest();assert digest=='02c41cb9a5068f8bc993435557fd7b159bddbcda1f022605d284d9ea51d72b0e'
p=r/'data/4.20/configuration/defaults/Game.cfg';p.parent.mkdir(parents=True,exist_ok=True)
if p.exists():assert p.read_bytes()==raw
else:p.write_bytes(raw)
section='';performance=[]
for line in raw.decode('ascii').splitlines():
 if line.strip().startswith('['):section=line.strip()
 if section=='[Performance]':performance.append(line)
receipt=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),complete=False,source=str(source),source_sha256=digest,bytes=len(raw),destination=str(p),destination_sha256=hashlib.sha256(p.read_bytes()).hexdigest(),byte_exact=True,performance_raw_lines=performance,parser_qualified=False,loaded_by_runtime=False,limits=['Default source file recovered byte-exactly. Performance lines recorded as raw source, not parsed/qualified values.','No user configuration in checked deploy paths; original user path initialization and text parser remain open.'])
(r/'docs/native_game_config_recovery.json').write_text(json.dumps(receipt,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(bytes=len(raw),sha256=digest,performance_raw_lines=performance,loaded_by_runtime=False)))
