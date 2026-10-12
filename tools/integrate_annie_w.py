from pathlib import Path
import json,shutil,hashlib,datetime
r=Path('E:/OpenLeague')
def edit(p,a,b):
 f=r/p;s=f.read_text(encoding='utf-8');assert a in s,(p,a);f.write_text(s.replace(a,b),encoding='utf-8')
src=json.loads((r/'docs/annie_w_native_contract.json').read_text(encoding='utf-8'));v=src['values'];d={'range':float(v['CastConeDistance']),'half_angle':float(v['CastConeAngle']),'coefficient':float(v['Coefficient']),'cooldown':float(v['Cooldown1']),'cast_seconds':(1+v['DelayCastOffsetPercent'])*.5}
for rank in range(1,6):d[f'cost{rank}']=float(v[f'ManaCost{rank}']);d[f'damage{rank}']=float(v[f'Effect1Level{rank}Amount'])
(r/'data/4.20/annie_w_rules.json').write_text(json.dumps(d,indent=2)+'\n',encoding='utf-8')
shutil.copyfile('E:/mapslol3v3/annie_w.rs',r/'crates/core/src/annie_w.rs')
edit('crates/core/src/annie_w.rs','!(0. ..90.).contains(&half_angle)','half_angle<=0. || half_angle>=90.')
edit('crates/core/src/lib.rs','pub mod annie;','pub mod annie;\npub mod annie_w;')
edit('crates/core/src/lib.rs','    Cast { slot: u8, target: Option<u32> },','    Cast { slot: u8, target: Option<u32> },\n    CastAt { slot: u8, point: Point },')
edit('crates/core/src/lib.rs','Action::Cast { slot, target } => self.cast(id, slot, target)?,','Action::Cast { slot, target } => self.cast(id, slot, target)?,\n            Action::CastAt {slot,point} => self.cast_at(id,slot,point)?,')
edit('crates/core/src/lib.rs','self.advance_annie();','self.advance_annie();\n        self.advance_annie_w();')
edit('crates/core/src/lib.rs','p.effects.annie_q.is_some() || p.windup.is_some()','p.effects.annie_q.is_some() || p.effects.annie_w.is_some() || p.windup.is_some()')
edit('crates/core/src/combat.rs','p.effects.ultimate.is_some() || p.windup.is_some()','p.effects.ultimate.is_some() || p.effects.annie_q.is_some() || p.effects.annie_w.is_some() || p.windup.is_some()')
edit('crates/core/src/attacks.rs','p.effects.annie_q.is_some() || self.tick','p.effects.annie_q.is_some() || p.effects.annie_w.is_some() || self.tick')
edit('crates/core/src/spells.rs','pub struct Effects {','pub struct Effects {\n    #[serde(default)]\n    pub annie_w: Option<annie_w::Pending>,')
edit('crates/core/src/annie.rs','if slot==2 {return self.cast_molten(id);}','if slot==2 {return self.cast_molten(id);}\n  if slot==1 {return Err("directional spell requires ground point".into());}')
edit('crates/core/src/annie.rs','if p.effects.annie_q.is_some() {','if p.effects.annie_q.is_some() || p.effects.annie_w.is_some() {')
(r/'crates/client/src/spell_input.rs').write_text('pub fn ground_target(champion:&str,slot:u8)->bool {champion=="annie"&&slot==1}\n#[cfg(test)] mod tests {#[test] fn only_qualified_directional_slot_routes_to_ground(){assert!(super::ground_target("annie",1));for (c,s) in [("garen",1),("annie",0),("annie",2),("annie",3),("ahri",1)] {assert!(!super::ground_target(c,s));}}}\n',encoding='utf-8')
edit('crates/client/src/main.rs','mod shop_ui;','mod shop_ui;\nmod spell_input;')
edit('crates/client/src/main.rs','    let targeted_skill=skill==Some(3)||targeted_q;','    let ground_skill=skill.is_some_and(|slot|state.snapshot.as_ref().and_then(|s|s.players.iter().find(|p|Some(p.id)==connection.id)).is_some_and(|p|spell_input::ground_target(&p.champion,slot)));\n    let targeted_skill=skill==Some(3)||targeted_q||ground_skill;')
edit('crates/client/src/main.rs','skill.filter(|slot| *slot != 3 && !targeted_q)','skill.filter(|slot| *slot != 3 && !targeted_q && !ground_skill)')
edit('crates/client/src/main.rs','if target.is_none() && !targeted_skill {','if ground_skill || (target.is_none() && !targeted_skill) {')
edit('crates/client/src/main.rs','Some(if targeted_skill {','Some(if ground_skill {Action::CastAt{slot:skill.unwrap(),point}} else if targeted_skill {')
edit('crates/client/src/main.rs','Q/W/E/R : lancer (R sur la cible)','Q/W/E/R : lancer (sorts ciblés sous le curseur)')
# Loaded native clip roles, driven by replicated committed cast state.
edit('crates/client/src/animation.rs','champion.destination.is_some() && !openleague_core::stuns::active(champion,snapshot.tick)','champion.destination.is_some() && champion.effects.annie_q.is_none() && champion.effects.annie_w.is_none() && !openleague_core::stuns::active(champion,snapshot.tick)')
edit('crates/client/src/animation.rs','                    openleague_core::stuns::active(champion,snapshot.tick),','                    openleague_core::stuns::active(champion,snapshot.tick),\n                    if champion.effects.annie_q.is_some() {Some("spell1")} else if champion.effects.annie_w.is_some() {Some("spell2")} else {None},')
edit('crates/client/src/animation.rs','                            None,\n                            false,\n                            false,','                            None,\n                            false,\n                            false,\n                            None,')
edit('crates/client/src/animation.rs','critical, champion, stunned))','critical, champion, stunned, cast_role))')
edit('crates/client/src/animation.rs','        } else if stunned {','        } else if let Some(role)=cast_role {role\n        } else if stunned {')
paths=[Path('D:/LeagueOfLegendsV2/4.20/GameServer/GameServerLib/GameObjects')/p for p in ['Spell/Sector/SpellSectorCone.cs','AttackableUnits/AI/ObjAIBase.cs']]
receipt={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'complete':False,'native_contract':'docs/annie_w_native_contract.json','community_geometry_sources':[{'source':str(p),'sha256':hashlib.sha256(p.read_bytes()).hexdigest()} for p in paths],'limits':['Native damage70/115/160/205/250+0.85AP,cost70..110,8secondCD,625cone length and24.76angle recovered;21Riot4.20.1 comparisons passed. Community damage/AP errors overridden with native values.','Community cone filter interprets angle as half angle and uses body bounds. Exact circle-sector contact is reconstructed; native33explicit champion gameplay radii used,89missing use only this cone explicit community ObjAIBase fallback40. Profile nulls unchanged; no selection/pathfinding radius substitution.','Cast duration/community0.25sec ceiling8ticks, cast-time AP/mana/CD snapshots, fixed cast direction with resolution-time origin/targets, groundaim beyond range, undefinedzero aim rejected, pending Q/W mutual gate, Eallowed and committed control survival reconstructed. Original server sequencing unqualified.','AoE hits enemy living nonstructures once without per-target visibility filter; NPC body radii use existing native-derived definitions. No wall test, stealth/invulnerability/untargetable/generalAoEmodifier full qualification.','Native animation clip roles driven by pending Q/W; actual spell playback, Wparticles/audio, Pyromania/Tibbers/R and fullHUD/physical input remain incomplete. Entire24domain game incomplete.']}
(r/'docs/annie_w_sources.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
print('Integrated native W/ground-target packets/circle-sector contact and Q/W animation state; fullkit still incomplete')
