"""Create the generic integration stage only; never edit production/frozen lots."""
from pathlib import Path
import hashlib,json,shutil
ROOT=Path(__file__).resolve().parent
PROD=Path('E:/OpenLeague/crates/core/src')
FROZEN=Path('E:/mapslol3v3/loading_standard_prefix_port')
OWNED=Path('E:/mapslol3v3/loading_string24_ownership_repair')
files={
 'audio_loading_owned_string.rs':OWNED,
 'audio_loading_owned_string_tests.rs':OWNED,
 'audio_loading_screen_packet.rs':PROD,
 'audio_loading_screen_packet_tests.rs':PROD,
 'audio_loading_standard_prefix.rs':FROZEN,
 'audio_loading_standard_prefix_tests.rs':FROZEN,
}
baseline={}
for name,source in files.items():
    data=(source/name).read_bytes()
    baseline[name]={'path':str(source/name),'bytes':len(data),'sha256':hashlib.sha256(data).hexdigest()}
    (ROOT/name).write_bytes(data)
(ROOT/'baseline.json').write_text(json.dumps(baseline,indent=2)+'\n')
