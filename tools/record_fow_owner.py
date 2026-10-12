from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague');now=datetime.datetime.now(datetime.timezone.utc).isoformat()
load=lambda p:json.loads((r/p).read_text(encoding='utf-8-sig'))
save=lambda p,d:(r/p).write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
sha=lambda p:hashlib.sha256((r/p).read_bytes()).hexdigest()
assert '94 passed; 0 failed' in (r/'logs/fow-owner-tests.log').read_text(encoding='utf-8-sig')
assert 'Finished `dev`' in (r/'logs/fow-owner-build.log').read_text(encoding='utf-8-sig')
proof=load('data/4.20/fow_owner_contract.json');composed=load('data/4.20/fow_map10_owned_contract.json');assert len(proof['cases'])==720 and len(composed['cases'])==24
assert composed['terrain']['sha256']==hashlib.sha256(Path(composed['terrain']['source']).read_bytes()).hexdigest()
files=['data/4.20/fow_owner_contract.json','data/4.20/fow_map10_owned_contract.json','crates/client/src/fow_owner.rs','crates/client/src/fow_occluded.rs','crates/client/src/main.rs','tools/probe_fow_owner.py','tools/probe_fow_map10_owned.py','logs/fow-owner-tests.log','logs/fow-owner-build.log','target/debug/openleague-client.exe']
receipt=dict(updated_utc=now,complete=False,client_tests_passed=94,client_build_passed=True,native_owner_modifier_cases=720,native_owned_map10_masks=24,owner_instruction_addresses=proof['original_instruction_addresses'],composed_instruction_addresses=composed['original_instruction_addresses'],live_fow_gpu_bound=False,current_client_graphical_rerun=False,
 findings=['Original source reader6B17E0, handle resolver717D10, native self-getter564F20 and modifier writer617F80 execute without result adapters.720cases over8native vtables match Rust modifier bits.','Valid native owner overrides source defaults with scale1+owner.percent and bias=owner.flat. Absent/stale handle, missing registry slot or mismatched generation preserve source defaults.','Composed original owned generator executed24actual Map10 masks with radius modifiers and stale-generation fallback; Rust owned-circle path computes modifier resolution and source query before generating masks. Rectangles, all mask words, counts and flipped pixels match.'],
 limits=proof['limits']+['The composed24cases supply registry objects and fields, unqualified world extent candidate and terrain constructor prerequisites. Actual game actor identity/field producers, source collections, lifecycle and ordinary rendering remain open.','Rust rejects cached-key mismatch and invalid sentinel explicitly; those native assertion branches are not compared.','All24game domains unfinished; no graphical rerun of the newly compiled client.'],
 next_actions=['Trace actual native constructors/vtable provenance and writers of actor fields+778/+77C; map source owner keys/generations and modifier state to authoritative Rust actors.','Qualify native world extent, source radius/metric providers, terrain inverse/half-cell initialization and live source lifecycle.','Bind counted source visibility and native-timed GPU upload/fade/blur/overlays to ordinary rendering; verify current gameplay.'],files_sha256={p:sha(p) for p in files})
save('docs/projected_fow_owner_progress.json',receipt)
b=r/'docs/plan_history'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');b.mkdir(parents=True,exist_ok=True)
for name in ['coverage.json','completion_plan.json','resume_checkpoint.json']:
 p='docs/'+name;shutil.copy2(r/p,b/name);d=load(p);d['updated_utc']=now;d['complete']=False;d['projected_fow_owner_progress']=receipt
 if name=='resume_checkpoint.json':d['saved_utc']=now;d['last_verified']['client_tests']=94;d['next_projected_action']=' '.join(receipt['next_actions'])
 else:d['current_evidence'].update(client_tests_passed=94,current_build_receipt='docs/projected_fow_owner_progress.json',current_client_sha256=sha('target/debug/openleague-client.exe'),projected_current_binary_vulkan_verified=False)
 if name=='completion_plan.json':d['next_execution_steps']=receipt['next_actions']
 save(p,d)
p=r/'docs/completion_plan.html';s=p.read_text(encoding='utf-8');s=s.replace('</body>','<section><h2>Brouillard — modificateurs des propriétaires</h2><p>94 tests client et compilation réussis.720cas de résolution native du propriétaire et de ses modificateurs comparés octet par octet ;24masques Map10 composés avec propriétaires et générations périmées. Les objets sont fournis au contrôle ; leur raccordement aux acteurs réels, leurs champs et le rendu restent ouverts.</p><a href="projected_fow_owner_progress.json">Preuves et limites actuelles</a></section></body>');p.write_text(s,encoding='utf-8')
shutil.copy2(Path('E:/mapslol3v3/record_fow_owner.py'),r/'tools/record_fow_owner.py')
print(json.dumps(dict(client_tests=94,native_owner_cases=720,native_owned_masks=24,complete=False,live_fow_bound=False)))
