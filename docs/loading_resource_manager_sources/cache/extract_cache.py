"""Read pinned PE and extract cache dependencies; output only this scratch lot."""
from pathlib import Path
import sys, importlib.util, json
sys.dont_write_bytecode = True
SOURCE_HELPER = Path(r'E:\mapslol3v3\loading_standard_resource_next\extract_resource.py')
spec = importlib.util.spec_from_file_location('frozen_resource_extractor', SOURCE_HELPER)
module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)
EXE, raw, digest, pe, image, BASE, read = module.EXE, module.raw, module.digest, module.pe, module.image, module.BASE, module.read
OUT = Path(__file__).resolve().parent
ENTRIES = [
    ('provider_lookup', 0x90ad00, 0x100),
    ('normalized_key_copy', 0x99a310, 0x70),
    ('lowercase_copy', 0x5fa650, 0x60),
    ('crt_tolower', 0xc98719, 0x30),
    ('cache_lower_bound', 0x90d220, 0x100),
    ('cache_key_less', 0x901f00, 0x70),
    ('string_compare_range', 0x5fa720, 0x100),
    ('bytes_compare', 0x5fa6b0, 0x70),
    ('string_reset_destroy', 0x564900, 0x60),
]
if __name__ == '__main__':
    regions, texts = [], []
    for entry in ENTRIES:
        region, text = module.walk(*entry)
        regions.append(region); texts.append(text)
    (OUT/'source_cache_regions.json').write_text(json.dumps({'source': str(EXE), 'source_sha256': digest, 'regions': regions}, indent=2)+'\n', encoding='utf-8')
    (OUT/'source_cache_functions.txt').write_text('\n\n'.join(texts)+'\n', encoding='utf-8')
    print(json.dumps({'regions': len(regions), 'outside_edges': [(r['role'], r['edges']) for r in regions if r['edges']]}))
