from pathlib import Path
import hashlib,json,datetime,shutil
import pefile
R=Path('E:/OpenLeague');S=Path('E:/mapslol3v3/replay_packet95_recipient_audit');D=R/'docs/replay_loading_screen_preparation'
def load(p):return json.loads(p.read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def save(p,data):
 temp=p.with_suffix(p.suffix+'.tmp');temp.write_text(json.dumps(data,indent=2,ensure_ascii=False)+'\n',encoding='utf-8');temp.replace(p)
m=load(S/'recipient_audit_manifest.json');assert not m['integrated'] and not m['native_execution_performed'] and not m['rust_compilation_performed']
assert sha(S/'recipient_audit_manifest.json')=='61942a78a460796718f6cc596b15bbc7ba1360bfd8fe5e8a47a00615b9281696'
native=load(R/'data/4.20/runtime/replay_runtime_image_manifest.json');src=Path(native['native_source']);assert sha(src)==m['native_sha256']==native['native_sha256']
pe=pefile.PE(str(src));image=pe.get_memory_mapped_image();regions=load(S/'recipient_sources.json')['regions'];assert len(regions)==44
for x in regions:
 raw=bytes.fromhex(x['hex']);start=x['address']-pe.OPTIONAL_HEADER.ImageBase
 assert len(raw)==x['size'] and raw==image[start:start+len(raw)] and hashlib.sha256(raw).hexdigest()==x['sha256']
assert sum(x['size'] for x in regions)==8315
D.mkdir(parents=True,exist_ok=True);files={}
for item in m['files']:
 p=Path(item['path']);assert p.parent.resolve()==S.resolve() and sha(p)==item['sha256'];out=D/p.name;shutil.copyfile(p,out);files[p.name]=sha(out)
shutil.copyfile(S/'recipient_audit_manifest.json',D/'recipient_audit_manifest.json');files['recipient_audit_manifest.json']=sha(D/'recipient_audit_manifest.json')
now=datetime.datetime.now(datetime.timezone.utc);proof={'saved_utc':now.isoformat(),'native_sha256':m['native_sha256'],'production_integrated':False,'static_analysis_only':True,'native_regions_independently_verified':44,'native_bytes':8315,'files':files,'next_step':m['next_step']}
save(D/'index.json',proof);summary={'manifest':str((D/'index.json').relative_to(R)),'sha256':sha(D/'index.json'),'production_integrated':False,'static_analysis_only':True,'native_regions_verified':44}
P=Path('E:/mapslol3v3/replay_loading_record_probe');Q=R/'docs/replay_loading_record_preparation';Q.mkdir(parents=True,exist_ok=True)
assert sha(P/'loading_record_manifest.json')=='30c7bf9cc69cc91f18fd64c93e53953364542cb7f0b22a54c7bd16a1ef3be706'
hot=load(P/'loading_record_manifest.json');assert hot['passed'] and not hot['integrated'] and not hot['rust_compilation_performed'];assert hot['results']['cases']==1600 and hot['trace_events']==39736
hotregions=load(P/'loading_record_sources.json')['regions'];assert len(hotregions)==5 and sum(x['size'] for x in hotregions)==2148
for x in hotregions:
 raw=bytes.fromhex(x['hex']);start=x['address']-pe.OPTIONAL_HEADER.ImageBase;assert raw==image[start:start+len(raw)] and len(raw)==x['size'] and hashlib.sha256(raw).hexdigest()==x['sha256']
hotfiles={}
for item in hot['files']:
 p=Path(item['path']);assert p.parent.resolve()==P.resolve() and sha(p)==item['sha256'];out=Q/p.name;shutil.copyfile(p,out);hotfiles[p.name]=sha(out)
shutil.copyfile(P/'loading_record_manifest.json',Q/'loading_record_manifest.json');hotfiles['loading_record_manifest.json']=sha(Q/'loading_record_manifest.json')
save(Q/'index.json',{'saved_utc':now.isoformat(),'native_sha256':m['native_sha256'],'production_integrated':False,'rust_tests_run':False,'native_cases':1600,'native_regions_independently_verified':5,'scope':hot['scope'],'files':hotfiles})
hot_summary={'manifest':str((Q/'index.json').relative_to(R)),'sha256':sha(Q/'index.json'),'production_integrated':False,'rust_tests_run':False,'native_cases':1600}
new=('Next concrete packet95 work: port loading-screen recipients57D650 (standard) and5B3230 (tutorial), record lookups5BE170/5BE1F0,25-byte payload copies and real UI/string dependencies. A native oracle now passes1600 existing-record/nonempty-SSO cases; it is archived in docs/replay_loading_record_preparation/index.json and has no Rust/application integration. Qualify missing-key insertion, UI first initialization and wrapper128/control16 construction, publication and retirement before binding an active recipient. Static provenance is archived separately in docs/replay_loading_screen_preparation/index.json. ')
backup=R/'docs/plan_history'/('replay-loading-preparation-'+now.strftime('%Y%m%dT%H%M%S%fZ'));backup.mkdir(parents=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json']:
 p=R/'docs'/name;data=load(p);shutil.copyfile(p,backup/name);data['prepared_replay_loading_screen']=summary;data['prepared_replay_loading_records']=hot_summary;data['next_action']=new+data['next_action'];data['updated_utc']=now.isoformat()
 if name=='resume_checkpoint.json':data['saved_utc']=now.isoformat()
 if name=='completion_plan.json':data['next_execution_steps'][0]=data['next_action']
 save(p,data)
html=R/'docs/completion_plan.html';text=html.read_text(encoding='utf-8');marker='replay-loading-preparation';assert marker not in text;shutil.copyfile(html,backup/html.name)
section='<section id="replay-loading-preparation"><h2>Préparation : écran de chargement</h2><p>Les véritables destinataires du paquet95 sont identifiés. 1 600 cas natifs passent pour les mises à jour de records existants dans les écrans standard et tutoriel. Cette preuve prépare le port Rust ; elle ne constitue pas une fonctionnalité intégrée. Les nouvelles entrées, l’initialisation UI et les durées de vie restent à qualifier.</p></section>'
temp=html.with_suffix('.html.tmp');temp.write_text(text.replace('</body>',section+'</body>'),encoding='utf-8');temp.replace(html)
print(json.dumps({'prepared_manifest':summary['manifest'],'sha256':summary['sha256'],'native_regions_verified':44,'existing_record_native_cases':1600,'record_manifest':hot_summary['manifest'],'production_integrated':False}))
