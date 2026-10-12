from pathlib import Path
import json,hashlib,shutil,datetime
import pefile
R=Path('E:/OpenLeague');B=Path('E:/mapslol3v3')
def load(p):return json.loads(p.read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def save(p,x):p.write_text(json.dumps(x,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
clock=B/'loading_clock_preparation';meta=load(clock/'clock_sources.json');pepath=Path(meta['native_source']);assert sha(pepath)==meta['native_sha256']
pe=pefile.PE(str(pepath));im=pe.get_memory_mapped_image();im+=bytes(pe.OPTIONAL_HEADER.SizeOfImage-len(im))
for row in meta['regions']:
 data=bytes.fromhex(row['hex']);off=row['address']-pe.OPTIONAL_HEADER.ImageBase;assert data==im[off:off+row['size']];assert hashlib.sha256(data).hexdigest()==row['sha256']
for row in load(clock/'manifest.json')['files']:assert sha(clock/row['path'])==row['sha256']
standard=B/'loading_standard_ui_preparation'
standard_sources=load(standard/'source_regions.json');assert standard_sources['native_sha256']==meta['native_sha256']
for row in standard_sources['regions']:
 data=bytes.fromhex(row['hex']);off=row['address']-pe.OPTIONAL_HEADER.ImageBase;assert data==im[off:off+row['size']];assert hashlib.sha256(data).hexdigest()==row['sha256']
port=B/'loading_clock_port_agent';port_manifest=load(port/'manifest.json')
assert port_manifest['native_sha256']==meta['native_sha256']
assert port_manifest['native_execution_run'] and not port_manifest['rust_compilation_attempted'] and not port_manifest['rust_tests_run'] and not port_manifest['production_integrated']
for row in port_manifest['files']:assert sha(port/row['path'])==row['sha256']
now=datetime.datetime.now(datetime.timezone.utc);records={}
for name in ['loading_clock_preparation','loading_standard_ui_preparation','loading_clock_port_agent']:
 source=B/name;assert (source/'AUDIT.md').exists() or (source/'README.md').exists()
 dest=R/'docs'/name;rows={}
 for p in source.rglob('*'):
  if not p.is_file():continue
  rel=p.relative_to(source);target=dest/rel;target.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(p,target);assert sha(p)==sha(target);rows[rel.as_posix()]={'sha256':sha(target),'bytes':target.stat().st_size}
 static=name!='loading_clock_port_agent'
 index={'saved_utc':now.isoformat(),'native_sha256':meta['native_sha256'],'static_analysis_only':static,'production_integrated':False,'native_execution_run':not static,'files':rows}
 if not static:index.update(rust_compilation_attempted=False,rust_tests_run=False,windows_connected=False,native_sequences=253,native_calls=349,hardware_samples=277,hardware_mismatches=0)
 save(dest/'index.json',index);records[name]={'manifest':(dest/'index.json').relative_to(R).as_posix(),'sha256':sha(dest/'index.json'),'production_integrated':False,'static_analysis_only':static,'native_execution_run':not static}
backup=R/'docs/plan_history'/('loading-next-preparation-'+now.strftime('%Y%m%dT%H%M%S%fZ'));backup.mkdir(parents=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json']:
 p=R/'docs'/name;shutil.copyfile(p,backup/name);doc=load(p);doc['prepared_loading_next']=records;doc['updated_utc']=now.isoformat()
 if name=='resume_checkpoint.json':doc['saved_utc']=now.isoformat();doc['state']='active'
 save(p,doc)
print(json.dumps(records))
