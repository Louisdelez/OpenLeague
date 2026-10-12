from pathlib import Path
import json,hashlib,datetime,itertools,shutil
r=Path('E:/OpenLeague')
setup=(r/'tools/qualify_native_user_config_directory.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0]
exec(compile(setup,'native user configuration prerequisites','exec'))
attributes={};root=b'';attrs_stub=end+0x120;w(0xfa41a4,attrs_stub);u.mem_write(attrs_stub,b'\xcc')
def hook_initializer(uc,a,size,user):
 sp=uc.reg_read(UC_X86_REG_ESP);this=uc.reg_read(UC_X86_REG_ECX)
 if a==0x9935d0:
  source=read(sp+4);count=read(sp+8);assert count==0xffffffff;limit=uc.reg_read(UC_X86_REG_EDX);data=cbytes(source)[:limit-1];u.mem_write(this,data+b'\0');finish(0);return
 if a==0x9937e0:
  data=cbytes(this);needle=cbytes(uc.reg_read(UC_X86_REG_EDX));index=data.lower().find(needle.lower());finish(0 if index<0 else this+index);return
 if a==0x564c20:ssowrite(this,bytes(u.mem_read(read(sp+4),read(sp+8))));finish(this,8);return
 if a==0x5fda30:ssowrite(this,ssoread(this)+bytes(u.mem_read(read(sp+4),read(sp+8))));finish(this,8);return
 if a==0xc98528:finish(uc.reg_read(UC_X86_REG_EAX));return
 if a==attrs_stub:
  path=cbytes(read(sp+4)).decode('latin1');calls.append(dict(kind='attributes',path=path));finish(attributes.get(path,-1),4);return
 if a==0xc9c554:
  calls.append(dict(kind='rename',source=cbytes(read(sp+4)).decode('latin1'),destination=cbytes(read(sp+8)).decode('latin1')));finish(0);return
 # Keep the underlying base producer and default path branches native.
 if a in [0x8b35a0]:visited.add(a);return
 if any(begin<=a<stop for begin,stop in [(0x8b3490,0x8b3655),(0x8b3970,0x8b3c0e),(0x8b30d0,0x8b313b),(0x8b2ed0,0x8b30d0),(0x8b5d50,0x8b5d99)]):visited.add(a);return
 hook_directory(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,hook_initializer)
cases=[]
for root,mode,access_result,dest_attr,source_attr in itertools.product([b'E:/OpenLeague',b'E:\\OpenLeague\\Game',b'E:/OpenLeague/game/assets',b'C:/Games/MyGameplay',b'./',b'E:/OpenLeague/RADS',b'E:/OpenLeague/rads/releases',b'E:/RADStuff/RADS',b'//server///folder//RADS/'],[0,1,2,3],[-1,0],[-1,0,16],[-1,0,16]):
 allocation=0x41000000;calls.clear();u.mem_write(0x2d858f0,root+b'\0');w(0x2d83fbc,1);w(0x2d859f4,mode);u.mem_write(0x2d78db8,b'\0');w(0x14bef40,0);ssowrite(0x2d8a9c0,b'')
 base=root
 if mode==0:
  normalized=base.replace(b'\\',b'/');result=bytearray()
  for b in normalized:
   if b==47 and len(result)>1 and result[-1]==47:continue
   result.append(b)
  base=bytes(result);needle=cbytes(0x10c9d20);index=base.lower().find(needle.lower())
  if index>=0 and base[index+5:index+6] in [b'',b'/']:base=base[:index]
 expected_dir=fallback if mode==2 or access_result!=0 else base+suffix;expected=expected_dir+file_name
 source_path=(fallback+file_name).decode('latin1');expected_path=expected.decode('latin1');attributes={source_path:source_attr,expected_path:dest_attr};
 w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(0x8b3970,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end
 actual=ssoread(0x2d8a9c0);assert actual==expected,(root,mode,actual,expected)
 renames=[c for c in calls if c['kind']=='rename'];should_rename=source_path!=expected_path and (dest_attr==-1 or dest_attr&16) and source_attr!=-1 and not source_attr&16
 assert renames==([dict(kind='rename',source=source_path,destination=expected_path)] if should_rename else []),(root,mode,renames,should_rename)
 cases.append(dict(root=root.decode('latin1'),mode=mode,access_result=access_result,destination_attributes=dest_attr,source_attributes=source_attr,path=actual.decode('latin1'),base=base.decode('latin1'),calls=list(calls)))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),initializer='0x8b3970',base_producer='0x8b35a0',legacy_base='0x8b3490',legacy_trim_needle=cbytes(0x10c9d20).decode('latin1'),directory='0x8b3840',migration='0x8b30d0',case_count=len(cases),native_addresses=len(visited),cases=cases,adapters=['Initialized process-mode/root globals supplied; process classifier8B3140 not executed. Locale-specific filename flag disabled; default filename branch8B2ED0 executes.','Standard strings, bounded path copy and case-insensitive substring search adapted. Original base selection, slash normalization, legacy /RADS trimming, directory choice, Game.cfg initialization and migration decisions execute.','Directory creation, access, attributes and rename boundaries recorded/supplied; no filesystem operations performed.','FS exception-chain cell supplied; security cookie and heap free adapted.'],limits=['Native default-language initialization/path migration decision scope; process-root/mode classification and locale-specific filenames still open.','Filesystem failures/races, actual runtime file selection/cache/menu/persistence and full game acceptance remain unqualified.'])
(r/'data/4.20/native_user_config_initializer_contract.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(cases=len(cases),native_addresses=len(visited),default_language_initializer=True,migration_decisions=True)))
