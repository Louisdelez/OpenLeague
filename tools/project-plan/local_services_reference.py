"""Historical service surface and explicit local replacement scope, never a backend."""
import argparse,collections,hashlib,json,pathlib,re
from air_reference import mask_code
from frontend_builds import digest,safe_source
CONTRACT='docs/reference_local_services_4_20.json'
class ScopeError(ValueError):pass

def rpc_surface(text):
    """Calls only, excluding interfaces/declarations; retain unresolved dynamic names."""
    masked=mask_code(text);out=[]
    for m in re.finditer(r'\b(invokeServiceWithoutSession|invokeServiceWithSession)\s*\(',masked):
        if re.search(r'\bfunction\s*$',masked[max(0,m.start()-40):m.start()]):continue
        end=m.end();depth=1
        while end<len(masked) and depth:
            depth+=(masked[end]=='(')-(masked[end]==')');end+=1
        if depth:raise ScopeError('Truncated original invocation')
        args=text[m.end():end-1]
        literal=re.match(r'\s*"([^"\\]+)"\s*,\s*"([^"\\]+)"',args)
        item={'line':text.count('\n',0,m.start())+1,'invoke_kind':m[1],
              'classification':'literal_client_call' if literal else 'dynamic_client_call'}
        if literal:item.update(destination=literal[1],operation=literal[2])
        out.append(item)
    return out

def proxy_properties(text):
    return [{'property':m[1],'type':m[2],'line':text.count('\n',0,m.start())+1}
            for m in re.finditer(r'public\s+function\s+get\s+(\w+)\(\)\s*:\s*(\w+)',text) if m[1]!='instance']

def tauri_commands(text):
    rows=re.findall(r'tauri::generate_handler!\[([^\]]+)\]',mask_code(text))
    if len(rows)!=1:raise ScopeError('Launcher command registration absent or ambiguous')
    names=[x.strip() for x in rows[0].split(',') if x.strip()]
    if len(set(names))!=len(names):raise ScopeError('Duplicate local command')
    return names

def assess(doc,family_id,*,original_service=False,real_money=False,external=False):
    """Read-only scope query for plan authors. Does not route or execute requests."""
    rows=[f for f in doc['families'] if f['id']==family_id]
    if len(rows)!=1:raise ScopeError('Unknown service family')
    f=rows[0]
    if original_service or real_money or external:
        return {'decision':'outside_local_replacement_contract','implemented':False,'runtime_call_executed':False,
                'reason':'No Riot identity/payment/production endpoint is supplied by this local scope.'}
    return {'decision':f['scope_decision'],'current_state':f['current_state'],
            'implemented':False,'runtime_call_executed':False,'family':f['id'],
            'implementation_gate':'Use the linked implementation tasks and their acceptance tests; scope definition is not service availability.'}

def verify(doc,root,snapshot_root=None):
    root=pathlib.Path(root);snap=pathlib.Path(snapshot_root or root)
    if doc.get('schema')!='openleague_local_services_scope/v1' or doc.get('task')!='SYS-01.1-07':raise ScopeError('Invalid service scope contract')
    expected_refs={'docs/reference_client_4_20.json','docs/reference_frontend_builds_4_20.json',
                   'docs/reference_air_routes_4_20.json','docs/reference_game_server_4_20.json','docs/reference_loading_return_4_20.json'}
    if set(doc['reference_hashes'])!=expected_refs:raise ScopeError('Incomplete reference binding')
    for rel,sha in doc['reference_hashes'].items():
        if digest(safe_source(root,rel))['sha256']!=sha:raise ScopeError('Reference changed: '+rel)
    from reference_client import load_reference,validate
    native=load_reference(root);validate(native,verify_native=True)
    if doc['reference']!={'game':'4.20.0.315','air':'4.20.14_11_18_18_52','region':'EUW','locale':'en_GB','catalogue':'4.20.1'}:raise ScopeError('Wrong historical reference')
    air=json.loads((root/'docs/reference_air_routes_4_20.json').read_bytes())
    upstream={x['path']:x for x in air['review_sources']}
    sources={s['id']:s for s in doc['sources']}
    if len(sources)!=len(doc['sources']):raise ScopeError('Duplicate service source')
    texts={}
    for row in sources.values():
        origin=pathlib.Path(row['origin']);identity={k:row[k] for k in ['bytes','sha256']}
        if digest(origin)!=identity:raise ScopeError('Service origin changed: '+row['id'])
        if digest(safe_source(snap,row['snapshot']))!=identity:raise ScopeError('Service snapshot changed: '+row['id'])
        if row['kind']=='air_review':
            up=upstream.get(row['upstream_review'])
            if not up or up['input']!=row['upstream_input'] or up['sha256']!=row['sha256']:raise ScopeError('AIR service not bound to original export')
        texts[row['id']]=origin.read_text(encoding='utf-8-sig')
    families={f['id']:f for f in doc['families']}
    if len(families)!=len(doc['families']):raise ScopeError('Duplicate service family')
    required={'identity','catalogue','profile','collections','loadouts','preferences','social','chat','party',
              'queues','team_builder','selection','allocation','sessions','game_authority','results','progression',
              'teams','leagues','store','economy','reports','spectator','replays','distribution','content',
              'status','telemetry','surveys','email','transport','persistence'}
    if set(families)!=required:raise ScopeError('Service family perimeter incomplete or unexpected')
    registry=json.loads((root/'docs/completion_tasks_2026-10-20.json').read_bytes());tasks={t['id']:t for t in registry['tasks']}
    for f in families.values():
        if f['scope_decision'] not in {'replace_locally','adapt_locally','local_only','optional_local_replacement'}:raise ScopeError('Invalid local scope decision')
        if f['current_state'] not in {'not_implemented','partial_code_present','local_orchestration_present','local_content_present'}:raise ScopeError('Unproven service readiness')
        if f['riot_server_implementation_recovered'] is not False or f['runtime_qualified_in_this_task'] is not False:raise ScopeError('Unproven backend/runtime recovery')
        if not f['source_ids'] or any(x not in sources for x in f['source_ids']):raise ScopeError('Family source missing')
        if not f['backlog_task_ids'] or any(x not in tasks for x in f['backlog_task_ids']):raise ScopeError('Family implementation work unlinked')
        if any(not f.get(k) for k in ['local_contract','authority','persistence','nominal_acceptance','refusal_acceptance','remaining_work','current_evidence']):raise ScopeError('Incomplete family contract')
        if any(x not in families for x in f['depends_on']):raise ScopeError('Unknown family dependency')
    def visit(i,trail):
        if i in trail:raise ScopeError('Service dependency cycle')
        for dep in families[i]['depends_on']:visit(dep,trail|{i})
    for i in families:visit(i,set())
    # Re-extract the observed call surface from every Riot-namespaced export.
    calls=[];scanned=0
    for up in air['review_sources']:
        if not (up['analysis'].get('class') or '').startswith('com.riotgames.'):continue
        scanned+=1;text=(root/air['source_directory']/up['path']).read_text(encoding='utf-8-sig')
        for call in rpc_surface(text):calls.append({'source':up['path'],'input':up['input'],'source_sha256':up['sha256'],**call})
    if scanned!=doc['rpc_surface']['scanned_riot_classes'] or calls!=doc['rpc_surface']['calls']:raise ScopeError('Observed RPC surface incomplete or changed')
    for call in calls:
        if call['source'] not in {x.get('upstream_review') for x in sources.values()}:raise ScopeError('RPC source not preserved')
    properties=proxy_properties(texts['air.ServiceProxy'])
    if properties!=doc['service_proxy']['properties']:raise ScopeError('ServiceProxy properties changed')
    mapping=doc['service_proxy']['family_mapping']
    if set(mapping)!={p['property'] for p in properties} or any(not v or any(i not in families for i in v) for v in mapping.values()):raise ScopeError('ServiceProxy scope gap')
    destinations={c['destination'] for c in calls if c['classification']=='literal_client_call'}
    if set(doc['rpc_surface']['destination_family_mapping'])!=destinations:raise ScopeError('RPC destination scope gap')
    for value in doc['rpc_surface']['destination_family_mapping'].values():
        if not value or any(x not in families for x in value):raise ScopeError('RPC family mapping invalid')
    if tauri_commands(texts['current.launcher/src-tauri/src/main.rs'])!=doc['current_local_interface']['tauri_commands']:raise ScopeError('Current launcher command surface changed')
    if doc['current_local_interface']['account_authentication_available'] is not False or doc['current_local_interface']['native_protocol_compatibility_qualified'] is not False:raise ScopeError('Local session capability confused with accounts/native protocol')
    if doc['policy']!={'network_default':'loopback','riot_credentials':'never_required','real_money':'outside_local_contract',
        'remote_riot_fallback':False,'silent_success_for_unsupported':False,'unknown_server_rules':'explicit_local_policy_or_unavailable',
        'production_ports_assigned_by_this_task':False,'plan_database_is_game_account_database':False}:raise ScopeError('Local replacement policy divergent')
    cross=doc['cross_cutting_requirements']
    if {r['id'] for r in cross}!={'L'+str(i).zfill(2) for i in range(1,9)} or any(not r.get('rule') or not r.get('acceptance') for r in cross):raise ScopeError('Cross-service invariants incomplete')
    if len(doc['open_questions'])<4:raise ScopeError('Known service unknowns hidden')
    if doc['native_executed'] or doc['manual_state_mutated'] or doc['human_acceptance']!='not_given':raise ScopeError('Unproven execution/acceptance')
    return {'task':doc['task'],'verified':True,'families':len(families),'sources':len(sources),'service_proxy_properties':len(properties),
            'riot_classes_scanned':scanned,'literal_client_calls':sum(c['classification']=='literal_client_call' for c in calls),
            'dynamic_client_calls':sum(c['classification']=='dynamic_client_call' for c in calls),'rpc_destinations':len(destinations),
            'local_tauri_commands':len(doc['current_local_interface']['tauri_commands']),
            'native_executed':False,'backend_services_implemented_by_this_task':False,'manual_state_mutated':False,'human_acceptance':'not_given'}

def main():
    p=argparse.ArgumentParser();p.add_argument('--root',default='E:/OpenLeague');p.add_argument('--snapshot-root');p.add_argument('--output');args=p.parse_args()
    try:
        doc=json.loads((pathlib.Path(args.snapshot_root or args.root)/CONTRACT).read_bytes());result=verify(doc,args.root,args.snapshot_root)
    except (ValueError,OSError,KeyError,IndexError) as e:
        print(json.dumps({'verified':False,'error':str(e)},ensure_ascii=False));return 1
    text=json.dumps(result,ensure_ascii=False,indent=2)
    if args.output:pathlib.Path(args.output).write_text(text+'\n',encoding='utf-8')
    print(text);return 0
if __name__=='__main__':raise SystemExit(main())
