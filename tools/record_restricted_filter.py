from pathlib import Path
import json,datetime,hashlib,shutil,html
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'))
save=lambda p,d:(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
assert '120 passed; 0 failed' in (r/'logs/native-restricted-filter-tests.log').read_text(encoding='utf-8-sig')
assert 'Finished `dev`' in (r/'logs/native-restricted-filter-build.log').read_text(encoding='utf-8-sig')
proof=load('data/4.20/fow_restricted_filter_contract.json');assert proof['passed'] and len(proof['cases'])==3456
receipt=dict(updated_utc=now,complete=False,client_tests_passed=120,client_build_passed=True,native_restricted_filter_frames=3456,native_addresses=proof['native_addresses'],live_fow_gpu_bound=False,current_client_graphical_rerun=False,
 findings=['Original6B3FA0 executes3456frames crossing player+5E8 bit11, matching/nonmatching descriptor+34 identifiers, three source/actor teams, missing registration/missing actor/present actor, flagsAD/118/24/2C and applied/unapplied masks.','With the player restriction enabled, local sources without a registered actor or whose descriptor+34 differs from player descriptor+34 withdraw their applied masks and skip scheduling. Existing actor eligibility still applies. Unmatched source teams preserve their masks through the earlier non-spectator skip.','Rust PlayerViewActor/CircleView.select_player_source keeps descriptor identity separate from first source identity and native owner handles. Comparisons verify pending queue/priorities, generation order, counts and applied/pending states before/after processing;120client tests and build passed.'],
 limits=proof['limits']+['Player bit11, descriptor identities and cache flag2D7C070 supplied with matching initial state; mode/cache transitions and native refresh counter initialization/decrement are not qualified here.','Only non-spectator local player with tag100 is covered. Spectator/player-present combination, tag/descriptor mutation producers and complete view construction remain unqualified.','Mask generation adapted in these3456frames. Prior full Map10 generator qualification remains separate. No ordinary source activation, server/GPU fog binding or current graphical rerun.'],
 next_actions=['Qualify native selection/restriction transitions and refresh counter reset20/decrement per view update; complete view initialization/subscriptions.','Qualify actor/registry/descriptor producers and connect native source lifecycle to ordinary entities.','Integrate qualified masks into authoritative visibility and GPU rendering; verify current restored Map10 gameplay.'],
 files_sha256={p:sha(p) for p in ['data/4.20/fow_restricted_filter_contract.json','tools/probe_fow_restricted_filter.py','tools/probe_fow_restricted_filter_generated.py','crates/client/src/fow_player_filter.rs','logs/native-restricted-filter-tests.log','logs/native-restricted-filter-build.log','target/debug/openleague-client.exe']})
save('docs/native_restricted_filter_progress.json',receipt)
b=r/'docs/plan_history'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');b.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p='docs/'+name;shutil.copy2(r/p,b/name);d=load(p);d['updated_utc']=now;d['complete']=False;d['native_restricted_filter_progress']=receipt
 if name=='resume_checkpoint.json':d['saved_utc']=now;d['last_verified']['client_tests']=120;d['next_projected_action']=' '.join(receipt['next_actions'])
 else:d['current_evidence'].update(client_tests_passed=120,current_test_receipt='docs/native_restricted_filter_progress.json',current_build_receipt='docs/native_restricted_filter_progress.json',current_client_sha256=sha('target/debug/openleague-client.exe'),projected_current_binary_vulkan_verified=False)
 if name=='completion_plan.json':d['next_execution_steps']=receipt['next_actions']
 save(p,d)
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8').replace('</body>','<section><h2>Vision — filtre des vues restreintes</h2><p>120 tests client et compilation réussis.3456cycles natifs avec bit11 du joueur et comparaison des descripteurs. Transitions/cache, construction des vues et activation réelle restent ouverts.</p><a href="native_restricted_filter_progress.json">Preuves et limites</a></section></body>');p.write_text(s,encoding='utf-8')
p=r/'docs/goal_objective_current_request.txt';s=p.read_text(encoding='utf-8').replace('119 tests réussis','120 tests réussis').replace('qualifier les transitions spectateur, les vues restreintes et la création des vues','qualifier les transitions de sélection/restriction, le compteur de rafraîchissement et la création des vues')
p.write_text(s,encoding='utf-8');(r/'docs/goal_objective_current_request.html').write_text('<!doctype html><html lang="fr"><meta charset="utf-8"><title>OpenLeague — Goal actualisé</title><style>body{max-width:1000px;margin:40px auto;padding:20px;font:16px/1.6 system-ui;white-space:pre-wrap}</style><body>'+html.escape(s)+'</body></html>',encoding='utf-8')
shutil.copy2('E:/mapslol3v3/record_restricted_filter.py',r/'tools/record_restricted_filter.py')
print(json.dumps(dict(client_tests=120,native_frames=3456,complete=False)))
