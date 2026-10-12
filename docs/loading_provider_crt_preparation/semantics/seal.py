from pathlib import Path
import hashlib,json,datetime
OUT=Path(__file__).resolve().parent
def info(p):
    data=p.read_bytes()
    return {'bytes':len(data),'sha256':hashlib.sha256(data).hexdigest()}
note=json.loads((OUT/'semantics_review.json').read_text())
proof=json.loads((OUT/'source_verification.json').read_text())
assert note['verification']['existing_regions_compared_to_pe']==len(proof['verified_existing_regions'])==76
assert note['verification']['supplemental_function_regions']==len(proof['supplemental_regions'])==15
assert all(not r['edges'] for r in proof['supplemental_regions'])
assert proof['source_sha256']==note['source_sha256']
inputs={}
for base,names in [
 (Path('E:/OpenLeague/docs/loading_standard_resource_preparation'),['AUDIT.md','extract_resource.py','resource_functions.txt','resource_dependencies.txt','source_regions.json','source_dependency_regions.json','source_data_regions.json','preparation_manifest.json']),
 (Path('E:/mapslol3v3/loading_resource_provider_next'),['README.md','SCRATCH_ENVIRONMENT.md','provider_source.json','provider_source.txt','manifest.json'])]:
    for name in names:inputs[str(base/name)]=info(base/name)
files={p.name:info(p) for p in sorted(OUT.iterdir()) if p.is_file() and p.name!='manifest.json'}
manifest={'schema':1,'complete':False,'integrated':False,'frozen_at_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
          'kind':'static_provider_semantics_review','source_sha256':note['source_sha256'],
          'native_executed':False,'probes_with_io_executed':False,'compiler_executed':False,'production_modified':False,
          'source_inputs':inputs,'files':files,'limits':note['limits']}
p=OUT/'manifest.json';p.write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'manifest':str(p),**info(p),'files':len(files),'source_inputs':len(inputs)}))
