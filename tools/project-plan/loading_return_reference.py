"""Read loading/return reference facts; never launches historical programs."""
import argparse,collections,hashlib,json,pathlib,re
from air_reference import mask_code
from frontend_builds import digest,safe_source

CONTRACT='docs/reference_loading_return_4_20.json'
class LifecycleError(ValueError):pass

def method(text,name,accessor=None):
    masked=mask_code(text);matches=[]
    for m in re.finditer(r'\bfunction\s+(?:(get|set)\s+)?'+re.escape(name)+r'\s*\(([^)]*)\)',masked):
        if m[1]!=accessor:continue
        begin=masked.find('{',m.end());semi=masked.find(';',m.end())
        if begin<0 or 0<=semi<begin:continue
        end=begin+1;depth=1
        while depth and end<len(masked):depth+=(masked[end]=='{')-(masked[end]=='}');end+=1
        if depth:raise LifecycleError('Method body is truncated: '+name)
        if not masked[begin+1:end-1].strip():continue
        args=text[m.start(2):m.end(2)]
        matches.append({'name':name,'accessor':accessor,'line':text.count('\n',0,m.start())+1,
         'end_line':text.count('\n',0,end)+1,'arguments':args,'body':text[begin+1:end-1],
         'body_sha256':hashlib.sha256(text[begin+1:end-1].encode('utf-8')).hexdigest()})
    if len(matches)!=1:raise LifecycleError('Method absent, empty, or ambiguous: '+name)
    return matches[0]

def constants(text):
    out=[]
    for m in re.finditer(r'\b(?:public\s+)?static\s+(?:const|var)\s+([\w$]+)\s*:\s*(String|int|uint|Boolean)\s*=\s*("(?:\\.|[^"\\])*"|-?\d+|true|false)\s*;',text):
        value=json.loads(m[3]);out.append({'name':m[1],'type':m[2],'value':value,'line':text.count('\n',0,m.start())+1})
    return out

LOG_LITERALS={
 'Maestro Init':'maestro_initializing','Maestro completed init':'maestro_initialized',
 'Waiting until connection...':'waiting_connection','Waiting for client ID':'waiting_client_id',
 'Waiting for server response...':'waiting_server','PlayGame Started':'playgame_startup',
 'PreloadGlobalEffects':'preload_effects','PreloadGlobalEffects Finished':'preload_effects_finished',
 'game::Shutdown':'game_shutdown','Exiting WinMain':'winmain_exit',
}
MESSAGE_LITERALS={'Hard Connect':'hard_connect','Attempting to Reconnect popup displayed':'reconnect_popup',
 'Disconnected':'disconnected','Soft Reconnect':'soft_reconnect','Game exited':'game_exit'}
def log_event(line):
    body=re.split(r'\|\s*(?:ALWAYS|INFO|WARN|ERROR)\|',line)[-1].strip()
    elapsed=re.match(r'^(\d+\.\d+)\|',line)
    kind=LOG_LITERALS.get(body);exit_code=None
    if not kind:
        start=body.find('{"messageType":')
        if start<0:return None
        try:obj=json.loads(body[start:])
        except ValueError:return None
        if obj.get('messageType')!='riot__game_client__connection_info':return None
        kind=MESSAGE_LITERALS.get(obj.get('message_body'))
        if not kind:return None
        if kind=='game_exit':
            exit_code=obj.get('exit_code')
            if exit_code not in {'EXITCODE_ABANDON','EXITCODE_WIN'}:return None
    result={'kind':kind,'elapsed_seconds':float(elapsed[1]) if elapsed else None}
    if exit_code:result['exit_code']=exit_code
    return result

def transpile(m):
    """Only reviewed scalar AS methods. No AVM2/accessor/runtime equivalence claim."""
    body=m['body'];args=m['arguments']
    # Preserve statements and operators; erase AS3 type annotations only.
    args=re.sub(r':\s*[\w.<>,*]+','',args)
    body=re.sub(r'\bvar\s+([\w$]+)\s*:\s*[\w.<>,*]+',r'var \1',body)
    if re.search(r'\b(?:import|package|include|eval|Function)\b|\b(?:process|require|fetch|XMLHttpRequest)\s*[.(]',body):
        raise LifecycleError('Method outside the reviewed scalar VM subset')
    return 'function('+args+') {\n'+body+'\n}'

def verify(doc,root,check_sources=True,snapshot_root=None):
    root=pathlib.Path(root)
    snapshot_root=pathlib.Path(snapshot_root or root)
    if doc.get('schema')!='openleague_loading_return/v1' or doc.get('task')!='SYS-01.1-06':raise LifecycleError('Invalid lifecycle contract')
    for name,sha in doc['reference_hashes'].items():
        if digest(safe_source(root,name))['sha256']!=sha:raise LifecycleError('Reference changed: '+name)
    if set(doc['reference_hashes'])!={'docs/reference_client_4_20.json','docs/reference_frontend_builds_4_20.json','docs/reference_air_routes_4_20.json'}:
        raise LifecycleError('Required reference binding missing')
    game=json.loads((root/'docs/reference_client_4_20.json').read_bytes())
    frontend=json.loads((root/'docs/reference_frontend_builds_4_20.json').read_bytes())
    if doc['reference']!={'game':game['client']['version'],'air':frontend['air']['build'],'air_release':frontend['air']['rads_release'],
                         'region':game['reference']['region'],'locale':game['reference']['locale'],'catalogue':game['catalogue']['version']}:
        raise LifecycleError('Lifecycle reference identity divergent')
    if check_sources:
        from reference_client import load_reference,validate
        validate(load_reference(root),verify_native=True)
    sources={s['id']:s for s in doc['sources']}
    if len(sources)!=len(doc['sources']):raise LifecycleError('Duplicate source')
    cache={}
    for row in sources.values():
        if check_sources:
            origin=pathlib.Path(row['origin'])
            if digest(origin)!={k:row[k] for k in ['bytes','sha256']}:raise LifecycleError('Origin changed: '+row['id'])
            if row.get('snapshot'):
                snap=safe_source(snapshot_root,row['snapshot'])
                if digest(snap)!={k:row[k] for k in ['bytes','sha256']}:raise LifecycleError('Snapshot changed: '+row['id'])
            if row['kind'] in ['air_review','native_gfx_review','current_code','avm2_pcode']:
                cache[row['id']]=origin.read_text(encoding='utf-8-sig')
    required_air={'GameViewState','GameState','IAppControllerConstants','GameEvent','LolGamePreloadController',
      'MasterGameController','MasterGameViewController','ApplicationController','InGameController',
      'InGameView','EndOfGameStatsController','MaestroController','MaestroServiceImpl','MaestroConstants',
      'MaestroMessage','ClientConfig','GameType','IMaestroProvider'}
    if not {'air.'+x for x in required_air}.issubset(sources):raise LifecycleError('Required lifecycle source missing')
    if check_sources:
        air=json.loads((root/'docs/reference_air_routes_4_20.json').read_bytes())
        upstream={x['path']:x for x in air['review_sources']}
        for row in sources.values():
            if row['kind']=='air_review':
                original=upstream.get(row['upstream_review'])
                if original is None or row['upstream_input']!=original['input'] or row['sha256']!=original['sha256']:
                    raise LifecycleError('AIR source not bound to frozen original export')
    anchors={a['id']:a for a in doc['anchors']}
    if len(anchors)!=len(doc['anchors']):raise LifecycleError('Duplicate anchor')
    for a in anchors.values():
        if a['source'] not in sources:raise LifecycleError('Anchor has no source')
        if check_sources:
            text=cache.get(a['source'])
            if text is None:text=pathlib.Path(sources[a['source']]['origin']).read_text(encoding='utf-8-sig')
            lines=text.splitlines()
            if not 1<=a['line']<=a['end_line']<=len(lines):raise LifecycleError('Anchor bounds invalid')
            excerpt='\n'.join(lines[a['line']-1:a['end_line']])
            if hashlib.sha256(excerpt.encode('utf-8')).hexdigest()!=a['excerpt_sha256']:raise LifecycleError('Anchor changed')
            if a.get('method'):
                m=method(text,a['method'],a.get('accessor'))
                if m['line']!=a['line'] or m['end_line']!=a['end_line']:raise LifecycleError('Method binding changed')
    def refs(values):
        if not values or any(a not in anchors for a in values):raise LifecycleError('Missing state/transition evidence')
    states={s['id']:s for s in doc['states']}
    if len(states)!=len(doc['states']):raise LifecycleError('Duplicate state')
    for state in states.values():
        refs(state['anchors'])
        if state['namespace'] not in ['air_view','air_server_dto','air_reconnect','air_results','air_preload','air_application','native_log','native_endgame','openleague_process','openleague_transport','openleague_results']:
            raise LifecycleError('State namespace invalid')
        if state['observed_now'] is not False:raise LifecycleError('Unproven current native/runtime observation')
    groups={g['source']:g for g in doc['constant_sets']}
    for cls,prefix in [('GameViewState','view'),('GameState','dto'),('InGameController','ingame'),
                       ('EndOfGameStatsController','result'),('IAppControllerConstants','app')]:
        if 'air.'+cls not in groups:raise LifecycleError('Required enum set missing')
        for entry in groups['air.'+cls]['entries']:
            if entry['type']!='String' or cls=='IAppControllerConstants' and entry['name'] not in {'LOGIN','LOBBY','RECONNECT'}:continue
            ident=prefix+'.'+entry['name']
            if ident not in states or states[ident]['original_identifier']!=cls+'.'+entry['name'] or states[ident]['label']!=(entry['value'] or '(NO_GAME)'):
                raise LifecycleError('Original lifecycle constant missing or mislabelled: '+ident)
    if len({t['id'] for t in doc['transitions']})!=len(doc['transitions']):raise LifecycleError('Duplicate transition')
    for t in doc['transitions']:
        if t['from'] not in states or t['to'] not in states:raise LifecycleError('Transition endpoint not inventoried')
        refs(t['anchors'])
        if t['confidence'] not in ['source_defined','historical_log','explicit_local_policy','unresolved_boundary']:raise LifecycleError('Transition confidence invalid')
        if t['confidence']=='unresolved_boundary' and t.get('qualified') is not False:raise LifecycleError('Unresolved transition promoted')
    transitions={t['id']:t for t in doc['transitions']}
    for ident in ['T10','T26']:
        if ident not in transitions or transitions[ident]['confidence']!='unresolved_boundary' or transitions[ident]['qualified'] is not False:
            raise LifecycleError('Known unresolved lifecycle boundary hidden')
    if not {'T02','T07','T11','T15','T20','T25','T27','T33','T34','T36','T40','T41','T42','T48','T51'}.issubset(transitions):
        raise LifecycleError('Lifecycle path coverage incomplete')
    guards={g['id']:g for g in doc['guards']}
    if len(guards)!=len(doc['guards']) or not {'G02','G03','G04','G07','G08','G10','G11','G12','G13','G14','G17','G18','G20','G22'}.issubset(guards):
        raise LifecycleError('Required lifecycle guards missing')
    for g in guards.values():
        refs(g['anchors'])
        if g['verification_scope'] not in {'source_inventory','selected_method_vm'}:raise LifecycleError('Unsupported guard qualification')
    for group in doc['constant_sets']:
        if group['source'] not in sources:raise LifecycleError('Enum source missing')
        if check_sources and constants(cache[group['source']])!=group['entries']:raise LifecycleError('Enum values changed')
    counts=collections.Counter();all_events=0
    if len({r['origin'] for r in doc['historical_logs']})!=len(doc['historical_logs']):raise LifecycleError('Duplicate historical log')
    for row in doc['historical_logs']:
        if not row['build420_marker_present']:raise LifecycleError('Historical 4.20 marker missing')
        for event in row['events']:
            if set(event)-{'line','line_sha256','kind','elapsed_seconds','exit_code'}:raise LifecycleError('Private/unexpected event field')
            if event['kind'] not in set(LOG_LITERALS.values())|set(MESSAGE_LITERALS.values()):raise LifecycleError('Unknown historical event kind')
            counts[event['kind']]+=1;all_events+=1
    if dict(counts)!=doc['log_event_counts']:raise LifecycleError('Historical event counts inconsistent')
    if {s['id'] for s in states.values() if s['namespace']=='native_log'}!={'log.'+k for k in counts}:raise LifecycleError('Historical milestone coverage incomplete')
    if check_sources:
        native=load_reference(root)
        logdir=pathlib.Path(native['source_root'])/'Logs/Game - R3d Logs'
        if {str(p) for p in logdir.rglob('*_r3dlog.txt')}!={str(pathlib.Path(r['origin'])) for r in doc['historical_logs']}:
            raise LifecycleError('Historical log inventory incomplete')
        for row in doc['historical_logs']:
            p=pathlib.Path(row['origin']);b=p.read_bytes()
            if digest(p)!={k:row[k] for k in ['bytes','sha256']}:raise LifecycleError('Historical log changed')
            text=b.decode('utf-8',errors='replace');events=[]
            if '4.20.0.315' not in text:raise LifecycleError('Historical build marker not corroborated')
            for i,line in enumerate(text.splitlines(),1):
                event=log_event(line)
                if event:events.append({'line':i,'line_sha256':hashlib.sha256(line.encode('utf-8')).hexdigest(),**event})
            if events!=row['events']:raise LifecycleError('Historical event labels changed')
    if any(x['native_replay_claimed'] is not False for x in doc['historical_logs']):raise LifecycleError('Historical trace claimed as fresh replay')
    if doc['manual_state_mutated'] is not False or doc['human_acceptance']!='not_given' or doc['historical_game_executed'] is not False:raise LifecycleError('Unproven acceptance/execution')
    if not doc['open_questions']:raise LifecycleError('Known unresolved boundaries hidden')
    if check_sources:
        vm_path=safe_source(snapshot_root,doc['vm_methods'])
        if digest(vm_path)['sha256']!=doc['vm_methods_sha256']:raise LifecycleError('VM method corpus changed')
        vm=json.loads(vm_path.read_bytes())
        if vm['constant_sets']!=doc['constant_sets'] or len({m['id'] for m in vm['methods']})!=len(vm['methods']):raise LifecycleError('VM bindings inconsistent')
        if len(vm['methods'])!=22:raise LifecycleError('Reviewed VM method coverage incomplete')
        for row in vm['methods']:
            m=method(cache[row['source']],row['name'],row.get('accessor'))
            if any(row[k]!=m[k] for k in m) or row['javascript']!=transpile(m):raise LifecycleError('VM method differs from original body')
        lua=json.loads(safe_source(snapshot_root,doc['lua_execution']['receipt']).read_bytes())
        if lua['source_sha256']!=sources['native.lua']['sha256'] or not lua['source_roundtrip_exact'] or not lua['instruction_arrays_preserved'] or lua['runtime']!='Lua 5.1':raise LifecycleError('Lua original binding invalid')
        expected={(winner,champions,death) for winner in [100,200] for champions in [0,1,6,12] for death in [False,True]}
        if {(c['winner'],c['champions'],c['use_death_animation']) for c in lua['cases']}!=expected or len(lua['cases'])!=16 or doc['lua_execution']['cases']!=16:
            raise LifecycleError('Lua scenario matrix incomplete')
        for case in lua['cases']:
            ending=[c for c in case['calls'] if c['name']=='EndGame']
            if ending!=[{'time':5.5,'name':'EndGame','args':[case['winner']]}]:raise LifecycleError('Lua end-state timing changed')
        # Bind the fresh p-code comparison fact, not merely the AS source spelling.
        pcode=method(cache['pcode.InGameController'],'deactivate')['body']
        if not re.search(r'getproperty[^\n]*currentState[\s\S]{0,1000}?equals\s*\n\s*pop',pcode) or re.search(r'setproperty[^\n]*currentState',pcode):
            raise LifecycleError('Original deactivate comparison not corroborated by p-code')
    return {'task':doc['task'],'verified':bool(check_sources),'states':len(states),'transitions':len(doc['transitions']),
      'sources':len(sources),'anchors':len(anchors),'historical_logs':len(doc['historical_logs']),
      'guards':len(guards),'historical_events':all_events,'vm_methods':22 if check_sources else None,
      'unresolved_boundaries':sum(t['confidence']=='unresolved_boundary' for t in doc['transitions']),
      'historical_game_executed':False,'manual_state_mutated':False,'human_acceptance':'not_given'}

def main():
    p=argparse.ArgumentParser();p.add_argument('--root',default='E:/OpenLeague');p.add_argument('--snapshot-root');p.add_argument('--output');args=p.parse_args()
    try:r=verify(json.loads((pathlib.Path(args.snapshot_root or args.root)/CONTRACT).read_bytes()),args.root,snapshot_root=args.snapshot_root)
    except (ValueError,OSError,KeyError,IndexError) as e:
        print(json.dumps({'verified':False,'error':str(e)},ensure_ascii=False));return 1
    text=json.dumps(r,ensure_ascii=False,indent=2)
    if args.output:pathlib.Path(args.output).write_text(text+'\n',encoding='utf-8')
    print(text);return 0
if __name__=='__main__':raise SystemExit(main())
