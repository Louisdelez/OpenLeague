from pathlib import Path
import json, hashlib, datetime
from extract_resource import OUT, EXE, raw, digest, read
sha=lambda b:hashlib.sha256(b).hexdigest()
region_count=0
for name in ['source_regions.json','source_dependency_regions.json','source_data_regions.json']:
    report=json.loads((OUT/name).read_text())
    assert report.get('source_sha256')==digest
    for r in report['regions']:
        assert bytes.fromhex(r['hex'])==read(r['address'],r['size'])
        assert sha(bytes.fromhex(r['hex']))==r['sha256']
        assert not r.get('edges'),r['role']
        region_count+=1
resource=json.loads((OUT/'native_resource_oracle.json').read_text())
table=json.loads((OUT/'native_table_oracle.json').read_text())
assert resource['passed'] and table['passed'] and resource['source_sha256']==table['source_sha256']==digest
assert len(resource['cases'])==2 and all(c['all_owned_allocations_freed'] for c in resource['cases'])
assert sum(len(c['hits']) for c in resource['cases'])==66 and sum(len(c['misses']) for c in resource['cases'])==8
assert len(table['cases'])==8
assert 0x90b520 not in resource['executed_instruction_addresses']
assert not set([0x57d7d4,0x57d901])&set(table['executed_instruction_addresses'])
files={str(p.relative_to(OUT)).replace('\\','/'):{'bytes':p.stat().st_size,'sha256':sha(p.read_bytes())} for p in sorted(OUT.rglob('*')) if p.is_file() and p.name!='preparation_manifest.json'}
manifest={'frozen_at_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'status':'preparation_only_not_integrated','complete':False,'source':str(EXE),'source_sha256':digest,'source_regions_byte_verified':region_count,'native_manager_lifetimes':2,'native_cache_hits_with_opaque_fixture_tokens':66,'native_misses_stopped_before_factory_body':8,'native_table_publication_selection_cases':8,'native_manager_instruction_addresses':len(resource['executed_instruction_addresses']),'native_table_instruction_addresses':len(table['executed_instruction_addresses']),'real_provider_cache_constructed':False,'real_provider_cache_destroyed':False,'normal_nonempty_ui_usable':False,'production_modified':False,'compiler_or_client_executed':False,'next_action':['Port manager172 real producer90B7C0/90A4C0 with four static hash initializers531A50/531A90/531AD0/531B10, postpublication backpointers592E49..592E6A, nine actual container sentinels and empty-provider lifecycle.','Port90AD00 with actual99A310 normalization/copy/temporary cleanup and borrowed return; pass original name to the miss path. Do not treat cache-hit fixture tokens as constructed providers.','Qualify actual context/character directory object32 and provider56 construction, INIBIN path alias/read and real LoadScreen DDS resolution, FallbackPackage inheritance and populated-provider destruction before normal UI activation.'], 'partial_unqualified_supporting_extracts':['character_directory_populate.txt: 2304-byte bounded static view901F60 with outside-window edge; not a complete function contract'], 'files':files}
(OUT/'preparation_manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
# Verify every listed byte after writing the manifest; self hash is reported
# separately because a manifest cannot contain its own stable checksum.
for name,row in files.items():
    data=(OUT/name).read_bytes();assert len(data)==row['bytes'] and sha(data)==row['sha256']
print(json.dumps({'manifest_sha256':sha((OUT/'preparation_manifest.json').read_bytes()),'files':len(files),'source_regions_verified':region_count,'status':manifest['status']}))
