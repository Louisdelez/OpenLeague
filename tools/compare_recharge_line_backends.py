from pathlib import Path
import json
r=Path('E:/OpenLeague');cases=[]
for i in range(18):
 a=(r/f'logs/native-hud-recharge-line-vulkan-case{i}.rgba').read_bytes();b=(r/f'logs/native-hud-recharge-line-dx12-case{i}.rgba').read_bytes()
 different=sum(a[p:p+4]!=b[p:p+4] for p in range(0,len(a),4));coverage=sum(bool(a[p+3])!=bool(b[p+3]) for p in range(0,len(a),4));cases.append({'case':i,'different_pixels':different,'different_coverage_pixels':coverage,'maximum_channel_error':max(abs(x-y) for x,y in zip(a,b))})
proof={'complete':False,'identical_cases':sum(c['different_pixels']==0 for c in cases),'cases':cases,'limit':'Vulkan and DX12 line raster coverage is not pixel-identical. Each backend separately satisfies geometric coverage and native color tolerances; original D3D9 line raster equality remains unqualified.'}
(r/'logs/native-hud-recharge-line-backend-comparison.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(proof))
