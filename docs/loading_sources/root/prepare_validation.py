from pathlib import Path
import json,hashlib
S=Path(__file__).resolve().parent;R=Path('E:/OpenLeague')
source=(R/'tools/run_replay_receive_probes.ps1').read_text(encoding='utf-8').replace('client-replay-receive-','client-loading-')
(S/'run_loading_probes.ps1').write_text(source,encoding='utf-8')
