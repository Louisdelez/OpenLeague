"""Reproduce original skin-loader branches against exact reference inputs."""
import argparse
import collections
import datetime
import hashlib
import json
import pathlib
import sys

R = pathlib.Path('E:/OpenLeague')
sys.path.insert(0, str(R / 'tools/project-plan'))
from native_skin_loader_reference import OriginalSkinLoader, BINARY_SHA
from native_skin_reference import integer_identity
from reference_inibin import read, hashkey
import capstone
import unicorn
import pefile


def identity(p):
    p = pathlib.Path(p)
    raw = p.read_bytes()
    return {'path': str(p), 'bytes': len(raw), 'sha256': hashlib.sha256(raw).hexdigest()}


def load(p):
    return json.loads(pathlib.Path(p).read_bytes())


def main():
    p = argparse.ArgumentParser()
    p.add_argument('--root', default=str(R))
    p.add_argument('--output', required=True)
    args = p.parse_args()
    root, output = pathlib.Path(args.root), pathlib.Path(args.output)
    if output.exists():
        p.error('Output exists; preserve prior evidence.')
    ref = load(root / 'docs/reference_client_4_20.json')
    binary = pathlib.Path(ref['source_root']) / ref['client']['binary']
    loader = OriginalSkinLoader(binary)
    deploy = binary.parent
    registry_path = root / 'docs/fidelity_skin_configuration_bindings_4_20.json'
    registry = load(registry_path)
    catalogue = load(ref['catalogue']['local_path'])
    if identity(ref['catalogue']['local_path'])['sha256'] != registry['official_catalogue']['sha256'] or catalogue['version'] != '4.20.1':
        raise ValueError('Official skin catalogue identity changed')
    official = {(champion, int(skin['num']), int(skin['id'])) for champion, c in catalogue['data'].items() for skin in c['skins']}
    if official != {(x['champion'], x['skin_num'], x['skin_id']) for x in registry['rows']}:
        raise ValueError('Complete official skin coverage changed')
    controls = []
    for number, names, filename, dedicated in [
        (0, ['Base.ini'], 'Base.ini', True),
        (1, ['Skin01.ini', 'Base.ini'], 'Skin01.ini', True),
        (1, ['Base.ini'], 'Base.ini', True),
        (1, [], 'Renekton.ini', False),
        (4, ['Skin04.ini'], 'Skin04.ini', True),
    ]:
        result = loader.filename('Renekton', number, names)
        assert (result['logical_name'], result['dedicated']) == (filename, dedicated)
        controls.append({'kind': 'filename', 'number': number, 'logical_names': names,
                         'expected': [filename, dedicated], 'observed': result, 'passed': True})
    for dedicated, number, scale, expected in [
        (True, 4, 1.6, 'MeshSkin'), (False, 0, None, 'MeshSkin'),
        (False, 4, 1.6, 'MeshSkin4'), (False, 4, None, 'MeshSkin'),
        (False, 4, -1., 'MeshSkin'), (False, 4, 0., 'MeshSkin4'),
    ]:
        values = {} if scale is None else {hashkey('MeshSkin' + str(number), 'SkinScale'): scale}
        result = loader.section('Renekton', number, dedicated, values)
        assert result['section'] == expected
        controls.append({'kind': 'section', 'number': number, 'dedicated': dedicated,
                         'supplied_scale': scale, 'expected': expected, 'observed': result, 'passed': True})
    for path, key in [('Characters/Renekton/Skins/Base/Base.inibin', 'Base.ini'),
                      ('Characters/Renekton/Spells/RenektonQ.luaobj', 'RenektonQ.lua'),
                      ('Characters/Renekton/Base.dds', None), ('Characters/Renekton/Base.a', None)]:
        result = loader.alias(path)
        assert (result['alias']['key'] if result['alias'] else None) == key
        controls.append({'kind': 'alias', 'input': path, 'expected_key': key, 'observed': result, 'passed': True})
    aliases, parsed = {}, {}

    def native(path):
        k = str(path)
        if k not in parsed:
            parsed[k] = read(path)
        return parsed[k]

    def alias(path):
        k = str(path)
        if k not in aliases:
            if not path.is_relative_to(deploy / 'DATA'):
                raise ValueError('Source outside reference DATA')
            result = loader.alias(path.relative_to(deploy / 'DATA').as_posix())
            if result['alias'] is None:
                raise ValueError('Expected original INIBIN suffix alias was not emitted')
            aliases[k] = {'source': identity(path), 'observed': result}
        return aliases[k]

    rows = []
    for row in registry['rows']:
        champion, number, expected_id = row['champion'], row['skin_num'], row['skin_id']
        char_root = deploy / 'DATA/Characters' / champion
        legacy = char_root / (champion + '.inibin')
        base = char_root / 'Skins/Base/Base.inibin'
        folder = f'Skin{number:02}'
        dedicated = char_root / 'Skins' / folder / (folder + '.inibin')
        if not legacy.is_file():
            raise ValueError('Indispensable legacy input absent: ' + str(legacy))
        available = {}
        for physical in [base, dedicated] if number else [base]:
            if physical.is_file():
                result = alias(physical)
                available[result['observed']['alias']['key']] = physical
        alias(legacy)
        file_result = loader.filename(champion, number, list(available))
        section_result = loader.section(champion, number, file_result['dedicated'], native(legacy))
        chosen = available[file_result['logical_name']] if file_result['dedicated'] else legacy
        values = native(chosen)
        section = section_result['section']
        actual_id = integer_identity(values.get(hashkey(section, 'ChampionSkinID')))
        fields = {field: values.get(hashkey(section, field)) for field in
                  ['ChampionSkinID', 'ChampionSkinName', 'SkinScale', 'SimpleSkin', 'Skeleton', 'Texture', 'Animations']}
        rows.append({'champion': champion, 'skin_num': number, 'skin_id': expected_id,
                     'task_ids': row['task_ids'], 'reference_resource_input_assumption':
                         'Contains answers from aliases of the listed physical files only; original provider maps/package mounting/cache not executed.',
                     'supplied_logical_resources': {name: str(path) for name, path in available.items()},
                     'filename_result': file_result, 'section_result': section_result,
                     'conditional_selected_source': identity(chosen), 'conditional_selected_section': section,
                     'conditional_selected_fields': fields, 'requested_id_matches_selected_explicit_id': actual_id == expected_id,
                     'effective_historical_precedence_qualified': False, 'runtime_skin_selection_qualified': False})
    # Confirm the caller passes the filename decision's dedicated flag to the
    # section constructor. These are static source bindings, not executed callers.
    cs = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)
    cs.detail = True
    calls = []
    for start, stop, sites in [(0x568e20, 0x5691f0, {0x568fee: 0x56e0d0}),
                              (0x569210, 0x5692a0, {0x569293: 0x566b90})]:
        found = {}
        for i in cs.disasm(loader.image[start-loader.base:stop-loader.base], start):
            if i.address in sites:
                if i.mnemonic != 'call' or i.operands[0].type != capstone.x86.X86_OP_IMM or i.operands[0].imm != sites[i.address]:
                    raise ValueError('Original caller chain changed')
                found[i.address] = sites[i.address]
                calls.append({'site': hex(i.address), 'target': hex(sites[i.address]), 'bytes_hex': i.bytes.hex()})
        assert found == sites
    renekton = [x for x in rows if x['champion'] == 'Renekton']
    assert len(renekton) == 7 and all(x['requested_id_matches_selected_explicit_id'] for x in renekton)
    manifest = root / 'data/4.20/animation_manifest.json'
    animation = root / 'crates/client/src/animation.rs'
    current_scale = load(manifest)['renekton']['scale']
    assert current_scale == renekton[0]['conditional_selected_fields']['SkinScale']
    counts = {'official_skin_identities': len(rows), 'original_alias_inputs': len(aliases),
              'conditional_selected_id_matches': sum(x['requested_id_matches_selected_explicit_id'] for x in rows),
              'conditional_selected_id_differs_or_absent': sum(not x['requested_id_matches_selected_explicit_id'] for x in rows),
              'filename_decisions': dict(collections.Counter(x['filename_result']['logical_name'] for x in rows)),
              'synthetic_controls': len(controls), 'renekton_conflicts': len(renekton)}
    result = {'schema': 'openleague_original_skin_loader_branches/v1', 'created_utc': datetime.datetime.now(datetime.timezone.utc).isoformat(),
              'passed': True, 'reference': '4.20.0.315 PUBLIC EUW/en_GB; catalogue4.20.1', 'counts': counts,
              'original': loader.evidence(), 'source_registry': identity(registry_path),
              'official_catalogue': identity(ref['catalogue']['local_path']), 'synthetic_controls': controls,
              'actual_alias_inputs': list(aliases.values()), 'conditional_reference_cases': rows,
              'static_caller_binding': {'calls': calls, 'dedicated_flag_field': 'character_object+0x95c',
                   'callers_executed': False, 'section_common_consumer': '0x566cb4'},
              'current_consumer': {'manifest': identity(manifest), 'code': identity(animation),
                   'renekton_base_scale': current_scale, 'matches_conditional_dedicated_base': True,
                   'non_base_runtime_skin_dispatch_qualified': False},
              'producer': identity(__file__), 'helper': identity(pathlib.Path(__file__).with_name('native_skin_loader_reference.py')),
              'tools': {'python': identity(sys.executable), 'unicorn': {'version': unicorn.__version__,
                    'module': identity(unicorn.__file__), 'dlls': [identity(p) for p in pathlib.Path(unicorn.__file__).parent.rglob('*.dll')]},
                   'pefile': {'version': pefile.__version__, 'module': identity(pefile.__file__)},
                   'capstone': {'version': capstone.__version__, 'module': identity(capstone.__file__)}},
              'effective_historical_resource_provider_qualified': False, 'gameplay_accepted': False,
              'remaining_research': ['Execute/qualify original package mounting and Contains/GetResolvedPath tables for these actual physical resources.',
                   'Trace original compiled .ini opening to its .inibin payload with fallback/overlay and locale/profile context.',
                   'Qualify current per-skin asset/animation/material dispatch separately; base-scale equality is only one current value.']}
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(json.dumps(result, ensure_ascii=False, indent=2, allow_nan=False) + '\n', encoding='utf-8')
    print(json.dumps({'passed': True, 'counts': counts,
                      'original_unique_addresses': result['original']['original_unique_addresses_exercised'],
                      'effective_historical_resource_provider_qualified': False}, ensure_ascii=False))
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
