"""Read-only format/identity evidence for known runtime asset paths.

Pillow/wave checks do not establish Bevy playback/rendering or historical fidelity.
"""
from pathlib import Path
import hashlib
import sys
import wave
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'pythonlibs'))
from PIL import Image, ImageFont


class AssetEvidenceError(ValueError):
    pass


def identity(path):
    path = Path(path)
    raw = path.read_bytes()
    return {'path': str(path), 'bytes': len(raw), 'sha256': hashlib.sha256(raw).hexdigest()}


def inspect(asset_root, relative):
    root = Path(asset_root).resolve()
    path = (root / relative).resolve()
    try:
        path.relative_to(root)
    except ValueError as exc:
        raise AssetEvidenceError('runtime asset escapes root') from exc
    if not path.is_file():
        raise AssetEvidenceError('runtime asset missing')
    result = {'identity': identity(path), 'relative': str(relative), 'bevy_or_historical_runtime_executed': False}
    try:
        if path.suffix.lower() in ('.png', '.dds'):
            with Image.open(path) as image:
                if image.format != {'.png':'PNG','.dds':'DDS'}[path.suffix.lower()]:
                    raise AssetEvidenceError('extension does not match PNG/DDS content')
                image.verify()
            with Image.open(path) as image:
                rgba = image.convert('RGBA')
                rgba.load()
                result.update(kind=path.suffix.lower()[1:], size=list(rgba.size), rgba_sha256=hashlib.sha256(rgba.tobytes()).hexdigest())
        elif path.suffix.lower() == '.wav':
            with wave.open(str(path), 'rb') as stream:
                channels, width, rate, frames = stream.getnchannels(), stream.getsampwidth(), stream.getframerate(), stream.getnframes()
                raw = stream.readframes(frames)
                if len(raw) != frames * channels * width:
                    raise AssetEvidenceError('truncated PCM frame payload')
                result.update(kind='wav', channels=channels, sample_width=width, rate=rate, frames=frames, compression=stream.getcomptype(), pcm_sha256=hashlib.sha256(raw).hexdigest())
        elif path.suffix.lower() in ('.ttf', '.otf'):
            font = ImageFont.truetype(str(path), 16)
            mask = font.getmask('OpenLeague 0123456789 éèàç', mode='L')
            result.update(kind='font', family_style=list(font.getname()), diagnostic_glyph_mask_size=list(mask.size), diagnostic_glyph_mask_sha256=hashlib.sha256(bytes(mask)).hexdigest(), scope='Pillow FreeType acceptance and a diagnostic glyph mask only')
        elif path.suffix.lower() == '.wgsl':
            text = path.read_text(encoding='utf-8')
            if not text.strip():
                raise AssetEvidenceError('empty shader text')
            result.update(kind='wgsl_source', imports=[line.strip() for line in text.splitlines() if line.strip().startswith('#import')], shader_compiled=False)
        else:
            raise AssetEvidenceError('unsupported runtime asset format')
    except (OSError, ValueError, EOFError, wave.Error) as exc:
        if isinstance(exc, AssetEvidenceError):
            raise
        raise AssetEvidenceError(type(exc).__name__ + ': ' + str(exc)) from exc
    return result
