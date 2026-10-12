from pathlib import Path
p=Path('E:/mapslol3v3/analyze_pair_stage_control.py');src=p.read_text(encoding='utf-8')
src=src.replace("logs/projected-pair-baseline-controls-build.log","logs/native-multisample-client-build.log")
src=src.replace("'crates/client/src/projected_pixel_pair.rs'","'crates/client/src/projected_pixel_pair.rs','crates/client/src/native_multisample.rs','data/4.20/native_multisample_selection_contract.json'")
src=src.replace('Gamma/MSAA controls isolate stages only; passing an altered diagnostic view does not qualify unmodified ordinary output or original LoL fidelity.','Native Game.cfg selection now drives ordinary camera sampling; paired offscreen views still establish scoped consumer attribution rather than original LoL GPU equivalence.')
Path('E:/mapslol3v3/analyze_native_msaa_pair.py').write_text(src,encoding='utf-8')
