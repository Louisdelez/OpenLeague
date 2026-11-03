"""Exact source/current-role links; inherited decompilation is not executed UI."""
import argparse,collections,hashlib,json,pathlib,re,sys
class ContractError(ValueError):pass
def require(v,why):
 if not v:raise ContractError(why)
def pin(p):
 p=pathlib.Path(p);b=p.read_bytes();return dict(path=str(p.resolve()),bytes=len(b),sha256=hashlib.sha256(b).hexdigest())
TARGETS=[f'SYS-07.{p}-{i:02}' for p,n in [(4,4),(5,8)] for i in range(1,n+1)]
BOUNDARIES=['SYS-07.4-01','SYS-07.4-02','SYS-07.4-03','SYS-07.5-04']
FALSE_FLAGS=['native_server_policy_qualified','decompiler_freshly_executed','ActionScript_executed','native_binary_executed','current_application_executed','native_UI_fidelity_qualified','recommended_map_alias_runtime_qualified','search_semantics_equivalent','complete_category_payload_qualified','all_champion_dependencies_complete','global_feature_absence_proven']
EXPORT_ROOT=pathlib.Path('E:/mapslol3v3/historical_ingame_shop_extraction/fc249aeaf6104972ab607bc87cd6ce40')
SCRIPT_NEEDLES={
 'ItemShopModule.as':['bindTarget(this.loadRecommendedItemJSON,"LoadRecommendedItemJSON")','bindTarget(this.setCanUndo,"SetCanUndo")','private function loadItemJSON(','private function setPlayerInventory('],
 'ItemShopRoot.as':['public function setPlayerInventory(','private function refresh()','ExternalInterface.call("undo")','public function setCanUndo('],
 'itemdata/ItemData.as':['NUM_INVENTORY_SLOTS:uint = 7','for each(_loc4_ in param3.categories as Array)'],
 'itemdata/ItemCollection.as':['param1 = this.language.simplify(param1);','private function hasName(','private function hasTag('],
 'itemdata/ItemModel.as':['this._searchName = this.language.simplify(this._name) + this._colloquialism;','this._description = new ItemDescription('],
 'SearchArea.as':['SEARCH_KEY_TIME_DELAY:uint = 100','SEARCH_FIELD_TEXT_LIMIT:uint = 1000'],
 'Player.as':['ExternalInterface.call("buyItem",param1.id.toString())','ExternalInterface.call("sellItem",param1.toString())','Utility.getEnvironment() === Utility.ENV_INGAME'],
 'allitemsPane/AllItems.as':['private function buildAllItemTags()','this.itemData.itemCategories[_loc1_].header','this.itemData.itemCategories[_loc1_].tags[_loc3_]'],
 'selecteditemPane/SelectedItem.as':['public function selectWholeItem(','private function showBuildFrom(','public function refresh()'],
 'recommendedPane/RecommendedItems.as':['public function','ItemEvent.EVENT_MODE_RECOMMENDED'],
 'recommendedPane/RecommendedTranslator.as':['public function translateHeader(','public function translateTitle('],
 'tips/Tooltip.as':['public function forceUpdate()','this.itemTooltip.setDescription(param1.item.description)'],
 'Language.as':['function simplify('],
}
ITEM_FIELDS=['RequiredChampion','Price','RecipeItem1','RecipeItem2','RecipeItem3','RecipeItem4','InStore','CanBeSold','SpellName','DisplayName','Description','ItemGroup']
CHAR_FIELDS=['Spell1','Spell2','Spell3','Spell4','Passive1Name','Passive1LuaName','Passive1Desc']
def source_map(f):
 return f['items']|{'char:'+k:v for k,v in f['characters'].items()}|{'gfx':f['gfx']}|{'script:'+k:v for k,v in f['scripts'].items()}|{'rec:'+k:v for k,v in f['recommendations'].items()}|{'font:'+k:v for k,v in f['localization'].items()}|{'dds:'+str(i):v for i,v in enumerate(f['textures'])}|{'official':dict(source=f['official_source'])}
def task_sources(f):
 vik=['3200','3196','3197','3198','char:Viktor'];other=[i for i,n in f['items'].items() if n['fields']['RequiredChampion']!='Viktor'];s=lambda *names:['script:'+n+'.as' for n in names]
 return [vik,vik,other+['char:Rengar','char:Kalista'],list(f['items'])+['official'],['gfx']+s('itemdata/ItemData','allitemsPane/AllItems')+['dds:'+str(i) for i in range(8)],['gfx']+s('itemdata/ItemModel','itemdata/ItemCollection','Language','SearchArea')+['font:fr_FR','font:en_GB'],['official']+s('itemdata/ItemData','itemdata/ItemCollection','allitemsPane/AllItems'),s('ItemShopModule','recommendedPane/RecommendedItems','recommendedPane/RecommendedTranslator')+['rec:'+c for c in f['recommendations']],['gfx']+s('selecteditemPane/SelectedItem','Player','itemdata/ItemModel'),['gfx']+s('tips/Tooltip','itemdata/ItemModel')+['font:fr_FR','font:en_GB'],['gfx']+s('ItemShopRoot','ItemShopModule','Player'),['gfx']+s('ItemShopRoot','itemdata/ItemData')]
def collect_facts(root):
 root=pathlib.Path(root);sys.path.append(str(root/'tools/project-plan'))
 from reference_inibin import read,hashkey
 from rads_reference_membership import RadsReferenceMembership
 load=lambda p:json.loads(pathlib.Path(p).read_bytes());m=RadsReferenceMembership(root);pins={};checks=[]
 def pinned(p):
  s=pin(p);pins[s['path'].casefold()]=s;return s
 def check(name,ok):require(ok,name);checks.append(name)
 def native(rel):
  s=pinned(m.deploy/rel);mem=m.inspect(rel,m.deploy/rel,s);check(rel+'/manifest',mem['status']=='matches_selected_project_manifest');return dict(source=s,relative=rel,membership=mem)
 dd=load(root/'data/4.20/native_ddragon_items_420.json');restricted={id:x for id,x in dd['data'].items() if x.get('requiredChampion')};items={}
 for id,d in restricted.items():
  n=native('DATA/Items/'+id+'.inibin');v=read(n['source']['path']);n['fields']={k:v.get(hashkey('Data',k)) for k in ITEM_FIELDS};n['official']={k:d.get(k) for k in ['name','description','requiredChampion','from','into','specialRecipe','gold','effect']};items[id]=n
  check(id+'/champion field',n['fields']['RequiredChampion']==d['requiredChampion'])
 chars={}
 for name in ['Viktor','Rengar','Kalista']:
  n=native('DATA/Characters/'+name+'/'+name+'.inibin');v=read(n['source']['path']);n['fields']={k:v.get(hashkey('Data',k)) for k in CHAR_FIELDS};chars[name]=n
 gfx=native('DATA/Menu_SC4/FoundryItemShop.gfx');receipt=pinned(EXPORT_ROOT/'receipt.json');old=load(receipt['path']);check('inherited exporter successful static record',old['exit_code']==0 and not old['original_game_executed'] and not old['ActionScript_executed'])
 expected=next(x for x in old['sources'] if pathlib.Path(x['path']).name=='FoundryItemShop.gfx');check('exact exporter GFX input',all(gfx['source'][k]==expected[k] for k in ['bytes','sha256']))
 for k in ['tool','Java']:
  s=pinned(old[k]['path']);check('inherited exporter '+k,all(s[f]==old[k][f] for f in ['bytes','sha256']))
 exports={str(pathlib.Path(x['path']).resolve()).casefold():x for x in old['exported']};scripts={}
 for rel,needles in SCRIPT_NEEDLES.items():
  s=pinned(EXPORT_ROOT/'exported/scripts'/rel);check(rel+'/export hash',all(s[k]==exports[s['path'].casefold()][k] for k in ['bytes','sha256']));lines=pathlib.Path(s['path']).read_text(encoding='utf8').splitlines();selections=[]
  for needle in needles:
   matches=[i+1 for i,l in enumerate(lines) if needle in l];check(rel+'/'+needle,bool(matches));selections.append(dict(needle=needle,lines=matches))
  scripts[rel]=dict(source=s,extraction_receipt=receipt,selections=selections,execution_qualified=False)
 textures=[]
 for name in ['I7','I4','I1','I42','I66','I7B','IB4','I112']:
  n=native('DATA/Menu_SC4/FoundryItemShop_'+name+'.dds');local=pinned(root/'assets/ui/shop420/foundry'/pathlib.Path(n['source']['path']).name);check(name+'/current exact DDS',all(local[k]==n['source'][k] for k in ['bytes','sha256']));n['local_source']=local;textures.append(n)
 resources=load(root/'data/4.20/champion_resources.json');recs={}
 for c,x in resources.items():
  candidates=list((m.deploy/x['resource']).parent.glob('Recommended/*TT.json'));check(c+'/single TT candidate',len(candidates)==1);rel=candidates[0].relative_to(m.deploy).as_posix();n=native(rel);d=load(n['source']['path']);n['document']=d
  n['owner_matches_directory']=str(d['champion']).casefold()==c
  check(c+'/recommendation owner recorded',d['champion'].casefold()=={'soraka':'sona','xerath':'xerath_override'}.get(c,c) and d['mode']=='CLASSIC');check(c+'/raw map value',d['map']==('TT' if c=='kalista' else '10'));recs[c]=n
 shop=load(root/'data/4.20/shop_foundation.json');localization={};texts={}
 for locale in ['fr_FR','en_GB']:
  n=native('DATA/Menu/fontconfig_'+locale+'.txt');content=pathlib.Path(n['source']['path']).read_text(encoding='utf8');texts[locale]=dict(re.findall(r'^tr "([^"]+)" = "(.*)"$',content,re.M));localization[locale]=n
 localized=[]
 for i in shop['items']:
  name='game_item_displayname_'+str(i['id']);desc='game_item_description_'+str(i['id']);row=dict(id=i['id'],current_name=i['name'],current_native_description=i['native_description'],fr_name=texts['fr_FR'].get(name),fr_description=texts['fr_FR'].get(desc),en_name=texts['en_GB'].get(name),en_description=texts['en_GB'].get(desc))
  check(str(i['id'])+'/current FR identity',row['current_name']==row['fr_name'] and row['current_native_description']==row['fr_description']);localized.append(row)
 reg=load(root/'docs/completion_tasks_2026-10-20.json');tm={t['id']:t for t in reg['tasks']};named=[]
 for id in restricted:
  t=tm['ITEM-'+id+'-SCOPE'];check(id+'/existing named scope',str(t['entity'])==id and dd['data'][id]['name'] in t['title']);named.append({k:t[k] for k in ['id','title','entity']})
 for p in ['data/4.20/native_ddragon_items_420.json','data/4.20/champion_resources.json','data/4.20/shop_foundation.json','data/4.20/map10_shop_admission.json','docs/reference_client_4_20.json','tools/project-plan/reference_inibin.py','tools/project-plan/rads_reference_membership.py']:pinned(root/p)
 official=pinned('E:/mapslol3v3/Full_project_audit_2026-10-20/official_reference/item.json');check('official catalogue equivalence',load(official['path'])==dd)
 for s in [m.catalogue_identity,m.solution_identity,m.configuration_identity,*[x['identity'] for x in m.manifests],*m.provenance]:pins[s['path'].casefold()]=s
 return dict(items=items,characters=chars,gfx=gfx,export_receipt=receipt,scripts=scripts,textures=textures,recommendations=recs,localization=localization,localized_items=localized,named_scope_rows=named,official_source=official,source_checks=checks),list(pins.values())
def audit(q,root='E:/OpenLeague',verify_files=True):
 root=pathlib.Path(root);key=lambda p:str(pathlib.Path(p).resolve()).casefold()
 require(q['schema']=='openleague_champion_shop_ui_links/v1' and q['passed'] is True,'schema/result')
 for k in FALSE_FLAGS:require(q[k] is False,'scope: '+k)
 require(q['questions_closed']==q['full_task_scopes_closed']==0,'no scope closure')
 rows=q['associations'];require([x['task_id'] for x in rows]==TARGETS,'task census');require([x['task_id'] for x in rows if x['entry_boundary_only']]==BOUNDARIES,'boundary scopes')
 require(len({x['existing_unknown_id'] for x in rows})==12,'unique open questions')
 pins={key(s['path']):s for s in q['source_identities']};require(len(pins)==len(q['source_identities']),'unique source pins');f=q['facts']
 require(len(f['items'])==35 and set(f['characters'])=={'Viktor','Rengar','Kalista'},'champion-restricted sources')
 for id,n in f['items'].items():require(set(n['fields'])==set(ITEM_FIELDS) and n['fields']['RequiredChampion']==n['official']['requiredChampion'],'native restriction fields')
 require(set(f['scripts'])==set(SCRIPT_NEEDLES),'decompiled source census')
 for rel,s in f['scripts'].items():
  require(s['execution_qualified'] is False and [a['needle'] for a in s['selections']]==SCRIPT_NEEDLES[rel] and all(a['lines'] for a in s['selections']),'script scope and selections')
 require(len(f['recommendations'])==122 and collections.Counter(n['document']['map'] for n in f['recommendations'].values())=={'10':121,'TT':1} and f['recommendations']['kalista']['document']['map']=='TT','raw recommended map alias retained')
 require([c for c,n in f['recommendations'].items() if not n['owner_matches_directory']]==['soraka','xerath'],'two recommendation owner discrepancies retained')
 for c,n in f['recommendations'].items():require(n['document']['champion'].casefold()=={'soraka':'sona','xerath':'xerath_override'}.get(c,c) and n['document']['mode']=='CLASSIC' and n['owner_matches_directory']==(n['document']['champion'].casefold()==c),'recommended ownership')
 natives=[*f['items'].values(),*f['characters'].values(),f['gfx'],*f['textures'],*f['recommendations'].values(),*f['localization'].values()]
 for n in natives:require(n['source']==pins[key(n['source']['path'])] and n['membership']['status']=='matches_selected_project_manifest','native identity/membership')
 require(len(f['textures'])==8,'DDS census')
 for n in f['textures']:require(all(n['local_source'][k]==n['source'][k] for k in ['bytes','sha256']),'current DDS payload')
 require(len(f['localized_items'])==33,'localized definitions')
 for x in f['localized_items']:require(x['current_name']==x['fr_name'] and x['current_native_description']==x['fr_description'] and x['en_name'] is not None,'FR current EN reference distinction')
 require(len(f['named_scope_rows'])==35 and {str(x['entity']) for x in f['named_scope_rows']}==set(f['items']) and all(x['id']=='ITEM-'+str(x['entity'])+'-SCOPE' for x in f['named_scope_rows']),'existing named task coverage')
 require(q['checks_count']==len(q['checks']) and len(set(q['checks']))==len(q['checks']) and q['checks'][:len(f['source_checks'])]==f['source_checks'],'source check census')
 require(sum(len(a['anchors']) for a in rows)==q['role_count']==36 and len({c['role'] for a in rows for c in a['anchors']})==q['role_count'],'role census')
 sources=source_map(f);expected_sources=task_sources(f)
 for index,a in enumerate(rows):
  require(a['finding'] and a['remaining'] and a['anchors'] and a['native_bindings'],'complete association fields')
  require(a['full_task_scope_complete'] is False and a['native_server_policy_qualified'] is False,'partial scope')
  require([key(b['path']) for b in a['native_bindings']]==[key(sources[k]['source']['path']) for k in expected_sources[index]],'task-specific native/derived binding')
  for b in a['native_bindings']:require(key(b['path']) in pins and b['selector'] and b['role']=='native_authoring_input_not_server_policy','native binding authority')
  for c in a['anchors']:
   p=(root/c['path']).resolve();require(p.is_relative_to(root.resolve()) and key(p) in pins and c['role'].startswith('champion_shop_ui_reference_') and c['line']>0,'consumer identity')
   if verify_files:
    lines=p.read_text(encoding='utf8').splitlines();require(c['line']<=len(lines) and c['needle'] in lines[c['line']-1],'actual consumer anchor')
 if verify_files:
  for s in pins.values():require(pin(s['path'])=={k:s[k] for k in ['path','bytes','sha256']},'source changed: '+s['path'])
  actual,actualpins=collect_facts(root);require(actual==f,'native/export/local facts changed');require(all(key(s['path']) in pins and all(pins[key(s['path'])][k]==s[k] for k in ['bytes','sha256']) for s in actualpins),'source set')
 return dict(verified=True,tasks=12,roles=q['role_count'],restricted_items=35,recommendations=122,exported_scripts=len(f['scripts']),scope_complete=False,native_or_game_executed=False)
if __name__=='__main__':
 p=argparse.ArgumentParser();p.add_argument('--root',default='E:/OpenLeague');p.add_argument('--receipt');a=p.parse_args();f=pathlib.Path(a.receipt) if a.receipt else pathlib.Path(a.root)/'docs/reference_champion_shop_ui_sources/champion_shop_ui-links.json';print(json.dumps(audit(json.loads(f.read_bytes()),a.root)))
