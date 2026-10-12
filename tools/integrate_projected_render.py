from pathlib import Path
import shutil
r=Path('E:/OpenLeague')
shutil.copyfile('E:/mapslol3v3/projected_render.rs',r/'crates/client/src/projected_render.rs')
shutil.copyfile('E:/mapslol3v3/projected_terrain.wgsl',r/'assets/shaders/projected_terrain.wgsl')
p=r/'crates/client/src/main.rs';s=p.read_text(encoding='utf-8')
if 'mod projected_render;' not in s:s='mod projected_render;\n'+s
anchor='.add_plugins(MaterialPlugin::<annie_ready::ReadyMaterial>::default())'
if 'MaterialPlugin::<projected_render::ProjectedMaterial>' not in s:
    assert anchor in s;s=s.replace(anchor,anchor+'\n        .add_plugins(MaterialPlugin::<projected_render::ProjectedMaterial>::default())')
anchor='.init_resource::<projected_terrain::TerrainSurfaces>()'
if '.init_resource::<projected_render::Probe>()' not in s:
    assert anchor in s;s=s.replace(anchor,anchor+'\n        .init_resource::<projected_render::Probe>()')
anchor='.add_systems(Update, annie_q_vfx::update.after(receive).before(render_probe::capture))'
if 'projected_render::probe.after' not in s:
    assert anchor in s;s=s.replace(anchor,anchor+'\n        .add_systems(Update, projected_render::probe.after(receive).before(render_probe::capture))')
p.write_text(s,encoding='utf-8')
shutil.copyfile(Path(__file__),r/'tools/integrate_projected_render.py')
print('Projected terrain material installed; diagnostic consumer requires explicit env flag. Native emitter binding remains incomplete.')
