from pathlib import Path
import json,struct,datetime,ast,hashlib
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_fow_source_release.py').read_text(encoding='utf-8').split('\ncases=[]')[0]
exec(compile(setup,'native prerequisites','exec'))
tree=ast.parse(Path('E:/mapslol3v3/tools/import_all_champions.py').read_text(encoding='utf-8'));parser={'struct':struct}
exec(compile(ast.Module(body=[n for n in tree.body if isinstance(n,ast.FunctionDef) and n.name in ['ini','hashkey']],type_ignores=[]),'inibin','exec'),parser)
discovery=json.loads((r/'docs/native_projection_discovery.json').read_text());source=Path(discovery['source']).parent/'LEVELS/Map10/terrain.inibin'
authored=parser['ini'](source).get(parser['hashkey']('FoW','upscale'))
key_hash=int(parser['hashkey']('FoW','upscale'))
assert authored is None or isinstance(authored,bool),repr(authored)
config=heap+0x1d000;destination=heap+0x1e000;secondary_config=config+0x200;pair=config+0x400;frame=sp+0x1000;current=None;queries=[];layer_values={}
def returned(value,cleanup):
 top=u.reg_read(UC_X86_REG_ESP);ret=read32(top);u.reg_write(UC_X86_REG_EAX,value);u.reg_write(UC_X86_REG_ESP,top+4+cleanup);u.reg_write(UC_X86_REG_EIP,ret)
def boundaries(uc,a,size,user):
 if a==0x8ae5cd:
  # Security-cookie check preserves the boolean return in AL.
  u.reg_write(UC_X86_REG_EIP,0x8ae5d2)
 elif a==0x8afc3e:
  # GetCurrentThreadId import is adapted to one stable synthetic thread.
  u.reg_write(UC_X86_REG_EAX,1);u.reg_write(UC_X86_REG_EIP,0x8afc44)
 elif a==0x8af7b0:
  top=u.reg_read(UC_X86_REG_ESP);key=read32(top+4);out=read32(top+8);assert key==key_hash
  value=layer_values.get(u.reg_read(UC_X86_REG_ECX),current)
  queries.append(dict(kind='typed_binary_lookup',found=value is not None))
  if value is not None:u.mem_write(out,bytes([int(value)]))
  returned(int(value is not None),8)
 elif a==0x8af290:
  top=u.reg_read(UC_X86_REG_ESP);assert read32(top+4)==key_hash;queries.append(dict(kind='binary_string_lookup',found=False));returned(0,8)
u.hook_add(unicorn.UC_HOOK_CODE,boundaries)
cases=[]
for name,loaded,value,fallback in [('map10-original',True,authored,True),('missing-default-false',True,None,False),('binary-disabled',False,True,True),('explicit-false',True,False,True),('explicit-true',True,True,False)]:
 current=value;queries.clear();u.mem_write(config,bytes(0x180));u.mem_write(config+0x148,bytes([int(loaded)]));u.mem_write(destination,b'\xcc')
 invoke(0x8afc30,config,struct.pack('<5I',destination,0,0,key_hash,int(fallback)))
 found=bool(u.reg_read(UC_X86_REG_EAX)&255);result=bool(u.mem_read(destination,1)[0]);assert found==(loaded and value is not None),(name,found,result,queries);assert result==(value if found else fallback),(name,result,queries)
 cases.append(dict(name=name,binary_loaded=loaded,authored=value,default=fallback,result=result,found=found,queries=list(queries)))
layers=[]
for name,primary,secondary,present in [('map10-no-override',authored,None,False),('secondary-false-wins',True,False,True),('secondary-true-wins',False,True,True),('secondary-missing-primary-false',False,None,True),('both-missing-native-default',None,None,True),('primary-false-no-secondary',False,None,False)]:
 layer_values={config:primary,secondary_config:secondary};queries.clear()
 for obj in [config,secondary_config]:u.mem_write(obj,bytes(0x180));u.mem_write(obj+0x148,b'\1')
 write32(pair,config);write32(pair+4,secondary_config if present else 0);u.mem_write(frame-0x4c,b'\1')
 u.reg_write(UC_X86_REG_EBP,frame);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_EDI,pair)
 u.emu_start(0x6b3280,0x6b32d1,count=200000);assert u.reg_read(UC_X86_REG_EIP)==0x6b32d1
 result=bool(u.mem_read(frame-0x4c,1)[0]);expected=secondary if present and secondary is not None else primary if primary is not None else True;assert result==expected
 layers.append(dict(name=name,primary=primary,secondary=secondary,secondary_present=present,result=result,queries=list(queries)))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='0x8afc30',binary_boolean_reader='0x8ae530',initializer_default_address='0x6b3241',initializer_key_address='0x10a28cc',key='FoW/upscale',initializer_default=True,resource_source=str(source),resource_sha256=hashlib.sha256(source.read_bytes()).hexdigest(),map10_authored=authored,cases=cases,native_addresses=len({a for a in visited if 0x8afc30<=a<0x8afd85 or 0x8ae530<=a<0x8ae5d8}),limits=['Original boolean query and binary fallback/conversion control flow execute. Typed binary table and missing binary string query are explicit adapters; whole file parser not executed.','Imported clock call at8AFC3E is skipped; security-cookie call at8AE5CD skipped preserving AL. Other allocator/cookie boundaries inherited from native probe prerequisites.','Original initializer supplies default true and key upscale; two-layer resolution, configuration cache/IO and full initializer execution remain open.','Map10 value is parsed from actual terrain.inibin; absence is distinct from explicit false. No normal GPU fog acceptance claimed.'])
(r/'data/4.20/fow_upscale_config_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
proof['layer_cases']=layers;proof['native_initializer_branch']='0x6b3280..0x6b32d1';proof['native_initializer_addresses']=len({a for a in visited if 0x6b3280<=a<0x6b32d1});proof['limits'][1]='GetCurrentThreadId import at8AFC3E returns synthetic thread1; security-cookie call at8AE5CD skipped preserving AL. Other allocator/cookie boundaries inherited from native probe prerequisites.';proof['limits'][2]='Original initializer supplies default true and key upscale; configuration cache/IO and full initializer execution remain open.';proof['limits'].append('Original two-layer initializer branch and native section/key hashing execute; prebuilt configuration objects and layer pair supplied. Whole cache/path/IO resolution remains open.')
(r/'data/4.20/fow_upscale_config_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(cases=len(cases),map10_authored=authored,map10_result=cases[0]['result'],native_addresses=proof['native_addresses'])))
