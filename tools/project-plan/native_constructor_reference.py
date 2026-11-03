"""Use explicit original-code receipts, never guess rank/default inheritance."""
import argparse,collections,hashlib,json,pathlib,re
from fidelity_compare import close,numeric
BINARY_SHA='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
def same_path(a,b):return pathlib.PureWindowsPath(a)==pathlib.PureWindowsPath(b)
def qualified_receipt(receipt,start,stop):
 return bool(receipt and receipt.get('passed') is True and receipt.get('binary',{}).get('sha256')==BINARY_SHA and receipt.get('fragment',{}).get('start')==start and receipt['fragment'].get('stop')==stop and receipt.get('original_instructions_executed_in_isolated_memory') is True and receipt.get('historical_game_process_launched') is False)
def resolve_rank_default(row,source_sha,receipt):
 if row['family'] not in ['champion_spell','summoner'] or row.get('native') is not None:return None
 m=re.fullmatch(r'(cooldown|cost):([1-6])',row['field'])
 if not m or not qualified_receipt(receipt,'0x767a86','0x767c49'):return None
 cases=[x for x in receipt['actual_spell_cases'] if x['subject']==row['subject'] and x['sha256']==source_sha and same_path(x['source'],row['native_path'])]
 if len(cases)!=1:return None
 case=cases[0];field=('Cooldown' if m[1]=='cooldown' else 'ManaCost')+m[2]
 calls=[x for x in case['observed']['calls'] if x.get('field')==field and 'lookup_adapter' in x['api']]
 if len(calls)!=1 or calls[0]['present'] or calls[0]['native_raw'] is not None:return None
 call=calls[0];value=case['observed']['cooldowns' if m[1]=='cooldown' else 'mana_costs'][int(m[2])-1]
 if not close(value,call['constructor_default']) or not close(call['result'],value) or not close(value,row['catalogue']):return None
 return {'status':'resolved_original_constructor_rank_default','selected':'Default supplied by original constructor, not inferred from coincident catalogue values.','native_ranked_field':field,'value':value,'original_constructor_default':call['constructor_default'],
  'binary_sha256':BINARY_SHA,'native_constructor_fragment':['0x767a86','0x767c49'],'getter_api':call['api'],'mechanical_adoption_qualified':False,
  'scope':'Original six-rank loop/default argument and array stores executed in isolated memory; INIBIN lookup/sprintf/scalar setup are explicit adapters. Original cache/overlays and live gameplay not qualified.'}
def resolve_effect_default(row,source_sha,receipt):
 if row['family']!='champion_spell_effect' or row.get('native') is not None or not qualified_receipt(receipt,'0x767427','0x7674a4'):return None
 if row['subject']!=receipt['actual_subject'] or source_sha!=receipt['actual_source']['sha256'] or not same_path(row['native_path'],receipt['actual_source']['path']):return None
 m=re.fullmatch(r'effect(\d+):(\d+)',row['field'])
 if not m:return None
 field=f'Effect{m[1]}Level{m[2]}Amount'
 calls=[x for x in receipt['actual_getter_calls'] if x['field']==field]
 if len(calls)!=1 or calls[0]['present'] or calls[0]['original_constructor_default']!=0 or not close(calls[0]['result'],row['catalogue']):return None
 return {'status':'resolved_original_constructor_effect_zero','selected':'Original effect-array loop supplies an explicit0 default and stores it for this absent field.','field':field,'value':calls[0]['result'],'binary_sha256':BINARY_SHA,'mechanical_adoption_qualified':False,'scope':'Original iteration/FLDZ/array stores exercised with explicit lookup adapter; original cache/overlays and gameplay not qualified.'}
def resolve_projectile_range(row,character,missile):
 if row['family']!='champion_display_range' or row['subject']!='Nami:3' or not row['field'].startswith('range:'):return None
 if character.get('Spell4')!='NamiR' or character.get('ExtraSpell1')!='NamiRMissile' or not close(missile.get('CastRange'),row['catalogue']):return None
 return {'status':'resolved_related_projectile_range','selected':'Catalogue2750 matches NamiRMissile.CastRange, explicitly referenced by Nami.ExtraSpell1. Primary NamiR targeting/display fields stay separate.','projectile_value':missile['CastRange'],'character_link':'Spell4=NamiR; ExtraSpell1=NamiRMissile','mechanical_adoption_qualified':False,'scope':'Metadata relationship, not native cast validation or original live missile travel proof.'}
def resolve_special_recipe(row,native):
 if row['family']!='item_recipe_component' or row.get('native') is not None:return None
 if not close(native.get('SpecialRecipe'),row['catalogue']) or not close(native.get('InStore'),0):return None
 return {'status':'resolved_native_special_recipe_link','selected':'Catalogue from-link matches native SpecialRecipe; RecipeItem1 absence does not erase the alternate native link or create an ordinary purchasable recipe.','native_special_recipe':native['SpecialRecipe'],'native_in_store':native['InStore'],'mechanical_adoption_qualified':False,'scope':'Native metadata link only; transformation triggers and original server behavior remain separate.'}

RESOLVED_STATUSES={'resolved_original_constructor_rank_default','resolved_original_constructor_effect_zero','resolved_related_projectile_range','resolved_native_special_recipe_link'}

def checked_json(path,expected_sha):
 raw=pathlib.Path(path).read_bytes()
 if hashlib.sha256(raw).hexdigest()!=expected_sha:raise ValueError('Original-code receipt identity changed')
 return json.loads(raw)

def verify_recorded_resolutions(document,project_root):
 """Replay the actual persisted comparison policy; no writes or game execution."""
 from reference_inibin import read,hashkey
 root=pathlib.Path(project_root);e=document['constructor_reference_evidence'];rank=checked_json(root/e['rank_receipt']['path'],e['rank_receipt']['sha256']);effect=checked_json(root/e['effect_receipt']['path'],e['effect_receipt']['sha256'])
 def fields(path,section,names,expected):
  raw=pathlib.Path(path).read_bytes()
  if hashlib.sha256(raw).hexdigest()!=expected:raise ValueError('Native source identity changed')
  values=read(path);return {k:values.get(hashkey(section,k)) for k in names}
 char=e['nami_character'];miss=e['nami_projectile']
 character=fields(char['path'],'Data',['Spell4','ExtraSpell1'],char['sha256']);missile=fields(miss['path'],'SpellData',['CastRange'],miss['sha256'])
 counts=collections.Counter()
 for row in document['rows']:
  status=row['resolution']['status']
  if status not in RESOLVED_STATUSES:continue
  identity=document['native_sources'][row['native_path']]['sha256']
  if hashlib.sha256(pathlib.Path(row['native_path']).read_bytes()).hexdigest()!=identity:raise ValueError('Compared native source changed')
  if status=='resolved_original_constructor_rank_default':actual=resolve_rank_default(row,identity,rank)
  elif status=='resolved_original_constructor_effect_zero':actual=resolve_effect_default(row,identity,effect)
  elif status=='resolved_related_projectile_range':actual=resolve_projectile_range(row,character,missile)
  else:actual=resolve_special_recipe(row,fields(row['native_path'],'Data',['SpecialRecipe','InStore'],identity))
  # Evidence edges are provenance metadata; the decision itself must reproduce.
  expected={k:v for k,v in row['resolution'].items() if k!='evidence_source_ids'}
  if actual!=expected:raise ValueError('Original-evidence resolution does not reproduce: '+row['subject']+' '+row['field'])
  counts[status]+=1
 expected_counts={k:v for k,v in document['resolution_counts'].items() if k in RESOLVED_STATUSES}
 if dict(counts)!=expected_counts:raise ValueError('Resolution summary count changed')
 return {'verified':True,'verified_resolution_rows':sum(counts.values()),'resolution_counts':dict(counts),
  'remaining_open_rows':len(document['open_question_rows']),'historical_game_process_launched':False,'gameplay_accepted':False}

def main():
 p=argparse.ArgumentParser();p.add_argument('--root',default='E:/OpenLeague');args=p.parse_args()
 try:result=verify_recorded_resolutions(json.loads((pathlib.Path(args.root)/'docs/fidelity_catalogue_comparison_4_20.json').read_bytes()),args.root)
 except (OSError,ValueError,KeyError) as e:print(json.dumps({'verified':False,'error':str(e)},ensure_ascii=False));return 1
 print(json.dumps(result,ensure_ascii=False,indent=2));return 0
if __name__=='__main__':raise SystemExit(main())
