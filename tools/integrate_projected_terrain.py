from pathlib import Path
import shutil
r=Path('E:/OpenLeague')
shutil.copyfile('E:/mapslol3v3/projected_terrain.rs',r/'crates/client/src/projected_terrain.rs')
p=r/'crates/client/src/main.rs';s=p.read_text(encoding='utf-8')
if 'mod projected_terrain;' not in s:s='#[allow(dead_code)] // Surface preparation precedes the live projected particle consumer.\nmod projected_terrain;\n'+s
anchor='.init_resource::<camera_native::NativeCamera>()'
if '.init_resource::<projected_terrain::TerrainSurfaces>()' not in s:
    assert anchor in s;s=s.replace(anchor,anchor+'\n        .init_resource::<projected_terrain::TerrainSurfaces>()')
anchor='annie_q_vfx::visibility_probe.after(annie_q_vfx::update).after(bevy::camera::visibility::VisibilitySystems::CheckVisibility),'
if 'projected_terrain::collect.after' not in s:
    assert anchor in s;s=s.replace(anchor,'projected_terrain::collect.after(bevy::transform::TransformSystems::Propagate),\n                projected_terrain::probe.after(projected_terrain::collect),\n                '+anchor)
p.write_text(s,encoding='utf-8')
shutil.copyfile(Path(__file__),r/'tools/integrate_projected_terrain.py')
print('Actual map geometry cache integrated; live projected particle consumer remains open.')
