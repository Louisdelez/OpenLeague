#!/usr/bin/env python3
"""Restore the exact asset packs pinned by the repository manifest."""
import argparse
import hashlib
import json
import os
from pathlib import Path, PurePosixPath
import urllib.request
import zipfile

ROOT = Path(__file__).resolve().parents[1]

def digest(path):
    with path.open('rb') as stream:
        return hashlib.file_digest(stream, 'sha256').hexdigest()

def destination(root, relative):
    name = PurePosixPath(relative)
    if name.is_absolute() or '..' in name.parts or '\\' in relative or ':' in relative:
        raise ValueError('Unsafe archive path: ' + relative)
    target = (root / relative).resolve()
    if not target.is_relative_to(root.resolve()):
        raise ValueError('Archive path escapes project: ' + relative)
    return target

def restore(root, archive, entries, force=False):
    expected = {row['path']: row for row in entries}
    with zipfile.ZipFile(archive) as pack:
        names = pack.namelist()
        if len(names) != len(set(names)) or set(names) != set(expected):
            raise ValueError('Archive contents differ from the manifest')
        for name in names:
            row = expected[name]
            target = destination(root, name)
            info = pack.getinfo(name)
            if info.file_size != row['bytes'] or ((info.external_attr >> 16) & 0o170000) == 0o120000:
                raise ValueError('Invalid size or symbolic link: ' + name)
            if target.exists():
                if digest(target) == row['sha256']:
                    continue
                if not force:
                    raise ValueError('Local file differs; preserve it or use --force: ' + name)
            target.parent.mkdir(parents=True, exist_ok=True)
            temporary = target.with_name(target.name + '.openleague-download')
            h = hashlib.sha256()
            try:
                with pack.open(name) as source, temporary.open('wb') as output:
                    while chunk := source.read(1024 * 1024):
                        h.update(chunk)
                        output.write(chunk)
                if h.hexdigest() != row['sha256']:
                    raise ValueError('Extracted file checksum mismatch: ' + name)
                os.replace(temporary, target)
            finally:
                if temporary.exists():
                    temporary.unlink()

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--force', action='store_true', help='Replace differing local assets; back them up first')
    parser.add_argument('--verify-only', action='store_true', help='Verify cached packs without changing project assets')
    args = parser.parse_args()
    manifest = json.loads((ROOT / 'assets-manifest.json').read_text(encoding='utf-8'))
    if manifest['schema_version'] != 1:
        raise ValueError('Unsupported manifest version')
    cache = ROOT / '.asset-cache' / manifest['release']
    cache.mkdir(parents=True, exist_ok=True)
    for row in manifest['packs']:
        if Path(row['name']).name != row['name']:
            raise ValueError('Unsafe pack name')
        local = cache / row['name']
        if not local.exists() or local.stat().st_size != row['bytes'] or digest(local) != row['sha256']:
            if args.verify_only:
                raise ValueError('Missing or invalid cached pack: ' + row['name'])
            prefix = 'https://github.com/Louisdelez/OpenLeague/releases/download/'
            if not row['url'].startswith(prefix):
                raise ValueError('Unexpected download origin')
            print('Downloading ' + row['name'], flush=True)
            partial = local.with_suffix('.zip.part')
            request = urllib.request.Request(row['url'], headers={'User-Agent': 'OpenLeague-assets/1'})
            with urllib.request.urlopen(request, timeout=120) as source, partial.open('wb') as output:
                while chunk := source.read(1024 * 1024):
                    output.write(chunk)
            if partial.stat().st_size != row['bytes'] or digest(partial) != row['sha256']:
                partial.unlink()
                raise ValueError('Pack checksum mismatch: ' + row['name'])
            os.replace(partial, local)
        if not args.verify_only:
            restore(ROOT, local, [x for x in manifest['files'] if x['pack'] == row['name']], args.force)
        print('Verified ' + row['name'], flush=True)
    print('Asset verification complete.')

if __name__ == '__main__':
    main()
