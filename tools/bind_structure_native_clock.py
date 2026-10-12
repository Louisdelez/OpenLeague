from pathlib import Path
import json,struct,math,datetime,shutil
r=Path('E:/OpenLeague');native=json.loads((r/'data/4.20/structure_clip_period_contract.json').read_text(encoding='utf-8'));lookup={m['model']:m for m in native['models']};manifest=json.loads((r/'data/4.20/world_animation_manifest.json').read_text(encoding='utf-8'));intact=json.loads((r/'docs/intact_structure_animation_binding.json').read_text(encoding='utf-8'));destroyed=json.loads((r/'docs/map10_destroyed_asset_recovery.json').read_text(encoding='utf-8'));selections={m['alias']:m['alias'] for m in intact['records']};selections.update({a['alias']:a['selected_model'] for a in destroyed['aliases']});models={}
f32=lambda v:struct.unpack('<f',struct.pack('<f',v))[0]
for alias,model in selections.items():
 entry=manifest[alias];raw=(r/'assets'/entry['asset']).read_bytes();size=struct.unpack_from('<I',raw,12)[0];g=json.loads(raw[20:20+size]);blob=raw[28+size:];assert len(g['animations'])==1;animation=g['animations'][0];roles={}
 def times(index):
  a=g['accessors'][index];v=g['bufferViews'][a['bufferView']];assert a['componentType']==5126 and a['type']=='SCALAR';start=v.get('byteOffset',0)+a.get('byteOffset',0);return [struct.unpack_from('<f',blob,start+i*v.get('byteStride',4))[0] for i in range(a['count'])]
 all_times=[times(s['input']) for s in animation['samplers']];assert all(t==all_times[0] for t in all_times);t=all_times[0];assert len(t)>1 and t[0]==0;step=t[1];assert all(abs(value-f32(i*step))<1e-6 for i,value in enumerate(t))
 for role,index in entry['roles'].items():
  assert index==0;state=next(s for s in lookup[model]['states'] if s['name']=={'idle':'Idle1','death':'Death','attack':'Attack1'}[role]);assert state['animation_index']==0 and state['frame_start']==0 and state['frame_end']==len(t)-1
  speed=f32(t[-1]/state['native_period_seconds']);assert speed>0 and math.isfinite(speed)
  roles[role]=dict(speed=speed,gltf_time_step=step,gltf_endpoint=t[-1],native_period_seconds=state['native_period_seconds'],native_state=state['name'],native_model=model)
 models[alias]=roles
(r/'data/4.20/structure_clip_playback.json').write_text(json.dumps(dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),complete=False,models=models,limits=['Mapped key counts and evenly spaced exported time samples to original BLND frame end, period and frame clock.','Native state transition, original ANM interpolation and event/loop flags remain unqualified. Existing idle/shared-death repeat selection retained.']),indent=2)+'\n',encoding='utf-8')
p=r/'crates/client/src/main.rs';s=p.read_text(encoding='utf-8');assert 'mod structure_animation_clock;' not in s;p.write_text('mod structure_animation_clock;\n'+s,encoding='utf-8')
p=r/'crates/client/src/animation.rs';s=p.read_text(encoding='utf-8');needle='.play(&mut player, *index, std::time::Duration::ZERO)\n                    .repeat();';assert needle in s;s=s.replace(needle,'.play(&mut player, *index, std::time::Duration::ZERO)\n                    .set_speed(crate::structure_animation_clock::speed(&playback.model_name,"idle"))\n                    .repeat();')
needle='let active = transitions.play(&mut player, index, std::time::Duration::from_millis(80));';assert needle in s;s=s.replace(needle,needle+'\n        active.set_speed(crate::structure_animation_clock::speed(&actor.playback.model_name,role));');p.write_text(s,encoding='utf-8')
print(json.dumps(dict(model_aliases=len(models),role_clocks=sum(len(v) for v in models.values()),speed_examples={a:models[a]['idle']['speed'] for a in ['OrderNexus','TT_OrderInhibitor','TT_OrderTurret1']})))
