from pathlib import Path
source=Path('E:/mapslol3v3/capture_selector7_depth.py').read_text(encoding='utf-8').replace('16035','16037').replace('selector7-depth','selector7-depth-retry').replace('selector7_depth_runtime_capture','selector7_depth_retry_runtime_capture')
exec(compile(source,__file__,'exec'))
