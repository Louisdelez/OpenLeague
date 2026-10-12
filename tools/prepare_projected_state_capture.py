from pathlib import Path
r=Path('E:/OpenLeague')
p=r/'crates/client/src/projected_live.rs';s=p.read_text(encoding='utf-8');old='path.with_file_name("projected-live-off.png")';assert old in s;s=s.replace(old,'path.with_extension("off.png")');p.write_text(s,encoding='utf-8')
s=(r/'tools/capture_projected_live_v2.py').read_text(encoding='utf-8').replace('5984','5985').replace('projected-live-v2','projected-live-v3').replace('projected_normal_capture_v2.json','projected_normal_capture_v3.json').replace("off=r/'logs/projected-live-off.png'","off=probe.with_suffix('.off.png')")
(r/'tools/capture_projected_live_v3.py').write_text(s,encoding='utf-8')
print('Independent v3 captures prepared; historical images preserved.')
