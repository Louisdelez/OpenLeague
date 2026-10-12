from pathlib import Path
r=Path('E:/OpenLeague');p=r/'crates/core/src/world.rs';s=p.read_text(encoding='utf-8');s=s.replace('    ranged: bool,','    ranged: bool,\n    launched: bool,',1);s=s.replace('                            ranged: def.projectile_speed > 0.,','                            ranged: def.projectile_speed > 0.,\n                            launched: false,',1);s=s.replace('(a.ranged && a.releases<=self.tick)','a.launched',1)
old='''        for attack in pending.drain(..) {
            if attack.resolves > self.tick {'''
new='''        for mut attack in pending.drain(..) {
            if !attack.launched && !self.units.get(&attack.source).is_some_and(|u|u.health>0. && !stuns::unit_active(u,self.tick)) {continue;}
            if attack.ranged && attack.releases<=self.tick {attack.launched=true;}
            if attack.resolves > self.tick {'''
assert old in s;s=s.replace(old,new,1);s=s.replace('(attack.ranged && attack.releases<=self.tick && self.units.contains_key(&attack.source))','(attack.launched && self.units.contains_key(&attack.source))',1);p.write_text(s,encoding='utf-8')
p=r/'crates/core/src/unit_stun_tests.rs';s=p.read_text(encoding='utf-8');s=s.replace('s.tick=29;s.advance_world();assert_eq!(s.players[&b].health,hp);s.tick=30;s.advance_world();','s.tick=28;s.advance_world();assert_eq!(s.players[&b].health,hp);s.tick=29;s.advance_world();',1);p.write_text(s,encoding='utf-8');print('Explicit launch phase prevents dead/stunned unlaunched NPC attacks from becoming later projectiles')
