"""Read exact native spell/BLND references beside actual catalogue/GLB bindings.

This is a static source audit. Empty fields, absent fields, graph candidates,
cast flags, current role bindings and runtime playback are separate facts.
"""
import argparse,collections,hashlib,json,pathlib,re,struct,sys
from reference_inibin import read,hashkey
from rads_reference_membership import RadsReferenceMembership,identity,logical_key
from native_skin_reference import resolve

FIELDS=['AnimationName','AnimationLoopName','AnimationWinddownName','AnimationLeadOutName','Flags','CantCancelWhileWindingUp','TargettingType']
ROLE_CASES=[('ROLE-01','azir',1),('ROLE-02','fiora',2),('ROLE-03','fiora',3),('ROLE-04','garen',2),('ROLE-05','karma',4),('ROLE-06','khazix',4),('ROLE-07','quinn',2),('ROLE-08','varus',2),('ROLE-09','vayne',2),('ROLE-10','vayne',4)]

def field(values,section,name):
    key=hashkey(section,name)
    return {'section':section,'field':name,'hash_key':key,'present':key in values,'value':values.get(key)}

def classify_animation(value):
    if not value['present']:return 'native_field_absent'
    if value['value']=='':return 'native_field_explicitly_empty'
    if isinstance(value['value'],str):return 'native_named_animation_alias'
    raise ValueError('Native AnimationName is not a string; no coercion accepted')

def glb_metadata(path):
    pin=identity(path);p=pathlib.Path(path)
    with p.open('rb') as stream:
        header=stream.read(20)
        if len(header)!=20:raise ValueError('Truncated GLB header')
        magic,version,total,length,kind=struct.unpack('<5I',header)
        if magic!=0x46546c67 or version!=2 or total!=pin['bytes'] or kind!=0x4e4f534a or not 0<length<=64*1024*1024 or 20+length>total:
            raise ValueError('Invalid bounded GLB JSON/length contract')
        data=json.loads(stream.read(length))
    if identity(path)!=pin:raise ValueError('GLB changed while reading metadata')
    return pin,{'scene_count':len(data.get('scenes',[])),'animation_names':[a.get('name') for a in data.get('animations',[])],'pose_values_or_playback_qualified':False}

def audit(root,blnd_reader_path):
    root=pathlib.Path(root);membership=RadsReferenceMembership(root);deploy=membership.deploy
    import importlib.util
    reader_path=pathlib.Path(blnd_reader_path);reader_identity=identity(reader_path)
    if reader_identity['sha256']!='48407551a1a7b98e764a8b647aff826d54972fbd77960dba5deede0f576ed255':
        raise ValueError('Unqualified BLND reader identity')
    spec=importlib.util.spec_from_file_location('bounded_native_blnd_type1_reader',reader_path);reader=importlib.util.module_from_spec(spec);spec.loader.exec_module(reader)
    pins={};members={};sources={}
    def source(path,logical=None):
        path=pathlib.Path(path);key=str(path.resolve()).casefold()
        if key not in pins:
            pins[key]=identity(path)
            if logical is not None:
                checked=membership.inspect(logical,path,pins[key])
                if checked['status']!='matches_selected_project_manifest' or len(checked['matching_members'])!=1:raise ValueError('Native resource not an exact selected manifest member: '+logical)
                members[key]=checked
        return pins[key]
    catalog_path=root/'data/4.20/animation_manifest.json';catalog=json.loads(catalog_path.read_bytes());source(catalog_path)
    world_path=root/'data/4.20/world_animation_manifest.json';world=json.loads(world_path.read_bytes());source(world_path)
    if set(catalog)&set(world):raise ValueError('World catalogue shadows a champion; explicit source review required')
    runtime=root/'crates/client/src/animation.rs';runtime_text=runtime.read_text('utf-8');source(runtime)
    matches=re.findall(r'const EZREAL_JOINT_IDENTITY_ASSET: &str = "([^"]+)";',runtime_text)
    if len(matches)!=1 or 'catalog["ezreal"]["asset"] =' not in runtime_text or 'unwrap_or_else(|| format!("champions/{name}.glb"))' not in runtime_text:
        raise ValueError('Current runtime asset dispatch contract changed')
    registry_path=root/'docs/fidelity_skin_configuration_bindings_4_20.json';registry=json.loads(registry_path.read_bytes());source(registry_path)
    bases={x['champion'].casefold():x for x in registry['rows'] if x['skin_num']==0}
    if set(bases)!=set(catalog) or len(catalog)!=122:raise ValueError('Exact122 base champion identities required')
    role_tasks={(h,n):t for t,h,n in ROLE_CASES};rows=[];champions=[];glb_observations={};graph_cache={}
    for hero,entry in catalog.items():
        base=bases[hero];champion=base['champion'];char_root=deploy/'DATA/Characters'/champion
        character=char_root/(champion+'.inibin');char_pin=source(character,character.relative_to(deploy).as_posix());values=read(character)
        resource=matches[0] if hero=='ezreal' else entry.get('asset','champions/'+hero+'.glb')
        if not isinstance(resource,str) or pathlib.PurePosixPath(resource).is_absolute() or '..' in pathlib.PurePosixPath(resource).parts:raise ValueError('Runtime asset path escaped assets')
        model_path=root/'assets'/resource;model_pin,model=glb_metadata(model_path);pins[str(model_path.resolve()).casefold()]=model_pin
        glb_observations[hero]={'asset':resource,'source':model_pin,**model,'catalogue_names_equal':entry['clips']==model['animation_names']}
        binding=resolve(deploy,champion,0,base['skin_id']);graphs=[]
        for candidate in binding['qualified_bindings']:
            config=pathlib.Path(candidate['source']['path']);source(config,config.relative_to(deploy).as_posix())
            name=candidate['fields']['Animations']
            if not isinstance(name,str) or not name:continue
            basename=pathlib.PurePosixPath(name.replace('\\','/')).name
            for p in char_root.rglob('*'):
                if not p.is_file() or p.name.casefold()!=basename.casefold():continue
                key=str(p.resolve()).casefold()
                if key not in graph_cache:
                    pin=source(p,p.relative_to(deploy).as_posix());raw=p.read_bytes()
                    try:graph=reader.Blnd(raw);graph_cache[key]={'source':pin,'parsed':True,'graph':graph}
                    except reader.UnsupportedOrInvalid as e:graph_cache[key]={'source':pin,'parsed':False,'reason':str(e)}
                if key not in [g['key'] for g in graphs]:graphs.append({'key':key,'configured_name':name,'configuration_source':candidate['source'],'configuration_section':candidate['section']})
        for slot in range(1,5):
            role='spell'+str(slot);spell_name=field(values,'Data','Spell'+str(slot));name=spell_name['value'];spell_sources=[]
            if spell_name['present'] and isinstance(name,str) and re.fullmatch(r'[A-Za-z0-9_]{1,128}',name):
                for p in [char_root/'Spells'/(name+'.inibin'),deploy/'DATA/Spells'/(name+'.inibin')]:
                    if p.is_file():spell_sources.append({'source':source(p,p.relative_to(deploy).as_posix()),'fields':{f:field(read(p),'SpellData',f) for f in FIELDS}})
            if len(spell_sources)==1:
                animation=spell_sources[0]['fields']['AnimationName'];classification=classify_animation(animation)
            else:animation=None;classification='native_spell_source_absent' if not spell_sources else 'multiple_native_spell_sources_no_precedence_inferred'
            index=entry.get('roles',{}).get(role);clip=model['animation_names'][index] if isinstance(index,int) and not isinstance(index,bool) and 0<=index<len(model['animation_names']) else None
            edges=[]
            if animation and classification=='native_named_animation_alias':
                for config in graphs:
                    g=graph_cache[config['key']];edge={'graph_source':g['source'],'configured_name':config['configured_name'],'configuration_source':config['configuration_source'],'parsed':g['parsed'],'runtime_graph_precedence_qualified':False}
                    if g['parsed']:
                        nodes=[n for n in g['graph'].nodes if n['name']==animation['value']]
                        edge['exact_named_nodes']=nodes
                        edge['direct_type1_resources']=[n['resource']['name'] for n in nodes if n['payload_kind']==1 and n.get('resource') is not None]
                    else:edge['reason']=g['reason']
                    edges.append(edge)
            rows.append({'champion':champion,'catalogue_key':hero,'slot':slot,'role':role,'role_task_id':role_tasks.get((hero,slot)),'presentation_task_id':'CH-'+champion+'-'+['Q','W','E','R'][slot-1]+'-PRESENTATION','character_source':char_pin,'character_slot_field':spell_name,'native_spell_sources':spell_sources,'native_animation_classification':classification,'current_model_source':model_pin,'current_role_present':role in entry.get('roles',{}),'current_role_index':index,'current_clip_name':clip,'current_catalogue_and_model_names_equal':entry['clips']==model['animation_names'],'named_graph_candidates':edges,'native_flags_semantics_or_automatic_alias_remap_qualified':False,'runtime_playback_or_gameplay_qualified':False})
        champions.append({'champion':champion,'base_skin_id':base['skin_id'],'configured_graph_candidates':len(graphs),'runtime_asset':resource})
    return {'schema':'openleague_native_animation_role_reference_audit/v1','rows':rows,'champions':champions,'current_models':glb_observations,'source_identities':list(pins.values()),'native_manifest_membership':list(members.values()),'manifest_catalogue':membership.catalogue_identity,'selected_manifests':membership.manifests,'BLND_reader':reader_identity,'counts':{'champions':len(champions),'slots':len(rows),'sources':len(pins),'native_classifications':dict(collections.Counter(r['native_animation_classification'] for r in rows)),'missing_current_roles':sum(not r['current_role_present'] for r in rows),'model_catalogue_name_mismatches':sum(not g['catalogue_names_equal'] for g in glb_observations.values())},'limits':['Native AnimationName/Flags are exact raw fields,not proof of cast eligibility or effective animation selection.','BLND basename matches are retained candidates,not native provider priority. Only exact-name direct type1 edges are interpreted; other payloads remain opaque.','GLB header/names/indices and actual current source asset selection are static evidence; keyframe conversion fidelity,Bevy loading/pose playback and gameplay remain unqualified.','Do not automatically create a cast animation for an explicitly empty field or remap a role from a raw alias without original flag/graph semantics.']}

if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('--root',default='E:/OpenLeague');p.add_argument('--blnd-reader',required=True);p.add_argument('--output',required=True);args=p.parse_args();out=pathlib.Path(args.output)
    if out.exists():raise ValueError('Preserve existing audit output')
    result=audit(args.root,args.blnd_reader);out.write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');print(json.dumps(result['counts']))
