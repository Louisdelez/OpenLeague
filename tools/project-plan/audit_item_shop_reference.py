"""Read-only item/shop source qualification. Does not execute game behavior."""
import argparse,collections,hashlib,json,pathlib,re,sys
class ContractError(ValueError):pass
def require(ok,why):
 if not ok:raise ContractError(why)
def pin(p):
 p=pathlib.Path(p);b=p.read_bytes();return dict(path=str(p.resolve()),bytes=len(b),sha256=hashlib.sha256(b).hexdigest())
TARGETS=[f'SYS-07.{p}-{i:02}' for p,n in [(1,4),(2,10),(3,7)] for i in range(1,n+1)]
BOUNDARIES=['SYS-07.1-03','SYS-07.2-06','SYS-07.2-10','SYS-07.3-02','SYS-07.3-05']
FIELDS=['DisplayName','Description','Price','SellBackModifier','MaxStack','RequiredChampion','ItemGroup','InStore','CanBeSold','UseEffect','UseWhenAcquired','SpellName']+['RecipeItem'+str(i) for i in range(1,5)]
SCOPE_FALSE=['native_server_policy_qualified','historical_shop_radius_qualified','native_item_absence_means_invalid','stack_quantity_is_instance_charge','all_named_passives_implemented','all_actives_implemented','historical_rounding_qualified','current_application_executed','native_binary_executed','global_feature_absence_proven']
def collect_facts(root):
 root=pathlib.Path(root);sys.path.append(str(root/'tools/project-plan'))
 from reference_inibin import read,hashkey
 from rads_reference_membership import RadsReferenceMembership
 load=lambda p:json.loads(pathlib.Path(p).read_bytes());pins={};checks=[]
 def pinned(p):
  s=pin(p);pins[s['path'].casefold()]=s;return s
 def check(name,ok):require(ok,name);checks.append(name)
 m=RadsReferenceMembership(root);natives={}
 audit=load(root/'data/4.20/native_item_audit.json');dd=load(root/'data/4.20/native_ddragon_items_420.json');shop=load(root/'data/4.20/shop_foundation.json');ad=load(root/'data/4.20/map10_shop_admission.json')
 official=pathlib.Path('E:/mapslol3v3/Full_project_audit_2026-10-20/official_reference/item.json');os=pinned(official)
 check('official4.20.1 catalogue semantic identity',dd==load(official) and dd['version']=='4.20.1')
 check('admission raw JSON provenance',os['sha256']==ad['source_complete_JSON_utf8_sha256'])
 for row in audit:
  p=pathlib.Path(row['source']);s=pinned(p);rel='DATA/Items/'+p.name;mem=m.inspect(rel,p,s)
  check(str(row['id'])+'/source',s['sha256']==row['sha256'])
  check(str(row['id'])+'/manifest',mem['status']=='matches_selected_project_manifest')
  values=read(p);natives[str(row['id'])]=dict(source=s,relative=rel,membership=mem,fields={k:values.get(hashkey('Data',k)) for k in FIELDS})
 check('849 unique native IDs',len(natives)==len(audit)==849)
 check('280 official IDs native present',len(dd['data'])==280 and set(dd['data'])<=set(natives))
 nativeonly=sorted(set(map(int,natives))-set(map(int,dd['data'])))
 require(len(nativeonly)==569,'native only census')
 def total(id,path=()):
  require(id not in path and len(path)<32,'native recipe cycle/depth');f=natives[str(id)]['fields'];children=[int(f[k]) for k in FIELDS if k.startswith('RecipeItem') and f[k] is not None and float(f[k])>0]
  return float(f['Price'])+sum(total(c,path+(id,)) for c in children)
 rows=[];admap={i['id']:i['allowed'] for i in ad['items']}
 check('admission exact scope',ad['schema']==1 and ad['map_id']==10 and len(admap)==len(ad['items'])==len(shop['items'])==33 and set(admap)=={i['id'] for i in shop['items']})
 for i in shop['items']:
  id=i['id'];f=natives[str(id)]['fields'];d=dd['data'][str(id)];recipe=[int(f[k]) for k in FIELDS if k.startswith('RecipeItem') and f[k] is not None and float(f[k])>0];maps=dd['basic']['maps']|d.get('maps',{})
  row=dict(id=id,native_component_price=float(f['Price']),native_recipe=recipe,native_recursive_total=total(id),local_total=i['price'],official_total=d['gold']['total'],local_sell=i.get('sell_price'),official_sell=d['gold']['sell'],map10_allowed=admap[id],official_map10=maps['10'],local_group=i.get('group',''),native_group=f['ItemGroup'],native_max_stack=f['MaxStack'],local_max_stack=i.get('max_stack'),quantity_not_instance_charge=True)
  row['declared_source_sha256']=i.get('source_sha256');row['declared_source_missing']='source_sha256' not in i
  check(str(id)+'/local provenance recorded',row['declared_source_missing'] or i['source_sha256']==natives[str(id)]['source']['sha256'])
  check(str(id)+'/recipe',recipe==i['recipe'])
  check(str(id)+'/total',row['native_recursive_total']==i['price']==d['gold']['total'])
  check(str(id)+'/sell',i.get('sell_price')==d['gold']['sell'])
  check(str(id)+'/map10',admap[id] is maps['10'])
  if i.get('consumable'):check(str(id)+'/potion stack',i['max_stack']==f['MaxStack']==5 and i['group']=='' and f['ItemGroup'] in ['HealthPotion','ManaPotion'])
  rows.append(row)
 shops=[]
 for index,s in enumerate(shop['shops']):
  p=pathlib.Path(s['source']);identity=pinned(p);rel='LEVELS/Map10/scene/'+p.name;mem=m.inspect(rel,p,identity);coords=list(map(float,re.search(r'^CentralPoint=\s*(.*)$',p.read_text(),re.M)[1].split()))
  check('shop'+str(index)+'/source',identity['sha256']==s['sha256'] and mem['status']=='matches_selected_project_manifest')
  check('shop'+str(index)+'/coordinates',s['point']==dict(x=coords[0],z=coords[2]))
  shops.append(dict(source=identity,relative=rel,membership=mem,central_point=coords,current_point=s['point'],historical_purchase_radius_qualified=False))
 restrictions={id:dict(native=natives[id]['fields']['RequiredChampion'],official=d['requiredChampion']) for id,d in dd['data'].items() if d.get('requiredChampion')}
 for id,x in restrictions.items():check(id+'/champion restriction',x['native']==x['official'])
 examples={id:{k:dd['data'][id].get(k) for k in ['name','description','requiredChampion','maps','gold','from','into','specialRecipe']} for id in ['1001','2003','2004','3003','3040','3070','3144','3146','3157','3196','3200','3340','3341','3599']}
 for p in ['data/4.20/native_item_audit.json','data/4.20/native_ddragon_items_420.json','data/4.20/shop_foundation.json','data/4.20/map10_shop_admission.json','docs/reference_client_4_20.json','tools/project-plan/reference_inibin.py','tools/project-plan/rads_reference_membership.py']:pinned(root/p)
 for s in [m.catalogue_identity,m.solution_identity,m.configuration_identity,*[x['identity'] for x in m.manifests],*m.provenance]:pins[s['path'].casefold()]=s
 facts=dict(native_items=natives,official_source=os,native_only_ids=nativeonly,official_ids=sorted(map(int,dd['data'])),shop_rows=rows,shops=shops,shop_radius_local=shop['shop_radius'],champion_restrictions=restrictions,official_examples=examples,source_checks=checks)
 return facts,list(pins.values())

def audit(q,root='E:/OpenLeague',verify_files=True):
 root=pathlib.Path(root);key=lambda p:str(pathlib.Path(p).resolve()).casefold()
 require(q['schema']=='openleague_item_shop_links/v1' and q['passed'] is True,'schema/result')
 for k in SCOPE_FALSE:require(q[k] is False,'scope: '+k)
 require(q['questions_closed']==q['full_task_scopes_closed']==0,'no scope closure')
 rows=q['associations'];require([a['task_id'] for a in rows]==TARGETS,'task census')
 require([a['task_id'] for a in rows if a['entry_boundary_only']]==BOUNDARIES,'boundary scopes')
 require(len({a['existing_unknown_id'] for a in rows})==21,'distinct open questions')
 pins={key(s['path']):s for s in q['source_identities']};require(len(pins)==len(q['source_identities']),'unique source identities')
 f=q['facts'];n=f['native_items'];require(len(n)==849 and len(f['official_ids'])==280 and len(set(f['official_ids']))==280,'catalogue census')
 require(f['native_only_ids']==sorted(set(map(int,n))-set(f['official_ids'])) and len(f['native_only_ids'])==569,'native only IDs retained')
 require(all(str(i) in n for i in f['official_ids']),'official membership')
 require(len(f['source_checks'])==len(set(f['source_checks'])) and q['checks_count']==len(q['checks']) and q['checks'][:len(f['source_checks'])]==f['source_checks'],'check census')
 for id,v in n.items():
  require(set(v['fields'])==set(FIELDS),'native field census')
  require(v['source']==pins[key(v['source']['path'])] and v['membership']['status']=='matches_selected_project_manifest','item source/membership')
 require(len(f['shop_rows'])==33 and len({x['id'] for x in f['shop_rows']})==33,'implemented catalogue census')
 for x in f['shop_rows']:
  require(x['native_recursive_total']==x['local_total']==x['official_total'],'component vs total price')
  require(x['local_sell']==x['official_sell'],'explicit sale price')
  require(x['map10_allowed'] is x['official_map10'] and x['quantity_not_instance_charge'] is True,'map admission/quantity')
  require(x['native_component_price']==float(n[str(x['id'])]['fields']['Price']),'native base price')
 require(sum(x['map10_allowed'] for x in f['shop_rows'])==31,'31 Map10 admitted definitions')
 require(sorted(x['id'] for x in f['shop_rows'] if x['declared_source_missing'])==[1018,1051,1053],'three missing declared hashes retained')
 for x in f['shop_rows']:
  require(x['declared_source_missing']==(x['declared_source_sha256'] is None),'missing hash meaning')
  if not x['declared_source_missing']:require(x['declared_source_sha256']==n[str(x['id'])]['source']['sha256'],'declared source hash')
 require(f['shop_radius_local']==1000 and len(f['shops'])==2,'local shop geometry scope')
 for s in f['shops']:require(s['historical_purchase_radius_qualified'] is False and s['membership']['status']=='matches_selected_project_manifest' and s['current_point']==dict(x=s['central_point'][0],z=s['central_point'][2]),'shop coordinate/radius distinction')
 require(len(f['champion_restrictions'])==35 and all(x['native']==x['official'] for x in f['champion_restrictions'].values()),'champion restriction sources')
 require(f['official_source']==pins[key(f['official_source']['path'])],'official source pin')
 active=[x['id'] for x in f['shop_rows']];restricted=list(map(int,f['champion_restrictions']));potions=[2003,2004]
 itemlists=[f['native_only_ids'],active,restricted,active,[],active,[1029,1031,2003,2004],active,active,[],potions,potions,[],[2003,2004,3340,3341],[1001,3070,3003],[3144,3146,3157,3340,3341],potions,[2003,2004,3340,3341],[3070,3003,3040],active,[2003,2004,3003,3040]]
 catalogue_indices={0,1,2,3,5,7,8,9,12,13,14,15,17,18,19,20}
 require(sum(len(a['anchors']) for a in rows)==62 and len({c['role'] for a in rows for c in a['anchors']})==62,'precise role census')
 for index,a in enumerate(rows):
  require(a['finding'] and a['remaining'] and a['anchors'],'finding/remaining/anchors')
  require(a['full_task_scope_complete'] is False and a['native_server_policy_qualified'] is False,'partial scope')
  require(a['native_bindings'],'explicit native or catalog source per requirement')
  expected=[key(n[str(id)]['source']['path']) for id in itemlists[index]]
  if index in catalogue_indices:expected.append(key(f['official_source']['path']))
  if index==4:expected.extend(key(s['source']['path']) for s in f['shops'])
  require([key(b['path']) for b in a['native_bindings']]==expected,'task-specific native binding')
  for b in a['native_bindings']:require(key(b['path']) in pins and b['selector'] and b['role']=='native_authoring_input_not_server_policy','source authority')
  for c in a['anchors']:
   p=(root/c['path']).resolve();require(p.is_relative_to(root.resolve()) and key(p) in pins and c['role'].startswith('item_shop_reference_') and c['line']>0,'consumer identity')
   if verify_files:
    lines=p.read_text(encoding='utf8').splitlines();require(c['line']<=len(lines) and c['needle'] in lines[c['line']-1],'actual consumer anchor')
 if verify_files:
  for s in pins.values():require(pin(s['path'])=={k:s[k] for k in ['path','bytes','sha256']},'source changed: '+s['path'])
  actual,actualpins=collect_facts(root);require(actual==f,'native/local facts changed')
  require(all(key(s['path']) in pins and all(pins[key(s['path'])][k]==s[k] for k in ['bytes','sha256']) for s in actualpins),'actual source census')
 return dict(verified=True,tasks=len(rows),roles=sum(len(a['anchors']) for a in rows),native_items=len(n),native_only_retained=len(f['native_only_ids']),active_definitions=33,map10_admitted=31,scope_complete=False,native_or_game_executed=False)
if __name__=='__main__':
 p=argparse.ArgumentParser();p.add_argument('--root',default='E:/OpenLeague');p.add_argument('--receipt');a=p.parse_args();f=pathlib.Path(a.receipt) if a.receipt else pathlib.Path(a.root)/'docs/reference_item_shop_sources/item_shop-links.json';print(json.dumps(audit(json.loads(f.read_bytes()),a.root)))
