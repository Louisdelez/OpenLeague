from pathlib import Path
import json
r=Path('E:/OpenLeague')
for version in ['v14-native-dx12','v15-native-vulkan']:
 p=json.loads((r/'logs'/('projected-core-cycle-'+version+'-pipeline.json')).read_text())
 frames=p['frames'];bad=[f for f in frames if any(s!='ready' for d in f['draws'] for s in d['pipeline_states'])]
 print(json.dumps(dict(version=version,frames=len(frames),non_ready=len(bad),fow_unbound=sum(any(d['fow_ready']!=1 for d in f['draws']) for f in frames))))
