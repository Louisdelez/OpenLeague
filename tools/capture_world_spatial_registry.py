from pathlib import Path
s=Path('E:/mapslol3v3/capture_grass_live_registry.py').read_text(encoding='utf-8')
s=s.replace('16019','16027').replace('grass-live-215','grass-world-218').replace('docs/grass_live_registry_runtime.json','docs/grass_world_registry_runtime.json')
s=s.replace("m['root_members']==m['registered']", "m['queued_subdivisions']==0")
needle='  receipt=dict('
extra='''  movement=m;deadline=time.monotonic()+120;next_status=0
  world_names=set(json.loads((r/'data/4.20/native_grass_world_model_bounds.json').read_text()))
  while True:
   assert client.poll() is None and server.poll() is None;heartbeats();m=measurement()
   world_objects=[v for v in m['objects'] if v['model'].lower() in world_names] if m else []
   if world_objects and m['error'] is None and m['queued_subdivisions']==0:break
   assert time.monotonic()<deadline,('normal NPC wave registry timeout',m)
   if time.monotonic()>next_status:print(json.dumps(dict(waiting_for_normal_world_spawn=True,registered=m['registered'] if m else None)),flush=True);next_status=time.monotonic()+20
   time.sleep(.1)
'''
assert needle in s;s=s.replace(needle,extra+needle)
s=s.replace('after_movement=m,movement_target=target','after_movement=movement,after_world_spawn=m,registered_world_objects=world_objects,movement_target=target')
s=s.replace('forms/skins/NPC registry and dynamic size producers remain open.','16 world/summon model sources integrated; unresolved structures/altars, additional forms/skins and dynamic size producers remain open.')
s=s.replace("dict(registered=m['registered'],movement_verified=True,capture=str(capture))", "dict(registered=m['registered'],registered_world_models=[v['model'] for v in world_objects],movement_verified=True,capture=str(capture))")
exec(compile(s,'capture-world-spatial-registry','exec'))
