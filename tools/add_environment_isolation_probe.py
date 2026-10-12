from pathlib import Path
r=Path('E:/OpenLeague');p=r/'crates/client/src/animation.rs';s=p.read_text();s=s.replace('''        commands
            .entity(entity)
            .insert((WorldAssetRoot(scene.clone()), playback))''','''        let visibility = if std::env::var_os("OPENLEAGUE_SCREENSHOT").is_some()
            && std::env::var("OPENLEAGUE_PROBE_ENV_ONLY").as_deref() == Ok("1") {
            Visibility::Hidden
        } else { Visibility::Inherited };
        commands
            .entity(entity)
            .insert((WorldAssetRoot(scene.clone()), playback, visibility))''');p.write_text(s)
p=r/'crates/client/src/health.rs';s=p.read_text();s=s.replace('''    let Some(snapshot) = &state.snapshot else {''','''    if std::env::var_os("OPENLEAGUE_SCREENSHOT").is_some()
        && std::env::var("OPENLEAGUE_PROBE_ENV_ONLY").as_deref() == Ok("1") {
        return;
    }
    let Some(snapshot) = &state.snapshot else {''',1);p.write_text(s)
