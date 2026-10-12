from pathlib import Path
import datetime,shutil,json
r=Path('E:/OpenLeague');stage=Path('E:/mapslol3v3');history=r/'docs/plan_history'/('effect-packets-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));history.mkdir(parents=True)
p=r/'crates/client/src/main.rs';shutil.copy2(p,history/p.name);s=p.read_text(encoding='utf-8');assert 'mod native_hud_effect_packets;' not in s;s=s.replace('mod native_hud_effect_uniforms;','#[allow(dead_code)] // Native Effect packet/render-state port; GPU transport pending.\nmod native_hud_effect_packets;\nmod native_hud_effect_uniforms;');p.write_text(s,encoding='utf-8');shutil.copy2(stage/'native_hud_effect_packets.rs',r/'crates/client/src/native_hud_effect_packets.rs');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
p=r/'data/4.20/native_hud_effect_state_contract.json';d=json.loads(p.read_text(encoding='utf-8'));d['limits'][0]+=' Stack cookie adapted.';p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print('Installed original Effect packet and alpha-state port.')
