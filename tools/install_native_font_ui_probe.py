from pathlib import Path
import shutil
r=Path('E:/OpenLeague');stage=Path('E:/mapslol3v3');shutil.copy2(stage/'native_font_ui_probe.rs',r/'crates/client/examples/native_font_ui_probe.rs');shutil.copy2(stage/'install_native_font_ui_probe.py',r/'tools/install_native_font_ui_probe.py');print('production native UI material probe installed')
