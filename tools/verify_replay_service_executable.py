from pathlib import Path
import subprocess,json,hashlib,datetime,struct
r=Path('E:/OpenLeague');exe=r/'target/debug/openleague-client.exe';sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
stamp=datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');fixture=r/'logs'/('replay-config-profiles-'+stamp);fixture.mkdir()
baseline=(r/'data/4.20/configuration/defaults/Game.cfg').read_bytes()
def bits(value):return struct.unpack('<I',struct.pack('<f',value))[0]
defaults={'FastForwardSpeed':bits(100),'LagUpdateFreq':bits(1),'MaxLiveTimeBehind':bits(.1),'HeartbeatDelay':bits(.1),'SlowFastForwardSpeed':bits(4),'SpeedupSpeed':bits(1.3)}
user=b'[Replay]\nFastForwardSpeed=8.5\nLagUpdateFreq=2\nDisableCatchup=false\nUseLookAhead=2\n[TournamentPause]\nHeartbeatDelay=.25\n[Hacks]\nDisableFM=true\n[Reconnect]\nPingTimeForReconnectMessage=-7\n'
rows=[]
for name,default_bytes,user_bytes in [('default',baseline,None),('override',baseline,user),('empty',None,b''),('invalid',baseline,b'[Replay]\n\t\t=4\n')]:
 root=fixture/name;default_path=root/'data/4.20/configuration/defaults/Game.cfg';default_path.parent.mkdir(parents=True);config=root/'Config';config.mkdir()
 if default_bytes is not None:default_path.write_bytes(default_bytes)
 if user_bytes is not None:(config/'Game.cfg').write_bytes(user_bytes)
 run=subprocess.run([str(exe),'--native-replay-service-probe',str(root)],cwd=r,text=True,capture_output=True,timeout=45,creationflags=0x08000000)
 (fixture/(name+'.stdout.log')).write_text(run.stdout,encoding='utf-8');(fixture/(name+'.stderr.log')).write_text(run.stderr,encoding='utf-8')
 if name=='invalid':
  assert run.returncode!=0 and 'substring_out_of_range' in run.stderr,(name,run.returncode,run.stderr)
  rows.append({'profile':name,'invalid_configuration_rejected':True,'exit_code':run.returncode});continue
 assert run.returncode==0,(name,run.stderr);actual=json.loads(run.stdout);expected=dict(defaults)
 if name=='override':expected.update(FastForwardSpeed=bits(8.5),LagUpdateFreq=bits(2),HeartbeatDelay=bits(.25))
 s=actual['replay_service'];assert s['float_bits']==expected,(name,s,expected)
 assert s['DisableCatchup']==(0 if name=='override' else 1) and s['UseLookAhead']==1
 assert s['history_mode']==(0xffffffff if name=='override' else 0)
 assert s['PingTimeForReconnectMessage']==(-7 if name=='override' else 5000)
 assert actual['live_allocations_after_close']==0
 assert actual['default_loaded']==(default_bytes is not None) and actual['user_loaded']==bool(user_bytes)
 assert (config/'Game.cfg').read_bytes()==user_bytes if user_bytes is not None else not (config/'Game.cfg').exists()
 rows.append({'profile':name,'exit_code':run.returncode,'state':actual,'baseline_sha256':sha(default_path) if default_path.exists() else None,'user_sha256':sha(config/'Game.cfg') if (config/'Game.cfg').exists() else None})
proof={'passed':True,'complete':False,'client_sha256':sha(exe),'fixture_directory':str(fixture),'cases':rows,'limits':['Real client executable runs its configuration/service diagnostic entry on separate on-disk roots, preserving the project user settings. File parser, configuration provider, actual Rust service constructor and scalar teardown execute.','This diagnostic entry does not initialize Bevy, renderer, networking or a match. Normal graphical startup is separately checked. Typed INIBIN overlays, frame dispatch, live replay streams and complete replay behavior remain open.']}
(r/'docs/replay_service_executable_validation.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'passed':True,'profiles':len(rows),'client_sha256':proof['client_sha256'],'all_successful_profiles_release_allocations':True}))
