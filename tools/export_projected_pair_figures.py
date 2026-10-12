from pathlib import Path
import json
from PIL import Image,ImageChops
r=Path('E:/OpenLeague');d=json.loads((r/'docs/projected_pixel_pair_progress.json').read_text())
for c in d['projection_instances']:
    for f in c['saved_rgba']:
        p=Path(f);raw=Image.frombytes('RGBA',(2560,801),p.read_bytes())
        on=raw.crop((0,0,1280,800));off=raw.crop((1280,0,2560,800))
        on.save(p.with_suffix('.on.png'));off.save(p.with_suffix('.off.png'))
        diff=ImageChops.difference(on.convert('RGB'),off.convert('RGB'))
        diff.save(p.with_suffix('.difference.png'))
print('Raw GPU pairs and difference figures exported')
