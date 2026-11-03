"""Read exact current build-input links; never turn metadata/source presence into acceptance."""
import argparse,hashlib,json,pathlib,tarfile,tomllib
R=pathlib.Path('E:/OpenLeague');S=pathlib.Path('E:/mapslol3v3')
def load(p):return json.loads(pathlib.Path(p).read_bytes())
def pin(p):
 p=pathlib.Path(p);b=p.read_bytes();return dict(path=str(p),bytes=len(b),sha256=hashlib.sha256(b).hexdigest())
def need(v,msg):
 if not v:raise ValueError(msg)
def audit(inputs,verify_files=True):
 d=load(inputs) if isinstance(inputs,(str,pathlib.Path)) else inputs
 need(d['schema']=='openleague_dependency_precise_link_inputs/v1' and d['passed'] is True,'Wrong dependency-link schema or observation')
 for k in ['original_Riot_build_specification','current_game_or_GUI_executed','compiler_build_or_GPU_qualification','clean_build_reproducibility_qualified','upstream_registry_authenticity_independently_verified','new_library_adoption','manual_state_mutated']:
  need(d[k] is False,'Unsupported scope claim: '+k)
 need(d['WebView2_installed_runtime_version'] is None and d['human_acceptance']=='not_given' and d['full_task_scopes_closed']==d['questions_closed']==0,'Invented runtime,closure or acceptance')
 sources={str(pathlib.Path(s['path']).resolve()).casefold():s for s in d['source_identities']}
 need(len(sources)==len(d['source_identities'])==147,'Missing/duplicate dependency source')
 roots=[R,S,pathlib.Path('C:/Users/loicd/.cargo/registry')]
 tools=[pathlib.Path('C:/Users/loicd/.rustup/toolchains/stable-x86_64-pc-windows-msvc/bin')/f for f in ['rustc.exe','cargo.exe']]+[pathlib.Path('C:/Users/loicd/.cargo/bin/rustup.exe')]
 for s in sources.values():
  p=pathlib.Path(s['path']).resolve()
  need(any(p.is_relative_to(r.resolve()) for r in roots) or p in tools,'Source outside explicit build-reference roots')
  if verify_files:need(pin(s['path'])==s,'Source identity changed: '+str(p))
 for x in [d['producer'],d['reference'],d['previous_delivery'],d['preflight']]:
  need(sources.get(str(pathlib.Path(x['path']).resolve()).casefold())==x,'Source role rebound')
 need(d['reference']['path']==str(R/'docs/reference_client_4_20.json') and d['previous_delivery']['path']==str(R/'docs/fidelity_registry_garen_component_revision_4_20.json'),'Wrong reference/delivery role')
 for name in ['metadata_observation','patch_comparison','patch_content_view']:
  x=d[name];need(load(x['source']['path'])==x['observed'],'Changed exact observation: '+name)
 pre=load(d['preflight']['path']);meta=d['metadata_observation']['observed'];comparison=d['patch_comparison']['observed'];view=d['patch_content_view']['observed']
 need(meta['passed'] and meta['manifests_and_locks_unchanged'] is True and len(meta['commands'])==2,'Failed/incomplete metadata commands')
 need(all(meta[k] is False for k in ['full_dependency_graph_resolved','compilation_or_build_scripts_executed','Windows_target_builds_qualified','clean_reproducible_build_qualified','native_or_current_gameplay_executed','library_replacement_adopted','manual_state_mutated']),'Metadata promoted to compiler/build/runtime acceptance')
 observed_packages=[p for scope in meta['observations'] for p in scope['packages']]
 need(len(observed_packages)==6 and all(p['rust_version'] is None for p in observed_packages),'Declared root floor promoted to package inheritance')
 for c in meta['commands']:
  need(c['exit_code']==0 and all(flag in c['command'] for flag in ['--locked','--offline','--no-deps']) and c['compilation_or_build_script_executed'] is False,'Unsupported Cargo execution scope')
  need(pin(c['stdout']['path'])==c['stdout'] and pin(c['stderr']['path'])==c['stderr'],'Cargo terminal log changed')
  raw=load(c['stdout']['path'])
  expected=next(x for x in meta['observations'] if x['workspace_root']==raw['workspace_root'])
  need(raw['resolve'] is None and expected['resolve'] is None and len(raw['packages'])==len(expected['packages']),'No-deps metadata changed')
  need([{k:p[k] for k in ['name','version','manifest_path','rust_version','edition','targets','dependencies']} for p in raw['packages']]==expected['packages'],'Package metadata payload changed')
 need(comparison['passed'] and comparison['no_extraction_or_mutation'] is True and comparison['upstream_publisher_authenticity_independently_verified'] is False and comparison['gameplay_or_GPU_executed'] is False,'Patch comparison promoted to upstream/GPU authority')
 need([(r['crate'],[x['relative_path'] for x in r['changed_members']]) for r in comparison['crates']]==[('bevy_animation',['src/lib.rs','src/transition.rs']),('bevy_render',['src/view/window/screenshot.rs'])],'Different patch source set')
 for crate in comparison['crates']:
  need(crate['version']=='0.19.0' and crate['independent_expected_archive_checksum'] is None and crate['patched_code_executed'] is False and crate['behavioral_effects_or_GPU_qualified'] is False,'Invented package checksum/code behavior authority')
  root=R/'vendor'/crate['crate']
  need({str(p.resolve()).casefold() for p in root.rglob('*') if p.is_file()}=={str(pathlib.Path(p['path']).resolve()).casefold() for p in crate['local_files']},'Vendor file set changed')
  if verify_files:
   members={};prefix=crate['crate']+'-0.19.0/'
   with tarfile.open(crate['archive']['path'],'r:gz') as t:
    for member in t:
     if member.isdir():continue
     need(member.isfile() and member.name.startswith(prefix),'Invalid cached archive member')
     rel=member.name[len(prefix):];need('..' not in pathlib.PurePosixPath(rel).parts and rel not in members,'Unsafe/duplicate cached member')
     raw=t.extractfile(member).read();members[rel]=dict(bytes=len(raw),sha256=hashlib.sha256(raw).hexdigest())
   need(members==crate['archive_members'],'Cached archive member identity changed')
 need(view['original_or_patched_code_executed'] is False and all(x['line_endings_normalized_for_display_only'] is True for x in view['rows']),'Display normalization promoted to byte identity or execution')
 need(d['checks_count']==len(d['checks'])==12 and all(c['result']=='pass' for c in d['checks']),'Incomplete source observation controls')
 associations=d['associations'];need([x['task_id'] for x in associations]==[f'SYS-03.1-{i:02}' for i in range(1,8)],'Wrong task association set')
 boundaries={'SYS-03.1-01','SYS-03.1-06'};anchors=[]
 for a in associations:
  need(a['basis'].startswith('explicit_local_') and a['native_Riot_authority_claimed'] is False and a['full_task_scope_complete'] is False and a['current_gameplay_executed'] is False and a['remaining'],'Local build input promoted to native or completed feature')
  need(a['entry_boundary_only']==(a['task_id'] in boundaries),'Toolchain/replacement boundary promoted to feature consumer')
  original=next(x for x in pre['tasks'] if x['task']['id']==a['task_id'])
  need(a['prior_task_contract']==original['task'] and a['existing_unknown_id']==original['unknowns'][0]['unknown_id'],'Requirement/question identity rebound')
  for c in a['anchors']:
   p=R/c['path'];need(p.resolve().is_relative_to(R.resolve()),'Current site outside actual project')
   need(c['entry_boundary_only']==a['entry_boundary_only'],'Boundary consumer role mismatch')
   need(sources.get(str(p.resolve()).casefold())==c['source'],'Current site source role changed')
   lines=p.read_text(encoding='utf-8').splitlines()
   need(lines[c['line']-1]==c['excerpt'] and c['needle'] in c['excerpt'] and sum(c['needle'] in line for line in lines)==1,'Actual site changed or ambiguous')
   anchors.append(c)
 need(len(anchors)==len({a['role'] for a in anchors})==23,'Missing/duplicated precise site')
 for rel,x in pre['manifests'].items():need(tomllib.loads((R/rel).read_text(encoding='utf-8'))==x['parsed'],'Current Cargo manifest changed')
 need(pre['manifests']['Cargo.toml']['parsed']['workspace']['package']['rust-version']=='1.90' and all(not p for p in pre['explicit_ancestor_file_presence'].values()),'Root toolchain declaration/presence observation changed')
 need(all(pathlib.Path(p).exists()==present for p,present in pre['explicit_ancestor_file_presence'].items()),'Inspected ancestor toolchain/config presence changed')
 need(d['tool_versions_observed']['rustc']['release']=='1.96.1' and d['tool_versions_observed']['recorded_from_actual_tool_output_without_replay'] is True,'Wrong observed toolchain version')
 return dict(verified=True,source_hashes_verified=len(sources) if verify_files else 0,precise_local_task_associations=7,actual_current_sites=23,
  entry_boundary_only_task_ids=sorted(boundaries),full_task_scopes_closed=0,original_native_Riot_spec_qualified=False,
  source_checks=12,metadata_commands_inherited_not_reexecuted=2,whole_build_or_game_qualified=False,manual_state_mutated=False)
if __name__=='__main__':
 p=argparse.ArgumentParser();p.add_argument('--inputs',required=True);p.add_argument('--output');a=p.parse_args()
 try:r=audit(a.inputs)
 except (ValueError,OSError,KeyError,IndexError,StopIteration) as e:print(json.dumps(dict(verified=False,error=str(e))));raise SystemExit(1)
 if a.output:
  out=pathlib.Path(a.output);need(not out.exists(),'Preserve previous output');out.write_text(json.dumps(r,indent=2)+'\n',encoding='utf-8')
 print(json.dumps(r))
