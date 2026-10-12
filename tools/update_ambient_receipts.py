"""Record qualified native ambient integration without closing any full-game domain."""
from pathlib import Path
import json,hashlib,datetime
r=Path(__file__).resolve().parents[1];now=datetime.datetime.now(datetime.timezone.utc).isoformat()
def read(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def write(p,d):(r/p).write_text(json.dumps(d,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')
def sha(p):return hashlib.sha256((r/p).read_bytes()).hexdigest()
ambient=read('docs/map_ambient_runtime_validation.json');blender=read('docs/map_ambient_blender_validation.json');vertex=read('docs/environment_vertex_render_validation.json');terrain=read('docs/terrain_native_render_validation.json');fog=read('docs/native_fog_render_validation.json');client=sha('target/debug/openleague-client.exe')
for proof in [ambient,vertex,terrain,fog]:assert proof['client_sha256']==client and proof.get('passed',True)
assert (r/'logs/ambient-normal-render.png').stat().st_mtime>(r/'target/debug/openleague-client.exe').stat().st_mtime
metadata={'updated_utc':now,'client_sha256':client,'map_sha256':sha('assets/maps/twisted_treeline.glb'),'native_models':8,'native_clips':11,'moving_instances':17,'suppressed_embedded_roots':19,'duplicate_altars_suppressed':2,'blender_animated_source':blender['blend_file'],'blender_animated_source_sha256':blender['blend_sha256'],'source_receipt':'docs/map_ambient_source_validation.json','runtime_receipt':'docs/map_ambient_runtime_validation.json','blender_receipt':'docs/map_ambient_blender_validation.json','native_event_sources':'docs/map_ambient_event_sources.json','complete':False,'limits':ambient['limits']}
write('docs/map_ambient_progress.json',metadata)
coverage=read('docs/coverage.json');coverage['updated_utc']=now;coverage['complete']=False;ev=coverage['current_evidence'];ev.update({'map_ambient':metadata,'native_vertex_gpu_samples':len(vertex['samples']),'visual_verification':f"Current client: {len(vertex['samples'])} static NVR vertex-control samples <={vertex['maximum_rgb_error']:.3f}/255, 3 terrain samples <=0.561/255, 17 low-fog samples <={fog['maximum_rgb_error']:.3f}/255 on environment-only frames. 17 full native ambient loops and changing bone transforms verified separately in ordinary rendering; 19 stale embedded groups hidden including two altar duplicates. Full native variants/spatial/shadow/actor/particle/audio fidelity remains incomplete."})
for p in ['docs/map_ambient_source_validation.json','docs/map_ambient_runtime_validation.json','docs/map_ambient_blender_validation.json','docs/map_ambient_progress.json','docs/map_ambient_event_sources.json']:
 if p not in coverage['evidence']:coverage['evidence'].append(p)
write('docs/coverage.json',coverage)
build=read('docs/build_receipt.json');build['date']=now
for exe in build['executables']:
 exe['sha256']=sha(exe['path']);exe['bytes']=(r/exe['path']).stat().st_size
build.update({'latest_build_log':'logs/ambient-client-build.log','latest_client_build_log':'logs/ambient-client-build.log','latest_build_scope':'Client native ambient integration only; server and launcher unchanged','client_tests':6,'map_ambient':metadata,'game_complete':False})
for p in ['logs/ambient-client-tests.log','docs/map_ambient_runtime_validation.json','docs/map_ambient_blender_validation.json']:
 if p not in build['test_logs']:build['test_logs'].append(p)
if 'native_vertex_lighting' in build:
 nv=build['native_vertex_lighting'];nv.update({'updated_utc':now,'client_sha256':client,'actual_gpu_probe_passed':True,'actual_gpu_samples':len(vertex['samples']),'maximum_gpu_rgb_error':vertex['maximum_rgb_error'],'complete':False})
write('docs/build_receipt.json',build)
checkpoint=read('docs/resume_checkpoint.json');checkpoint.update({'saved_utc':now,'state':'active','complete':False,'executables':build['executables'],'build':'Six client tests pass. Current client verifies 17 native ambient loops, 19 suppressed embedded roots, all restored placement matrices and Blender poses after reopen; current terrain/vertex/fog GPU checks pass. Full OpenLeague incomplete.'})
checkpoint['last_verified'].update({'ambient_native_models':8,'ambient_native_clips':11,'ambient_moving_instances':17,'ambient_suppressed_roots':19,'ambient_blender_moving_instances':17,'native_vertex_gpu_pixels':len(vertex['samples'])})
checkpoint['latest_changes'].append('Full native ambient models replace 17 static decorative props; embedded duplicate altars hidden. Dedicated animated Blender map source saved/reopened with changing bone poses. Six native effect/audio particle files traced, not yet integrated.')
checkpoint['restart_next']=[s for s in checkpoint['restart_next'] if not s.startswith('Recover and bind ambient map animations:') and not s.startswith('Investigate two unresolved native vertex GPU pixels')]
checkpoint['restart_next'].insert(0,'Decode native ambient BLND event times/attachments and TROYBIN emitter/audio references: docs/map_ambient_event_sources.json resolves 18 references to six files. Integrate native braziers flames/chain/shopkeeper audio and exact secondary idle transitions. Current 17 primary full loops do not qualify all animation/event behavior. Preserve the full 24-domain objective.')
write('docs/resume_checkpoint.json',checkpoint)
plan=read('docs/completion_plan.json');plan['current_evidence']=ev;plan['development_state']='active';plan['updated_utc']=now;write('docs/completion_plan.json',plan)
print('RECORDED current native ambient integration:',client,'17 loops; full objective remains incomplete')

