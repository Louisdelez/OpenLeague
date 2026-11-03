"""Readonly reference consumer for bounded native/community callback evidence."""
import argparse,ast,hashlib,json,pathlib,re,struct,sys
R=pathlib.Path('E:/OpenLeague');S=pathlib.Path('E:/mapslol3v3')
sys.path.insert(0,str(R/'tools/project-plan'))
from lua51_reference import Reader,OPS
from rads_reference_membership import RadsReferenceMembership
def load(p):return json.loads(pathlib.Path(p).read_bytes())
def pin(p):
    p=pathlib.Path(p);b=p.read_bytes();return {'path':str(p),'bytes':len(b),'sha256':hashlib.sha256(b).hexdigest()}
def need(ok,why):
    if not ok:raise ValueError(why)
def checked(identity,tool=False):
    p=pathlib.Path(identity['path']).resolve(strict=True)
    allowed=[R.resolve(),S.resolve(),pathlib.Path('D:/LeagueOfLegendsV2/4.20').resolve()]
    need(any(p.is_relative_to(root) for root in allowed) or (tool and p==pathlib.Path(sys.executable).resolve()),'Source outside reference roots')
    need(all(pin(p)[k]==identity[k] for k in ['bytes','sha256']),'Changed source identity: '+str(p))
    return p
def function_names(proto):
    names={}
    for pc,(a,b) in enumerate(zip(proto['words'],proto['words'][1:])):
        if a&63==36 and b&63==7 and ((a>>6)&255)==((b>>6)&255):
            names.setdefault(a>>14,[]).append({'name':proto['constants'][b>>14],'closure_pc':pc,'setglobal_pc':pc+1})
    return names
def words(proto):return [proto['code_sha256']]+[h for c in proto['children'] for h in words(c)]
def adapted_identity(raw,adapter):
    # The separately pinned trusted adapter is reused as a pure byte converter.
    # No old scenario driver and no original Lua body is executed here.
    tree=ast.parse(pathlib.Path(adapter).read_text('utf-8'))
    found=[n for n in tree.body if isinstance(n,ast.FunctionDef) and n.name=='adapt']
    need(len(found)==1,'Missing or ambiguous format adapter')
    scope={'raw':raw,'struct':struct,'hashlib':hashlib}
    exec(compile(ast.Module(body=found,type_ignores=[]),str(adapter),'exec'),scope)
    same,a=scope['adapt'](4);converted,b=scope['adapt'](8)
    need(same==raw and a==b==words(Reader(raw).parse()),'Format adaptation did not preserve original instruction arrays')
    return hashlib.sha256(converted).hexdigest()
def arguments(proto):
    """Independent, straight-line argument reconstruction; no engine semantics."""
    regs={};calls=[]
    for w in proto['words']:
        op=w&63;a=(w>>6)&255;b=(w>>23)&511;c=(w>>14)&511;bx=w>>14
        if op==1:regs[a]=proto['constants'][bx]
        elif op==5:
            name=proto['constants'][bx]
            if name in ['TEAM_ORDER','TEAM_CHAOS']:regs[a]='SUPPLIED_'+name
            else:
                need(name in ['CreateChildTurret','SpawnTurret'],'Unexpected requested API')
                regs[a]={'api':name}
        elif op==28:
            need(b>0 and c==1 and isinstance(regs[a],dict),'Variable argument/result call unqualified')
            calls.append({'api':regs[a]['api'],'args':[regs[a+i] for i in range(1,b)]})
        elif op==30:need(b==1,'Return value unqualified')
        else:raise ValueError('Non-straight-line callback requires separate semantics')
    return calls

def audit(evidence_root,inputs_override=None,infernal_override=None,maps_override=None,inventory_override=None):
    v=pathlib.Path(evidence_root).resolve(strict=True);need(v.is_relative_to(S.resolve()),'Evidence outside workspace')
    inputs=load(v/'callback-review-source-inputs.json') if inputs_override is None else inputs_override
    need(inputs['schema']=='openleague_callback_review_source_inputs/v1','Wrong input schema')
    need(inputs['historical_native_dispatch_or_engine_scale_API_qualified'] is False and inputs['CSharp_or_Rust_gameplay_executed'] is False,'Unsupported native dispatch or gameplay claim')
    identities={}
    def keep(x,tool=False):
        p=checked(x,tool)
        if not tool:identities[str(p).casefold()]=x
        return p
    for key in ['reference','community_review','callback_inventory','inherited_infernal_probe','fresh_map_probe','native_PE_research','producer']:keep(inputs[key])
    inv=load(inputs['callback_inventory']['path']) if inventory_override is None else inventory_override
    ip=load(inputs['inherited_infernal_probe']['path']) if infernal_override is None else infernal_override
    mp=load(inputs['fresh_map_probe']['path']) if maps_override is None else maps_override
    need(inv['native_or_community_code_executed'] is False and inv['integrated_into_registry'] is False,'Inventory cannot assert gameplay execution or prior integration')
    need(len(inv['rows'])==17,'Expected seventeen exact native source candidates')
    membership=RadsReferenceMembership(R);parsed={};callback_count=0;empty_count=0
    for row in inv['rows']:
        p=keep(row['native_source']);proto=Reader(p.read_bytes()).parse();parsed[str(p).casefold()]=proto
        member=membership.inspect(p.relative_to(pathlib.Path(membership.deploy)).as_posix(),p,row['native_source'])
        need(member==row['membership'] and member['status']=='matches_selected_project_manifest','Native manifest membership changed')
        need(len(proto['children'])==len(row['callbacks']),'Callback count changed')
        names=function_names(proto)
        for i,(f,c) in enumerate(zip(proto['children'],row['callbacks'],strict=True)):
            need(c['prototype_index']==i and c['direct_named_bindings']==names.get(i,[]),'Original closure/global binding changed')
            need(c['parameters']==f['parameters'] and c['nested_prototypes']==len(f['children']) and c['constants']==f['constants'] and c['code_sha256']==f['code_sha256'],'Callback prototype changed')
            decoded=[{'pc':pc,'word':w,'op':OPS[w&63],'A':(w>>6)&255,'B':(w>>23)&511,'C':(w>>14)&511,'Bx':w>>14} for pc,w in enumerate(f['words'])]
            need(c['instructions']==decoded,'Decoded original instructions changed')
            empty=len(f['words'])==1 and f['words'][0]&63==30 and ((f['words'][0]>>23)&511)==1
            need(c['single_return_no_values'] is empty,'Empty callback classification changed')
            callback_count+=1;empty_count+=empty
        for candidate in row['community_candidates']:
            keep(candidate['source']);need(candidate['dispatch_qualified'] is False,'Basename match promoted to dispatch')
    need((callback_count,empty_count)==(56,8) and inv['counts']['callbacks_with_other_instructions']==48,'Callback census mismatch')
    review=load(inputs['community_review']['path']);by_script={x['relative_path']:x for x in review['script_inventory']}
    scripts={x['relative_path']:x for x in inputs['scripts']};need(len(scripts)==17,'Seventeen community source snapshots required')
    for rel,x in scripts.items():
        keep(x['source']);need(x['source']['sha256']==by_script[rel]['sha256'] and x['inherited_git_snapshot']==by_script[rel]['git_snapshot'],'Community source/version rebound')
        expected=[row['native_source']['path'] for row in inv['rows'] if any(c['relative_path']==rel for c in row['community_candidates'])]
        need(x['candidate_native_files']==expected and x['native_dispatch_qualified'] is False,'Candidate ambiguity or scope changed')
    for group in ['community_loader_and_map_anchors','current_Rust_source_anchors']:
        for a in inputs[group]:
            p=keep(a['source']);lines=p.read_text('utf-8-sig').splitlines()
            need(lines[a['line']-1]==a['excerpt'] and a['needle'] in a['excerpt'],'Consumer source anchor changed')
    for identity in inputs['additional_sources']:keep(identity)
    for probe in [ip,mp]:
        need(probe['runtime']['reported_version']=='Lua 5.1','Wrong Lua runtime family')
        keep(probe['runtime']['python'],tool=True);keep(probe['runtime']['lua_module']);keep(probe['producer']);keep(probe['format_adapter'])
        need(pathlib.Path(probe['runtime']['lua_module']['path']).resolve()==(R/'tools/pythonlibs/lupa/lua51.cp312-win_amd64.pyd').resolve() and probe['runtime']['lua_module']['sha256']=='29bc76a1cd9d2ac799edd84f0e6061f25324713228da9ffe9e4727570ac7f9e9','Bundled Lua51 module rebound')
    need(ip['raw32_roundtrip_exact'] is True and ip['instruction_arrays_preserved'] is True and ip['original_instruction_arrays_executed_by_bundled_Lua51'] is True,'Original instruction preservation unproven')
    for key in ['historical_embedded_game_VM_executed','historical_Windows_game_process_launched','current_Rust_or_CSharp_gameplay_executed','engine_call_implementation_qualified','actual_UpdateBuffs_argument_producer_qualified','integrated_into_registry']:
        need(ip[key] is False,'Unsupported InfernalGuardian scope claim: '+key)
    p=keep(ip['source']);proto=parsed[str(p).casefold()];f=proto['children'][0]
    need(ip['adapted_sha256']==adapted_identity(p.read_bytes(),ip['format_adapter']['path']),'InfernalGuardian adapted bytes identity changed')
    need(words(proto)==ip['instruction_array_sha256'] and len(f['words'])==7 and f['code_sha256']=='578c605d5a7ec3cf9c37b9f800e90a712d1f3627f23892355e2f6d2c30f72a81','Wrong original callback instruction arrays')
    expected_metadata={'NotSingleTargetSpell':True,'DoesntTriggerSpellCasts':False,'IsDamagingSpell':True,'SpellDamageRatio':0.5,'IsPetDurationBuff':True}
    need(ip['metadata']==expected_metadata,'Original metadata values changed')
    need(all(ip['metadata'][k] is value for k,value in expected_metadata.items() if isinstance(value,bool)),'Lua boolean metadata changed to a numeric surrogate')
    grid={(a,c) for a in ['pet_actor_A','pet_actor_B'] for c in [-0.5,0.,0.25,0.5,0.999999,1.,1.000001,2.]}
    need(len(ip['cases'])==16 and {(x['actor'],x['third_parameter']) for x in ip['cases']}==grid,'Missing or duplicate callback scenario')
    for case in ip['cases']:
        need(type(case['third_parameter']) in [int,float],'Supplied callback coefficient must remain numeric, not boolean')
        expected=[[case['third_parameter'],case['actor']]] if case['third_parameter']<1 else []
        need(case['expected_host_calls']==case['observed_host_calls']==expected and case['passed'] is True,'Incorrect native scale request observation')
        need(all(len(args)==2 and type(args[0]) in [int,float] and isinstance(args[1],str) for args in case['observed_host_calls']),'Observed scale arguments changed type')
    need(ip['cases_count']==16 and ip['host_call_cases']==10,'Probe case summary changed')
    for key in ['historical_game_VM_or_engine_APIs_executed','Rust_or_CSharp_gameplay_executed','integrated_into_registry']:need(mp[key] is False,'Unsupported map probe scope claim')
    need(len(mp['cases'])==6 and mp['counts']=={'files':5,'callbacks':6,'observed_turret_requests':78,'original_callback_instructions':552},'Map request census changed')
    map_keys=[]
    for case in mp['cases']:
        p=keep(case['source']);proto=parsed[str(p).casefold()];i=case['prototype_index'];f=proto['children'][i]
        need(case['adapted_sha256']==adapted_identity(p.read_bytes(),mp['format_adapter']['path']),'Map adapted bytes identity changed')
        need(function_names(proto)[i][0]['name']==case['callback'],'Map callback rebound')
        need(case['source_code_sha256']==f['code_sha256'] and case['all_prototype_instruction_sha256']==words(proto),'Map original instructions changed')
        need(case['raw32_roundtrip_exact'] is True and case['instruction_arrays_preserved'] is True and case['shared_Spawning_body_executed'] is False and case['passed'] is True,'Unqualified map adaptation/shared behavior')
        expected=arguments(f)
        need(case['observed_calls']==expected and case['expected_direct_calls_from_original_CALL_instructions']==len(expected),'Map API request differs from original constant arguments')
        need(all(len(c['args'])==5 and all(isinstance(x,str) for x in c['args'][:3]) and all(type(x) in [int,float] for x in c['args'][3:]) for c in case['observed_calls']),'Map symbolic/string/numeric argument types changed')
        need(case['expected_argument_counts_from_CALL_B']==[len(x['args']) for x in expected] and case['original_callback_instruction_count']==len(f['words']),'Map call arity/instruction count differs')
        map_id=p.parent.parent.name.casefold();need(case['shared_load_requests_observed']==([['Spawning']] if map_id=='map11' else []),'Shared dependency observation changed')
        map_keys.append((str(p).casefold(),i))
    need(len(set(map_keys))==6 and len({p for p,_ in map_keys})==5,'Duplicate map case')
    spell_path=scripts['Characters/Annie/R.cs']['source']['path'];spell=pathlib.Path(spell_path).read_text('utf-8-sig')
    buff=pathlib.Path(scripts['Buffs/Annie/InfernalGuardian.cs']['source']['path']).read_text('utf-8-sig')
    need('namespace Spells' in spell and 'class InfernalGuardian : ISpellScript' in spell and 'class InfernalGuardianGuide : BasePetController' in spell,'Spell class namespace/interfaces changed')
    need('namespace Buffs' in buff and 'class InfernalGuardian : IBuffGameScript' in buff,'Buff class namespace/interfaces changed')
    init=re.findall(r'public SpellScriptMetadata ScriptMetadata => new SpellScriptMetadata\(\)\s*\{([^}]+)\}',spell,re.S)
    need(len(init)==1,'Ambiguous community spell metadata')
    cs={}
    for name in ['TriggersSpellCasts','IsDamagingSpell','IsPetDurationBuff','NotSingleTargetSpell','SpellDamageRatio']:
        values=re.findall(r'\b'+name+r'\s*=\s*(true|false|[0-9]+\.[0-9]+f)\s*,',init[0]);need(len(values)==1,'Missing literal metadata '+name)
        cs[name]=values[0]=='true' if values[0] in ['true','false'] else float(values[0][:-1])
    need(cs=={'TriggersSpellCasts':True,'IsDamagingSpell':True,'IsPetDurationBuff':True,'NotSingleTargetSpell':True,'SpellDamageRatio':0.5},'Community metadata changed')
    search=load(inputs['native_PE_research']['path']);keep(search['binary']);keep(search['producer'])
    need(search['code_executed'] is False and not next(x for x in search['rows'] if x['name']=='SetScaleSkinCoef')['occurrences'],'Native PE search changed; review exact scope')
    matches=inputs['searches'];need(len(matches)==2 and all(x['exit_code'] in [0,1] and not x['stderr'] for x in matches),'Text search failed')
    return {'schema':'openleague_native_community_callback_reference_audit/v1',
        'counts':{'native_files':17,'native_direct_callback_prototypes':56,'empty_callbacks':8,'nonempty_callbacks':48,'community_scripts_with_refined_candidates':17,'inherited_InfernalGuardian_Lua51_cases':16,'fresh_map_Lua51_callbacks':6,'map_turret_requests':78,'map_callback_instructions':552,'literal_metadata_pairs':5,'fully_qualified_community_scripts':0},
        'infernal_metadata_native':expected_metadata,'community_spell_metadata':cs,
        'metadata_scope':'Four literal names/values agree; DoesntTriggerSpellCasts=false and TriggersSpellCasts=true have consistent literal polarity. Historical native flag consumer/full event semantics remain unqualified; no contradiction is asserted from names.',
        'community_source_anchors':inputs['community_loader_and_map_anchors'],'current_consumer_evidence':inputs['current_Rust_source_anchors'],
        'candidate_scripts':[{'relative_path':x['relative_path'],'native_candidates':x['candidate_native_files'],'dispatch_qualified':False} for x in inputs['scripts']],
        'map_callback_scope':'Original callbacks request turrets. Community decoration classes are not selected as equivalent because their filenames match; Map10 calls separate decoration and turret-object paths.',
        'source_identities':list(identities.values()),'inherited_native_experiments':[inputs['inherited_infernal_probe']],
        'fresh_native_experiments':[inputs['fresh_map_probe']],
        'native_engine_API_or_original_argument_producer_qualified':False,'current_Rust_or_CSharp_gameplay_qualified':False,'historical_game_process_launched':False,
        'declared_boundaries':['Original Lua instruction arrays run in bundled Lua51 with format-only string-length adaptation and explicit host adapters, not the game embedded VM.',
            'Map11 Spawning shared-body, turret engine side effects and numeric team enums are unqualified. Six callbacks prove requested names/arguments only.',
            'SetScaleSkinCoef binding and actual UpdateBuffs argument producer are not recovered. Missing exact strings in one PE and bounded textual searches do not prove absence elsewhere.',
            'Distinct community namespaces/loader source are inspected; no actual assembly dispatch or CSharp gameplay run. Current Rust Annie dispatch/lifecycle source is inspected only.',
            'All seventeen script questions remain open. No complete champion, map, script collection or Goal acceptance inferred.']}

if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('--evidence-root',required=True);p.add_argument('--output',required=True);a=p.parse_args()
    out=pathlib.Path(a.output);need(not out.exists(),'Preserve previous audit output')
    d=audit(a.evidence_root);out.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');print(json.dumps(d['counts']))
