"""Explicit, append-only versions of mutable local inputs in the source graph.

Native inputs and old proof receipts cannot be adopted as changed versions.
Each old record and its exact bytes remain addressable; updating the current
SHA alone is never sufficient. This module performs no filesystem mutations.
"""
import copy
import datetime
import hashlib
import json
import pathlib
import re


class SourceVersionError(ValueError):
    pass


MUTABLE = frozenset([
    'assets-manifest.json',
    'data/4.20/animation_manifest.json',
    'crates/client/src/animation_scale_reference_cases.json',
    'tools/project-plan/requirement_trace.py',
    'tools/project-plan/source_versions.py',
    'crates/core/src/audio_crt_windows_process_heap.rs',
])
ARCHIVES = 'docs/fidelity_source_versions'


def identity(payload):
    return {'bytes': len(payload), 'sha256': hashlib.sha256(payload).hexdigest()}


def record_sha(record):
    raw = json.dumps(record, ensure_ascii=False, sort_keys=True,
                     separators=(',', ':'), allow_nan=False).encode('utf-8')
    return hashlib.sha256(raw).hexdigest()


def _local(root, relative):
    name = pathlib.PurePosixPath(relative)
    if name.is_absolute() or '..' in name.parts or '\\' in relative or ':' in relative:
        raise SourceVersionError('Unsafe source-version path')
    path = (pathlib.Path(root) / relative).resolve()
    if not path.is_relative_to(pathlib.Path(root).resolve()):
        raise SourceVersionError('Source-version path escapes root')
    return path


def _mutable(source, root):
    path = pathlib.Path(source['path']).resolve()
    try:
        relative = path.relative_to(pathlib.Path(root).resolve()).as_posix()
    except ValueError as e:
        raise SourceVersionError('Native/external source is immutable') from e
    if relative not in MUTABLE:
        raise SourceVersionError('Source not in explicit mutable local allowlist')
    if not re.fullmatch(r'OLS-[0-9a-f-]{36}', source['source_id']):
        raise SourceVersionError('Invalid versioned source ID')
    return path, relative


def _check_identity(value):
    if (type(value.get('bytes')) is not int or value['bytes'] < 0
            or not re.fullmatch(r'[0-9a-f]{64}', value.get('sha256', ''))):
        raise SourceVersionError('Invalid source-version identity')


def _utc(value):
    try:
        date = datetime.datetime.fromisoformat(value)
        valid = date.tzinfo is not None and date.utcoffset() == datetime.timedelta(0)
    except (ValueError, TypeError):
        valid = False
    if not valid:
        raise SourceVersionError('Source-version date must be explicit UTC')


def _archive(source, previous):
    return '/'.join([ARCHIVES, source['source_id'], previous['sha256'],
                     pathlib.Path(source['path']).name])


def _previous(entry, prefix):
    previous = copy.deepcopy(entry['previous_record'])
    if 'version_history' in previous or entry['prior_history_count'] != len(prefix):
        raise SourceVersionError('Nonlinear or truncated source-version history')
    if type(entry['previous_had_history']) is not bool:
        raise SourceVersionError('Invalid previous-history flag')
    if entry['previous_had_history']:
        previous['version_history'] = copy.deepcopy(prefix)
    elif prefix:
        raise SourceVersionError('Lost earlier source-version history')
    if record_sha(previous) != entry['previous_record_sha256']:
        raise SourceVersionError('Historical source record changed')
    return previous


def validate_history(source, root, verify_files=False):
    history = source.get('version_history')
    if history is None:
        return 0
    root = _validation_root(source, root); path, _ = _mutable(source, root)
    if not isinstance(history, list) or not history:
        raise SourceVersionError('Empty or invalid source-version history')
    for i, entry in enumerate(history):
        if entry.get('schema') != 'openleague_source_version/v1':
            raise SourceVersionError('Invalid source-version schema')
        previous = _previous(entry, history[:i])
        _check_identity(previous)
        if (previous['source_id'] != source['source_id'] or previous['path'] != source['path']
                or not previous.get('origin') or not previous.get('version')):
            raise SourceVersionError('Source identity or provenance rebound')
        next_record = history[i + 1]['previous_record'] if i + 1 < len(history) else source
        next_identity = {k: next_record[k] for k in ['bytes', 'sha256']}
        if entry['next_identity'] != next_identity or previous['sha256'] == next_record['sha256']:
            raise SourceVersionError('Broken source-version identity chain')
        if not isinstance(entry.get('reason'), str) or not entry['reason'].strip():
            raise SourceVersionError('Source-version change has no reason')
        _utc(entry['changed_utc'])
        if entry['archive_path'] != _archive(source, previous):
            raise SourceVersionError('Unexpected historical archive path')
        archive = _local(root, entry['archive_path'])
        evidence = entry['evidence']
        _check_identity(evidence)
        evidence_path = _local(root, evidence['path'])
        if not evidence['path'].startswith('docs/') or evidence_path.suffix != '.json':
            raise SourceVersionError('Version change needs a local JSON evidence receipt')
        if verify_files:
            if not archive.is_file() or identity(archive.read_bytes()) != {k: previous[k] for k in ['bytes', 'sha256']}:
                raise SourceVersionError('Historical source bytes missing or changed')
            if not evidence_path.is_file() or identity(evidence_path.read_bytes()) != {k: evidence[k] for k in ['bytes', 'sha256']}:
                raise SourceVersionError('Source-version evidence missing or changed')
    if verify_files and (not path.is_file() or identity(path.read_bytes()) != {k: source[k] for k in ['bytes', 'sha256']}):
        raise SourceVersionError('Current versioned source changed')
    return len(history)


def historical_record(source, sha256):
    """Resolve an old full record by its byte identity without rebinding the ID."""
    if source['sha256'] == sha256:
        return copy.deepcopy(source)
    history = source.get('version_history', [])
    for i, entry in enumerate(history):
        if entry['previous_record']['sha256'] == sha256:
            return _previous(entry, history[:i])
    raise SourceVersionError('Unknown historical source SHA')


def prepare_version(source, root, old_bytes, new_bytes, evidence, reason, changed_utc):
    """Return new metadata plus an archive destination; caller publishes bytes."""
    _mutable(source, root)
    validate_history(source, root, verify_files=True)
    if identity(old_bytes) != {k: source[k] for k in ['bytes', 'sha256']}:
        raise SourceVersionError('Previous bytes differ from registered source')
    if identity(pathlib.Path(source['path']).read_bytes()) != identity(old_bytes):
        raise SourceVersionError('Live source drift before version adoption')
    new_identity = identity(new_bytes)
    if new_identity['sha256'] in [source['sha256']] + [x['previous_record']['sha256'] for x in source.get('version_history', [])]:
        raise SourceVersionError('Unchanged or reused historical byte identity')
    previous = copy.deepcopy(source)
    history = previous.pop('version_history', [])
    entry = {
        'schema': 'openleague_source_version/v1', 'previous_record': previous,
        'previous_record_sha256': record_sha(source), 'previous_had_history': 'version_history' in source,
        'prior_history_count': len(history), 'archive_path': _archive(source, previous),
        'next_identity': new_identity, 'evidence': copy.deepcopy(evidence),
        'reason': reason, 'changed_utc': changed_utc,
    }
    result = copy.deepcopy(source)
    result.update(new_identity, version='content-sha256:' + new_identity['sha256'],
                  source_identity_verified=True, version_history=history + [entry])
    expected = result.get('expected_sha256')
    result['expected_identity_matches'] = None if expected is None else expected == result['sha256']
    validate_history(result, root, verify_files=False)
    return result, entry['archive_path']


def _validation_root(source, root):
    """Resolve a frozen pre-migration record for validation only, never adoption.

    Its identity, bytes, archives and receipts stay at the recorded old root.
    This does not assert that the same relative file in the active root matches.
    prepare_version still calls _mutable against the active root first.
    """
    active = pathlib.Path(root).resolve()
    path = pathlib.Path(source['path']).resolve()
    if path.is_relative_to(active):
        return active
    location = active / 'docs/project_location.json'
    try:
        config = json.loads(location.read_bytes())
        recorded_active = pathlib.Path(config['active_root'])
        previous = pathlib.Path(config['previous_root'])
        if (config['schema'] != 'openleague-project-location/v1'
                or not recorded_active.is_absolute() or recorded_active.resolve() != active
                or not previous.is_absolute()
                or config.get('external_historical_sources_preserved') is not True):
            raise ValueError('Invalid explicit relocation')
        if any(p.is_symlink() or p.is_junction() for p in [previous, *previous.parents]):
            raise ValueError('Historical root reparse refused')
        previous = previous.resolve(strict=True)
        if previous.is_relative_to(active) or active.is_relative_to(previous):
            raise ValueError('Overlapping historical and active roots')
        _mutable(source, previous)
        return previous
    except (OSError, ValueError, KeyError, TypeError) as error:
        raise SourceVersionError('Native/external source is immutable; explicit historical root required') from error
