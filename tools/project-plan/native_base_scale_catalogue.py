"""Repair qualified INIBIN type-2 rounding in the actual base-model catalogue.

The selected source files are explicit test-fixture inputs, not a claim about
historical provider precedence. Other representations are compared to retained
native getter results and remain unchanged. No generic INIBIN importer is run.
"""
import copy
import hashlib
import math
import pathlib
import struct

from reference_inibin import decode, hashkey


class ScaleError(ValueError):
    pass


GAME_SHA256 = '402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
TENTHS = struct.unpack('<f', bytes.fromhex('cdcccc3d'))[0]


def f32(value):
    return struct.unpack('<f', struct.pack('<f', value))[0]


def bits(value):
    if not isinstance(value, (int, float)) or isinstance(value, bool) or not math.isfinite(value):
        raise ScaleError('Scale is not a finite numeric value')
    return struct.pack('<f', value).hex()


def compressed_tenths(value):
    if type(value) is not int or not 0 <= value <= 255:
        raise ScaleError('Compressed scalar must be one unsigned byte')
    # The exact product has at most 32 significant binary digits, so binary64
    # multiplication is exact before the explicit binary32 rounding here.
    return f32(value * TENTHS)


def compressed_field(data, section='MeshSkin', field='SkinScale'):
    """Find the raw type-2 byte; validate the entire table with the old reader."""
    decode(data)  # preserves the comparison reader's normalized semantics
    slen, flags = struct.unpack_from('<HH', data, 1)
    offset = 5
    target = int(hashkey(section, field))
    result = None
    widths = [4, 4, 1, 2, 1, None, 3, 12, 2, 8, 4, 16, 2]
    for bit, width in enumerate(widths):
        if not flags & (1 << bit):
            continue
        count = struct.unpack_from('<H', data, offset)[0]
        offset += 2
        keys = struct.unpack_from('<' + 'I' * count, data, offset)
        offset += 4 * count
        if bit == 2 and target in keys:
            result = data[offset + keys.index(target)]
        offset += (count + 7) // 8 if bit == 5 else count * width
    if offset != len(data) - slen:
        raise ScaleError('Unconsumed INIBIN value bytes')
    return result


def qualify(receipt):
    if (receipt.get('schema') != 'openleague_original_compressed_byte_precision/v1'
            or receipt.get('passed') is not True or receipt.get('pilot') is not False
            or receipt.get('supplemental_count') != 256 or receipt.get('actual_source_count') != 51
            or receipt.get('binary', {}).get('sha256') != GAME_SHA256
            or receipt.get('original_instruction_bytes_unchanged') is not True):
        raise ScaleError('Full original compressed-byte qualification is required')
    ops = receipt['original_multiplications']
    if (len(ops) != 1 or ops[0]['pc'] != '0x8af514' or ops[0]['bytes'] != 'f30f5905c88a1301'
            or ops[0]['mnemonic'] != 'mulss'
            or ops[0]['memory_operands'] != [{'address': '0x1138ac8', 'bytes': 'cdcccc3d', 'float_value': TENTHS}]):
        raise ScaleError('Original operator or binary32 constant differs')
    cases = receipt['supplemental_cases']
    if len(cases) != 256 or {x['byte'] for x in cases} != set(range(256)):
        raise ScaleError('Incomplete or duplicate compressed-byte vectors')
    for row in cases:
        expected = bits(compressed_tenths(row['byte']))
        if any(row['observed'][name]['float32_hex'] != expected for name in ['typed_float', 'scalar']):
            raise ScaleError('Native compressed-byte vector disagrees')
    originals = {x['champion']: x for x in receipt['actual_sources']}
    if len(originals) != 51:
        raise ScaleError('Incomplete or duplicate actual-source corpus')
    return originals


def repair(manifest, fixture, qualification, source_root):
    originals = qualify(qualification)
    cases = fixture['cases']
    if len(cases) != 122 or len({x['current_manifest_key'] for x in cases}) != 122:
        raise ScaleError('Expected 122 distinct base-model bindings')
    result = copy.deepcopy(manifest)
    root = pathlib.Path(source_root).resolve()
    observed = []
    used = set()
    changes = []
    for row in cases:
        source = row['source']
        path = pathlib.Path(source['path']).resolve()
        if not path.is_relative_to(root):
            raise ScaleError('Selected source escapes original reference root')
        data = path.read_bytes()
        if len(data) != source['bytes'] or hashlib.sha256(data).hexdigest() != source['sha256']:
            raise ScaleError('Selected native source changed: ' + row['champion'])
        key = row['current_manifest_key']
        if key not in result or 'scale' not in result[key]:
            raise ScaleError('Current catalogue binding absent: ' + key)
        previous = result[key]['scale']
        prior_bits = bits(previous)
        raw = compressed_field(data, row['section'], 'SkinScale')
        if raw is None:
            if prior_bits != row['native_float32_hex']:
                raise ScaleError('Non-type-2 difference is not qualified for repair: ' + key)
            value = previous
        else:
            value = compressed_tenths(raw)
            original = originals.get(row['champion'])
            if (original is None or original['source'] != source
                    or original['stored'] != {'type_bit': 2, 'format': 'B', 'raw_value': raw}
                    or original['observed']['scalar']['float32_hex'] != bits(value)
                    or bits(value) != row['native_float32_hex']):
                raise ScaleError('Actual source/native getter/fixture disagreement: ' + key)
            used.add(row['champion'])
            if prior_bits != bits(value):
                result[key]['scale'] = value
                changes.append({'champion': row['champion'], 'key': key, 'before_value': previous,
                                'after_value': value, 'before_bits': prior_bits, 'after_bits': bits(value)})
        observed.append({'champion': row['champion'], 'key': key, 'source': source,
                         'type2_byte': raw, 'before_bits': prior_bits,
                         'after_bits': bits(result[key]['scale']),
                         'native_bits': row['native_float32_hex']})
    if used != set(originals):
        raise ScaleError('Qualified actual-source corpus not exactly consumed')
    # Preserve all other entries, clips, assets, roles and numeric JSON values.
    comparison = copy.deepcopy(result)
    for change in changes:
        comparison[change['key']]['scale'] = change['before_value']
    if comparison != manifest:
        raise ScaleError('Non-scale catalogue data changed')
    return result, {'rows': observed, 'changes': changes,
                    'all_122_bits_match': all(x['after_bits'] == x['native_bits'] for x in observed),
                    'qualified_type2_sources': len(used), 'provider_precedence_qualified': False}
