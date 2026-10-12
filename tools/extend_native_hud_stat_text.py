from pathlib import Path
r=Path('E:/OpenLeague');p=r/'crates/client/src/native_hud_widgets.rs';s=p.read_text(encoding='utf-8');assert 'name==b"HPStat"' not in s
s=s.replace('//! Three original map10 Text widgets','//! Five original map10 Text widgets')
s=s.replace('(layout.request.ends_with("ShadowIslesTitanBar.ini") && name==b"GameTime")','(layout.request.ends_with("ShadowIslesTitanBar.ini") && name==b"GameTime") || (layout.request.ends_with("CenterHUD_HealthBar.ini") && name==b"HPStat") || (layout.request.ends_with("CenterHUD_PARBar.ini") && name==b"MPStat")')
s=s.replace('widgets.len()!=3','widgets.len()!=5').replace('live.widgets.len()!=3','live.widgets.len()!=5').replace('original GameTime/GoldStat/LevelStat definitions','original GameTime/GoldStat/LevelStat/HPStat/MPStat definitions')
old='    Ok(Some(std::collections::BTreeMap::from([("GameTime".into(),format!("{}:{:02}",seconds/60,seconds%60)),("GoldStat".into(),format!("{}",player.gold.floor() as u32)),("LevelStat".into(),player.level.to_string())])))'
assert old in s
s=s.replace(old,'''    let counter=|v:f32|->Result<u32,String> {if !v.is_finite() || v<0.0 || v as f64>u32::MAX as f64 {return Err("HUD health/resource number outside supported unsigned32 range".into());}Ok(v.floor() as u32)};
    let bars=crate::native_hud_bars::values(snapshot,id)?.ok_or("authoritative player disappeared")?;
    let mut values=std::collections::BTreeMap::from([("GameTime".into(),format!("{}:{:02}",seconds/60,seconds%60)),("GoldStat".into(),format!("{}",player.gold.floor() as u32)),("LevelStat".into(),player.level.to_string()),("HPStat".into(),format!("{} / {}",counter(player.health)?,counter(player.max_health)?))]);
    if bars.kind=="Mana" {values.insert("MPStat".into(),format!("{} / {}",counter(player.mana)?,counter(player.max_mana.ok_or("authoritative mana capacity missing")?)?));}
    Ok(Some(values))''')
s=s.replace('let text=values.get(&widget.name).ok_or("widget value missing")?.as_bytes();','let Some(text)=values.get(&widget.name) else {continue;};let text=text.as_bytes();')
s=s.replace('live.widgets.iter_mut().map(|w|&mut w.storage)','live.widgets.iter_mut().filter(|w|values.contains_key(&w.name)).map(|w|&mut w.storage)')
s=s.replace('"packed_color":w.storage.word(0x1dc)','"packed_color":w.storage.word(0x1dc),"active":values.contains_key(&w.name)')
s=s.replace('Three Text widgets only; original formatter','Five source Text widgets; HP/MP floor current / maximum is engine-owned and mana text hidden for non-mana champions. Original formatter')
s=s.replace('assert_eq!(widgets.len(),3);','assert_eq!(widgets.len(),5);').replace('assert_eq!(widget.storage.flags(),1);','assert_eq!(widget.storage.flags(),if matches!(widget.name.as_str(),"HPStat"|"MPStat") {0x11}else {1});')
marker='    #[test] fn authoritative_snapshot_values_follow_gold_level_time_and_missing_player() {'
assert marker in s
test='''    #[test] fn health_mana_numbers_follow_real_snapshots_and_absence_never_becomes_zero_capacity() {
        let root=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");let navigation=openleague_core::Navigation::load(&std::fs::read_to_string(root.join("assets/maps/tt_navigation_grid.json")).unwrap(),&std::fs::read(root.join("assets/maps/tt_navigation_grid.cells.bin")).unwrap()).unwrap();let mut simulation=openleague_core::Simulation::new(navigation).unwrap();let a=simulation.join("ahri").unwrap();let g=simulation.join("garen").unwrap();let mut snapshot=simulation.snapshot();
        let values=snapshot_values(&snapshot,Some(g)).unwrap().unwrap();assert!(values.contains_key("HPStat"));assert!(!values.contains_key("MPStat"));
        let p=snapshot.players.iter_mut().find(|p|p.id==a).unwrap();p.health=123.75;p.max_health=456.5;p.mana=12.5;p.max_mana=Some(300.25);let values=snapshot_values(&snapshot,Some(a)).unwrap().unwrap();assert_eq!(values["HPStat"],"123 / 456");assert_eq!(values["MPStat"],"12 / 300");
        let p=snapshot.players.iter_mut().find(|p|p.id==a).unwrap();p.max_mana=None;assert!(snapshot_values(&snapshot,Some(a)).is_err());let p=snapshot.players.iter_mut().find(|p|p.id==a).unwrap();p.max_mana=Some(300.25);p.health=f32::NAN;assert!(snapshot_values(&snapshot,Some(a)).is_err());
    }
'''
s=s.replace(marker,test+marker);p.write_text(s,encoding='utf-8');print('Source HPStat/MPStat integrated; current/max floor formatter explicit; no-mana/unknown handled')
