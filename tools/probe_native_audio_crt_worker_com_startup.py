from pathlib import Path
import json,itertools,hashlib
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'worker-com-helper-setup','exec'))
package=vector+0x29000;ro=vector+0x29100;record=vector+0x12000;key=0x13572468;calls=[];regions=[];access=set();collect=True;cfg={};module=0x76540000
api={0xfa42d4:('LoadLibraryExW',vector+0x29200),0xfa43dc:('GetProcAddress',vector+0x29210),0xfa42ec:('EncodePointer',vector+0x29220),0xfa42e8:('DecodePointer',vector+0x29230)}
for iat,(_,target)in api.items():w(iat,target)
targets={target:name for name,target in api.values()};baseline=bytes(u.mem_read(base,len(image)))
def snapshot():return {name:bytes(u.mem_read(a,z)).hex()for name,a,z in regions}
def emit(name,args,value,extra=None):
 item={'kind':name,'arguments':args,'result':value,'at_call':snapshot()}
 if extra:item.update(extra)
 calls.append(item)
def narrow(a):return bytes(u.mem_read(a,128)).split(b'\0')[0].decode()
def wide(a):return bytes(u.mem_read(a,128)).decode('utf-16le').split('\0')[0]
def hook(uc,a,z,user):
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==package:
  ref=read(sp+4);assert read(ref)==0 and read(sp+8)==0;emit('GetCurrentPackageId',[0,0],cfg['package_result'],{'supplied_length':cfg['length']});w(ref,cfg['length']);finish(cfg['package_result'],8);return
 if a==ro:assert read(sp+4)==1;emit('RoInitialize',[1],cfg['hresult']);finish(cfg['hresult'],4);return
 name=targets.get(a)
 if name=='LoadLibraryExW':args=[wide(read(sp+4)),read(sp+8),read(sp+12)];assert args==['combase.dll',0,0x800];emit(name,args,cfg['module']);finish(cfg['module'],12);return
 if name=='GetProcAddress':args=[read(sp+4),narrow(read(sp+8))];assert args==[cfg['module'],'RoInitialize'];result=ro if cfg['module'] and cfg['available']else 0;emit(name,args,result);finish(result,8);return
 if name in ['EncodePointer','DecodePointer']:value=read(sp+4);emit(name,[value],value^key);finish(value^key,4);return
 assert base<=a<base+len(image),hex(a)
def memory(uc,kind,a,z,value,user):
 if collect and base<=a<base+len(image):access.update(range(a,a+z))
u.hook_add(unicorn.UC_HOOK_CODE,hook);u.hook_add(unicorn.UC_HOOK_MEM_READ|unicorn.UC_HOOK_MEM_WRITE,memory)
def execute(config):
 global cfg
 cfg=config;calls.clear();u.mem_write(base,baseline);w(0x1222ed0,cfg['cookie']);w(0x122343c,cfg['package_cached']);w(0x2da5374,cfg['cookie']^(package if cfg['package_export']else 0));w(0x14ae5fc,cfg['com_cached']);w(0x14ae5f8,ro^key);u.mem_write(record,bytes([0xa5])*956);w(stack,end)
 entry=0xcabda8 if cfg['kind']=='package'else 0xc9c384 if cfg['kind']=='com'else 0xc9c439
 if cfg['kind']=='stage':u.reg_write(UC_X86_REG_ESI,record);w(stack,0xc9c453)
 before=snapshot();u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(entry,0xc9c453 if cfg['kind']=='stage'else end,count=3000);assert u.reg_read(UC_X86_REG_EIP)==(0xc9c453 if cfg['kind']=='stage'else end)
 return {'config':cfg.copy(),'before':before,'after':snapshot(),'calls':list(calls),'result':read(record+0x3b4)if cfg['kind']=='stage'else u.reg_read(UC_X86_REG_EAX),'terminal':True}
defaults={'cookie':0x11223344,'package_cached':0xffffffff,'package_export':True,'package_result':122,'length':123,'com_cached':0,'module':module,'available':True,'hresult':0}
configs=[]
for cached,export,result,length,cookie in itertools.product([0,1,2,0x7fffffff,0x80000000,0xffffffff],[False,True],[0,1,122,15700,0xffffffff],[0,123],[0,0x11223344,0xffffffff]):configs.append(defaults|{'kind':'package','package_cached':cached,'package_export':export,'package_result':result,'length':length,'cookie':cookie})
for cached,mod,available,hr in itertools.product([0,1,0xffffffff],[0,module],[False,True],[0,1,2,0x80004005,0xffffffff]):configs.append(defaults|{'kind':'com','com_cached':cached,'module':mod,'available':available,'hresult':hr})
for pc,export,pr,cc,available,hr in itertools.product([0xffffffff,0,1],[False,True],[122,15700],[0,0xffffffff],[False,True],[0,1,0x80004005]):configs.append(defaults|{'kind':'stage','package_cached':pc,'package_export':export,'package_result':pr,'com_cached':cc,'available':available,'hresult':hr})
for pc in [1,0xffffffff]:configs.append(defaults|{'kind':'stage','package_cached':pc,'module':0,'available':False})
for cfg in configs:execute(cfg)
collect=False;intervals=[]
for a in sorted({a&~3 for a in access}):
 if intervals and a==intervals[-1][1]:intervals[-1][1]=a+4
 else:intervals.append([a,a+4])
intervals.extend([(record,record+956)]);merged=[]
for a,b in sorted(intervals,key=lambda v:v[0]):
 if merged and a<=merged[-1][1]:merged[-1][1]=max(b,merged[-1][1])
 else:merged.append([a,b])
regions=[(f'bank_{a:08x}',a,b-a)for a,b in merged];rows=[execute(cfg)for cfg in configs]
p={'passed':True,'complete':False,'case_count':len(rows),'native_sha256':hashlib.sha256(raw).hexdigest(),'regions':[{'name':n,'reference':a,'size':z}for n,a,z in regions],'cases':rows,'limits':['Complete original CABDA8 package helper and C9C384 RoInitialize helper execute; original C9C439 worker COM stage executes until worker-body C9C315 call boundary. All service entry/final banks and raw result/flag retained.','Windows package/COM/loader/codec outcomes supplied, including initialized cache and field values. No actual package identity or COM lifetime measured; original worker entry/body and physical providers remain separate.']}
(r/'data/4.20/audio_crt_worker_com_startup_preparation.json').write_text(json.dumps(p,indent=2)+'\n',encoding='utf-8');(r/'tools/probe_native_audio_crt_worker_com_startup.py').write_text(Path(__file__).read_text(),encoding='utf-8');print('Captured',len(rows),'native package/COM/worker stage cases;',len(regions),'banks')
