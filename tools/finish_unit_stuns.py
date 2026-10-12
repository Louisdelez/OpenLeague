from pathlib import Path
import shutil
r=Path('E:/OpenLeague');shutil.copyfile('E:/mapslol3v3/unit_stun_tests.rs',r/'crates/core/src/unit_stun_tests.rs')
p=r/'crates/core/src/stuns.rs';s=p.read_text(encoding='utf-8');s+='\n#[cfg(test)]\n#[path="unit_stun_tests.rs"]\nmod unit_tests;\n';p.write_text(s,encoding='utf-8')
p=r/'crates/core/src/world.rs';s=p.read_text(encoding='utf-8');old='        let killing_team = self.target_info(source)';assert old in s;s=s.replace(old,'        self.interrupt_unit_windup(target);\n'+old,1);p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/animation.rs';s=p.read_text(encoding='utf-8');s=s.replace('if u.pet.as_ref().is_some_and(|pet|snapshot.tick<pet.spawned','if !openleague_core::stuns::unit_active(u,snapshot.tick) && u.pet.as_ref().is_some_and(|pet|snapshot.tick<pet.spawned');p.write_text(s,encoding='utf-8')
print('Added6NPC/pet control lifecycle/projectile/credit tests and death windup interruption')
