"""Prepare the root-owned adapters without modifying production."""
from pathlib import Path
import hashlib,json
R=Path('E:/OpenLeague');S=Path(__file__).resolve().parent;P=S/'production'
previous=json.loads((R/'docs/loading_standard_validation.json').read_text(encoding='utf-8'))
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def save(rel,text):
 p=P/rel;p.parent.mkdir(parents=True,exist_ok=True);p.write_text(text,encoding='utf-8')
rel='crates/core/src/audio_replay_windows_transport.rs'
assert sha(R/rel)==previous['source_and_resource_hashes'][rel]
text=(R/rel).read_text(encoding='utf-8')
edits=[
 ('mod loading_retirement;','mod loading_retirement;\n#[path = "audio_replay_windows_resource_manager.rs"]\nmod resource_manager;'),
 ('    loading_retirements: Mutex<loading_retirement::Ledger<N>>,','    loading_retirements: Mutex<loading_retirement::Ledger<N>>,\n    resource_manager: Mutex<resource_manager::State<N>>,'),
 ('                loading_retirements: Mutex::new(loading_retirement::Ledger::default()),','                loading_retirements: Mutex::new(loading_retirement::Ledger::default()),\n                resource_manager: Mutex::new(resource_manager::State::default()),'),
 ('        self.close_configuration_owned(&mut b)?;','        self.close_configuration_owned(&mut b)?;\n        // Resource lookup temporaries and replay consumers are already drained.\n        self.close_loading_resources_owned(&mut b)?;'),
]
for a,b in edits:
 assert text.count(a)==1,a;text=text.replace(a,b)
save(rel,text)
rel='crates/core/src/lib.rs';assert sha(R/rel)==previous['source_and_resource_hashes'][rel]
text=(R/rel).read_text(encoding='utf-8')
for module in ['audio_loading_resource_manager','audio_loading_resource_cache']:
 assert 'mod '+module not in text;text+='\npub mod '+module+';\n'
save(rel,text)
text=(R/'tools/run_loading_standard_probes.ps1').read_text(encoding='utf-8-sig')
assert 'client-loading-standard-' in text
text=text.replace('client-loading-standard-','client-loading-resource-manager-')
save('tools/run_loading_resource_manager_probes.ps1',text)
print('Root adapters staged; production unchanged')
