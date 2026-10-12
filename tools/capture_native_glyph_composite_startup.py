from pathlib import Path
import sys
r=Path('E:/OpenLeague')
source=(r/'tools/capture_native_font_metrics.py').read_text(encoding='utf-8').replace('native-font-metrics-','native-glyph-composite-startup-')
exec(compile(source,'owned glyph composite startup verification','exec'))
