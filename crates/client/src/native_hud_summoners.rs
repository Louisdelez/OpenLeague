//! D/F presentation for the five summoners already implemented by the current core.
//! Layouts/icons are original4.20 bytes. Remaining time is authoritative ready_at;
//! the denominator is the current core's unmodified base-cooldown profile, not a
//! claim that the original4.20 server used it (notably Smite90 and Heal240).
use bevy::prelude::Vec4;
use openleague_core::{Champion, summoners::Spell};

pub(crate) const SLOT_COUNT: usize = 6;
pub(crate) fn catalog() -> &'static serde_json::Value {
    static C: std::sync::OnceLock<serde_json::Value> = std::sync::OnceLock::new();
    C.get_or_init(|| serde_json::from_str(include_str!("../../../data/4.20/native_summoner_hud.json")).unwrap())
}
pub(crate) fn native_name(spell: Spell) -> &'static str {
    match spell { Spell::Barrier => "SummonerBarrier", Spell::Heal => "SummonerHeal",
        Spell::Exhaust => "SummonerExhaust", Spell::Ignite => "SummonerDot", Spell::Smite => "SummonerSmite" }
}
pub(crate) fn layout(slot: usize) -> String {
    assert!(slot < SLOT_COUNT);
    if slot < 4 { format!("CenterHUD_AbilitiesSpell{slot}.ini") }
    else { format!("CenterHUD_AbilitiesSpellSummoner{}.ini", slot - 4) }
}
pub(crate) fn icon_name(slot: usize) -> String {
    assert!(slot < SLOT_COUNT);
    if slot < 4 { format!("Spell{slot}") } else { format!("SummonerSpell{}", slot - 4) }
}
pub(crate) fn effect_name(slot: usize) -> String {
    assert!(slot < SLOT_COUNT);
    if slot < 4 { format!("SpellCooldownFX{slot}") } else { format!("SummonerSpellCooldownFX{}", slot - 4) }
}
pub(crate) fn panel_slot(name: &str) -> usize {
    let local = usize::from(name.as_bytes().last().copied().unwrap() - b'0');
    if name.starts_with("SummonerSpell") { local + 4 } else { local }
}
pub(crate) fn labels() -> Result<[String; 2], String> {
    let binding = |slot| catalog()["bindings"][slot]["binding"].as_str().ok_or("summoner binding missing".to_string()).and_then(crate::spell_input::short_label);
    Ok([binding(0usize)?, binding(1usize)?])
}
pub(crate) fn total_ticks(spell: Spell) -> Result<u64, &'static str> {
    if spell == Spell::Smite { return Ok(openleague_core::summoner_smite::provisional_cooldown_ticks()); }
    let source = match spell {
        Spell::Barrier => include_str!("../../../data/4.20/barrier_rules.json"),
        Spell::Heal => include_str!("../../../data/4.20/heal_rules.json"),
        Spell::Exhaust => include_str!("../../../data/4.20/exhaust_rules.json"),
        Spell::Ignite => include_str!("../../../data/4.20/ignite_rules.json"),
        Spell::Smite => unreachable!(),
    };
    #[derive(serde::Deserialize)] struct Cooldown { cooldown_seconds: f32 }
    let seconds = serde_json::from_str::<Cooldown>(source).map_err(|_| "summoner base cooldown profile invalid")?.cooldown_seconds;
    if !seconds.is_finite() || seconds <= 0.0 { return Err("summoner base cooldown profile invalid"); }
    Ok(openleague_core::spells::seconds(seconds))
}
/// Gameplay range is the current core contract, not the client INIBIN acquisition field.
pub(crate) fn range(spell: Spell) -> Option<f32> {
    match spell { Spell::Barrier => None, Spell::Heal => Some(openleague_core::summoner_heal::range()),
        Spell::Exhaust => Some(openleague_core::summoner_exhaust::range()),
        Spell::Ignite => Some(openleague_core::summoner_ignite::range()),
        Spell::Smite => Some(openleague_core::summoner_smite::range()) }
}
pub(crate) fn states(player: &Champion, tick: u64) -> Result<[u32; 2], String> {
    if !player.health.is_finite() { return Err("invalid authoritative summoner health".into()); }
    let mut result = [1; 2];
    for (slot, spell) in player.summoners.spells.iter().enumerate() {
        let Some(spell) = spell else { continue; };
        let allowed = player.health > 0.0 && (!openleague_core::stuns::active(player, tick)
            || openleague_core::stuns::allows_disabled(native_name(*spell))?);
        let remaining = player.summoners.ready_at[slot].saturating_sub(tick) as f32 / openleague_core::TICK_RATE as f32;
        result[slot] = crate::native_hud_spells::state(true, remaining, 1, allowed, 0);
    }
    Ok(result)
}
pub(crate) fn all_states(player: &Champion, tick: u64) -> Result<[u32; SLOT_COUNT], String> {
    let q = crate::native_hud_spells::player_states(player, tick)?;
    let s = states(player, tick)?;
    Ok([q[0], q[1], q[2], q[3], s[0], s[1]])
}
pub(crate) fn recharge(player: &Champion, tick: u64) -> Result<[Option<Vec4>; SLOT_COUNT], &'static str> {
    let q = crate::native_hud_recharge::player_params(player, tick)?;
    let mut result = [q[0], q[1], q[2], q[3], None, None];
    for (slot, spell) in player.summoners.spells.iter().enumerate() {
        let Some(spell) = spell else { continue; };
        let remaining = player.summoners.ready_at[slot].saturating_sub(tick);
        if remaining == 0 { continue; }
        let total = total_ticks(*spell)?;
        if remaining > total { return Err("summoner cooldown exceeds current unmodified profile"); }
        result[slot + 4] = Some(crate::native_hud_recharge::angle(remaining as f32 / openleague_core::TICK_RATE as f32, total as f32 / openleague_core::TICK_RATE as f32)?);
    }
    Ok(result)
}
pub(crate) fn cooldown(player: &Champion, slot: usize) -> Result<(u64, Option<u64>), &'static str> {
    if slot < 4 { return Ok((player.cooldowns[slot], player.cooldown_totals[slot])); }
    let slot = slot.checked_sub(4).filter(|s| *s < 2).ok_or("summoner slot outside HUD")?;
    let total = player.summoners.spells[slot].map(total_ticks).transpose()?;
    Ok((player.summoners.ready_at[slot], total))
}
pub(crate) fn trace(player: &Champion, tick: u64) -> serde_json::Value {
    serde_json::Value::Array(player.summoners.spells.iter().enumerate().map(|(slot, spell)| serde_json::json!({
        "slot":slot,"spell":spell,"native_name":spell.map(native_name),
        "ready_at":player.summoners.ready_at[slot],"remaining_ticks":player.summoners.ready_at[slot].saturating_sub(tick),
        "base_profile_total_ticks":spell.and_then(|s|total_ticks(s).ok()),"current_core_range":spell.and_then(range),
        "total_source":"current core unmodified base profile; not snapshot total or original-server qualification"
    })).collect())
}

#[cfg(test)] mod tests {
    use super::*;
    fn game() -> (openleague_core::Simulation, u32) {
        let nav = openleague_core::Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"), include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap();
        let mut sim = openleague_core::Simulation::new(nav).unwrap();
        let id = sim.join_with_summoners("garen", [Some(Spell::Barrier), Some(Spell::Heal)]).unwrap();
        (sim, id)
    }
    #[test] fn five_exact_original_dds_and_source_bindings_cover_only_existing_enum() {
        let root = std::path::Path::new(env!("CARGO_MANIFEST_DIR")).join("../..");
        let entries = catalog()["entries"].as_array().unwrap(); assert_eq!(entries.len(), 5);
        for spell in [Spell::Barrier, Spell::Heal, Spell::Exhaust, Spell::Ignite, Spell::Smite] {
            let matches: Vec<_> = entries.iter().filter(|e|e["native_name"] == native_name(spell)).collect(); assert_eq!(matches.len(), 1);
            let entry = matches[0]; let bytes = std::fs::read(root.join("assets").join(entry["asset"].as_str().unwrap())).unwrap();
            assert_eq!(bytes.len() as u64, entry["bytes"].as_u64().unwrap());
            let image = crate::native_hud_atlases::decode(&bytes, bevy::image::CompressedImageFormats::BC).unwrap();
            assert_eq!(image.data.as_deref(), Some(&bytes[128..]));
            assert_eq!(image.texture_descriptor.size.width, 64); assert_eq!(image.texture_descriptor.size.height, 64);
            assert_eq!(entry["fields"]["CanCastWhileDisabled"]["value"], 1);
            assert!(openleague_core::stuns::allows_disabled(native_name(spell)).unwrap());
        }
        assert_eq!(labels().unwrap(), ["d", "f"].map(str::to_string));
        assert_eq!(range(Spell::Barrier), None); assert_eq!(range(Spell::Heal), Some(850.0));
        assert_eq!(range(Spell::Smite), Some(760.0));
    }
    #[test] fn real_barrier_cast_drives_icon_text_ring_and_second_cast_rejection() {
        let (mut sim, id) = game();
        assert_eq!(states(&sim.players[&id], sim.tick).unwrap(), [0, 0]);
        sim.cast_summoner(id, 0).unwrap(); let end = sim.players[&id].summoners.ready_at[0];
        assert_eq!(end, total_ticks(Spell::Barrier).unwrap());
        assert_eq!(states(&sim.players[&id], sim.tick).unwrap(), [4, 0]);
        let params = recharge(&sim.players[&id], sim.tick).unwrap(); assert!(params[4].is_some()); assert_eq!(params[5], None);
        let values = crate::native_hud_widgets::snapshot_values(&sim.snapshot(), Some(id)).unwrap().unwrap();
        assert_eq!(values["SummonerSpellHotKey0"], "d"); assert_eq!(values["SummonerSpellHotKey1"], "f");
        assert!(values.contains_key("SummonerSpellCooldown0")); assert!(!values.contains_key("SummonerSpellCooldown1"));
        assert!(sim.cast_summoner(id, 0).is_err()); assert_eq!(sim.players[&id].summoners.ready_at[0], end);
        // Pure projection at observed ready_at: not an accelerated runtime or mutated server clock.
        assert_eq!(states(&sim.players[&id], end).unwrap(), [0, 0]);
        assert_eq!(recharge(&sim.players[&id], end).unwrap(), [None; 6]);
    }
    #[test] fn every_loadout_state_stun_and_profile_is_explicit() {
        let (mut sim, id) = game(); sim.grant_stun(None, id, "fixture", 30).unwrap();
        for (spell, seconds) in [(Spell::Barrier,210), (Spell::Heal,240), (Spell::Exhaust,210), (Spell::Ignite,180), (Spell::Smite,90)] {
            let mut p = sim.players[&id].clone(); p.summoners.spells = [Some(spell), None];
            p.summoners.ready_at = [0, 0]; assert_eq!(states(&p, 0).unwrap(), [0, 1]);
            assert_eq!(total_ticks(spell).unwrap(), seconds * openleague_core::TICK_RATE);
            let total = total_ticks(spell).unwrap(); p.summoners.ready_at[0] = total;
            assert_eq!(states(&p, 0).unwrap(), [4, 1]);
            assert_eq!(recharge(&p, total/2).unwrap()[4], Some(crate::native_hud_recharge::angle((total-total/2) as f32/openleague_core::TICK_RATE as f32, total as f32/openleague_core::TICK_RATE as f32).unwrap()));
            p.summoners.ready_at[0] += 1; assert!(recharge(&p, 0).is_err());
            p.summoners.ready_at[0] = 0; p.health = 0.; assert_eq!(states(&p, 0).unwrap(), [3, 1]);
            p.health = f32::NAN; assert!(states(&p, 0).is_err());
        }
    }
    #[test] fn qwer_values_and_original_names_remain_separate() {
        let (sim, id) = game(); let p = &sim.players[&id];
        assert_eq!(&all_states(p, 0).unwrap()[..4], &crate::native_hud_spells::player_states(p,0).unwrap());
        assert_eq!(&recharge(p,0).unwrap()[..4], &crate::native_hud_recharge::player_params(p,0).unwrap());
        assert_eq!(layout(4), "CenterHUD_AbilitiesSpellSummoner0.ini"); assert_eq!(layout(5), "CenterHUD_AbilitiesSpellSummoner1.ini");
        assert_eq!(icon_name(4), "SummonerSpell0"); assert_eq!(effect_name(5), "SummonerSpellCooldownFX1");
        assert_eq!(panel_slot("SummonerSpellOverlay1"), 5); assert_eq!(panel_slot("SpellOverlay3"), 3);
    }
}
