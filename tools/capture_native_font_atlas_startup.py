from pathlib import Path
import sys
r=Path('E:/OpenLeague')
source=(r/'tools/capture_native_font_metrics.py').read_text(encoding='utf-8').replace('native-font-metrics-','native-font-atlas-startup-')
exec(compile(source,'owned font atlas startup verification','exec'))
