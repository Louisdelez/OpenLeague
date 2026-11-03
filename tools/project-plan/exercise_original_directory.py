"""Exercise original non-base skin discovery against actual 4.20 directories."""
import argparse
import collections
import datetime
import hashlib
import json
import pathlib
import sys

sys.path.insert(0, 'E:/OpenLeague/tools/project-plan')
from original_directory_reference import OriginalDirectoryScanner
from original_config_reader_reference import OriginalConfigReader
from native_skin_reference import integer_identity


def identity(p):
    p = pathlib.Path(p); raw = p.read_bytes()
    return {'path': str(p), 'bytes': len(raw), 'sha256': hashlib.sha256(raw).hexdigest()}


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--root', default='E:/OpenLeague')
    parser.add_argument('--output', required=True)
    args = parser.parse_args()
    root = pathlib.Path(args.root); out = pathlib.Path(args.output)
    if out.exists():
        parser.error('Existing evidence is preserved; select a new output.')
    reference = json.loads((root/'docs/reference_client_4_20.json').read_bytes())
    catalogue_path = pathlib.Path(reference['catalogue']['local_path'])
    assert identity(catalogue_path)['sha256'] == reference['catalogue']['sha256']
    catalogue = json.loads(catalogue_path.read_bytes())
    assert catalogue['version'] == '4.20.1'
    binary = pathlib.Path(reference['source_root'])/reference['client']['binary']
    data_root = binary.parent/'DATA'
    scanner = OriginalDirectoryScanner(binary, data_root)
    reader = OriginalConfigReader(binary)
    rows = []; configs = {}; counts = collections.Counter()
    for champion, official in sorted(catalogue['data'].items()):
        for skin in official['skins']:
            number = int(skin['num'])
            if number == 0:
                continue
            try:
                result = scanner.discover_skin(champion, number)
            except BaseException:
                print(json.dumps({'failed_champion': champion, 'skin_num': number,
                                  'previous_completed_rows': len(rows),
                                  'last_query': scanner.enumerations[-1]['query'] if scanner.enumerations else None}), flush=True)
                raise
            selection = scanner.filename_registered(champion, number)
            resolved = scanner.resolve_registered(selection['logical_name'])
            variant_name = f'Skin{number:02}.ini'
            payload = None
            if variant_name in result['entries']:
                assert selection['logical_name'] == variant_name and selection['dedicated']
                logical = resolved['path']
                physical = pathlib.Path(str(data_root/logical)+'bin')
                assert physical.resolve().is_relative_to(data_root.resolve())
                parsed = reader.parse(logical, physical)
                explicit_id = reader.identity_field('MeshSkin')
                assert explicit_id['found'] and integer_identity(explicit_id['value']) == int(skin['id'])
                payload = {'source': identity(physical), 'parse': parsed, 'section': 'MeshSkin',
                           'explicit_id': explicit_id, 'scale': reader.scalar_lookup('MeshSkin', 'SkinScale', -1.)}
                configs[str(physical)] = identity(physical)
                category = 'dedicated_config_discovered_and_original_id_verified'
            else:
                # This scanner supplies the non-base map only. Absence here
                # does not mean the full native package lacks a base/legacy file.
                category = 'no_dedicated_config_in_non_base_scan_base_legacy_context_open'
            counts[category] += 1
            rows.append({'champion': champion, 'skin_num': number, 'skin_id': int(skin['id']),
                         'classification': category, 'scan': result, 'selection_in_non_base_map_only': selection,
                         'resolved_in_non_base_map_only': resolved, 'compiled_config': payload})
            if len(rows) % 25 == 0:
                print(json.dumps({'processed': len(rows), 'counts': counts}), flush=True)
    expected = sum(int(s['num']) != 0 for c in catalogue['data'].values() for s in c['skins'])
    assert len(rows) == expected
    proof = {'schema': 'openleague_original_non_base_directory_experiment/v1', 'passed': True,
             'observed_utc': datetime.datetime.now(datetime.timezone.utc).isoformat(),
             'reference': identity(root/'docs/reference_client_4_20.json'), 'binary': identity(binary),
             'catalogue': identity(catalogue_path), 'catalogue_version': '4.20.1',
             'rows_count': len(rows), 'counts': dict(counts), 'compiled_sources': list(configs.values()),
             'rows': rows, 'scanner_evidence': scanner.evidence(), 'compiled_reader_evidence': reader.evidence(),
             'tools': [identity(pathlib.Path(__file__)), identity(pathlib.Path(__file__).with_name('original_directory_reference.py'))],
             'actual_host_listing_input': True, 'historical_game_process_launched': False,
             'game_source_or_data_changed': False, 'full_native_package_bootstrap_qualified': False,
             'full_config_cache_defaults_overrides_qualified': False,
             'limits': ['Non-base scanner only; base and legacy maps, overlays, fallback packages and complete provider bootstrap are not established by this experiment.',
                        'Native file/directory filter, first ordered folder, alias registration and map insertion execute; iterator factory/methods and the sound path formatter are explicit adapters.',
                        'Directory entry metadata is a current filesystem snapshot, not a content hash or historical deployment proof for every listed asset. Compiled payloads actually read have individual SHA-256.',
                        'No current skin dispatch, rendering, audio, champion or game acceptance is inferred.']}
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(json.dumps(proof, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')
    print(json.dumps({'passed': True, 'rows': len(rows), 'counts': dict(counts),
                      'compiled_sources': len(configs), 'output': str(out)}), flush=True)


if __name__ == '__main__':
    main()
