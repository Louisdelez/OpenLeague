from pathlib import Path
p=Path('E:/OpenLeague/crates/client/src/native_endgame_ui.rs');s=p.read_text(encoding='utf-8');needle='"pan_target":result.destroyed_nexus';assert needle in s;s=s.replace(needle,'"pan_now":time.elapsed_secs(),'+needle,1);p.write_text(s,encoding='utf-8')
p=Path('E:/mapslol3v3/verify_native_camera_pan_runtime.py');s=p.read_text(encoding='utf-8');s=s.replace("floats(0x2d78dfc,[row['local_time']])","floats(0x2d78dfc,[row['pan_now']])");p.write_text(s,encoding='utf-8')
print('exact float32 producer timestamp included in diagnostic records')
