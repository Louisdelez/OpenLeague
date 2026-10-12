from pathlib import Path
from datetime import datetime, timezone
import json, hashlib, shutil, re
r = Path('E:/OpenLeague')
now = datetime.now(timezone.utc).isoformat()
receipt = 'docs/native_simple_recycled_terrain_progress.json'
log = 'logs/native-simple-recycled-terrain-core-tests.log'
def load(p): return json.loads((r/p).read_text(encoding='utf-8-sig'))
def save(p, d): (r/p).write_text(json.dumps(d, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
def sha(p): return hashlib.sha256((r/p).read_bytes()).hexdigest()
assert 'test result: ok. 571 passed; 0 failed;' in (r/log).read_text(encoding='utf-8-sig')
p = load('data/4.20/simple_recycled_terrain_contract.json')
assert p['passed'] and len(p['cases']) == 288 and p['emulator_cpu_case_disagreements'] == 0
assert len(p['adapters']) == 1 and p['actual_cpu_sse_operations'] == 1344
files = ['crates/core/src/'+n+'.rs' for n in ['native_simple_birth_insert', 'native_simple_terrain_follow', 'native_simple_storage', 'native_simple_particle_update', 'lib']]
files += ['data/4.20/simple_recycled_terrain_contract.json', 'tools/probe_native_simple_recycled_terrain.py', 'docs/native_simple_normal_frame_storage_progress.json', log]
files.append(str(max((r/'target/debug/deps').glob('openleague_core-*.exe'), key=lambda f:f.stat().st_mtime).relative_to(r)).replace('\\','/'))
next_action = 'Raccorder acquisition du stockage et tables natives à l’émission941F00 ; qualifier backend mémoire et libération du pool, échantillonnage et attributs/rotations dynamiques ; qualifier le modificateur de pose93BBD0, les producteurs système et le fournisseur terrain ; intégrer au cycle93F2F0, puis au rendu/audio Map10 et à la projection d’Annie ; reconstruire les applications et poursuivre les24domaines.'
evidence = dict(core_tests_passed=571, simple_recycled_terrain_native_cases=288, simple_recycled_terrain_composition_qualified=True, real_terrain_height_provider_qualified=False, latest_native_execution_progress=receipt, latest_core_test_log=log)
save(receipt, dict(updated_utc=now, complete=False, **evidence, native_sha256=p['native_sha256'], adapters=p['adapters'], artifacts_sha256={f:sha(f) for f in files}, findings=['Native reset retains height98 independently of cleared particle arrays. Appended births append to the end of that retained array; terrain following reads the active prefix and preserves its suffix.', 'Rust insertion and terrain-follow validation now support retained extra heights; the composed reset/birth/follow matches288 native CPU cases, including empty/nonempty previous storage, retained length0/1/4/8,1/2/4 births, terrain and lock flags and bind windows.1344 hardware scalar SSE operations, zero VM/CPU differences.'], limits=p['limits']+['Controlled terrain provider only. Missing logical height slot reuse, native capacity growth, allocator and release are not qualified.','Ordinary executable integration, rendered and audio acceptance remain pending; no complete champion, task or domain claimed.']))
history = r/'docs/plan_history'/('simple-recycled-terrain-'+datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%SZ'))
history.mkdir(parents=True, exist_ok=True)
for name in ['coverage.json', 'completion_plan.json', 'resume_checkpoint.json', 'goal_plan_revision.json']:
    shutil.copy2(r/'docs'/name, history/name)
    d = load('docs/'+name)
    d.update(updated_utc=now, native_simple_recycled_terrain_progress=receipt)
    if name == 'goal_plan_revision.json': d.update(core_tests_passed=571, core_source_tests_passed=571, latest_native_execution_progress=receipt, next_steps=[next_action])
    else:
        d['complete'] = False
        e = d['last_verified'] if name == 'resume_checkpoint.json' else d['current_evidence']
        e.update(evidence)
        if name == 'resume_checkpoint.json':
            e['core_tests'] = 571
            d.update(saved_utc=now, next_projected_action=next_action)
        if name == 'completion_plan.json':
            d['next_execution_steps'] = [next_action]+d.get('next_execution_steps', [])[1:]
            for domain in d['domains']:
                if domain['id'] in ['03','10','15']: domain.setdefault('progress_evidence', []).append(receipt)
    save('docs/'+name, d)
for path in [r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt', r/'docs/GOAL-OPENLEAGUE-ACTUALISE.txt', Path('E:/mapslol3v3/GOAL-OPENLEAGUE-NOUVEAU.txt'), Path('E:/mapslol3v3/GOAL-OPENLEAGUE-MIS-A-JOUR.txt')]:
    text = path.read_text(encoding='utf-8').replace('570 tests moteur', '571 tests moteur')
    text = re.sub(r'PROCHAINE ÉTAPE :.*?(?=\n\nCLÔTURE)', 'PROCHAINE ÉTAPE : '+next_action, text, flags=re.S)
    path.write_text(text, encoding='utf-8')
d=load('docs/completion_plan.json'); d['goal_objective_proposed']=(r/'docs/GOAL-OPENLEAGUE-NOUVEAU.txt').read_text(encoding='utf-8'); save('docs/completion_plan.json',d)
d=load('docs/goal_plan_revision.json'); d['objective_sha256']=sha('docs/GOAL-OPENLEAGUE-NOUVEAU.txt'); save('docs/goal_plan_revision.json',d)
path=r/'docs/completion_plan.html'; shutil.copy2(path,history/path.name)
text=path.read_text(encoding='utf-8').replace('</body>', '<section><h2>Terrain après recyclage des particules</h2><p>Correction de la conservation des hauteurs : naissance en fin du tableau retenu, suivi sur son préfixe actif.288cas natifs qualifiés avec fournisseur terrain contrôlé ;571tests moteur passent. Fournisseur terrain réel, backend mémoire et intégration au rendu/audio restent à qualifier.</p><a href="native_simple_recycled_terrain_progress.json">Preuves et limites</a></section></body>')
path.write_text(text,encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(receipt=receipt, core_tests=571, native_cases=288, complete=False)))
