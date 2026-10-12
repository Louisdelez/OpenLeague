from pathlib import Path
import shutil,datetime
r=Path('E:/OpenLeague');p=r/'crates/client/src/native_hud_live_probe.rs';s=p.read_text(encoding='utf-8');history=r/'docs/plan_history'/('hud-live-fix-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'));history.mkdir(parents=True);shutil.copy2(p,history/p.name)
s=s.replace('purchase_mana:f32','precast_mana:f32').replace('probe.stage==8','probe.stage==9')
s=s.replace('probe.purchase_mana=player.mana;','')
start=s.index('            4=>');end=s.index('            _=>',start)
s=s[:start]+r'''            4=>{if player.ranks[2]!=1 || player.mana<player.max_mana.ok_or("missing mana capacity")? {return Ok(false);}capture(&mut commands,&mut probe,"precast",snapshot,id)?;}
            5=>{
                if !std::path::Path::new(&format!("{}-precast.png",probe.prefix.as_ref().unwrap())).exists() {return Ok(false);}
                // Request just after the existing fountain interval, so the next ordinary snapshot can expose the cost before sustain restores it.
                let config:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/map10_interactions.json")).map_err(|e|e.to_string())?;
                let period=(config["fountain_interval_seconds"].as_f64().ok_or("missing fountain interval")?*openleague_core::TICK_RATE as f64).round() as u64;
                if period<4 {return Err("unsupported fountain period for capture timing".into());}
                if snapshot.tick%period>period/4 || player.mana<player.max_mana.ok_or("missing mana capacity")? {return Ok(false);}
                probe.precast_mana=player.mana;probe.records.push(serde_json::json!({"kind":"cast_baseline","tick":snapshot.tick,"player":player,"capture_timing_fountain_period_ticks":period}));
                send(&mut connection,&mut probe,Action::Cast{slot:2,target:None},snapshot.tick)?;
            }
            6=>{if player.cooldowns[2]<=snapshot.tick || player.effects.molten_until<=snapshot.tick || player.mana>=probe.precast_mana {return Ok(false);}probe.cast_mana=player.mana;capture(&mut commands,&mut probe,"cast",snapshot,id)?;}
            7=>{if player.mana.floor()<probe.cast_mana.floor()+5.0 || !std::path::Path::new(&format!("{}-cast.png",probe.prefix.as_ref().unwrap())).exists() {return Ok(false);}capture(&mut commands,&mut probe,"regenerated",snapshot,id)?;}
            8=>{if now-probe.since<1.0 || !std::path::Path::new(&format!("{}-regenerated.png",probe.prefix.as_ref().unwrap())).exists() {return Ok(false);}}
'''+s[end:]
s=s.replace('"cast.png","regenerated.png"','"precast.png","cast.png","regenerated.png"')
s=s.replace('"Does not qualify complete Annie kit','"Captures include ordinary base regeneration and existing fountain sustain; original fountain-rule fidelity remains unqualified.","Does not qualify complete Annie kit')
p.write_text(s,encoding='utf-8');print('Added precast capture and real fountain timing; no simulation changes')
