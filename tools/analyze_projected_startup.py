from pathlib import Path
import json,sys,hashlib
r=Path('E:/OpenLeague');version=sys.argv[1];assert version.isalnum()
client_path=r/f'logs/projected-core-cycle-{version}-receivers-dx12-client.log';wire_path=r/f'logs/projected-{version}-dx12-wire.json'
client=[];received=[];lifecycle=[]
for line in client_path.read_text(encoding='utf-8',errors='replace').splitlines():
 if 'ANNIE_STARTUP ' in line:client.append(json.JSONDecoder().raw_decode(line.split('ANNIE_STARTUP ',1)[1])[0])
 if 'ANNIE_LIFECYCLE ' in line:lifecycle.append(json.JSONDecoder().raw_decode(line.split('ANNIE_LIFECYCLE ',1)[1])[0])
 if 'ANNIE_RECEIVE ' in line:received.append(json.JSONDecoder().raw_decode(line.split('ANNIE_RECEIVE ',1)[1])[0])
assert client,'No client startup diagnostic rows'
wire=json.loads(wire_path.read_text());states=[row['value'] for row in wire if row['kind']=='state']
def key(m):return (m['source'],m['target'],m['cooldown_ready'])
identities=sorted({key(m) for s in states for m in s['spell_projectiles']}|{key(m) for s in client for m in s['missiles']}|{key(m) for s in received for m in s['missiles']})
results=[]
for identity in identities:
 observed=[s for s in client if any(key(m)==identity for m in s['missiles'])]
 wire_ticks=[s['tick'] for s in states if any(key(m)==identity for m in s['spell_projectiles'])]
 missing_neck=[s['tick'] for s in observed if not any(a['id']==identity[0] and a['neck'] for a in s['sources'])]
 missing_target=[s['tick'] for s in observed if any(key(m)==identity and not m['target_present'] for m in s['missiles'])]
 existing=[s['tick'] for s in observed if any(key(m)==identity and m['flight_exists'] for m in s['missiles'])]
 results.append(dict(identity=identity,wire_ticks=wire_ticks,accepted_client_ticks=[s['tick'] for s in received if any(key(m)==identity for m in s['missiles'])],client_ticks=[s['tick'] for s in observed],missing_neck_ticks=missing_neck,missing_target_ticks=missing_target,existing_flight_ticks=existing,lifecycle=[x for x in lifecycle if key(x)==identity]))
report=dict(complete=False,lifecycle_rows=len(lifecycle),lifecycle_missing_context=[x for x in lifecycle if x.get("context_present") is False],lifecycle_ambiguous_context=[x for x in lifecycle if x.get("context_present") is None],client_snapshot_rows=len(client),accepted_snapshot_rows=len(received),server_rejections=[x['value'] for x in wire if x['kind']=='rejected'],projectiles=results,max_created_flights=max(s['flights_created'] for s in client),source_hashes={str(p.relative_to(r)):hashlib.sha256(p.read_bytes()).hexdigest() for p in [client_path,wire_path]},limits=['Wire harness and graphical client use separate sockets and can receive different snapshot ticks.','Missing observations alone do not establish UDP loss; the client may replace snapshots between rendering updates.','This reports observations, not a proven cause for the earlier v49 failure.','Multiple accepted frames can share one tick; an ambiguous context is not proof of a dropped snapshot or a rendering failure.'])
(r/f'docs/projected_startup_{version}_analysis.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
