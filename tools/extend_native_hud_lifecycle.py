from pathlib import Path
import shutil, datetime
r=Path('E:/OpenLeague')
p=r/'crates/client/src/native_hud_widgets.rs'
s=p.read_text(encoding='utf-8')
needle='#[cfg(test)] mod tests {'
assert s.count(needle)==1
test=r'''
    // Exercises real simulation operations and the bounded state transport before HUD conversion.
    // This is not a GPU capture or a qualification of original LoL numeric formatting.
    #[test]
    fn health_and_mana_hud_follow_simulation_lifecycle_through_state_transport() {
        use openleague_core::{Action, ServerPacket, Snapshot, Simulation, Navigation, damage::DamageKind};
        fn received(sim:&Simulation)->Snapshot {
            let snapshot=sim.snapshot();
            let mut assembler=openleague_core::wire::StateAssembler::default();
            let mut received=None;
            for bytes in openleague_core::wire::state_datagrams(&snapshot).unwrap() {
                assert!(bytes.len()<=1200);
                if let Some(packet)=assembler.push(&bytes,Some(snapshot.session)) {received=Some(packet);}
            }
            let ServerPacket::State(snapshot)=serde_json::from_slice(&received.unwrap()).unwrap() else {panic!("expected state")};
            snapshot
        }
        fn check(sim:&Simulation,id:u32)->(std::collections::BTreeMap<String,String>,crate::native_hud_bars::Values) {
            let snapshot=received(sim);
            let p=snapshot.players.iter().find(|p|p.id==id).unwrap();
            let texts=snapshot_values(&snapshot,Some(id)).unwrap().unwrap();
            let bars=crate::native_hud_bars::values(&snapshot,Some(id)).unwrap().unwrap();
            assert_eq!(texts["HPStat"],format!("{} / {}",p.health.floor() as u32,p.max_health.floor() as u32));
            assert_eq!(texts["LevelStat"],p.level.to_string());
            assert_eq!(texts["GoldStat"],(p.gold.floor() as u32).to_string());
            assert_eq!(bars.health,(p.health/p.max_health).clamp(0.0,1.0));
            if bars.kind=="Mana" {
                let cap=sim.stats(id).max_mana;
                assert_eq!(p.max_mana,Some(cap));
                assert_eq!(texts["MPStat"],format!("{} / {}",p.mana.floor() as u32,cap.floor() as u32));
                assert_eq!(bars.resource,Some((p.mana/cap).clamp(0.0,1.0)));
            } else {assert!(!texts.contains_key("MPStat"));assert_eq!(bars.resource,None);}
            (texts,bars)
        }
        let root=std::path::PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../..");
        let navigation=Navigation::load(&std::fs::read_to_string(root.join("assets/maps/tt_navigation_grid.json")).unwrap(),&std::fs::read(root.join("assets/maps/tt_navigation_grid.cells.bin")).unwrap()).unwrap();
        let mut sim=Simulation::new(navigation).unwrap();
        let a=sim.join("annie").unwrap();let g=sim.join("garen").unwrap();
        let (start,_)=check(&sim,a);check(&sim,g);
        let cap=sim.stats(a).max_mana;
        sim.command(a,Action::Buy{item:1027}).unwrap();
        let (purchase,bars)=check(&sim,a);
        assert_ne!(start["GoldStat"],purchase["GoldStat"]);assert!(sim.stats(a).max_mana>cap);
        assert!(bars.resource.unwrap()<1.0);
        sim.command(a,Action::Learn{slot:2}).unwrap();
        let mana=sim.players[&a].mana;
        sim.command(a,Action::Cast{slot:2,target:None}).unwrap();
        assert!(sim.players[&a].mana<mana);
        let (cast,cast_bars)=check(&sim,a);assert_ne!(cast["MPStat"],purchase["MPStat"]);
        sim.apply_damage(Some(g),a,150.0,DamageKind::True).unwrap();
        let (hurt,hurt_bars)=check(&sim,a);assert_ne!(hurt["HPStat"],cast["HPStat"]);assert!(hurt_bars.health<1.0);
        let hp=sim.players[&a].health;let mana=sim.players[&a].mana;
        for _ in 0..openleague_core::TICK_RATE {sim.advance();}
        assert!(sim.players[&a].health>hp);assert!(sim.players[&a].mana>mana);
        let (_,regen_bars)=check(&sim,a);assert!(regen_bars.health>hurt_bars.health);assert!(regen_bars.resource>cast_bars.resource);
        sim.heal(Some(a),a,sim.players[&a].max_health).unwrap();
        assert_eq!(check(&sim,a).1.health,1.0);
        sim.award_experience(a,1000.0).unwrap();
        let (grown,_)=check(&sim,a);assert_ne!(grown["LevelStat"],start["LevelStat"]);assert!(sim.stats(a).max_mana>cap);
        sim.apply_damage(Some(g),a,100000.0,DamageKind::True).unwrap();
        assert_eq!(check(&sim,a).1.health,0.0);
        let respawn=sim.players[&a].respawn_at.expect("lethal damage schedules respawn");
        while sim.tick<=respawn {sim.advance();}
        let (_,respawn_bars)=check(&sim,a);assert_eq!(respawn_bars.health,1.0);assert_eq!(respawn_bars.resource,Some(1.0));
        assert_eq!(check(&sim,g).1.resource,None);
    }
'''
assert 'health_and_mana_hud_follow_simulation_lifecycle_through_state_transport' not in s
history=r/'docs/plan_history'/('hud-lifecycle-'+datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%S%fZ'))
history.mkdir(parents=True)
shutil.copy2(p,history/p.name)
p.write_text(s.replace(needle,needle+test),encoding='utf-8')
print('Added simulation/network/HUD lifecycle qualification')
