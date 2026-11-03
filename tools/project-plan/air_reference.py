"""Source inventory for the AIR 4.20 client. Never launches the AIR client."""
import argparse,collections,hashlib,json,pathlib,re,xml.etree.ElementTree as ET
from frontend_builds import safe_source,digest,air_version
from patcher_formats import read_manifest

CONTRACT='docs/reference_air_routes_4_20.json'
class AirReferenceError(ValueError):pass

def mask_code(text):
    return re.sub(r'"(?:\\.|[^"\\])*"|\'(?:\\.|[^\'\\])*\'|/\*[\s\S]*?\*/|//[^\n]*',
                  lambda m:re.sub(r'[^\n]',' ',m[0]),text)

def parse_source(text):
    masked=mask_code(text);package=re.search(r'\bpackage\s*([^\s{]*)\s*\{',masked)
    cls=re.search(r'\b(?:public|internal)\s+(?:final\s+|dynamic\s+)?(class|interface)\s+([\w$]+)(?:\s+extends\s+([\w.]+))?',masked)
    name=((package[1]+'.') if package and package[1] else '')+cls[2] if cls else None
    generated=bool(name and re.search(r'(^_|WatcherSetupUtil|__embed|_embed_|_[A-Z][A-Z_]{3,}|_mx_core_FlexModuleFactory)',name.split('.')[-1]))
    owned=bool(name and (name.startswith('com.riotgames.') or '.' not in name or name.startswith('developer.')))
    if generated:role='generated_binding_or_asset'
    elif name and name.startswith('developer.'):role='developer_internal'
    elif owned:role='application_class' if cls[1]=='class' else 'application_interface'
    else:role='framework_or_dependency'
    methods=[]
    for m in (re.finditer(r'\bfunction\s+(?:(get|set)\s+)?([\w$]+)\s*\(',masked) if role in ['application_class','developer_internal'] else []):
        start=m.start();semi=masked.find(';',m.end());begin=masked.find('{',m.end())
        if begin<0 or 0<=semi<begin:continue
        depth=1;end=begin+1
        while depth and end<len(masked):
            depth+=(masked[end]=='{')-(masked[end]=='}');end+=1
        if depth:raise AirReferenceError('Bloc ActionScript non fermé : '+str(name))
        methods.append({'name':m[2],'accessor':m[1],'line':text.count('\n',0,start)+1,
          'end_line':text.count('\n',0,end)+1,'empty':not masked[begin+1:end-1].strip()})
    constants=[]
    if name and re.search(r'(State|Constants|ProfilePagesEnum|MenuStates)$',name.split('.')[-1]):
        for m in re.finditer(r'\b(?:const|var)\s+([\w$]+)\s*:\s*String\s*=\s*"((?:\\.|[^"\\])*)"',text):
            constants.append({'name':m[1],'value':m[2],'line':text.count('\n',0,m.start())+1})
    flows=[]
    if role in ['application_class','developer_internal']:
        for i,line in enumerate(text.splitlines(),1):
            if (re.search(r'\.(?:navigate|modalDialog|requestLobbyState|setMainViewState|setCurrentState|changeStateByClass|changeState)\s*\(',line)
                or re.search(r'\.(?:currentState|currentAppState|currentLobbyState|selectedChild|content)\s*=',line)):
                flows.append({'line':i,'expression':line.strip(),
                              'method':next((m['name'] for m in methods if m['line']<=i<=m['end_line']),None)})
    return {'class':name,'base':cls[3] if cls else None,'role':role,'methods':methods,'state_constants':constants,
            'flow_statements':flows,'decompilation_error':bool(re.search(r'Decompilation error|Error decompiling|Decompilation skipped|decompilation timed out',text))}

def descriptor(data):
    root=ET.fromstring(data)
    def local(el):return el.tag.rsplit('}',1)[-1]
    def text(key):
        return next((''.join(el.itertext()).strip() for el in root.iter() if local(el)==key),None)
    return {'name':text('name'),'module_path':text('modulePath'),
            'providers':[''.join(x.itertext()).strip() for x in root.iter() if local(x)=='interfaceClassName'],
            'services_mode':int(text('servicesMode') or 0),'main_screen':text('mainScreen')}

def dependency_graph(files):
    """Use the actual name/file + tab-indented dependency fragment format."""
    entries={}
    for path,text in files:
        current=None
        for number,line in enumerate(text.splitlines(),1):
            if not line.strip() or line.lstrip().startswith(('#','/')):continue
            if line.startswith('\t'):
                if current is None:raise AirReferenceError('Dépendance sans entrée : '+path)
                entries[current]['dependencies'].append(line.strip())
            else:
                parts=line.strip().split()
                if len(parts)<2:raise AirReferenceError('Fragment de dépendances invalide : '+path+':'+str(number))
                current=parts[0]
                row={'id':current,'file':parts[1],'dependencies':[],'fragment':path,'line':number}
                if current in entries:raise AirReferenceError('Dépendance déclarée deux fois : '+current)
                entries[current]=row
    return list(entries.values())

def derive_components(review,screens):
    bases={'ViewX','UIComponent','Sprite','MovieClip','DisplayObject','DisplayObjectContainer','DisplayObjectProxy','DisplayAdapter','NativeWindow','Window','Canvas','Container','Module'}
    while True:
        prior=len(bases)
        for row in review:
            a=row['analysis']
            if a['class'] and a['base'] and a['base'].split('.')[-1] in bases:bases.add(a['class'].split('.')[-1])
        if len(bases)==prior:break
    result=[]
    for row in review:
        a=row['analysis']
        if a['role'] not in ['application_class','developer_internal'] or not a['base'] or a['base'].split('.')[-1] not in bases:continue
        kind='internal_diagnostic' if a['role']=='developer_internal' else ('skin_or_asset_class' if re.search(r'Asset$|Skin$',a['base']) or re.search(r'Skin$|_png|_jpg',a['class']) else 'view_container_or_component')
        result.append({'source':row['path'],'input':row['input'],'class':a['class'],'base':a['base'],'kind':kind,
            'states':a['state_constants'],'flow_statements':len(a['flow_statements']),
            'screen_families':[x['id'] for x in screens if row['path'] in x['sources']],'public_visibility_proven':False})
    return result

def verify(doc,root,verify_sources=True):
    root=pathlib.Path(root)
    if doc.get('schema')!='openleague_air_routes/v1' or doc.get('task')!='SYS-01.1-05':raise AirReferenceError('Contrat AIR invalide')
    from frontend_builds import verify as verify_builds
    build_path=root/'docs/reference_frontend_builds_4_20.json'
    if digest(build_path)['sha256']!=doc['build_reference_sha256']:raise AirReferenceError('Référence du build AIR divergente')
    if verify_sources:verify_builds(json.loads(build_path.read_bytes()),root)
    if digest(root/'docs/reference_client_4_20.json')['sha256']!=doc['game_reference_sha256']:raise AirReferenceError('Référence de partie divergente')
    source_root=safe_source(root,doc['source_directory'])
    manifest_path=safe_source(source_root,doc['manifest']['path'])
    if digest(manifest_path)!={k:doc['manifest'][k] for k in ['bytes','sha256']}:raise AirReferenceError('Manifeste AIR modifié')
    manifest=read_manifest(manifest_path.read_bytes())
    if manifest['project']!='lol_air_client' or manifest['release']!='0.0.1.119':raise AirReferenceError('Autre projet/release AIR')
    raw={x['path']:x for x in doc['original_sources']}
    if len(raw)!=len(doc['original_sources']):raise AirReferenceError('Source originale dupliquée')
    expected_code={p for p in manifest['files'] if p.endswith('.dat') and p.startswith(('lib/','mod/'))}|{'LolClient.swf'}
    if {p for p,x in raw.items() if x['role']=='code'}!=expected_code:raise AirReferenceError('Inventaire des fichiers de code incomplet')
    expected_descriptors={p for p in manifest['files'] if p.endswith('info.riotmod')}
    if {x['descriptor'] for x in doc['modules']}!=expected_descriptors:raise AirReferenceError('Inventaire des modules incomplet')
    if len(doc['modules'])!=len(expected_descriptors):raise AirReferenceError('Module dupliqué')
    if {p for p,x in raw.items() if x['role']=='dependency_fragment'}!={p for p in manifest['files'] if p.endswith('dependencies.properties')}:
        raise AirReferenceError('Fragments du chargeur incomplets')
    if {p for p,x in raw.items() if x['role']=='local_html'}!={p for p in manifest['files'] if p.endswith(('.html','.htm'))}:
        raise AirReferenceError('Cadres HTML locaux incomplets')
    for name,row in raw.items():
        entry=manifest['files'].get(name)
        if entry is None or row['manifest_entry']!=entry:raise AirReferenceError('Appartenance RADS divergente : '+name)
        if verify_sources:
            path=safe_source(source_root,'original/'+name)
            if digest(path)!={k:row[k] for k in ['bytes','sha256']}:raise AirReferenceError('Source originale modifiée : '+name)
            if entry['bytes']!=row['bytes'] or hashlib.md5(path.read_bytes()).hexdigest()!=entry['md5']:raise AirReferenceError('Octets RADS divergents : '+name)
    classes={x['path']:x for x in doc['review_sources']}
    if len(classes)!=len(doc['review_sources']):raise AirReferenceError('Export de lecture dupliqué')
    if verify_sources:
        disk={p.relative_to(source_root).as_posix() for p in (source_root/'review').rglob('*.as')}
        if disk!=set(classes):raise AirReferenceError('Export ActionScript incomplet ou ajouté')
    for path,row in classes.items():
        if row['input'] not in expected_code:raise AirReferenceError('Classe provenant d’un module exclu')
        if verify_sources:
            p=safe_source(source_root,path)
            if digest(p)!={k:row[k] for k in ['bytes','sha256']}:raise AirReferenceError('Export ActionScript modifié : '+path)
            if parse_source(p.read_text(encoding='utf-8-sig'))!=row['analysis']:raise AirReferenceError('Index ActionScript divergent : '+path)
    for m in doc['modules']:
        if m['module_path'] not in expected_code or m['descriptor'] not in raw:raise AirReferenceError('Module sans code/descriptor de release119')
        if verify_sources:
            parsed=descriptor(safe_source(source_root,'original/'+m['descriptor']).read_bytes())
            if any(m[k]!=v for k,v in parsed.items()):raise AirReferenceError('Module XML divergent')
    ids={x['id'] for x in doc['dependency_graph']}
    if any(n not in ids for row in doc['dependency_graph'] for n in row['dependencies']):raise AirReferenceError('Identifiant de dépendance non résolu')
    gaps=[{'id':row['id'],'path':row['file'],'fragment':row['fragment'],'line':row['line'],
           'referenced_by':[x['id'] for x in doc['dependency_graph'] if row['id'] in x['dependencies']],
           'classification':'declared_but_absent_from_release_manifest','native_loading_verified':False}
          for row in doc['dependency_graph'] if row['file'] not in manifest['files']]
    if gaps!=doc['dependency_target_gaps']:raise AirReferenceError('Écarts des dépendances masqués ou divergents')
    if verify_sources:
        graph=dependency_graph([(p,safe_source(source_root,'original/'+p).read_text(encoding='utf-8-sig'))
                               for p,x in raw.items() if x['role']=='dependency_fragment'])
        if graph!=doc['dependency_graph']:raise AirReferenceError('Graphe du chargeur divergent')
        build=air_version(safe_source(source_root,'original/lib/ClientLibCommon.dat'))['build']
        if build!=doc['air_build']:raise AirReferenceError('Build interne AIR divergent')
    anchors={x['id']:x for x in doc['anchors']}
    if len(anchors)!=len(doc['anchors']):raise AirReferenceError('Ancre dupliquée')
    for a in anchors.values():
        row=classes.get(a['source'])
        if row is None:raise AirReferenceError('Ancre sans source recensée')
        if row['analysis']['decompilation_error']:raise AirReferenceError('Parcours fondé sur un export incomplet')
        if a.get('method') and not any(m['name']==a['method'] and m['line']==a['line'] and not m['empty'] for m in row['analysis']['methods']):
            raise AirReferenceError('Parcours fondé sur une méthode vide/interface')
        if verify_sources:
            text=safe_source(source_root,a['source']).read_text(encoding='utf-8-sig');lines=text.splitlines()
            if not 1<=a['line']<=a['end_line']<=len(lines):raise AirReferenceError('Ancre hors limites')
            excerpt='\n'.join(lines[a['line']-1:a['end_line']])
            if hashlib.sha256(excerpt.encode('utf-8')).hexdigest()!=a['excerpt_sha256']:raise AirReferenceError('Ancre de parcours modifiée')
    screens={x['id']:x for x in doc['screens']}
    if len(screens)!=len(doc['screens']):raise AirReferenceError('Écran dupliqué')
    allowed={'source_defined','feature_gated','region_or_partner_gated','internal_or_hidden','service_dependent'}
    def check_anchors(values):
        if not values or any(x not in anchors for x in values):raise AirReferenceError('Référence de parcours sans ancre')
    for screen in screens.values():
        if not screen['sources'] or any(x not in classes for x in screen['sources']):raise AirReferenceError('Écran sans classe réelle')
        if screen['availability'] not in allowed or screen['observed_native'] is not False:raise AirReferenceError('Disponibilité/observation non prouvée')
    if derive_components(doc['review_sources'],doc['screens'])!=doc['ui_components']:raise AirReferenceError('Index des composants incomplet ou promu à tort')
    if doc['loader_policy']['module_blacklist']!=['fale','rds'] or doc['loader_policy']['default_services_mode']!=1:
        raise AirReferenceError('Politique du chargeur divergente')
    for route in doc['journeys']:
        check_anchors(route['anchors'])
        if not route['steps'] or any(x not in screens for x in route['steps']):raise AirReferenceError('Parcours vers un écran non recensé')
        if route['verification_kind']!='static_original_source_review' or route['native_executed'] is not False:raise AirReferenceError('Parcours natif non exécuté présenté comme vérifié')
    for guard in doc['guards']:check_anchors(guard['anchors'])
    if any(x.get('promoted_as_public') is not False for x in doc['excluded_candidates']):raise AirReferenceError('Ancien module promu à tort')
    for x in doc['excluded_candidates']:
        if x['descriptor'] in expected_descriptors or x['module_path'] in expected_code:raise AirReferenceError('Exclusion divergente du manifeste')
    errors=[x['path'] for x in doc['review_sources'] if x['analysis']['decompilation_error']]
    if doc['decompilation_errors']!=errors:raise AirReferenceError('Erreurs de décompilation masquées')
    if verify_sources:
        xml=ET.fromstring(safe_source(source_root,'original/META-INF/AIR/application.xml').read_bytes());ns=xml.tag.split('}')[0][1:]
        desc={'path':'META-INF/AIR/application.xml','source_release':manifest['files']['META-INF/AIR/application.xml']['release'],
              'version_number':xml.findtext('{'+ns+'}versionNumber'),'namespace':ns,'not_the_application_build':True,'member_matches_release_manifest':True}
        if desc!=doc['native_air_descriptor']:raise AirReferenceError('Descripteur exact divergent')
    if doc.get('human_acceptance')!='not_given' or doc.get('manual_state_mutated') is not False or doc.get('native_executed') is not False:
        raise AirReferenceError('Acceptation ou exécution non établie')
    return {'task':doc['task'],'verified':True,'verification_kind':'static_original_source_inventory',
       'air_build':doc['air_build'],'release':'0.0.1.119','code_files':len(expected_code),'modules':len(doc['modules']),
       'original_sources':len(raw),'review_sources':len(classes),'screens':len(screens),'journeys':len(doc['journeys']),
       'guards':len(doc['guards']),'anchors':len(anchors),'ui_components':len(doc['ui_components']),
       'dependency_target_gaps':gaps,'decompilation_errors':errors,
       'native_executed':False,'human_acceptance':'not_given','manual_state_mutated':False}

def main():
    p=argparse.ArgumentParser();p.add_argument('--root',default='E:/OpenLeague');p.add_argument('--output');args=p.parse_args()
    try:result=verify(json.loads((pathlib.Path(args.root)/CONTRACT).read_bytes()),args.root)
    except (ValueError,OSError,KeyError,IndexError) as e:
        print(json.dumps({'verified':False,'error':str(e)},ensure_ascii=False));return 1
    text=json.dumps(result,ensure_ascii=False,indent=2)
    if args.output:pathlib.Path(args.output).write_text(text+'\n',encoding='utf-8')
    print(text);return 0
if __name__=='__main__':raise SystemExit(main())
