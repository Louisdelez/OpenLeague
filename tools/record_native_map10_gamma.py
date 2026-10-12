from pathlib import Path
import json,hashlib,datetime,shutil
r=Path('E:/OpenLeague');stage=Path('E:/mapslol3v3');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def save(p,d):(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=load('data/4.20/native_map10_gamma_contract.json');assert p['passed'] and len(p['lut'])==256 and len(p['selector_cases'])==8
binary=hashlib.sha256((r/'target/debug/openleague-client.exe').read_bytes()).hexdigest()
assert binary=='f5ad2c93edcf6bb7a88f861dbb680d9dedbb8f70e6085ac563956f811eb04a5d'
receipt=dict(updated_utc=now,complete=False,product_changed=False,application_binary_unchanged=True,application_binary_sha256=binary,
 contract='data/4.20/native_map10_gamma_contract.json',gamma_parameters=p['parameters'],native_lut_samples=256,native_argb_samples=256,native_selector_cases=8,
 native_pow_executed=True,client_tests_last_passed=238,chaos_base_defect_fixed=False,
 findings=['Original Gamma.inibin loads Level1.1, Gamma0.9, Brightness1.05, Contrast1.12; values stored with native f32 rounding.',
 'Original table uses i/256, original CRT pow, then contrast/brightness/level and clamping. Upload truncates to255-scale and writes FFgggggg.',
 'Entered selector chooses gamma for enabled byte or nonempty queue; original table/upload refresh only when revision differs. Final draw calls observed through adapters.'],
 limits=p['limits'])
action='Intégrer la passe gamma Map10 dans le moteur après qualification du transfert, des états de sampler et de son ordre par rapport au HUD. Table native256valeurs et conversion ARGB qualifiées ; huit branches de sélection/rafraîchissement vérifiées. Producteur du réglage GammaEnabled et composition entière restent ouverts. Vérifier ensuite une capture Vulkan du nouvel exécutable ; défaut cyan Chaos toujours ouvert. Puis effets de fin de partie, réseau/launcher et partie ordinaire à six clients graphiques, avant les autres domaines.'
receipt['next_action']=action;save('docs/native_map10_gamma_progress.json',receipt)
archive=r/'docs/plan_history'/('native-map10-gamma-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));archive.mkdir(parents=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 path='docs/'+name;shutil.copy2(r/path,archive/name);d=load(path);d.update(updated_utc=now,complete=False,native_map10_gamma_progress=receipt)
 if name=='resume_checkpoint.json':
  d.update(saved_utc=now,next_projected_action=action,pending_native_jobs=[])
  d['last_verified'].update(native_gamma_table_samples=256,native_gamma_argb_samples=256,native_gamma_selector_cases=8)
 else:d['current_evidence'].update(native_gamma_table_samples=256,native_gamma_argb_samples=256,native_gamma_selector_cases=8,native_gamma_runtime_integrated=False)
 if name=='completion_plan.json':d['next_execution_steps']=[action]+d.get('next_execution_steps',[])[1:]
 save(path,d)
for name in ['qualify_native_map10_gamma.py','inspect_gamma_contract.py','record_native_map10_gamma.py']:shutil.copy2(stage/name,r/'tools'/name)
path=r/'docs/completion_plan.html';s=path.read_text(encoding='utf-8');s=s.replace('</body>','<section><h2>Gamma natif Map10 vérifié</h2><p>256valeurs calculées par le code original, 256pixels ARGB et 8branches de sélection/rafraîchissement vérifiés. Passe Rust/GPU à intégrer après qualification du sampler et de son ordre. Zones cyan Chaos toujours ouvertes.</p><a href="native_map10_gamma_progress.json">Preuves et limites</a></section></body>');path.write_text(s,encoding='utf-8')
print(json.dumps(dict(samples=256,argb_samples=256,selector_cases=8,product_changed=False,complete=False)))
