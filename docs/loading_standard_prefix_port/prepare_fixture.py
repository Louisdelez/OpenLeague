"""Copy frozen native evidence with source-only table bytes for the Rust host."""
from pathlib import Path
import hashlib,json
out=Path(__file__).resolve().parent
original=Path(r'E:\mapslol3v3\loading_standard_ui_next\prefix_native_probe.json')
raw=original.read_bytes()
assert hashlib.sha256(raw).hexdigest()=='e321a049a6ef3af573549b578fa7f3f79dc51f302808a4dcbd29b2f061a6d521'
proof=json.loads(raw)
manifest=json.loads(Path(r'E:\OpenLeague\data\4.20\runtime\replay_runtime_image_manifest.json').read_text())
image=Path(r'E:\OpenLeague\data\4.20\runtime\replay_runtime_image.bin').read_bytes()
assert hashlib.sha256(image).hexdigest()==manifest['package_sha256']
assert proof['native_sha256']==manifest['native_sha256']
regions=[]
for address,size in [(0x10afe8c,0x50),(0x10b00c4,0x28),(0x10d6048,12)]:
    r=next(r for r in manifest['regions'] if r['address']<=address and address+size<=r['address']+r['size'])
    offset=r['payload_offset']+address-r['address'];data=image[offset:offset+size]
    regions.append({'address':address,'size':size,'hex':data.hex(),'sha256':hashlib.sha256(data).hexdigest(),'runtime_region':r['name']})
proof['fixture_derivation']={'source':str(original),'sha256':hashlib.sha256(raw).hexdigest(),
                            'native_cases_unchanged':True,'new_native_execution':False,
                            'seed_tables_from_source_runtime_image':manifest['package_sha256']}
proof['seed_regions']=regions
(out/'loading_standard_prefix_probe.json').write_text(json.dumps(proof,indent=2)+'\n')
sources=json.loads(Path(r'E:\mapslol3v3\loading_standard_ui_next\source_regions.json').read_text())
region=next(r for r in sources['regions'] if r['address']==0x2d78f1c)
assert region['size']==4 and region['hex']=='00000000'
requirements={'native_sha256':sources['native_sha256'],
              'required_additional_runtime_region':{'group':1,'name':'loading_package_manager_global',
                 'address':region['address'],'rva':region['rva'],'size':4,'hex':region['hex'],'sha256':region['sha256']},
              'existing_regions_required':regions,
              'note':'Source zero only. Mapping does not construct/publish a real package manager. Root must update extractor, runtime image table and manifested binary together before Windows prefix qualification.'}
(out/'runtime_image_requirements.json').write_text(json.dumps(requirements,indent=2)+'\n')
print(json.dumps({'native_cases':len(proof['cases']),'seed_regions':len(regions),'new_native_execution':False}))
