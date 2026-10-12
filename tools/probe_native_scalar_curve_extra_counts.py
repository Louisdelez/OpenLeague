from pathlib import Path
import shutil
r=Path('E:/OpenLeague');source=(r/'tools/probe_native_scalar_curve_bake.py').read_text(encoding='utf-8');source=source.replace('for count in (1,3,16,256):','for count in (0,7,64):').replace('scalar_curve_bake_contract.json','scalar_curve_extra_counts_contract.json');exec(compile(source,'additional native scalar table counts','exec'))
