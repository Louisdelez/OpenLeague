from pathlib import Path
p=Path('E:/OpenLeague/crates/client/src/render_probe.rs');s=p.read_text();s=s.replace('let times = [25., 35., 42., 50., 58., 66., 74.];', '''let delay = std::env::var("OPENLEAGUE_SCREENSHOT_DELAY")
        .ok()
        .and_then(|s| s.parse::<f32>().ok())
        .filter(|v| v.is_finite() && *v >= 25. && *v <= 600.)
        .unwrap_or(25.);
    let times = [25., 35., 42., 50., 58., 66., 74.].map(|v| v + delay - 25.);''');p.write_text(s)
