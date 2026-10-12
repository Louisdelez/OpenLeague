from pathlib import Path
import json,shutil,datetime
r=Path('E:/OpenLeague');w=Path('E:/mapslol3v3')
old=r/'logs/projected-live-off.png';archived=r/'logs/projected-live-v1-off.png'
assert old.resolve().is_relative_to((r/'logs').resolve()) and archived.resolve().is_relative_to((r/'logs').resolve())
assert not archived.exists()
receipt=r/'docs/projected_normal_capture.json';d=json.loads(receipt.read_text())
backup=r/'docs/plan_history'/datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ');backup.mkdir(parents=True,exist_ok=True);shutil.copy2(receipt,backup/receipt.name)
old.rename(archived)
for capture in d['captures']:
 if Path(capture['path']).name=='projected-live-off.png':capture['path']='logs/projected-live-v1-off.png'
receipt.write_text(json.dumps(d,indent=2)+'\n')
s=(w/'capture_projected_live.py').read_text().replace('5983','5984').replace('projected-live','projected-live-v2').replace('projected_normal_capture.json','projected_normal_capture_v2.json')
s=s.replace("off=r/'logs/projected-live-v2-off.png'","off=r/'logs/projected-live-off.png'")
s=s.replace("assert m['active_draws']==0", "assert m['max_visible_draws']>0\n   assert m['active_draws']==0")
(r/'tools/capture_projected_live_v2.py').write_text(s)
print('Prepared loaded-texture/camera-visible normal capture; first off-capture archived with receipt reference preserved.')
