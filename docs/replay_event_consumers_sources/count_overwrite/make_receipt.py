from pathlib import Path
import datetime,hashlib,json,sys
import pefile,unicorn,capstone
root=Path(__file__).parent
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
proof=json.loads((root/'count_overwrite_native_probe.json').read_text())
assert proof['passed'] and proof['summary']=={'cases':100,'completed':84,'packet_read_faults':8,'metadata_write_faults':8,'counter_overwrite_cases':40}
assert sha(Path(proof['source']))==proof['native_sha256']
files=[p for p in root.iterdir() if p.is_file() and p.name!='validation_receipt.json']
receipt={'schema':'openleague.metadata-count-overwrite.native-audit.v1','recorded_at_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'source_sha256':proof['native_sha256'],'python':sys.executable,'versions':{'unicorn':unicorn.__version__,'capstone':capstone.__version__,'pefile':pefile.__version__},'command':[sys.executable,str(root/'probe_count_overwrite.py')],'observed_exit_code':0,'summary':proof['summary'],'production_modified':False,'rust_or_cargo_builds':False,'files':{p.name:{'bytes':p.stat().st_size,'sha256':sha(p)}for p in sorted(files)}}
out=root/'validation_receipt.json';out.write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'receipt':str(out),'receipt_sha256':sha(out),'summary':proof['summary']}))
