from pathlib import Path
import datetime, hashlib, json, shutil
r = Path('E:/OpenLeague')
now = datetime.datetime.now(datetime.timezone.utc).isoformat()
def load(f): return json.loads((r/f).read_text(encoding='utf-8-sig'))
def save(f, value): (r/f).write_text(json.dumps(value, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
def sha(f): return hashlib.sha256((r/f).read_bytes()).hexdigest()
c = load('docs/projected_core_cycle_capture_v3.json')
assert c['client_sha256'] == sha('target/debug/openleague-client.exe')
assert c['fixture_sha256'] == sha('target/debug/examples/annie_ready_fixture.exe')
assert len(c['measurements']) == 2
for n, m in enumerate(c['measurements'], 1):
    assert m['spawned'] == n and m['cleaned'] == n
    assert m['active_effects'] == m['active_draws'] == 0
    assert len(m['capture_frames']) == n and m['max_visible_draws'] > 0
    for frame in m['capture_frames']:
        assert frame['active_count'] == 1 and frame['vertices'] > 0
for cap in c['captures']: assert sha(cap['path']) == cap['sha256']
assert 'Finished `dev`' in (r/'logs/native-projected-per-cast-single-request-build.log').read_text(encoding='utf-8-sig')
receipt = 'docs/native_projected_core_runtime_v3_progress.json'
files = ['target/debug/openleague-client.exe', 'target/debug/examples/annie_ready_fixture.exe',
         'crates/client/src/native_projected_cycle.rs', 'crates/client/src/projected_live.rs',
         'crates/client/src/simple_projected_config.rs', 'logs/native-projected-per-cast-single-request-build.log',
         'docs/projected_core_cycle_capture_v3.json', 'tools/capture_projected_core_cycle_v3.py']
files += [x['path'] for x in c['captures']]
e = dict(current_client_sha256=c['client_sha256'], annie_projection_core_frame_current_runtime_executed=True,
         annie_projection_core_frame_repeat_cleanup_checks=2, annie_projection_per_cast_captures=2,
         annie_projection_current_graphical_binary_qualified=False, annie_projection_pixel_attribution_qualified=False,
         latest_projected_runtime_progress=receipt)
save(receipt, dict(updated_utc=now, complete=False, **e, artifacts_sha256={f:sha(f) for f in files},
    visual_inspection=dict(inspected=True, findings='Baseline, both cast images and off inspected. Second cast has a broad subtle orange ground glow consistent with projection. First cast is less clear. Off still contains separate red Fire/Fire_Head effects. Different simulation times and coexisting particles prevent strict pixel attribution; no original-framebuffer fidelity acceptance.'),
    capture_frames=c['measurements'][-1]['capture_frames'], limits=c['limits']))
next_action = 'Isoler la contribution GPU de la projection normale sans modifier son rendu ; qualifier les fournisseurs natifs, puis poursuivre le rendu/audio et les 24 domaines.'
h = r/'docs/plan_history'/('projected-capture-v3-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ'))
h.mkdir(parents=True, exist_ok=True)
for name in ['coverage.json', 'completion_plan.json', 'resume_checkpoint.json', 'goal_plan_revision.json']:
    shutil.copy2(r/'docs'/name, h/name)
    d = load('docs/'+name)
    d.update(updated_utc=now, native_projected_core_runtime_v3_progress=receipt)
    if name == 'goal_plan_revision.json':
        d.update(latest_projected_runtime_progress=receipt, next_steps=[next_action], client_source_tests_passed=366)
    else:
        target = d['last_verified'] if name == 'resume_checkpoint.json' else d['current_evidence']
        target.update(e)
        if name == 'resume_checkpoint.json':
            d.pop('pending_projected_per_cast', None)
            d.update(saved_utc=now, next_projected_action=next_action)
        if name == 'completion_plan.json': d['next_execution_steps'] = [next_action]+d['next_execution_steps'][1:]
    save('docs/'+name, d)
p = load('docs/projected_per_cast_pending.json')
p.pop('session_id', None)
p.update(updated_utc=now, status='build_and_two_cast_capture_passed', runtime_progress=receipt, next_action=next_action)
save('docs/projected_per_cast_pending.json', p)
html = r/'docs/completion_plan.html'
shutil.copy2(html, h/html.name)
html.write_text(html.read_text(encoding='utf-8').replace('</body>', '<section><h2>Projection Annie — captures par lancement</h2><p>Deux lancements capturés sur le client reconstruit, avec création et libération des ressources à chaque lancement. Une lueur au sol est visible sur la seconde capture ; son attribution précise reste à vérifier. Aucun domaine ni kit supplémentaire clôturé.</p><p><a href="native_projected_core_runtime_v3_progress.json">Preuves et limites actuelles</a></p></section></body>'), encoding='utf-8')
shutil.copy2(Path(__file__), r/'tools'/Path(__file__).name)
print(json.dumps(dict(receipt=receipt, captures=2, cleanup_checks=2, complete=False)))
