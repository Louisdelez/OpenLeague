from pathlib import Path
r=Path('E:/OpenLeague');p=r/'crates/client/src/native_font_material.rs';s=p.read_text(encoding='utf-8');s=s.replace('Vec2::new(.5,.5)','Vec2::new(0.5,0.5)').replace(']+.5',']+0.5');p.write_text(s,encoding='utf-8')
