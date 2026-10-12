from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague')
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def save(p,d):(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
source=load('docs/annie_spell_vfx_sources.json');summary=source['summary']
for e in source['effects']:
 assert sha(e['source'])==e['sha256'] and sha(r/e['contract'])==e['contract_sha256']
 assert e['independent_named_fields_equal']+e['unknown_fields']==e['fields']
for t in source['textures']:
 if t.get('pixels_equal'):assert sha(t['source'])==t['source_sha256'] and sha(r/'assets'/t['asset'])==t['png_sha256']
q=next(b for b in source['native_spell_bindings'] if b['spell']=='Disintegrate')
assert q['named_fields']['MissileEffect']=='Annie_Q_mis.troy'
now=datetime.datetime.now(datetime.timezone.utc).isoformat()
phase={'updated_utc':now,'complete':False,'native_spell':'Disintegrate','source':q['source'],'sha256':q['sha256'],'binding_fields':{k:q['named_fields'].get(k) for k in ['MissileEffect','MissileBoneName','MissileTargetHeightAugment','ParticleStartOffset','HitEffectName','HaveHitEffect','HitBoneName','HaveHitBone','AfterEffectName','HaveAfterEffect']},'limits':['HaveHitEffect and HaveAfterEffect are native string0; named effect references alone do not authorize automatic impact/after emission. Native callbacks and skin overrides still need qualification.','Missile launch attachment neck and target height augmentation100 are native bindings; interpolation path and original transforms not yet implemented in client.','Old Disintegrate_mis resource is not the native SpellData MissileEffect for this build.','Preserve all emitter/skin variants, unresolved meshes/textures and raw unknown fields before runtime port. No placeholder sphere replaces original multi-emitter Q.']}
save('docs/annie_q_vfx_binding_contract.json',phase)
for p in ['docs/coverage.json','docs/completion_plan.json']:
 d=load(p);d['updated_utc']=now;d['complete']=False
 d['current_evidence']['annie_spell_vfx_recovery']={'sources':'docs/annie_spell_vfx_sources.json','Q_binding':'docs/annie_q_vfx_binding_contract.json',**summary,'complete':False,'runtime_consumer_complete':False}
 if p.endswith('coverage.json'):
  for f in ['docs/annie_spell_vfx_sources.json','docs/annie_q_vfx_binding_contract.json']:
   if f not in d['evidence']:d['evidence'].append(f)
 save(p,d)
d=load('docs/resume_checkpoint.json');d['saved_utc']=now;d['state']='active';d['complete']=False
d['latest_changes'].append('Recovered actual Annie SpellData VFX bindings:18 spell files,10 effects,2360nativefields(2298 independently named equal,62raw unknown preserved),57pixel-exact original textures; one missingGoth glow and one ambiguous different-content Base/Shared glow. Q references Annie_Q_mis, neck bone and100target-height augment; native HaveHitEffect/HaveAfterEffect0 mean named legacy impact references alone cannot qualify automatic emission. Runtime effects not complete; no rebuild/test/GPU change in this recovery.')
d['restart_next'].insert(0,'Implement true multi-emitter Annie_Q_mis consumer using recovered fields/skin keywords, native neck launch attachment and target-height augmentation. Qualify actual callback-controlled impact/after effects:HaveHitEffect/HaveAfterEffect0 despite names. Resolve Base/Shared Annie_Fire_Glow precedence and missing Goth texture; preserve62rawunknowns. Sources in docs/annie_spell_vfx_sources.json and docs/annie_q_vfx_binding_contract.json.')
save('docs/resume_checkpoint.json',d)
shutil.copyfile(Path(__file__),r/'tools/record_annie_spell_vfx.py')
print(json.dumps(summary));print('Validated source/contract/PNG hashes and recorded actual Q binding; no runtime completion claimed.')
