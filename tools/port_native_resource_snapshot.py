from pathlib import Path
import shutil
r=Path('E:/OpenLeague');stage=Path('E:/mapslol3v3');p=r/'crates/core/src/lib.rs';s=p.read_text(encoding='utf-8');assert 'pub max_mana: Option<f32>' not in s
s=s.replace('    pub mana: f32,\n    pub level: u8,','    pub mana: f32,\n    /// Snapshot-only authoritative capacity; absence in older packets means unknown.\n    #[serde(default, skip_serializing_if = "Option::is_none")]\n    pub max_mana: Option<f32>,\n    pub level: u8,',1)
s=s.replace('                mana: def.mana,\n                level: 1,','                mana: def.mana,\n                max_mana: None,\n                level: 1,',1)
s=s.replace('            players: self.players.values().cloned().collect(),','            players: self.players.values().map(|p| {let mut state=p.clone();state.max_mana=Some(self.stats(p.id).max_mana);state}).collect(),',1)
s+='\nmod native_resource_snapshot;\n';p.write_text(s,encoding='utf-8');shutil.copy2(stage/'native_resource_snapshot.rs',r/'crates/core/src/native_resource_snapshot.rs');print('Authoritative resource capacity added to outgoing snapshots; old packets retain unknown None')
