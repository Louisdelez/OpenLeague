from pathlib import Path
import json
d=json.loads(Path('E:/mapslol3v3/native_endgame_actions.json').read_text())
def scan(rows):
 for i,a in enumerate(rows):
  if a['op']=='0x8e' and i and rows[i-1]['op']=='0x96':
   values=rows[i-1]['value']
   if any(v in ['doCommand','onRelease','onMouseUp','sendCommand','parseCommand'] for v in values if isinstance(v,str)):print(json.dumps(dict(method=values,body=a['value']['body'])))
  if isinstance(a['value'],dict) and 'body' in a['value']:scan(a['value']['body'])
for r in d:scan(r['actions'])
