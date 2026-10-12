from pathlib import Path
import shutil,datetime
r=Path('E:/OpenLeague');w=Path('E:/mapslol3v3');b=r/'docs/plan_history'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');b.mkdir(parents=True,exist_ok=True)
for name in ['main.rs','annie_q_vfx.rs']:shutil.copy2(r/'crates/client/src'/name,b/name)
shutil.copy2(w/'projected_live.rs',r/'crates/client/src/projected_live.rs')
p=r/'crates/client/src/annie_q_vfx.rs';s=p.read_text();marker='fn life(g: &serde_json::Value, seed: u64) -> f32 {'
adapter='''impl Flights {
    pub(crate) fn projection_owners(&self)->Vec<((u32,u32,u64),f64,Vec3,bool)> {
        self.shots.iter().map(|(key,shot)|(*key,shot.started,shot.previous,shot.ended.is_some())).collect()
    }
}
'''
if 'fn projection_owners' not in s:s=s.replace(marker,adapter+marker)
s=s.replace('Glow path ambiguity, Projected and skin mesh consumers remain open.','Glow path ambiguity and skin mesh consumers remain open; Projected uses a reconstructed owner adapter.')
p.write_text(s)
p=r/'crates/client/src/main.rs';s=p.read_text()
if 'mod projected_live;' not in s:s='mod projected_live;\n'+s
if '.init_resource::<projected_live::Live>()' not in s:s=s.replace('.init_resource::<projected_render::Probe>()','.init_resource::<projected_render::Probe>()\n        .init_resource::<projected_live::Live>()')
if 'projected_live::update.after' not in s:s=s.replace('.add_systems(Update, projected_render::probe', '.add_systems(Update, projected_live::update.after(annie_q_vfx::update).before(render_probe::capture))\n        .add_systems(Update, projected_render::probe')
if 'projected_live::visibility_probe.after' not in s:s=s.replace('projected_terrain::probe.after(projected_terrain::collect),','projected_terrain::probe.after(projected_terrain::collect),\n                projected_live::visibility_probe.after(projected_live::update).after(bevy::camera::visibility::VisibilitySystems::CheckVisibility),')
p.write_text(s)
print('Normal Projected consumer installed; native owner interface/render fidelity remain open.')
