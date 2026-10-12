from pathlib import Path
import shutil
r=Path('E:/OpenLeague');stage=Path('E:/mapslol3v3')
shutil.copy2(stage/'native_hud_integer_properties.rs',r/'crates/client/src/native_hud_integer_properties.rs')
for name in ['qualify_native_hud_integer_properties.py','locate_native_hud_property_registry.py','qualify_native_hud_property_registry.py']:shutil.copy2(stage/name,r/'tools'/name)
p=r/'crates/client/src/native_hud_element_storage.rs';s=p.read_text(encoding='utf-8').replace('    fn word(&self,offset:usize)->u32','    pub(crate) fn word(&self,offset:usize)->u32')
if 'fn set_word' not in s:s=s.replace('    pub fn initial_fractions', '    pub(crate) fn set_word(&mut self,offset:usize,value:u32) {self.bytes[offset..offset+4].copy_from_slice(&value.to_le_bytes());}\n    pub fn initial_fractions')
p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/main.rs';s=p.read_text(encoding='utf-8')
if 'mod native_hud_integer_properties;' not in s:s='mod native_hud_integer_properties;\n'+s
p.write_text(s,encoding='utf-8');print('12 native integer property callbacks ported; remaining callbacks/runtime integration pending.')
