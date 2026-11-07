"""Source-backed screen/route inventory, without starting the historical patcher."""
import argparse,csv,hashlib,io,json,pathlib,re
from patcher_formats import read_manifest,read_load
from frontend_builds import digest,safe_source,pe_versions
from reference_client import load_reference,validate as validate_client
CONTRACT='docs/reference_patcher_routes_4_20.json'
class PatcherReferenceError(ValueError):pass

def translations(data):
    values={}
    for line in data.decode('utf-8-sig').splitlines():
        if not line.strip() or line.lstrip().startswith('//'):continue
        m=re.fullmatch(r'\s*tr\s+"([^"\\]+)"\s*=\s*("(?:\\.|[^"\\])*")\s*',line)
        if not m or m[1] in values:raise PatcherReferenceError('Catalogue de traductions ambigu ou illisible.')
        values[m[1]]=json.loads(m[2])
    return values

def load_members(doc,roots):
    manifest=read_manifest(safe_source(roots['native'],doc['patcher']['manifest']).read_bytes())
    if manifest['project']!='lol_patcher' or manifest['release']!='0.0.0.11':raise PatcherReferenceError('Mauvais projet/release du patcher.')
    members={};bundle_results=[]
    for bundle in doc['bundles']:
        data=safe_source(roots['recovered'],bundle['path']).read_bytes();entry=manifest['files'].get(bundle['path'])
        if not entry or entry['bytes']!=len(data) or entry['md5']!=hashlib.md5(data).hexdigest() or entry['release']!='0.0.0.11':raise PatcherReferenceError('Bundle différent du manifeste natif : '+bundle['path'])
        if digest(safe_source(roots['recovered'],bundle['path']))!={k:bundle[k] for k in ['bytes','sha256']}:raise PatcherReferenceError('Empreinte du bundle divergente.')
        files,metadata=read_load(data)
        if set(files)&set(members):raise PatcherReferenceError('Membre de bundle dupliqué.')
        members.update(files);bundle_results.append({'path':bundle['path'],'members':metadata})
    return members,bundle_results

def surface(members,tra,route_bytes):
    app='bundle-chrome/src/js/app.js';text=members[app].decode('utf-8')
    controllers=[{'name':m[0],'module':'bundle-chrome/src/js/'+m[1]+'.js'} for m in re.findall(r"app\.controller\('([^']+)', require\('([^']+)'\)\)",text)]
    for c in controllers:
        if c['module'] not in members:raise PatcherReferenceError('Contrôleur référencé absent.')
    modals=[]
    for path,b in members.items():
        if path.startswith('bundle-chrome/src/js/app/') and path.endswith('Modal.js'):
            text=b.decode('utf-8');targets=re.findall(r"templateUrl:\s*'([^']+)'",text)
            if len(targets)!=1 or 'bundle-chrome/src/'+targets[0] not in members:raise PatcherReferenceError('Template de modale absent/ambigu.')
            modals.append({'factory':path,'template':'bundle-chrome/src/'+targets[0]})
    commands={};events={};bindings=[];read_keys=set()
    for path,b in members.items():
        if not (path.startswith('bundle-chrome/src/js/app/') or path=='bundle-chrome/src/index.html'):continue
        if not path.endswith(('.js','.html')):continue
        text=b.decode('utf-8')
        for i,line in enumerate(text.splitlines(),1):
            for m in re.finditer(r"hostCommand\(\s*['\"]([^'\"]+)['\"]",line):commands.setdefault(m[1],[]).append({'member':path,'line':i})
            for m in re.finditer(r"addEventListener\(\s*['\"]([^'\"]+)['\"]",line):events.setdefault(m[1],[]).append({'member':path,'line':i})
            for name,value in re.findall(r'\b(ng-click|ng-change|ng-disabled|ng-show|ng-hide)="([^"\n]+)"',line):bindings.append({'member':path,'line':i,'attribute':name,'value':value})
        read_keys.update(re.findall(r"\btra\[['\"]([^'\"]+)['\"]\]",text));read_keys.update(re.findall(r'\btra\.([A-Za-z_][A-Za-z0-9_]*)',text))
    read_keys.discard('length') # tra.length is a JS container property, not a localization key.
    missing=read_keys-set(tra)
    if missing:raise PatcherReferenceError('Clés de traduction absentes : '+str(sorted(missing)))
    routes=[]
    for row in csv.reader(io.StringIO(route_bytes.decode('utf-8-sig'))):
        if len(row)!=4:raise PatcherReferenceError('Route CSV invalide.')
        bundle,role,name,target=row
        member=bundle+'/'+target
        routes.append({'bundle':bundle,'role':role,'route':name,'member':member,'member_recovered':member in members,
                       'is_patcher_ui_page':role in ['chrome','landing','f2p','articles','patch-notes']})
    if any(x['is_patcher_ui_page'] and not x['member_recovered'] for x in routes):raise PatcherReferenceError('Vue routée du patcher absente.')
    return {'controllers':sorted(controllers,key=lambda x:x['name']),'modals':sorted(modals,key=lambda x:x['factory']),
            'host_commands':commands,'event_listeners':events,'bindings':bindings,'translation_keys_read':sorted(read_keys),'translation_count':len(tra),'routes':routes}

def log_events(data):
    out=[]
    allowed=['Client::PatcherUI::Init:','Client::PatcherUI::SetTaskState:','Client::PatcherUI::SetTroubleshootResult:',
             'Client::PatcherUI::OnTaskComplete:','Client::PatcherUI::DisplayAgreement:','Client::PatcherUI::SendCommand:','AgreementManager::TryShowAgreement:']
    for i,line in enumerate(data.decode('utf-8').splitlines(),1):
        if any(k in line.lower() for k in ['commandline','command line','password','token','createradsprocess']):continue
        if not any(x in line for x in allowed):continue
        text=line.split('|')[-1].strip()
        if 'SendCommand:' in text and not re.search(r'SendCommand: (?:Launch 2000|StartUpdate |CheckServerStatus |SendAgreementResponse [01])\.',text):continue
        out.append({'line':i,'event':text})
    return out

def verify(doc,root,roots=None):
    if doc.get('schema')!='openleague_patcher_routes/v1' or doc.get('task')!='SYS-01.1-04':raise PatcherReferenceError('Contrat de parcours invalide.')
    roots=roots or doc['source_roots'];ref=load_reference(root);validate_client(ref,roots['native'],True)
    for s in doc['sources']:
        p=safe_source(roots[s['root']],s['path'])
        if not p.is_file():raise PatcherReferenceError('Source absente : '+s['id'])
        if digest(p)!={k:s[k] for k in ['bytes','sha256']}:raise PatcherReferenceError('Source modifiée : '+s['id'])
    if pe_versions(safe_source(roots['native'],doc['patcher']['binary']))!={'file_version':'0.4.0.122','product_version':'0.4.0.122'}:raise PatcherReferenceError('Build du patcher divergent.')
    binary=safe_source(roots['native'],doc['patcher']['binary']).read_bytes()
    manifest=read_manifest(safe_source(roots['native'],doc['patcher']['manifest']).read_bytes())
    for s in doc['sources']:
        if s.get('kind')!='recovered_ui':continue
        b=safe_source(roots['recovered'],s['path']).read_bytes();e=manifest['files'].get(s['path'])
        if not e or e['bytes']!=len(b) or e['md5']!=hashlib.md5(b).hexdigest():raise PatcherReferenceError('Ressource différente du manifeste natif : '+s['path'])
    members,results=load_members(doc,roots)
    tra=translations(safe_source(roots['native'],doc['patcher']['locale_file']).read_bytes())
    route=safe_source(roots['recovered'],doc['route_file']).read_bytes();observed=surface(members,tra,route)
    if observed!=doc['surface']:raise PatcherReferenceError('Surface d’interface divergente.')
    for page in doc['screens']:
        if page['kind']=='routed_view' and page.get('route_member') not in {x['member'] for x in observed['routes'] if x['is_patcher_ui_page']}:raise PatcherReferenceError('Vue non routée dans le patcher : '+page['id'])
        for anchor in page['anchors']:
            if anchor['member'] not in members or anchor['literal'] not in members[anchor['member']].decode('utf-8'):raise PatcherReferenceError('Ancrage d’écran absent : '+page['id'])
        if any(k not in tra for k in page.get('translation_keys',[])):raise PatcherReferenceError('Libellé d’écran absent.')
        if any(s.encode('ascii') not in binary for s in page.get('native_symbols',[])):raise PatcherReferenceError('Symbole natif d’écran absent.')
        if page['new_native_observation'] is not False:raise PatcherReferenceError('Observation native non effectuée.')
    ids=[p['id'] for p in doc['screens']]
    if len(ids)!=len(set(ids)):raise PatcherReferenceError('Identifiant d’écran dupliqué.')
    for flow in doc['journeys']:
        if any(x not in ids for x in flow['screens']):raise PatcherReferenceError('Parcours vers un écran inconnu.')
        for command in flow['commands']:
            if command not in observed['host_commands'] and command!='SendGenericTwoButtonResponse':raise PatcherReferenceError('Commande de parcours inconnue.')
    declared={x for p in doc['journeys'] for x in p['commands']}
    if set(observed['host_commands'])-declared:raise PatcherReferenceError('Commandes UI non recensées.')
    logs={s['id']:log_events(safe_source(roots[s['root']],s['path']).read_bytes()) for s in doc['sources'] if s.get('kind')=='log'}
    if logs!=doc['historical_log_events']:raise PatcherReferenceError('Événements historiques divergents.')
    if doc['claims']['native_binary_executed'] or doc['claims']['native_visual_acceptance'] or doc['claims']['openleague_historical_patcher_implemented']:raise PatcherReferenceError('Qualification d’interface non établie.')
    return {'task':doc['task'],'facts_verified':True,'source_files':len(doc['sources']),'bundles':len(results),
            'members':len(members),'screens':len(ids),'journeys':len(doc['journeys']),'controllers':len(observed['controllers']),
            'host_commands':len(observed['host_commands']),'historical_log_evidence':sum(len(x) for x in logs.values()),
            'native_binary_executed':False,'native_visual_acceptance':False,'human_acceptance':'not_given','manual_state_mutated':False}

def main():
    p=argparse.ArgumentParser();p.add_argument('--root',default='E:/OpenLeague');p.add_argument('--output');p.add_argument('--member');args=p.parse_args()
    try:
        doc=json.loads((pathlib.Path(args.root)/CONTRACT).read_bytes())
        result=verify(doc,args.root)
        if args.member:
            members,_=load_members(doc,doc['source_roots'])
            if args.member not in members:raise PatcherReferenceError('Membre absent.')
            print(members[args.member].decode('utf-8'));return 0
    except (ValueError,OSError,KeyError) as e:
        print(json.dumps({'facts_verified':False,'error':str(e)},ensure_ascii=False));return 1
    text=json.dumps(result,ensure_ascii=False,indent=2)
    if args.output:pathlib.Path(args.output).write_text(text,encoding='utf-8')
    print(text);return 0
if __name__=='__main__':raise SystemExit(main())
