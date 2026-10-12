"""Stage only the additional initial PE data needed by resource-manager ports."""
from pathlib import Path
import hashlib,json,re,shutil,subprocess,sys
R=Path('E:/OpenLeague');S=Path(__file__).resolve().parent;P=S/'production'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
previous=json.loads((R/'docs/loading_standard_validation.json').read_text(encoding='utf-8'))
assert previous['passed'] and not previous['complete']
for rel in ['tools/extract_replay_runtime_image.py','crates/core/src/audio_replay_runtime_image.rs','data/4.20/runtime/replay_runtime_image.bin']:
 assert sha(R/rel)==previous['source_and_resource_hashes'][rel],rel
additions=[
 ('loading_resource_hash_globals',1,0x2d6edf0,16),
 ('loading_resource_static_initializer_table',1,0xfa6b74,16),
 ('loading_resource_manager_vtable',1,0x10d6450,8),
 ('loading_resource_configuration_literal',1,0x10d666c,16),
 ('loading_resource_shared_literal',1,0x10bf2d4,9),
 ('loading_resource_forwarding_literal',1,0x10d6880,13),
 ('loading_resource_interface_literal',1,0x10d6b34,12),
 ('loading_resource_configuration_hash_slot',1,0x10d640c,4),
 ('loading_resource_interface_hash_slot',1,0x10d6320,4),
 ('loading_resource_shared_hash_slot',1,0x10d62ec,4),
 ('loading_resource_forwarding_hash_slot',1,0x10d6354,4),
]
extractor=(R/'tools/extract_replay_runtime_image.py').read_text(encoding='utf-8')
old="stage=Path('E:/mapslol3v3/loading_standard_integration')"
assert extractor.count(old)==1
extractor=extractor.replace(old,"stage=Path('E:/mapslol3v3/loading_resource_manager_integration')")
point='\n]\noutput=';assert extractor.count(point)==1
rows=''.join(f" ('{name}',{group},{address:#x},{size}),\n" for name,group,address,size in additions)
extractor=extractor.replace(point,'\n'+rows+']\noutput=')
target=P/'tools/extract_replay_runtime_image.py';target.parent.mkdir(parents=True,exist_ok=True);target.write_text(extractor,encoding='utf-8')
subprocess.run([sys.executable,'-B',str(target)],check=True)
for name in ['replay_runtime_image.bin','replay_runtime_image_manifest.json']:
 target=P/'data/4.20/runtime'/name;target.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(S/name,target)
manifest=json.loads((S/'replay_runtime_image_manifest.json').read_text(encoding='utf-8'))
old_manifest=json.loads((R/'data/4.20/runtime/replay_runtime_image_manifest.json').read_text(encoding='utf-8'))
assert manifest['regions'][:62]==old_manifest['regions']
assert len(manifest['regions'])==73 and manifest['package_bytes']==21110
rust=(R/'crates/core/src/audio_replay_runtime_image.rs').read_text(encoding='utf-8')
pattern=r'const REGIONS: \[\(u32, u32, u32\); 62\] = \[(.*?)\];'
match=re.search(pattern,rust,re.S);assert match
rows=''.join(f'    ({group}, {address:#x}, {size}),\n' for _,group,address,size in additions)
rust=rust[:match.start()]+match.group(0).replace('; 62]', '; 73]').replace('\n];','\n'+rows+'];')+rust[match.end():]
target=P/'crates/core/src/audio_replay_runtime_image.rs';target.parent.mkdir(parents=True,exist_ok=True);target.write_text(rust,encoding='utf-8')
audit=(S.parent/'loading_standard_integration/independent_image_verification.py').read_text(encoding='utf-8')
audit=audit.replace("'a23f6215d9a876ee38115a3350b7330c9af795da09645dcc8c3e541f715c9c97'",repr(manifest['package_sha256']))
audit=audit.replace('== 20872 ==','== 21110 ==').replace('== 62 ==','== 73 ==')
point='globals_spec = [\n';assert audit.count(point)==1
audit=audit.replace(point,point+''.join(f"    ('{name}', {address:#x}, {size}, {group}),\n" for name,group,address,size in additions))
(S/'independent_image_verification.py').write_text(audit,encoding='utf-8')
subprocess.run([sys.executable,'-B',str(S/'independent_image_verification.py')],check=True)
print(json.dumps({'image_staged_only':True,'added_regions':len(additions),'previous_receipt_sha256':sha(R/'docs/loading_standard_validation.json')}))
