"""Archive a read-only port mapping without rewriting the qualification receipt."""
from pathlib import Path
import datetime,hashlib,json,shutil

R=Path('E:/OpenLeague');S=Path(__file__).resolve().parent
def sha(p):
 with p.open('rb') as f:return hashlib.file_digest(f,'sha256').hexdigest()
def load(p):return json.loads(p.read_text(encoding='utf-8-sig'))
def encoded(d):return (json.dumps(d,ensure_ascii=False,indent=2)+'\n').encode('utf-8')

m=S/'manifest.json';expected='e78c943f30769f72ea132c0efad62ac3a151a87ce3f02ce7a25473c426a6209f'
assert sha(m)==expected
d=load(m);assert d['status']=='port_mapping_only_not_integrated'
assert sha(S/'PLAN.md')==d['plan']['sha256']
for row in d['production_sources_consulted_or_dependency_artifacts']+d['frozen_preparation_files_verified']:
 p=Path(row['path']);assert p.stat().st_size==row['bytes'] and sha(p)==row['sha256'],p
receipt=R/'docs/loading_standard_validation.json';receipt_before=receipt.read_bytes()
v=load(receipt);assert v['passed'] and not v['complete'] and v['core_tests']['passed']==865 and v['client']['commands']==11
now=datetime.datetime.now(datetime.timezone.utc).isoformat()
summary={'saved_utc':now,'status':d['status'],'complete':False,
         'plan':'docs/loading_resource_manager_port_plan/PLAN.md','plan_sha256':d['plan']['sha256'],
         'manifest':'docs/loading_resource_manager_port_plan/manifest.json','manifest_sha256':expected,
         'production_sources_checked':29,'tests_run':[],'next_action':d['next_action']}
prefix=('Use docs/loading_resource_manager_port_plan/PLAN.md for exact reusable Rust interfaces. Before connecting90AD00, extend typed ownership and scratch retirement to retain both caller name and normalized cache key on simultaneous cleanup failures. ')
payloads={}
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json']:
 p=R/'docs'/name;x=load(p);assert 'prepared_loading_resource_port_plan' not in x
 x['prepared_loading_resource_port_plan']=summary;x['updated_utc']=now;x['next_action']=prefix+x['next_action']
 if name=='resume_checkpoint.json':
  assert x['state']=='active';x['saved_utc']=now
 if name=='completion_plan.json':x['next_execution_steps'][0]=x['next_action']
 payloads[p]=encoded(x)
html=R/'docs/completion_plan.html';body=html.read_text(encoding='utf-8')
assert body.count('</body>')==1 and 'id="loading-resource-port-plan"' not in body
section='<section id="loading-resource-port-plan"><h2>Prochain raccordement des ressources</h2><p>La cartographie des fonctions Rust réutilisables est archivée. Le port du gestionnaire doit conserver les deux noms temporaires et leur stockage en cas d’échec du nettoyage, puis qualifier le cache et les fournisseurs réels avant leur affichage. Cette préparation ne constitue pas une implémentation supplémentaire.</p></section>'
payloads[html]=body.replace('</body>',section+'</body>').encode('utf-8')
dest=R/'docs/loading_resource_manager_port_plan';dest.mkdir(parents=True,exist_ok=True)
for name in ['PLAN.md','manifest.json','archive_plan.py']:
 shutil.copyfile(S/name,dest/name);assert sha(S/name)==sha(dest/name)
originals={p:p.read_bytes() for p in payloads}
backup=R/'docs/plan_history'/('loading-resource-port-plan-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));backup.mkdir(parents=True)
for p,b in originals.items():(backup/p.name).write_bytes(b)
pending={}
for p,b in payloads.items():
 t=p.with_suffix(p.suffix+'.resource-plan-pending');t.write_bytes(b);assert t.read_bytes()==b;pending[p]=t
try:
 assert receipt.read_bytes()==receipt_before
 for p,t in pending.items():t.replace(p)
 for p,b in payloads.items():assert p.read_bytes()==b
 assert receipt.read_bytes()==receipt_before
except BaseException:
 for p,b in originals.items():
  t=p.with_suffix(p.suffix+'.resource-plan-rollback');t.write_bytes(b);t.replace(p)
 raise
finally:
 for t in pending.values():t.unlink(missing_ok=True)
print(json.dumps(summary))
