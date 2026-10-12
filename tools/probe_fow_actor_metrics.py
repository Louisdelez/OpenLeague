from pathlib import Path
import json,struct,itertools,datetime
r=Path('E:/OpenLeague')
metrics_prerequisites=(r/'tools/probe_fow_source_release.py').read_text(encoding='utf-8').split('\ncases=[]')[0]
exec(compile(metrics_prerequisites,'native actor metrics prerequisites','exec'))
u.mem_map(0x70000000,0x10000);actor=0x70000000;character=0x70004000
notifications=[];warnings=[]
def metrics_boundary(uc,a,size,user):
 if a==0x6151a0:notifications.append(a);finish()
 elif a==0x991e60:warnings.append(a);finish()
u.hook_add(unicorn.UC_HOOK_CODE,metrics_boundary)
cases=[]
for present,shape,raw_radius,raw_secondary,geometry_factor in itertools.product([False,True],[-1.,25.],[-1.,65.,1000.],[-1.,128.],[0.,2.,struct.unpack('<f',struct.pack('<f',-1./3.))[0]]):
 u.mem_write(actor,bytes(0x3000));u.mem_write(character,bytes(0x700));notifications.clear();warnings.clear()
 write32(actor,0x1090ea8);write32(actor+0x206c,character if present else 0)
 for address,value in [(character+0x60c,shape),(character+0x610,raw_radius),(character+0x614,raw_secondary),(character+0x618,geometry_factor),(actor+0x740,3.),(actor+0x95,10.),(actor+0x99,20.),(actor+0x9d,30.),(actor+0xa1,110.),(actor+0xa5,220.),(actor+0xa9,330.),(actor+0x48,9.),(actor+0x4c,8.),(actor+0x37c,7.),(actor+0x380,6.),(actor+0x384,5.)]:f(address,value)
 invoke(0x617970,actor)
 cases.append(dict(character_present=present,shape=shape,raw_radius=raw_radius,raw_secondary=raw_secondary,geometry_factor=geometry_factor,model_scale=3.,bounds_min=[10.,20.,30.],bounds_max=[110.,220.,330.],initial=[9.,8.,7.,6.,5.],result_bits=[read32(actor+o) for o in [0x48,0x4c,0x37c,0x380,0x384]],notifications=len(notifications),warnings=len(warnings)))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='0x617970',geometry_getter='0x614e40',native_addresses=len(visited-{0x6151a0,0x991e60}),constants={hex(a):read32(a) for a in [0x11392bc,0x11392ec,0x1138bd0,0x11391c4,0x1138960,0x1138b40]},cases=cases,limits=['Complete617970 initialization and original614E40 geometry fallback execute. Character/model bounds/resource fields supplied; upstream resource readers and model bounds loaders not executed.','Motion provider is null;6061E0 motion height update remains unqualified. Final virtual6151A0 notification and991E60 warning output adapted; internal callback behavior unqualified.','Raw actor37C/384 retain resource radius/secondary values, distinct from resolved geometry48/4C. Vision6198F0 consumes raw37C fallback, not resolved4C.','No native actor identity/team constructor or ordinary source activation and GPU binding qualified.'])
(r/'data/4.20/fow_actor_metrics_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(dict(cases=len(cases),native_addresses=proof['native_addresses'],constants=proof['constants'])))
