"""Exact skin-configuration lookup across dedicated and legacy native layouts.

No skin inheritance or runtime dispatch is inferred. Explicit ChampionSkinID
must match the official catalogue identity; ambiguous bindings remain open.
"""
import argparse,functools,hashlib,json,pathlib,re,sys
R=pathlib.Path('E:/OpenLeague');sys.path.insert(0,str(R/'tools/project-plan'))
from reference_inibin import read,hashkey
FIELDS=['ChampionSkinID','ChampionSkinName','SimpleSkin','Skeleton','Texture','Animations','SkinScale','SelfIllumination']
def integer_identity(value):
 if isinstance(value,bool):return None
 if isinstance(value,int):return value
 if isinstance(value,str) and re.fullmatch(r'[0-9]+',value):return int(value)
 if isinstance(value,float) and value.is_integer():return int(value)
 return None
@functools.lru_cache(maxsize=1024)
def _read(path,mtime,size):
 p=pathlib.Path(path);raw=p.read_bytes();return read(p),{'path':str(p),'bytes':len(raw),'sha256':hashlib.sha256(raw).hexdigest()}
def inspect_binding(path,section,expected_skin_id):
 if not path.is_file():return {'path':str(path),'section':section,'status':'file_absent'}
 stat=path.stat();values,identity=_read(str(path),stat.st_mtime_ns,stat.st_size)
 fields={name:values.get(hashkey(section,name)) for name in FIELDS};actual=integer_identity(fields['ChampionSkinID'])
 status='matches_explicit_skin_id' if actual==expected_skin_id else ('explicit_skin_id_absent_or_invalid' if actual is None else 'different_explicit_skin_id_refused')
 return {'source':identity,'section':section,'status':status,'fields':fields,'expected_skin_id':expected_skin_id,'actual_skin_id':actual}
def choose(bindings):
 qualified=[x for x in bindings if x['status']=='matches_explicit_skin_id']
 if not qualified:return {'status':'unresolved_native_skin_binding','qualified_bindings':[],'candidates':bindings,'runtime_skin_selection_qualified':False}
 first=qualified[0]['fields']
 if any(x['fields']!=first for x in qualified[1:]):return {'status':'ambiguous_native_skin_bindings','qualified_bindings':[],'candidates':bindings,'runtime_skin_selection_qualified':False}
 return {'status':'resolved_explicit_native_skin_id' if len(qualified)==1 else 'equivalent_native_skin_bindings','qualified_bindings':qualified,'candidates':bindings,'runtime_skin_selection_qualified':False}
def resolve(deploy_root,champion,skin_num,skin_id):
 if not isinstance(champion,str) or not re.fullmatch(r'[A-Za-z][A-Za-z0-9]*',champion):raise ValueError('Invalid champion path identity')
 if isinstance(skin_num,bool) or not isinstance(skin_num,int) or not 0<=skin_num<=999:raise ValueError('Invalid skin number')
 expected=integer_identity(skin_id)
 if expected is None or expected<0:raise ValueError('Invalid official skin identity')
 deploy=pathlib.Path(deploy_root).resolve();root=deploy/'DATA/Characters'/champion;folder='Base' if skin_num==0 else f'Skin{skin_num:02}';section='MeshSkin' if skin_num==0 else 'MeshSkin'+str(skin_num)
 paths=[(root/'Skins'/folder/(folder+'.inibin'),'MeshSkin'),(root/(champion+'.inibin'),section)]
 for p,_ in paths:
  if not p.resolve().is_relative_to(deploy):raise ValueError('Skin source escaped native reference root')
 result=choose([inspect_binding(p,s,expected) for p,s in paths]);result.update(champion=champion,skin_num=skin_num,skin_id=expected,
  scope='Native configuration identity and named resource references only; no skin inheritance, availability/ownership, UI selection, runtime dispatch or presentation acceptance.')
 return result

def verify_registry(document,deploy_root):
 counts={};verified=0
 for row in document['rows']:
  actual=resolve(deploy_root,row['champion'],row['skin_num'],row['skin_id'])
  expected={k:v for k,v in row.items() if k not in ['task_ids','prior_missing_config_task_ids']}
  if actual!=expected:raise ValueError('Skin binding no longer reproduces: '+row['champion']+':'+str(row['skin_num']))
  verified+=1;counts[actual['status']]=counts.get(actual['status'],0)+1
 if counts!=document['counts']['statuses'] or verified!=document['counts']['skin_identities']:raise ValueError('Skin registry summary changed')
 return {'verified':True,'skin_identities_verified':verified,'statuses':counts,'runtime_skin_selection_qualified':False,'gameplay_accepted':False}
def main():
 p=argparse.ArgumentParser();p.add_argument('--root',default=str(R));a=p.parse_args();root=pathlib.Path(a.root)
 try:
  ref=json.loads((root/'docs/reference_client_4_20.json').read_bytes());deploy=pathlib.Path(ref['source_root'])/'RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy';result=verify_registry(json.loads((root/'docs/fidelity_skin_configuration_bindings_4_20.json').read_bytes()),deploy)
 except (OSError,ValueError,KeyError) as e:print(json.dumps({'verified':False,'error':str(e)},ensure_ascii=False));return 1
 print(json.dumps(result,ensure_ascii=False,indent=2));return 0
if __name__=='__main__':raise SystemExit(main())
