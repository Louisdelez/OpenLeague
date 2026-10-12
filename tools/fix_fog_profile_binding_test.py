from pathlib import Path
r=Path('E:/OpenLeague/crates/client/src')
p=r/'native_high_fog.rs';s=p.read_text(encoding='utf-8');start=s.index('#[cfg(test)] mod tests {');test=s[start:];s=s[:start].replace('(_,mut m)','(_,m)');p.write_text(s,encoding='utf-8')
p=r/'map_fog.rs';s=p.read_text(encoding='utf-8');extension=s.split('  let extension=FogExtension {',1)[1].split(';',1)[0]
test=test.replace('mod tests {','mod native_fog_profile_binding_tests {').replace('use super::*;','use super::*; use crate::native_high_fog::{profile_uniform,fog_constant,synchronize};')
test=test.replace('let mut catalog=crate::map_fog::FogCatalog::default();','let extension=FogExtension {'+extension+';\n  let mut catalog=FogCatalog {extension,allowed:HashSet::new(),vertex_factors:HashMap::new(),colormap_factors:HashMap::new(),draw_modes:HashMap::new(),selector7_names:HashSet::new()};')
p.write_text(s+'\n'+test,encoding='utf-8')
