from pathlib import Path
import json,hashlib,datetime,sys
r=Path('E:/OpenLeague');root=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy');sys.path.insert(0,str(r/'tools'));import native_lua
sources=[]
for locale in ['en_US','fr_FR']:
 p=root/f'DATA/Menu/fontconfig_{locale}.txt';text=p.read_text(encoding='utf-8-sig');lines=text.splitlines();q=next((i+1,line) for i,line in enumerate(lines) if '"game_spell_tooltip_Disintegrate"' in line)
 sources.append({'path':str(p),'sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'Q_tooltip_line':q[0],'Q_tooltip':q[1],'passive_tooltips':{str(i+1):line for i,line in enumerate(lines) if 'game_buff_tooltip_Pyromania' in line}})
assert 'half the cooldown' in sources[0]['Q_tooltip']
official=json.loads((r/'data/4.20/native_ddragon_annie_420.json').read_text(encoding='utf-8'));assert 'half the cooldown' in official['data']['Annie']['spells'][0]['tooltip']
lua=[]
for p in (root/'DATA/Characters/Annie/Spells').glob('Pyromania*.luaobj'):
 d=native_lua.initialization(native_lua.Chunk(p.read_bytes()).function());assert d['stopped'] is None;lua.append({'path':str(p),'sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'globals':d['globals']})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'complete':False,'native_localization_sources':sources,'official_cache_sha256':hashlib.sha256((r/'data/4.20/native_ddragon_annie_420.json').read_bytes()).hexdigest(),'official_url':'https://ddragon.leagueoflegends.com/cdn/4.20.1/data/en_US/champion/Annie.json','native_passive_metadata':lua,'limits':['Native4.20 client tooltip and Riot4.20.1 tooltip both require half cooldown refund on Q kill; earlier mana-only implementation incorrect.','Implement half of cast-time CDR-adjusted duration, subtract from committed deadline at impact and clamp current tick. Scope refund to matching committed cooldown so delayed old missiles do not alter a newer cast. Exact original refund arithmetic/late-missile behavior remains reconstructed.','Pyromania native descriptions establish four casts and next offensive spell stuns; native duration remains dynamic @f1@. MarkerPersistsThroughDeath=true and NonDispellable=true are recovered metadata, not proof that stack counts or ready buff survive death. Do not infer modern initial4stacks or reset-ondeath behavior.','No passive stack/stun implementation or primary historical stun duration qualified in this audit.']};(r/'docs/annie_q_refund_native_contract.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p=r/'data/4.20/annie_q_rules.json';d=json.loads(p.read_text(encoding='utf-8'));d['kill_cooldown_refund_fraction']=.5;p.write_text(json.dumps(d,indent=2)+'\n',encoding='utf-8')
p=r/'crates/core/src/annie.rs';s=p.read_text(encoding='utf-8');s=s.replace('pub raw:f32,pub cost:f32}', 'pub raw:f32,pub cost:f32,#[serde(default)] pub refund_ticks:u64,#[serde(default)] pub cooldown_ready:u64}')
old='raw,cost});Ok(())';assert old in s;s=s.replace(old,'raw,cost,refund_ticks:(cd as f32*value("kill_cooldown_refund_fraction")).floor() as u64,cooldown_ready:self.tick+cd});Ok(())',1)
old='raw:q.raw,cost:q.cost});';assert old in s;s=s.replace(old,'raw:q.raw,cost:q.cost,refund_ticks:q.refund_ticks,cooldown_ready:q.cooldown_ready});',1)
old='p.mana=(p.mana+m.cost).min(max);';assert old in s;s=s.replace(old,'p.mana=(p.mana+m.cost).min(max);if p.cooldowns[0]==m.cooldown_ready {p.cooldowns[0]=p.cooldowns[0].saturating_sub(m.refund_ticks).max(self.tick);}',1)
s=s.replace('assert_eq!(s.players[&a].cooldowns[0],240);assert_eq!(s.players[&a].score.kills,1);','assert_eq!(s.players[&a].cooldowns[0],180);assert_eq!(s.players[&a].score.kills,1);',1)
marker=' #[test] fn failed_targets_and_resource_checks_leave_cost_and_cooldown_untouched() {'
test=''' #[test] fn kill_refund_snapshots_cdr_and_reduces_half_total_cooldown_not_half_remaining() {
  let(mut s,a,b)=game();s.players.get_mut(&a).unwrap().inventory[0]=Some(3108);s.players.get_mut(&b).unwrap().health=1.;let mana=s.players[&a].mana;s.cast(a,0,Some(b)).unwrap();assert_eq!(s.players[&a].cooldowns[0],108);
  // Selling the CDR source after commitment must not change the refund amount.
  s.players.get_mut(&a).unwrap().inventory[0]=None;for tick in 1..=19 {s.tick=tick;s.advance_annie();}assert_eq!(s.players[&a].cooldowns[0],54);assert_eq!(s.players[&a].mana,mana);
  s.tick=53;assert_eq!(s.cast(a,0,Some(b)).unwrap_err(),"skill on cooldown");
 }
 #[test] fn late_lethal_missile_clamps_refund_and_cannot_modify_newer_cast_cooldown() {
  for newer in [false,true] {
   let(mut s,a,b)=game();s.players.get_mut(&b).unwrap().health=1.;s.cast(a,0,Some(b)).unwrap();s.tick=8;s.advance_annie();s.spell_projectiles[0].position=s.players[&b].position;
   s.tick=150;if newer {s.players.get_mut(&a).unwrap().cooldowns[0]=270;}
   s.advance_annie();assert_eq!(s.players[&a].cooldowns[0],if newer {270} else {150});assert_eq!(s.players[&a].score.kills,1);
  }
 }
'''
assert marker in s;s=s.replace(marker,test+marker,1);p.write_text(s,encoding='utf-8');print('Corrected native4.20Q half cooldown refund and added2timing/CDR regressions; passive duration still unknown')
