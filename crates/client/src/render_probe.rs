//! Optional real-framebuffer/window-lifecycle qualification. Disabled for ordinary play.
use bevy::{
    prelude::*,
    render::view::screenshot::{save_to_disk, Screenshot},
    window::{MonitorSelection, WindowMode},
};

pub fn window_options(keys: Res<ButtonInput<KeyCode>>, mut windows: Query<&mut Window>) {
    if keys.just_pressed(KeyCode::F11) {
        for mut window in &mut windows {
            window.mode = if window.mode == WindowMode::Windowed {
                WindowMode::BorderlessFullscreen(MonitorSelection::Current)
            } else {
                WindowMode::Windowed
            };
        }
    }
}

pub fn capture(
    mut commands: Commands,
    time: Res<Time>,
    mut stage: Local<usize>,
    mut windows: Query<&mut Window>,
) {
    let Ok(path) = std::env::var("OPENLEAGUE_SCREENSHOT") else {
        return;
    };
    let lifecycle = std::env::var_os("OPENLEAGUE_RENDER_LIFECYCLE").is_some();
    let delay = std::env::var("OPENLEAGUE_SCREENSHOT_DELAY")
        .ok()
        .and_then(|s| s.parse::<f32>().ok())
        .filter(|v| v.is_finite() && *v >= 25. && *v <= 600.)
        .unwrap_or(25.);
    let minimize = lifecycle && std::env::var_os("OPENLEAGUE_RENDER_MINIMIZE").is_some();
    let times = [25., 35., 42., 50., 58., 66., 74., 82., 90., 98.].map(|v| v + delay - 25.);
    if *stage >= if minimize { times.len() } else { 7 } || (!lifecycle && *stage > 0) || time.elapsed_secs() < times[*stage] {
        return;
    }
    let suffix = match *stage {
        0 => Some(""),
        1 => {
            for mut w in &mut windows {
                w.resolution.set(1024., 768.);
            }
            println!("OpenLeague render probe: resize 1024x768");
            None
        }
        2 => Some("-resized"),
        3 => {
            for mut w in &mut windows {
                w.mode = WindowMode::BorderlessFullscreen(MonitorSelection::Current);
            }
            println!("OpenLeague render probe: borderless fullscreen");
            None
        }
        4 => Some("-fullscreen"),
        5 => {
            for mut w in &mut windows {
                w.mode = WindowMode::Windowed;
                w.resolution.set(1280., 800.);
            }
            println!("OpenLeague render probe: restore windowed");
            None
        }
        6 => Some("-restored"),
        7 => {
            for mut w in &mut windows { w.set_minimized(true); }
            println!("OpenLeague render probe: minimize requested");
            None
        }
        8 => {
            for mut w in &mut windows { w.set_minimized(false); }
            println!("OpenLeague render probe: unminimize requested");
            None
        }
        _ => Some("-unminimized"),
    };
    if let Some(suffix) = suffix {
        let target = if suffix.is_empty() {
            path
        } else {
            path.strip_suffix(".png").unwrap_or(&path).to_owned() + suffix + ".png"
        };
        commands
            .spawn(Screenshot::primary_window())
            .observe(save_to_disk(target));
    }
    *stage += 1;
}
