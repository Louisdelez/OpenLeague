"""Manifest uncompiled preparation and diff against its captured bases."""
from pathlib import Path
from datetime import datetime, timezone
import hashlib,json,difflib
root=Path(__file__).resolve().parent
sha=lambda b:hashlib.sha256(b).hexdigest()
base=json.loads((root/'base_manifest.json').read_text())
patch=[]
for name,value in base.items():
    original=(root/('base_'+name+'.txt')).read_bytes()
    assert sha(original)==value['sha256']
    current=(root/name).read_bytes()
    patch.extend(difflib.unified_diff(original.decode().splitlines(True),current.decode().splitlines(True),
                                    fromfile='E:/OpenLeague/crates/core/src/'+name,tofile=str(root/name)))
(root/'changes.patch').write_text(''.join(patch),encoding='utf-8')
fixture=json.loads((root/'loading_standard_prefix_probe.json').read_text())
assert len(fixture['cases'])==128 and fixture['passed']
assert fixture['fixture_derivation']['native_cases_unchanged']
original=json.loads(Path(fixture['fixture_derivation']['source']).read_text())
assert original['cases']==fixture['cases']
old_metadata=(root/'base_audio_loading_metadata.rs.txt').read_text()
new_metadata=(root/'audio_loading_metadata.rs').read_text()
old_body=old_metadata.split('fn assign(',1)[1].split('\nfn find(',1)[0].split('{',1)[1]
new_body=new_metadata.split('fn assign_owned_non_alias(',1)[1].split('\nfn find(',1)[0].split('{',1)[1]
assert old_body==new_body, 'Owned string assignment body changed unexpectedly'
assert old_metadata.split('pub fn service_extra(',1)[1]==new_metadata.split('pub fn service_extra(',1)[1]
for c in fixture['cases']:
    assert len([b for b in c['prepared']['blocks'] if b['bytes']==140])==1
    assert len([e for e in c['events'] if e['op']=='prefix_entry'])==1
    if len(bytes.fromhex(c['override_hex']))>=16:
        for address in [0x360002a8,0x360002bc]:
            assert any(e['op']=='read' and e['pointer']==address for e in c['events'])
names=['audio_loading_metadata.rs','audio_loading_screen_packet.rs','audio_loading_screen_packet_tests.rs',
       'audio_replay_windows_loading_packets.rs','audio_replay_windows_loading_packets_tests.rs',
       'audio_loading_standard_prefix.rs','audio_loading_standard_prefix_tests.rs']
files=[]
for path in sorted(root.iterdir()):
    if path.is_file() and path.name!='preparation_manifest.json':
        raw=path.read_bytes();files.append({'path':str(path),'bytes':len(raw),'sha256':sha(raw)})
manifest={'created_utc':datetime.now(timezone.utc).isoformat(),
          'status':'Frozen uncompiled scratch preparation; NOT READY FOR INTEGRATION',
          'integration_ready':False,
          'integration_blocker':'Owned String24 assignment needs a safe ownership strategy for host write failure after partial publication; successful native paths do not qualify rollback',
          'native_sha256':fixture['native_sha256'],'native_fixture_source':fixture['fixture_derivation'],
          'source_cases':128,'rust_test_functions_prepared':2,'rust_test_functions_executed':0,
          'preparation_checks_executed':['128 cases unchanged versus frozen native oracle',
              'Assignable String24 implementation body unchanged', 'service_extra body unchanged',
              'Native fixture contains record-tree seed and override pointer/capacity inputs for every case'],
          'new_native_execution':False,'compiler_run':False,'production_modified':False,
          'candidate_rust_files':names,'base_files':base,
          'required_integration':['First design and qualify safe ownership across partial publication and host write failure, separately from native success parity',
              'Register new module in lib.rs','Install fixture',
              'Map actual source2D78F1C4bytes in extractor/Rust runtime image/binary/manifest as one change',
              'Compile isolated tests first, then relevant generic/Windows integration and source-image verification'],
          'files':files,'limits':['991E60 diagnostic and90AD00 provider remain explicit unsupported boundaries',
              'No resource/texture/UI/factory/runtime success is implied by returned Stop',
              'Native cleanup was separate reentry after abandoning the halted continuation',
              'Owned string reuse remains non-alias/full-assignment only; OOM/SEH/overlap unqualified',
              'Independent static review: existing assign differs in capacity-read versus final length-write order; equivalent states require stable exclusive storage',
              'Existing assign rollback after injected write failure following old-buffer free can leave invalid ownership; not fixed or qualified by this preparation']}
(root/'preparation_manifest.json').write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'manifest':str(root/'preparation_manifest.json'),'sha256':sha((root/'preparation_manifest.json').read_bytes()),
                  'candidate_rust_files':len(names),'native_cases_unchanged':len(fixture['cases']),'compiled':False},indent=2))
