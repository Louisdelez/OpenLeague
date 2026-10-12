"""Recover Map10 Lua literal initialization; native functions are never executed.
Usage: python tools/extract_native_map10.py --deploy <original deploy directory>
"""
from pathlib import Path
import argparse,json,hashlib
from native_lua import Chunk,initialization
parser=argparse.ArgumentParser();parser.add_argument('--deploy',required=True,type=Path);args=parser.parse_args()
root=Path(__file__).resolve().parents[1]
for resource,initial_name,bytecode_name in [
 ('LEVELS/Map10/Scripts/LevelScript.luaobj','map10_native_initialization.json','map10_levelscript_bytecode.json'),
 ('LEVELS/Map10/Scripts/NeutralMinionSpawn.luaobj','map10_native_neutrals.json','map10_native_neutrals_bytecode.json'),
 ('DATA/Shared/Scripts/Minions.luaobj','native_minions_shared.json','native_minions_shared_bytecode.json')]:
 raw=(args.deploy/resource).read_bytes();reader=Chunk(raw);proto=reader.function();assert reader.i==len(raw),'Unexpected bytes after Lua chunk'
 data=initialization(proto);data.update(source_sha256=hashlib.sha256(raw).hexdigest(),native_resource=resource)
 for filename,payload in [(initial_name,data),(bytecode_name,proto)]:
  (root/'data/4.20'/filename).write_text(json.dumps(payload,indent=2),encoding='utf-8')
 print(resource,data['source_sha256'],'stopped:',data['stopped'])
