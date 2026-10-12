from pathlib import Path
import shutil
r=Path('E:/OpenLeague')
for src,dst in [('native_font_sequence.rs','crates/font-raster/src/native_font_sequence.rs'),('qualify_native_font_sequence.py','tools/qualify_native_font_sequence.py')]:shutil.copy2(Path('E:/mapslol3v3')/src,r/dst)
p=r/'crates/font-raster/src/lib.rs';s=p.read_text(encoding='utf-8');assert 'pub mod native_font_sequence;' not in s;p.write_text(s+'\npub mod native_font_sequence;\n',encoding='utf-8')
