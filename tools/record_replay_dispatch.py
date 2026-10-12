from pathlib import Path
import hashlib,json,re,datetime,shutil
r=Path('E:/OpenLeague');s=Path('E:/mapslol3v3')
def load(p):return json.loads(p.read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def write(p,value):
 t=p.with_suffix(p.suffix+'.tmp');t.write_text(json.dumps(value,indent=2,ensure_ascii=False)+'\n',encoding='utf-8');load(t);t.replace(p)
isolated=r/'logs/replay-dispatch-tests.log';core=r/'logs/core-replay-dispatch-tests.log'
assert '130 passed; 0 failed' in isolated.read_text(encoding='utf-8-sig')
assert '686 passed; 0 failed; 0 ignored; 0 measured; 480 filtered out' in core.read_text(encoding='utf-8-sig')
exe=r/re.search(r'Running unittests .*?\(([^)]+\.exe)\)',core.read_text(encoding='utf-8-sig'))[1].replace('\\','/')
contracts=['replay_dispatch_contract.json','replay_shared_pair_contract.json']
for name in contracts:assert sha(s/name)==sha(r/'data/4.20'/name)
events=load(r/'data/4.20'/contracts[0]);shared=load(r/'data/4.20'/contracts[1]);probe=load(s/'replay_object_commands_probe.json')
assert events['passed'] and len(events['cases'])==445 and len(events['invocations'])==36
assert shared['passed'] and len(shared['cases'])==288 and len(shared['accessors'])==72
assert probe['passed'] and len(probe['steps'])==14
assert events['native_sha256']==shared['native_sha256']==probe['native_sha256']=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
shutil.copy2(s/'probe_replay_object_commands.py',r/'tools/probe_replay_object_commands.py')
shutil.copy2(s/'replay_object_commands_probe.json',r/'data/4.20/replay_object_commands_probe.json')
plan=load(r/'docs/completion_plan.json');scope={'domains':len(plan['domains']),'tasks':sum(len(d['tasks']) for d in plan['domains']),'additional_requirements':sum(len(d['additional_requirements']) for d in plan['domains'])};assert scope=={'domains':24,'tasks':114,'additional_requirements':37}
next_action='Implement native replay object manager8F8810/8F88A0 and dual-tree8F89D0 insertion,8F8B30 removal,8F8CF0 lookup, then complete72C780 command routing with real owned shared pairs and integrate replay frame producers/consumers. New core734130 invocation,729370 dispatcher,729D70 metadata transfer,5CC070/5BD3C0 pair lifetime and729CF0/738AC0 acquisition match native fixtures; terminal consumer methods remain explicit boundaries and are not yet connected to client simulation. Native14-command probe now runs actual trees and packet-object methods5740D0/8FD680/8FD690: duplicate64-bit values can leave separate ID entries without matching reverse entries; a zero-valued existing ID is retried on add but insertion does not replace it, and72C780 removes only when lookup64!=0. Preserve these observed quirks, real ownership and metadata setter callbacks. Continue stream type/configuration qualification, graceful graphical AppExit, actor listeners, maps/champions/audio and all24domains114tasks37requirements.'
now=datetime.datetime.now(datetime.timezone.utc)
sources=['crates/core/src/audio_replay_events.rs','crates/core/src/audio_replay_events_tests.rs','crates/core/src/audio_replay_shared_pair.rs','crates/core/src/audio_replay_shared_pair_tests.rs','crates/core/src/audio_announcer_owner_control.rs','crates/core/src/lib.rs','tools/qualify_replay_dispatch.py','tools/qualify_replay_shared_pair.py','tools/probe_replay_object_commands.py','tools/replay-dispatch-tests.rs']
receipt={'saved_utc':now.isoformat(),'passed':True,'complete':False,'scope':scope,'native_dispatch_cases':445,'native_member_invocations':36,'native_shared_pair_lifetimes':288,'native_shared_manager_acquisitions':72,'native_object_command_probe_steps':14,'isolated_tests_passed':130,'core_audio_tests_passed':686,'core_tests_filtered_not_run':480,'core_test_executable':str(exe),'core_test_executable_sha256':sha(exe),'isolated_test_executable_sha256':sha(r/'tools/replay-dispatch-tests.exe'),'native_source_sha256':events['native_sha256'],'source_hashes':{n:sha(r/n) for n in sources},'contract_hashes':{name:sha(r/'data/4.20'/name) for name in contracts+['replay_object_commands_probe.json']},'log_hashes':{str(p.relative_to(r)):sha(p) for p in [isolated,core,r/'logs/replay-dispatch-build.log']},'behavior':[
 'Core734130 preserves the referenced first argument, wrapping32-bit owner adjustment and full target return. Core729370 routes low-byte selectors, optional versus required callbacks, unaligned packet fields,16-bit values, exact boolean comparison, raw byte strings and metadata updates. Native729D70 getter/setter order, overwrite return byte, callback-mutated loop bounds and both copied arrays match original execution.',
 'New shared pair5CC070 retains the source control before releasing destination, including self-copy and callback-mutated source storage. Native5BD3C0 destruction leaves pair bytes unchanged;729CF0/738AC0 write fresh output pairs and acquire strong ownership. Atomic increment is now implemented with the same sequential consistency as existing decrements;8-thread balanced acquisition test passes.',
 'Native14-step object-command probe executes complete72C780 create/remove routing through actual8F8810 trees,8F89D0 insertion,8F8CF0 lookup,8F8B30 removal and8F88A0 destruction. This is new source-behavior evidence for the remaining Rust implementation, not a Rust/runtime completion claim.'
 ],'limits':[
 'Terminal replay virtual consumers are supplied recording boundaries. Tests compare actual native dispatcher and shared-pair bodies against Rust; they do not prove real world-event handling or live replay streaming. The Rust member-call test boundary only dispatches the qualified72C780 pass-through path, not object commands.',
 'String argument bytes are owned temporary values at the Rust consumer boundary; native string allocator identity, exception/unwind and invalid native-pointer behavior are not replicated. Storage errors are explicit. Native control-dispose/release callbacks in pair fixtures retain bytes and can mutate source pair; real control-specific destruction remains separately qualified.',
 'The native object-manager probe uses explicit caller-owned nested/held-control storage and single-thread Win32 lock boundaries; stream creation and real manager ownership are not shown. Native duplicate-value and zero-value quirks remain to be ported with both indices and lifecycle.',
 '686 core tests are current;480 other core tests were filtered and not rerun.130 isolated tests include existing configuration/service regressions. Normal client executable was not rebuilt or visually retested in this milestone, and new event consumers are not connected to it. No champion, domain or whole game is completed.'
 ],'next_action':next_action}
backup=r/'docs/plan_history'/('replay-dispatch-'+now.strftime('%Y%m%dT%H%M%SZ'));backup.mkdir(parents=True)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json','completion_plan.html']:shutil.copy2(r/'docs'/name,backup/name)
write(r/'docs/replay_dispatch_validation.json',receipt)
for name in ['coverage.json','resume_checkpoint.json','completion_plan.json']:
 p=r/'docs'/name;d=load(p);d['replay_dispatch_validation']=receipt;d['updated_utc']=now.isoformat();d['next_action']=next_action;write(p,d);assert load(p)['replay_dispatch_validation']==receipt
p=r/'docs/completion_plan.html';html=p.read_text(encoding='utf-8');marker='replay-dispatch-validation';assert '</body>' in html and 'id="'+marker+'"' not in html
section='<section id="'+marker+'"><h2>Replay : routage et r\u00e9f\u00e9rences partag\u00e9es</h2><p>Routage des \u00e9v\u00e9nements, transfert des m\u00e9tadonn\u00e9es et copies/destructions des r\u00e9f\u00e9rences compar\u00e9s au client original : 445 routages, 36 appels, 288 cycles de r\u00e9f\u00e9rences et 72 acquisitions. 130 tests isol\u00e9s et 686 tests moteur r\u00e9ussis. Un parcours natif de 14 commandes pr\u00e9cise les doublons et valeurs nulles du gestionnaire d\u2019objets, dont le port Rust reste \u00e0 faire. Les producteurs et consommateurs de replay restent \u00e0 connecter au client.</p></section>'
t=p.with_suffix('.html.tmp');t.write_text(html.replace('</body>',section+'</body>'),encoding='utf-8');t.replace(p)
shutil.copy2(s/'record_replay_dispatch.py',r/'tools/record_replay_dispatch.py')
for name,digest in receipt['source_hashes'].items():assert sha(r/name)==digest,name
print(json.dumps({'passed':True,'isolated_tests':130,'core_tests':686,'native_dispatches':445,'native_shared_lifetimes':288,'scope':scope}))
