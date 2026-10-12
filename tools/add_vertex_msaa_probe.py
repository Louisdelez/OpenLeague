from pathlib import Path
p=Path('E:/OpenLeague/crates/client/src/main.rs');s=p.read_text();old='''        Camera3d::default(),
        Tonemapping::None,''';new='''        Camera3d::default(),
        if std::env::var_os("OPENLEAGUE_SCREENSHOT").is_some()
            && std::env::var("OPENLEAGUE_PROBE_NO_MSAA").as_deref() == Ok("1")
        {
            Msaa::Off
        } else {
            Msaa::default()
        },
        Tonemapping::None,''';assert old in s;s=s.replace(old,new,1);p.write_text(s)
