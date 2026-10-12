"""Freeze static inventory and native prefix proof; scratch writes only."""
from pathlib import Path
from datetime import datetime, timezone
import hashlib, json

root = Path(__file__).resolve().parent
sha = lambda raw: hashlib.sha256(raw).hexdigest()
source = json.loads((root/'source_regions.json').read_text())
proof = json.loads((root/'prefix_native_probe.json').read_text())
summary = json.loads((root/'prefix_native_result.json').read_text())
assert proof['passed'] and summary['passed']
assert summary['lifetimes'] == 128 and summary['stops_before_resource'] == summary['stops_before_diagnostic'] == 64
assert summary['events'] == 10144
assert proof['native_sha256'] == source['native_sha256']
assert sha(Path(source['native_source']).read_bytes()) == source['native_sha256']
assert not proof['native_provider_results_simulated']
assert all(not case['shutdown']['words'] and not case['shutdown']['blocks'] for case in proof['cases'])
def entry(path):
    raw = path.read_bytes()
    return {'path':str(path), 'bytes':len(raw), 'sha256':sha(raw)}

inventory = {
    'scope': 'Candidate selection prefix only, stopping before package resource provider90AD00',
    'native_source':source['native_source'],'native_sha256':source['native_sha256'],
    'caller_slice':{'start':0x57d6fe,'end_exclusive':0x57d775,'rva':0x17d6fe,'bytes':119},
    'native_execution':summary,
    'code_already_ported':[
        {'address':0x72ad90,'api':'audio_loading_metadata::service_name(b,out24,key,scratch8)'},
        {'address':0x72ae40,'api':'audio_loading_metadata::service_extra(b,key,scratch8)'},
        {'address':0x728500,'api':'audio_loading_metadata::extra'},
        {'address':0x57dcae,'api':'audio_loading_screen_packet private drop_string; preserve no-reset behavior'},
    ],
    'source_proven_missing':[
        {'address':0x57d6fe,'scope':'Caller override selection and retained-service +4C dispatch'},
        {'address':0x991e60,'scope':'Negative-skin diagnostic; its format/consumer helpers remain unqualified'},
        {'address':0x90ad00,'scope':'Provider lookup plus temporary String24 lifetime'},
        {'address':0x90d220,'scope':'Provider lower bound'},
        {'address':0x901f00,'scope':'Provider key equality/order'},
        {'address':0x90b520,'scope':'Provider cache miss construction/publication'},
        {'address':0x9034d0,'scope':'Provider constructor and ownership'},
    ],
    'api_constraints':[
        'Keep retained service pointer from first-name lookup; current initialize_standard_record signature lacks this value',
        'Do not reload SERVICE_GLOBAL as an invented substitute for passing the retained pointer',
        'Reuse service_extra exact native chain and caller-exclusive scratch8 under existing launch lock',
        'Do not use fresh-string copy to replace an owned nonempty String24',
        'Private metadata::assign is a candidate after prefix parity, not a general alias-safe public API',
        'Until actual991E60 and90AD00 dependencies are connected, keep explicit unsupported boundaries and caller cleanup',
    ],
    'resource_constraints':[
        'SERVICE_GLOBAL is mapped but its normal publisher remains unported; diagnostics restore real service pointer binding before teardown',
        'Package manager2D78F1C is unmapped in runtime package and initial PE value0 does not create a provider',
        'Hit90AD00 can allocate the temporary name copy; absence of a new provider is not absence of allocation',
        'Bitmap/UI/Flash/table resources occur beyond90AD00 and are outside this proposed tranche',
    ],
    'next_actions':[
        'Qualify reusable owned String24 assignment against these prefix contracts before exposing a broader API',
        'Port caller selection and service+4C boundary with retained service, preserving negative diagnostic refusal',
        'Integrate and test only that prefix; preserve explicit error at90AD00 and exact caller cleanup',
        'Qualify real package manager ownership and cache-hit90AD00 separately from miss90B520',
    ],
    'rust_port_created':False,'application_integration':False,
}
(root/'next_slice_inventory.json').write_text(json.dumps(inventory,indent=2)+'\n',encoding='utf-8')
files = [entry(path) for path in sorted(root.iterdir()) if path.is_file() and path.name != 'preparation_manifest.json']
manifest = {
    'created_utc':datetime.now(timezone.utc).isoformat(),
    'status':'Frozen scratch preparation; not integrated',
    'native_source':source['native_source'],'native_sha256':source['native_sha256'],
    'static_regions':len(source['regions']),'static_bytes':sum(r['size'] for r in source['regions']),
    'native_execution':summary,'all_owned_allocations_released':True,
    'rust_port_created':False,'rust_compilation_executed':False,'production_modified':False,
    'files':files,'limits':proof['limits'],
}
(root/'preparation_manifest.json').write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'manifest':entry(root/'preparation_manifest.json'),'oracle':entry(root/'prefix_native_probe.json'),
                  'summary':summary},indent=2))
