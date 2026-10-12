from pathlib import Path
import json,sys,hashlib
r=Path('E:/OpenLeague');v=sys.argv[1];assert v.isalnum()
wire_path=r/f'logs/projected-{v}-dx12-wire.json';log_path=r/f'logs/projected-core-cycle-{v}-receivers-dx12-client.log'
wire=json.loads(wire_path.read_text());replay=next(x['value'] for x in wire if x['kind']=='old_datagrams_replayed');new=replay['new_session']
rows=[];rejected=[]
for line in log_path.read_text(errors='replace').splitlines():
 if 'Ignored retired welcome identity:' in line:rejected.append(line)
 for marker in ['ANNIE_RECEIVE','ANNIE_LIFECYCLE']:
  if marker+' ' in line:rows.append((marker,json.JSONDecoder().raw_decode(line.split(marker+' ',1)[1])[0]))
cut=next(i for i,(k,x) in enumerate(rows) if k=='ANNIE_RECEIVE' and x['session']==new)
assert all(x['session']==new for k,x in rows[cut:]),'old session accepted after new handshake'
assert rejected,'no retired welcome rejection observed'
life=[x for k,x in rows[cut:] if k=='ANNIE_LIFECYCLE']
assert sum(x['kind']=='Appeared' for x in life)==1 and sum(x['kind']=='Disappeared' for x in life)==1
assert all(x.get('context_present') is True for x in life), 'missile lifecycle context missing or ambiguous; tick alone cannot identify a frame'
receipt=json.loads((r/f'docs/projected_batch_{v}.json').read_text());m=receipt['measurement']
assert m['created_effects']==1 and m['active_effects']==0 and m['active_draws']==0
out=dict(complete=False,passed=True,version=v,client_sha256=receipt['client_sha256'],replay=replay,retired_welcome_rejections=len(rejected),new_session_lifecycle=life,source_sha256={str(p.relative_to(r)):hashlib.sha256(p.read_bytes()).hexdigest() for p in [wire_path,log_path]},limits=['Unknown session authentication is not covered.',('Old effect was observed visible before switch; per-effect GPU teardown requires separate atlas verification.' if any(x['kind']=='visible_before_switch' for x in wire) else 'Old-session missile states were queued before visual creation; active old visual teardown remains a separate case.'),'Diagnostic local fixture restart, not full session-service acceptance.'])
(r/f'docs/missile_reconnect_{v}_verified.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out))
