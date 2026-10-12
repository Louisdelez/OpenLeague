from pathlib import Path
import json,datetime,hashlib,shutil,re
r=Path('E:/OpenLeague');stage=Path('E:/mapslol3v3');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
def load(p):return json.loads((r/p).read_text(encoding='utf-8-sig'))
def save(p,d):(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
proof=load('data/4.20/native_environment_fog_profile_contract.json');assert proof['passed'] and proof['case_count']==1408
log=(r/'logs/native-fog-profile-full-client-tests.log').read_text(encoding='utf-8');assert '241 passed; 0 failed' in log
test_path=re.search(r'Running unittests[^\n]*\((target[^\r\n)]+\.exe)\)',log);assert test_path
test_exe=r/test_path.group(1).replace('\\','/');assert test_exe.exists()
binary=hashlib.sha256((r/'target/debug/openleague-client.exe').read_bytes()).hexdigest();assert binary=='37de22a9aac32ce4c77ffdee498fc6019e4169ebd1dfebaa7074b556ccbb1f32'
action='Relier native_fog_profile au rendu : brouillard simple Fog1/couleur native et absence de nuages pour niveaux<=1, brouillard deux couches Fog2/Cloud2 pour niveaux>=2. Qualifier ensuite identité/récupération de l’option835080 et menu, rafraîchissement des variantes et exclusions FULLBRIGHT/NOLIGHTING. Les1408cas du suffixe natif et les241tests des sources passent ; executable de jeu inchangé. Puis référence/rendu Chaos, cérémonie/audio/sbires, reconnexion, résultats/launcher, partie ordinaire à six clients graphiques et les24domaines.'
artifacts=['data/4.20/native_environment_fog_profile_contract.json','crates/client/src/native_fog_profile.rs','logs/native-fog-profile-client-tests.log','logs/native-fog-profile-full-client-tests.log']
receipt=dict(updated_utc=now,complete=False,native_profile_cases=1408,client_source_tests_passed=241,
 native_profile_ported_to_rust=True,runtime_options_bound=False,product_source_changed=True,
 application_binary_unchanged=True,application_binary_sha256=binary,test_executable=str(test_exe),test_executable_sha256=hashlib.sha256(test_exe.read_bytes()).hexdigest(),
 artifacts=artifacts,hashes={p:hashlib.sha256((r/p).read_bytes()).hexdigest() for p in artifacts},limits=proof['limits'],next_action=action)
save('docs/native_fog_profile_progress.json',receipt)
archive=r/'docs/plan_history'/('native-fog-profile-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));archive.mkdir(parents=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p='docs/'+name;shutil.copy2(r/p,archive/name);d=load(p);d.update(updated_utc=now,complete=False,native_fog_profile_progress=receipt)
 if name=='resume_checkpoint.json':
  d.update(saved_utc=now,next_projected_action=action,pending_native_jobs=[]);d['last_verified'].update(client_tests=241,native_fog_profile_cases=1408,client_tests_current_binary=False)
 else:d['current_evidence'].update(client_tests=241,native_fog_profile_cases=1408,client_tests_current_binary=False)
 if name=='completion_plan.json':d['next_execution_steps']=[action]+d.get('next_execution_steps',[])[1:]
 save(p,d)
for name in ['inspect_fog_quality_producer.py','qualify_native_environment_fog_profile.py','record_native_fog_profile.py']:shutil.copy2(stage/name,r/'tools'/name)
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');s=s.replace('</body>','<section><h2>Profil natif du brouillard porté en Rust</h2><p>1 408 cas : niveaux 0/1 → Fog1 sans nuages ; niveaux ≥2 → Fog2 avec nuages. Révision et notifications vérifiées. Port Rust et 241 tests des sources passent. Module encore à relier aux shaders et options ; exécutable de jeu inchangé.</p><a href="native_fog_profile_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
print(json.dumps(dict(native_cases=1408,client_source_tests=241,runtime_options_bound=False,binary_unchanged=True,complete=False)))
