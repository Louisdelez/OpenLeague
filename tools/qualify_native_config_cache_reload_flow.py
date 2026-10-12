from pathlib import Path
import json,hashlib,datetime,itertools,shutil
r=Path('E:/OpenLeague');setup=(r/'tools/qualify_native_config_cache_policy.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0];exec(compile(setup,'native cache control flow prerequisites','exec'))
attrs_stub=end+0x1a0;remove_stub=end+0x1c0;w(0xfa41a4,attrs_stub);w(0xfa41ac,remove_stub);u.mem_write(attrs_stub,b'\xcc');u.mem_write(remove_stub,b'\xcc');constructors=[];events=[];new_pairs=[];attr_value=0;resolved=('', '', '')
locale_predicates=(False,False);locale_queries=[]
def allocate(size):
 global allocation
 p=allocation;allocation+=(size+32+15)//16*16;assert allocation<0x41100000;u.mem_write(p,b'\0'*size);return p
def full_hook(uc,a,size,user):
 global dictionary_exists
 sp=uc.reg_read(UC_X86_REG_ESP);this=uc.reg_read(UC_X86_REG_ECX)
 if a==thread_stub:finish(1);return
 if a==attrs_stub:events.append(dict(kind='attributes',path=cbytes(read(sp+4)).decode('latin1')));finish(attr_value,4);return
 if a==remove_stub:events.append(dict(kind='remove_directory',path=cbytes(read(sp+4)).decode('latin1')));finish(1,4);return
 if a in [0xc9f39b,0x9933e0]:
  size=read(sp+4);p=allocate(size)
  if size==8:new_pairs.append(p)
  finish(p);return
 if a==0xc98528:events.append(dict(kind='free',old_pair=read(sp+4)==pair));finish(uc.reg_read(UC_X86_REG_EAX));return
 if a==0x8ad540:events.append(dict(kind='destroy_pair',old_pair=this==pair));finish(0);return
 if a==0xc975f5:finish(uc.reg_read(UC_X86_REG_EAX));return
 if a==0x564c20:ssowrite(this,bytes(u.mem_read(read(sp+4),read(sp+8))));finish(this,8);return
 if a==0x5648a0:ssowrite(this,cbytes(read(sp+4)));finish(this,4);return
 if a==0x564900:finish(uc.reg_read(UC_X86_REG_EAX));return
 if a in [0x564af0,0x5fdb20]:
  src=ssoread(read(sp+4));start=read(sp+8);count=read(sp+12);data=src[start:] if count==0xffffffff else src[start:start+count];ssowrite(this,(ssoread(this) if a==0x5fdb20 else b'')+data);finish(this,12);return
 if a==0x5fda30:ssowrite(this,ssoread(this)+bytes(u.mem_read(read(sp+4),read(sp+8))));finish(this,8);return
 if a==0x5fa650:
  start=uc.reg_read(UC_X86_REG_EDX);stop=read(sp+4);destination=read(sp+8);u.mem_write(destination,bytes(u.mem_read(start,stop-start)).lower());finish(this);return
 if a==0x8b5700:
  ssowrite(uc.reg_read(UC_X86_REG_EDX),resolved[0].encode());ssowrite(read(sp+4),resolved[1].encode());ssowrite(read(sp+8),resolved[2].encode());finish(0);return
 if a==0x8ad5b0:
  args=[cbytes(read(sp+4+i*4)).decode('latin1') for i in range(3)];constructors.append(args);u.mem_write(this,b'\0'*0x180);u.mem_write(this+0x5c,b'\1');finish(this,12);return
 if a==0xc98c70:
  haystack=read(sp+4);index=cbytes(haystack).find(cbytes(read(sp+8)));finish(0 if index<0 else haystack+index);return
 if a==0xc9cf31:
  left=cbytes(read(sp+4));right=cbytes(read(sp+8));finish((left>right)-(left<right));return
 if a==0x5f4480:ssowrite(this,ssoread(this)+bytes([read(sp+4)&255]));finish(this,4);return
 if a==0x5fa520:ssowrite(this,ssoread(this)+cbytes(read(sp+4)));finish(this,4);return
 if a==0x8b5170:
  index=len(locale_queries);locale_queries.append(cbytes(this).decode('latin1'));finish(locale_predicates[index]);return
 if a==0xc9f8b6:events.append(dict(kind='localized_string_boundary',path=cbytes(read(sp+4)).decode('latin1'),limit=read(sp+8)));finish(0);return
 if a==0xc9f8d1:
  dest=read(sp+4);capacity=read(sp+8);data=cbytes(read(sp+12));assert len(data)<capacity;u.mem_write(dest,data+b'\0');finish(0);return
 if a==0x5fa720:
  start=read(sp+4);count=read(sp+8);left=ssoread(this)[start:start+count];right=bytes(u.mem_read(read(sp+12),read(sp+16)));finish((left>right)-(left<right),16);return
 if a==0x5c6700:
  dest=read(sp+4);dictionary_queries.append(ssoread(read(sp+8)).decode('latin1'));w(dest,node if dictionary_exists else sentinel);finish(dest,8);return
 if a==0x5fe7f0:ssowrite(this,ssoread(read(sp+4)));finish(this,4);return
 if a==0x8bbae0:
  destination=read(sp+4);value=read(sp+8);ssowrite(node+8,ssoread(value));w(node+0x20,0);w(destination,node);dictionary_exists=True;events.append(dict(kind='insert',key=ssoread(value).decode('latin1')));finish(destination,8);return
 assert any(begin<=a<stop for begin,stop in [(0x8acef0,0x8ad4c4),(0x993780,0x9937d3),(0x8b5da0,0x8b5e28),(0x8b5d50,0x8b5d99),(0x8b2ed0,0x8b30d0)]),hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,full_hook)
def normalize(path):
 out=bytearray()
 for b in path.lower().replace(b'\\',b'/'):
  if b==47 and len(out)>1 and out[-1]==47:continue
  out.append(b)
 return bytes(out)
paths=[b'config/game.cfg',b'Config/Game.cfg',b'Config\\Game.cfg',b'DATA/CFG/defaults/Game.cfg',b'Levels/Map10/terrain.ini',b'DATA/Characters/Annie/Spells/AnnieQ.ini',b'DATA\\Characters\\Annie\\Spells\\AnnieQ.ini',b'data/characters/annie/spells/annieq.ini',b'//server///Cfg//Game.cfg']
cases=[]
for requested,old_exists,dirty,flag,attr_value,locale,locale_predicates in itertools.product(paths,[False,True],[False,True],[0,1],[-1,0,16],[None,b'en_US',b'fr_FR',b''],[(False,False),(False,True),(True,False),(True,True)]):
 allocation=0x41000000;constructors.clear();events.clear();new_pairs.clear();dictionary_queries.clear();locale_queries.clear();dictionary_exists=old_exists
 u.mem_write(owner,b'\0'*0x100);u.mem_write(pair,b'\0'*8);u.mem_write(primary,b'\0'*0x180);u.mem_write(overlay,b'\0'*0x180);u.mem_write(node,b'\0'*0x30)
 for off in [0x28,0x40,0x58,0x70,0x88,0xa0,0xb8,0xd0]:ssowrite(owner+off,b'')
 w(owner+4,sentinel);w(owner+0x24,0);w(node+0x20,pair);w(pair,primary);w(pair+4,overlay);u.mem_write(primary+0x5c,bytes([dirty]));u.mem_write(overlay+0x5c,bytes([dirty]));w(0x2d77b20,1);w(0x14bef58,0);w(0x14bef40,0);u.mem_write(0x2d78db8,bytes([locale is not None]));u.mem_write(0x14beb74,(locale or b'')+b'\0')
 normalized=normalize(requested);directory,filename=normalized.rsplit(b'/',1) if b'/' in normalized else (b'',normalized);name,extension=filename.rsplit(b'.',1) if b'.' in filename else (filename,b'');resolved=((directory+b'/').decode() if directory else '',name.decode(),extension.decode())
 u.mem_write(path_buffer,requested+b'\0');w(stack,end);w(stack+4,path_buffer);w(stack+8,flag);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,owner);u.emu_start(0x8acef0,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end
 reload=not old_exists or dirty or flag!=0;expected=[]
 localized=requested
 if locale is not None and extension and not all(locale_predicates):
  localized=requested[:len(requested)-len(extension)-1]+b'_'+locale+b'.'+requested[-len(extension):]
 if reload:
  expected=[[normalize(localized).decode(),resolved[0]+'defaults/'+resolved[1]+'.'+resolved[2],requested.decode()]]
  if normalize(localized)!=normalized and b'/Spells/' not in requested and b'\\Spells\\' not in requested:expected.append([normalize(localized).decode(),normalize(localized).decode(),localized.decode()])
 assert constructors==expected,(requested,constructors,expected)
 result=u.reg_read(UC_X86_REG_EAX);assert read(owner+0x24)==result and result!=0
 if reload:
  assert result in new_pairs and read(node+0x20)==result
  assert u.mem_read(read(result)+0x5c,1)[0]==0
  assert bool(read(result+4))==(len(expected)==2)
  if read(result+4):assert u.mem_read(read(result+4)+0x5c,1)[0]==0
 else:assert result==pair and not new_pairs
 assert any(e['kind']=='destroy_pair' for e in events)==(old_exists and reload)
 cases.append(dict(requested=requested.decode(),locale=None if locale is None else locale.decode(),locale_predicates=locale_predicates,locale_queries=locale_queries.copy(),old_exists=old_exists,dirty=dirty,flag=flag,attributes=attr_value,resolved_prefix=resolved[0],resolved_name=resolved[1],resolved_extension=resolved[2],reloaded=reload,constructors=constructors.copy(),dictionary_queries=dictionary_queries.copy(),events=events.copy(),primary_dirty_after=bool(u.mem_read(read(result)+0x5c,1)[0]),overlay_present=bool(read(result+4))))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,entry='0x8acef0',native_sha256=hashlib.sha256(raw).hexdigest(),case_count=len(cases),native_addresses=len(visited),cases=cases,adapters=['Resource path splitter8B5700 supplies prefix/base/extension metadata; standard string, allocator/free and thread/exception cookie boundaries adapted.','Config constructor8AD5B0 supplies allocated configuration objects with dirty marker; parsing/loading/flags/ownership inside constructor not executed.','Dictionary lookup/insertion/destructor and filesystem attribute/removal boundaries adapted; no filesystem operations performed.','Original cache control flow, path lowercase/slash normalization, defaults construction, Spells exclusions, overlay decisions, replacement, dirty clearing and last-entry update execute. Locale-specific filename flag disabled.'],limits=['Cache control-flow/call contract only; original path resolver, constructor contents, dictionary allocation/lookup/lifetime, loader/file handling and localized names remain open.','Successful allocation only; allocation failure/exception cleanup and concurrency unqualified.','No runtime live cache/options/menu/persistence or complete game acceptance proof.'])
proof['adapters'][-1]='Original cache control flow, lowercase/slash normalization, defaults construction, Spells exclusions, overlay decisions, replacement, dirty clearing, last-entry update and localized filename8B2ED0 branches execute.'
proof['adapters'].append('Localized file predicate8B5170 supplies controlled booleans; native filesystem/resource predicate implementation not executed. Standard character/c-string append, comparison, bounded output copy and string boundary calls adapted. ASCII locale/global flag supplied; no localized file created.')
proof['limits'][0]='Cache control-flow/call contract only; original path resolver, constructor contents, dictionary allocation/lookup/lifetime, loader/file handling and localized file predicates remain open.'
(r/'data/4.20/native_config_cache_reload_flow_contract.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(cases=len(cases),native_addresses=len(visited),scope='whole cache control flow with constructor/path/dictionary adapters')))
