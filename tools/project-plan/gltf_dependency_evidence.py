"""Read-only glTF dependency evidence for explicitly selected local assets.

Checks buffer/image URI references and buffer-view ranges. This is not a Bevy
load, codec/GPU validation, or complete dynamic dependency closure.
"""
from pathlib import Path
import base64
import hashlib
import json
import struct
from urllib.parse import urlsplit, unquote


class DependencyError(ValueError):
    pass


def identity(path):
    path = Path(path)
    h = hashlib.sha256()
    with path.open('rb') as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b''):
            h.update(block)
    return {'path': str(path), 'bytes': path.stat().st_size, 'sha256': h.hexdigest()}


def local_reference(asset_root, parent, uri):
    parts = urlsplit(uri)
    if parts.scheme or parts.netloc or parts.query or parts.fragment or '\\' in uri:
        raise DependencyError('unsupported external URI or URI syntax')
    decoded = unquote(parts.path, encoding='utf-8', errors='strict')
    if not decoded or '\x00' in decoded or '\\' in decoded:
        raise DependencyError('invalid local resource URI')
    target = (Path(parent) / decoded).resolve()
    try:
        target.relative_to(Path(asset_root).resolve())
    except ValueError as exc:
        raise DependencyError('resource URI escapes asset root') from exc
    return target


def document(path):
    path = Path(path)
    if path.suffix.lower() == '.gltf':
        return json.loads(path.read_bytes()), None
    if path.suffix.lower() != '.glb':
        raise DependencyError('unsupported model container')
    raw = path.read_bytes()
    if len(raw) < 20:
        raise DependencyError('truncated GLB header')
    magic, version, length = struct.unpack_from('<4sII', raw)
    if magic != b'glTF' or version != 2 or length != len(raw):
        raise DependencyError('GLB header identity/length mismatch')
    offset = 12
    chunks = []
    while offset < length:
        if offset + 8 > length:
            raise DependencyError('truncated GLB chunk header')
        size, kind = struct.unpack_from('<II', raw, offset)
        offset += 8
        if size % 4 or offset + size > length:
            raise DependencyError('GLB chunk length/alignment mismatch')
        chunks.append((kind, raw[offset:offset + size]))
        offset += size
    if not chunks or chunks[0][0] != 0x4e4f534a:
        raise DependencyError('first GLB chunk is not JSON')
    if any(kind not in (0x4e4f534a, 0x004e4942) for kind, _ in chunks):
        raise DependencyError('unqualified GLB extension chunk')
    if sum(kind == 0x4e4f534a for kind, _ in chunks) != 1 or sum(kind == 0x004e4942 for kind, _ in chunks) > 1:
        raise DependencyError('duplicate GLB chunks')
    binary = next((data for kind, data in chunks if kind == 0x004e4942), None)
    return json.loads(chunks[0][1]), binary


def inspect(asset_root, path):
    asset_root = Path(asset_root).resolve()
    path = Path(path).resolve()
    try:
        path.relative_to(asset_root)
    except ValueError as exc:
        raise DependencyError('model escapes asset root') from exc
    doc, binary = document(path)
    if doc.get('asset', {}).get('version') != '2.0':
        raise DependencyError('unqualified glTF asset version')
    external = {}
    inline = []

    def payload(uri, role):
        if uri.startswith('data:'):
            header, separator, body = uri.partition(',')
            if not separator or not header.endswith(';base64'):
                raise DependencyError('unsupported inline data URI')
            try:
                value = base64.b64decode(body, validate=True)
            except ValueError as exc:
                raise DependencyError('invalid base64 resource') from exc
            inline.append({'role': role, 'bytes': len(value), 'sha256': hashlib.sha256(value).hexdigest()})
            return value
        target = local_reference(asset_root, path.parent, uri)
        if not target.is_file():
            raise DependencyError('missing external dependency: ' + str(target))
        external[str(target)] = identity(target)
        return target.read_bytes()

    buffers = []
    for i, item in enumerate(doc.get('buffers', [])):
        data = payload(item['uri'], 'buffer/' + str(i)) if 'uri' in item else binary if i == 0 else None
        size = item.get('byteLength')
        if data is None or type(size) is not int or size < 0 or len(data) < size:
            raise DependencyError('missing/truncated buffer')
        buffers.append((data, size))
    views = doc.get('bufferViews', [])
    for item in views:
        index, offset, size = item.get('buffer'), item.get('byteOffset', 0), item.get('byteLength')
        if type(index) is not int or not 0 <= index < len(buffers) or type(offset) is not int or type(size) is not int or min(offset, size) < 0 or offset + size > buffers[index][1]:
            raise DependencyError('bufferView outside declared buffer')
    images = []
    for i, item in enumerate(doc.get('images', [])):
        if ('uri' in item) == ('bufferView' in item):
            raise DependencyError('ambiguous/missing image storage')
        if 'uri' in item:
            data = payload(item['uri'], 'image/' + str(i))
            storage = 'data_uri' if item['uri'].startswith('data:') else 'external_file'
        else:
            index = item['bufferView']
            if type(index) is not int or not 0 <= index < len(views):
                raise DependencyError('image bufferView index outside table')
            view = views[index]
            offset = view.get('byteOffset', 0)
            data = buffers[view['buffer']][0][offset:offset + view['byteLength']]
            storage = 'buffer_view'
        images.append({'index': i, 'storage': storage, 'bytes': len(data), 'sha256': hashlib.sha256(data).hexdigest(), 'mimeType': item.get('mimeType')})
    return {
        'schema': 'openleague_gltf_dependency_evidence/v1', 'model': identity(path),
        'buffer_count': len(buffers), 'buffer_views_checked': len(views), 'images': images,
        'external_dependencies': list(external.values()), 'inline_resources': inline,
        'scenes': len(doc.get('scenes', [])), 'animations': len(doc.get('animations', [])),
        'extensions_used_not_semantically_validated': doc.get('extensionsUsed', []),
        'scope': 'Buffer/image storage references and byte ranges only; selected local model.',
        'codec_or_gpu_validated': False, 'complete_dynamic_closure': False,
    }
