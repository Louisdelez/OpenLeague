"""Read-only integrity checks for frozen preparations, not runtime qualification.

Call validate() before copying any archive. Its returned per-file hashes can
also verify destination copies. No compiler, client, recorder or mutation runs.
Historical production-source snapshots are intentionally not compared with the
current application: only the frozen local artifacts and their manifest pins.
"""
from pathlib import Path
import hashlib
import json

BASE = Path('E:/mapslol3v3')
SPECS = [
    ('loading_standard_ui_next','preparation_manifest.json','b9d171ee87d411ae4b5d8c932f89dabb53d44c2ed157f0ef7fb1ac78fa79cb3e','files'),
    ('process_clock_client_shutdown_review','manifest.json','2d2c9618d276b012abce874cbd0b62f61448b2f88640418244f2c97045cc4015','artifacts'),
    ('loading_service_global_preparation','evidence_index.json','948151d1000b8e59eb11ab88d46a5282300dbffa6ee2f718f7e853b147ded36e','artifacts'),
    ('loading_standard_prefix_port','preparation_manifest.json','0dc254ce2ed85aa29ebb16100898c9429ef6f37a8a6383d306dd6719324cfccc','files'),
    ('loading_service_lifecycle_oracle','qualification_manifest.json','67fdc5a7e0697fc300b66b59cb6059c6790aba388e5211e433864d86887e5bf3','files'),
    ('loading_string24_ownership_repair','preparation_manifest.json','2a6d5c62bcf0c5eb4aaca71cf3a59fd922677f85881dd698a7df1012b622d7ff','files'),
    ('client_shutdown_candidate','manifest.json','df1475670bc8569713cbc496b11fdb1f3a5dc0446a89e93d6a63ce4e904da2b2','artifacts'),
]

def require(condition, message):
    if not condition:
        raise ValueError(message)

def sha(path):
    with path.open('rb') as stream:
        return hashlib.file_digest(stream,'sha256').hexdigest()

def _pairs(rows):
    value={}
    for key,item in rows:
        require(key not in value,f'duplicate JSON key {key}')
        value[key]=item
    return value

def load(path):
    return json.loads(path.read_text(encoding='utf-8-sig'),object_pairs_hook=_pairs)

def check_file(root, row, checked):
    path=Path(row['path'])
    path=(path if path.is_absolute() else root/path).resolve()
    require(path.is_relative_to(root),f'artifact escapes frozen directory: {path}')
    require(path.is_file(),f'frozen artifact missing: {path}')
    relative=path.relative_to(root).as_posix()
    require(relative not in checked,f'duplicate artifact entry: {path}')
    expected=row['sha256']
    require(isinstance(expected,str) and len(expected)==64,f'invalid artifact hash: {path}')
    size=row.get('bytes',row.get('size'))
    require(type(size) is int and size>=0,f'missing/invalid artifact size: {path}')
    require(path.stat().st_size==size and sha(path)==expected,f'frozen artifact changed: {path}')
    checked[relative]={'bytes':size,'sha256':expected}

def validate(base=BASE):
    groups={}
    for group,manifest_name,expected,field in SPECS:
        root=(Path(base)/group).resolve()
        manifest=root/manifest_name
        require(sha(manifest)==expected,f'frozen manifest changed: {manifest}')
        value=load(manifest)
        require(isinstance(value[field],list) and value[field],f'empty artifact list: {manifest}')
        checked={}
        for row in value[field]:
            check_file(root,row,checked)
        if group=='loading_service_global_preparation':
            # The already-pinned artifact source_manifest owns the 17 raw
            # regions, which evidence_index counts but does not repeat.
            require('source_manifest.json' in checked,'source manifest is not pinned')
            regions=load(root/'source_manifest.json')['regions']
            require(len(regions)==value['code_regions']+value['data_regions'],'region count drift')
            for region in regions:
                check_file(root,region,checked)
        checked[manifest_name]={'bytes':manifest.stat().st_size,'sha256':expected}
        actual={p.relative_to(root).as_posix() for p in root.rglob('*')
                if p.is_file() and '__pycache__' not in p.relative_to(root).parts}
        require(actual==set(checked),f'unmanifested/missing frozen files in {group}: {sorted(actual^set(checked))}')
        # Detect changes to the manifest while it was being consumed.
        require(sha(manifest)==expected,f'frozen manifest changed during validation: {manifest}')
        groups[group]={'manifest':manifest_name,'manifest_sha256':expected,
                       'files_checked':len(checked),'files':checked}
    return {'passed':True,'scope':'frozen artifact integrity only',
            'production_integrated':False,'runtime_qualification_performed':False,
            'groups_checked':len(groups),'files_checked':sum(v['files_checked'] for v in groups.values()),
            'groups':groups}

if __name__=='__main__':
    result=validate()
    print(json.dumps({key:value for key,value in result.items() if key!='groups'},indent=2))
