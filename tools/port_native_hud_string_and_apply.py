from pathlib import Path
import shutil
r=Path('E:/OpenLeague');stage=Path('E:/mapslol3v3')
for name in ['native_hud_string_properties.rs','native_hud_property_apply.rs']:shutil.copy2(stage/name,r/'crates/client/src'/name)
shutil.copy2(stage/'qualify_native_hud_string_properties.py',r/'tools/qualify_native_hud_string_properties.py')
p=r/'crates/client/src/native_hud_element_storage.rs';s=p.read_text(encoding='utf-8')
if 'fn write_bytes' not in s:s=s.replace('    pub fn initial_fractions','    pub(crate) fn write_bytes(&mut self,offset:usize,value:&[u8]) {self.bytes[offset..offset+value.len()].copy_from_slice(value);}\n    pub fn initial_fractions')
p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/main.rs';s=p.read_text(encoding='utf-8')
for name in ['native_hud_string_properties','native_hud_property_apply']:
 if 'mod '+name+';' not in s:s='mod '+name+';\n'+s
p.write_text(s,encoding='utf-8');print('String callbacks and numeric field application ported; full parser/runtime integration pending.')
