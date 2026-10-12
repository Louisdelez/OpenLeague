from pathlib import Path
import shutil
r=Path('E:/OpenLeague');root=r/'crates/client/examples'
for name in ('environment_draw_gpu_probe.rs','selector7_depth_gpu_probe.rs','fow_factor_probe.rs','fow_height_raster_probe.rs','fow_uniform_probe.rs'):
 p=root/name;s=p.read_text(encoding='utf-8');prefix=''
 for module in ('native_game_cfg_text','native_graphics_options'):
  if 'mod '+module+';' not in s:prefix+=f'#[allow(dead_code)] #[path="../src/{module}.rs"] mod {module};\n'
 p.write_text(prefix+s,encoding='utf-8');print(name)
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
