"""Read existing Cargo dependency evidence and locate current resource includes.

This is a source/distribution audit. It does not run Cargo, establish freshness of
an executable, or close dynamically loaded dependencies.
"""
from pathlib import Path
import hashlib
import json
import os
import re


def identity(path):
    path = Path(path)
    data = path.read_bytes()
    return {'path': str(path), 'bytes': len(data), 'sha256': hashlib.sha256(data).hexdigest()}


def parse_dependencies(text):
    lines = text.splitlines()
    if not lines or ': ' not in lines[0]:
        raise ValueError('missing Cargo target separator')
    target, rhs = lines[0].split(': ', 1)
    if not target or not rhs.strip():
        raise ValueError('empty Cargo target or dependency list')
    if any(value in rhs for value in ('\\ ', '$$', '\\#')) or rhs.rstrip().endswith('\\'):
        raise ValueError('unsupported escaped or continued dependency syntax')
    return target, rhs.split()


def inspect(root, dep_info, scope):
    """Return explicit evidence for this dep-info; scope is caller-supplied."""
    if scope not in ('client_link_dependency_list', 'client_test_direct_dependencies'):
        raise ValueError('explicit supported dependency scope required')
    root = Path(root).resolve()
    dep_info = Path(dep_info).resolve()
    target, tokens = parse_dependencies(dep_info.read_text(encoding='utf-8-sig'))
    manifest_path = root / 'assets-manifest.json'
    manifest = json.loads(manifest_path.read_bytes())
    records = manifest['files']
    if isinstance(records, dict):
        records = [dict(value, path=key) for key, value in records.items()]
    declared = {}
    for row in records:
        key = row['path'].replace('\\', '/').casefold()
        if key in declared:
            raise ValueError('duplicate distribution path')
        declared[key] = row
    unique = {}
    outside = []
    for token in tokens:
        path = Path(os.path.normpath(str(root / token))).resolve()
        try:
            relative = path.relative_to(root).as_posix()
        except ValueError:
            outside.append(str(path))
            continue
        unique[str(path).casefold()] = (path, relative)
    resources = []
    for path, relative in unique.values():
        if not relative.casefold().startswith(('assets/', 'data/')):
            continue
        expected = declared.get(relative.casefold())
        row = {'path': str(path), 'relative': relative, 'exists': path.is_file(),
               'declared_in_distribution': expected is not None, 'include_anchors': []}
        if path.is_file():
            row.update(identity(path))
            row['modified_after_dep_info'] = path.stat().st_mtime > dep_info.stat().st_mtime
            if expected is not None:
                row['matches_manifest_sha256'] = row['sha256'] == expected['sha256']
        resources.append(row)
    by_relative = {row['relative'].casefold(): row for row in resources}
    source_pins = {}
    for source in (root / 'crates').rglob('*.rs'):
        text = source.read_text(encoding='utf-8-sig')
        for match in re.finditer(r'include_(str|bytes)!\s*\(\s*"([^"\n]+)"', text):
            resolved = (source.parent / match.group(2)).resolve()
            try:
                key = resolved.relative_to(root).as_posix().casefold()
            except ValueError:
                continue
            if key not in by_relative:
                continue
            line = text.count('\n', 0, match.start()) + 1
            by_relative[key]['include_anchors'].append({
                'path': str(source), 'line': line, 'macro': match.group(1),
                'literal': match.group(2), 'excerpt': text.splitlines()[line - 1].strip(),
                'qualification': 'exact literal include; cfg and call activation unqualified',
            })
            source_pins[str(source)] = identity(source)
    return {
        'schema': 'openleague_cargo_resource_dependencies/v1',
        'scope': scope, 'dep_info': identity(dep_info), 'target': target,
        'manifest': identity(manifest_path), 'resources': resources,
        'consumer_sources': list(source_pins.values()),
        'outside_root_dependencies_not_read': sorted(set(outside)),
        'counts': {
            'resources': len(resources),
            'declared': sum(row['declared_in_distribution'] for row in resources),
            'undeclared': sum(not row['declared_in_distribution'] for row in resources),
            'missing': sum(not row['exists'] for row in resources),
            'manifest_mismatches': sum(row.get('matches_manifest_sha256') is False for row in resources),
            'modified_after_dep_info': sum(row.get('modified_after_dep_info', False) for row in resources),
            'include_anchors': sum(len(row['include_anchors']) for row in resources),
        },
        'fresh_execution': {'source_audit': True, 'cargo_build': False, 'game': False},
        'complete_dependency_closure': False,
    }


if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--root', type=Path, default=Path(__file__).resolve().parents[2])
    parser.add_argument('--dep-info', type=Path, required=True)
    parser.add_argument('--scope', required=True)
    args = parser.parse_args()
    print(json.dumps(inspect(args.root, args.dep_info, args.scope), ensure_ascii=False, indent=2))
