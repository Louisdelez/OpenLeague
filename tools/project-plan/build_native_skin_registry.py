import argparse,collections,datetime,hashlib,json,pathlib,sys
from native_skin_reference import resolve
R=pathlib.Path('E:/OpenLeague')
def load(p):return json.loads(p.read_bytes())
def identity(p):b=p.read_bytes();return {'path':str(p),'bytes':len(b),'sha256':hashlib.sha256(b).hexdigest()}
p=argparse.ArgumentParser();p.add_argument('--root',default=str(R));p.add_argument('--output',required=True);a=p.parse_args();root=pathlib.Path(a.root);out=pathlib.Path(a.output)
if out.exists():p.error('Preserve existing audit output.')
ref=load(root/'docs/reference_client_4_20.json');dep=pathlib.Path(ref['source_root'])/'RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy';cat_path=pathlib.Path(ref['catalogue']['local_path']);catalogue=load(cat_path)
assert identity(cat_path)['sha256']==ref['catalogue']['sha256'] and catalogue['version']=='4.20.1'
reg_path=root/'docs/completion_tasks_2026-10-20.json';reg=load(reg_path);groups={};official={}
for champion,entry in catalogue['data'].items():
 for skin in entry['skins']:official[(champion,skin['num'],str(skin['id']))]=skin
for task in reg['tasks']:
 if not task['id'].startswith('SKIN-'):continue
 e=task['entity'];key=(e['champion'],e['skin_num'],str(e['skin_id']));assert key in official,'Skin entity not in exact official catalogue: '+task['id'];groups.setdefault(key,[]).append(task['id'])
assert set(groups)==set(official),'Official skin coverage differs from plan entities.'
unknown_path=root/'docs/fidelity_unknowns_4_20.json';unknown=load(unknown_path);missing={x['task_id']:x for x in unknown['unknowns'] if x['aspect']=='native_skin_config' and x['status']=='open'}
rows=[]
for (champion,num,sid),task_ids in groups.items():
 row=resolve(dep,champion,num,sid);row['task_ids']=task_ids;row['prior_missing_config_task_ids']=[t for t in task_ids if t in missing];rows.append(row)
counts={'skin_identities':len(rows),'skin_tasks':sum(map(len,groups.values())),'statuses':dict(collections.Counter(x['status'] for x in rows)),
 'prior_missing_config_questions':len(missing),'prior_missing_questions_with_explicit_native_id':sum(len(x['prior_missing_config_task_ids']) for x in rows if x['qualified_bindings']),
 'legacy_only_explicit_configs':sum(bool(x['qualified_bindings']) and all('/Skins/' not in b['source']['path'].replace('\\','/') for b in x['qualified_bindings']) for x in rows)}
result={'schema':'openleague_native_skin_configuration_bindings/v1','created_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'reference':'4.20.0.315 PUBLIC EUW/en_GB','native_deploy_root':str(dep),
 'official_catalogue':{**identity(cat_path),'url':ref['catalogue']['url'],'version':'4.20.1','locale':ref['catalogue']['locale']},'input_registry_at_generation':identity(reg_path),'input_unknown_registry_at_generation':identity(unknown_path),
 'counts':counts,'rows':rows,'runtime_skin_selection_qualified':False,'historical_game_process_launched':False,
 'producer':{**identity(pathlib.Path(__file__)),'helper':identity(pathlib.Path(__file__).with_name('native_skin_reference.py'))},
 'limits':['Explicit native ChampionSkinID matches the official skin identity; this is a source binding, not gameplay/presentation/ownership acceptance.','Dedicated and legacy bindings must agree on all named fields to be equivalent. Conflicting Renekton scales/names remain ambiguous.','A missing conventional directory is not proof of absent skin configuration; indexed legacy sections must be checked. No skin inheritance/default base substitution is inferred.']}
out.parent.mkdir(parents=True,exist_ok=True);out.write_text(json.dumps(result,ensure_ascii=False,indent=2,allow_nan=False)+'\n',encoding='utf-8');print(json.dumps(counts,indent=2))
