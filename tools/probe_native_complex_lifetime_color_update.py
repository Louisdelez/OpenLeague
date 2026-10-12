"""Native color update using tables recovered by the actual p-xrgba caller."""
from pathlib import Path
import json,struct,itertools,datetime,shutil
r=Path('E:/OpenLeague');setup=(r/'tools/probe_native_complex_color_update.py').read_text().split('\nsource=')[0];exec(compile(setup,'native color update setup','exec'))
source=json.loads((r/'data/4.20/complex_lifetime_color_contract.json').read_text());profiles=[row for row in source['cases'] if row['prior_count']==0 and row['name'].startswith('map:')];assert len(profiles)==27
cases=[]
for profile,age,seed,birth_color in itertools.product(profiles,[bits(v) for v in [-.1,0.,.1,.5,1.,2.]]+[0x7fc01234,0x7f800000],[42,0xffffffff],[[1.]*4,[-2.,0.,3.5,-.5]]):
 values=[struct.unpack('<f',struct.pack('<I',int(v,16)))[0] for v in profile['table_bits']];colors=[values[i:i+4] for i in range(0,len(values),4)]
 row=run(profile['name'],profile['probabilities'],colors,age,seed,birth_color);row['fields']=profile['fields'];cases.append(row)
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'profiles':27,'cases':cases,'fragment':['939B94','939C47'],'original_instruction_addresses':len(visited),'adapters':['Native9151F6/94ACC0p-xrgba caller captures supply actual27Map10lifetime color profiles to original age/sampler/RNG/color update fragment. Immutable birth color, legal birth/life and container states supplied.'],'limits':['Reader and update executed as composed fragments, not entire constructor/lifecycle. Distance modulation and remainder of color/material update excluded.','Owner sources, full birth RNG order and ordinary graphical integration remain incomplete.']}
(r/'data/4.20/complex_lifetime_color_update_contract.json').write_text(json.dumps(proof,indent=2)+'\n')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'profiles':len(profiles),'cases':len(cases),'passed':True}))
