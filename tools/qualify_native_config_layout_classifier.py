from pathlib import Path
import json,hashlib,datetime,itertools,random,shutil
r=Path('E:/OpenLeague');setup=(r/'tools/qualify_native_user_config_directory.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0];exec(compile(setup,'native layout classifier prerequisites','exec'))
markers=['DATA','../configurationmanifest','../solutionmanifest','../lol.launcher_tencent.exe','../Air','../Game','HeroPak_client.zip','Map1.zip','../TCLS','../zlib1.dll','debug','LEVELS','Build','ParticleTool','luac5.1.exe','DATA/Buffs']
root=b'';attrs={};requests=[];get_cwd=end+0x180;get_attrs=end+0x1a0;w(0xfa41d8,get_cwd);w(0xfa41a4,get_attrs);u.mem_write(get_cwd,b'\xcc');u.mem_write(get_attrs,b'\xcc')
def classifier_hook(uc,a,size,user):
 sp=uc.reg_read(UC_X86_REG_ESP);this=uc.reg_read(UC_X86_REG_ECX)
 if a==get_cwd:
  assert read(sp+4)==260;u.mem_write(read(sp+8),root+b'\0');finish(len(root),8);return
 if a==get_attrs:
  path=cbytes(read(sp+4)).decode('ascii');assert path in markers,path;requests.append(path);finish(attrs.get(path,-1),4);return
 if a==0x564c20:ssowrite(this,bytes(u.mem_read(read(sp+4),read(sp+8))));finish(this,8);return
 if a==0x5fa650:
  start=uc.reg_read(UC_X86_REG_EDX);stop=read(sp+4);destination=read(sp+12);assert stop>=start;u.mem_write(destination,bytes(u.mem_read(start,stop-start)).lower());finish(this);return
 if a==0xc98c70:
  haystack=read(sp+4);needle=cbytes(read(sp+8));index=cbytes(haystack).find(needle);finish(0 if index<0 else haystack+index);return
 if a==0xc98528:finish(uc.reg_read(UC_X86_REG_EAX));return
 if a==0xc975f5:finish(uc.reg_read(UC_X86_REG_EAX));return
 assert 0x8b3140<=a<0x8b3490,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,classifier_hook)
def scores(path,attributes):
 is_dir=lambda key:attributes.get(key,-1)!=-1 and bool(attributes[key]&16)
 is_file=lambda key:attributes.get(key,-1)!=-1 and not attributes[key]&16
 lower=path.lower();primary=3*int(b'rads' in lower)+int(b'solutions' in lower)+int(b'lol_game_client_sln' in lower)+2*is_dir('DATA')+2*is_file('../configurationmanifest')+2*is_file('../solutionmanifest')
 tencent=3*is_file('../lol.launcher_tencent.exe')+is_dir('../Air')+is_dir('../Game')+2*is_dir('../TCLS')+2*is_file('../zlib1.dll')
 if is_dir('../Game'):tencent+=2*is_file('HeroPak_client.zip')+2*is_file('Map1.zip')
 developer=3*int(b'DevRoot' in path)+is_dir('debug')+2*is_dir('LEVELS')+is_dir('Build')+is_dir('ParticleTool')
 if is_dir('DATA'):developer+=1+is_file('luac5.1.exe')+is_dir('DATA/Buffs')
 return [int(primary),int(tencent),int(developer)]
def run(path,attributes):
 global allocation,root,attrs
 root=path;attrs=attributes;allocation=0x41000000;requests.clear();w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(0x8b3140,end,count=50000);assert u.reg_read(UC_X86_REG_EIP)==end
 actual=read(0x2d859f4);values=scores(root,attrs);maximum=max(values);expected=values.index(maximum) if values.count(maximum)==1 else 3;assert actual==expected,(root,values,actual,expected)
 return dict(root=root.decode('ascii'),attributes=dict(attrs),scores=values,mode=actual,queries=list(requests))
layouts=[{},dict.fromkeys(markers,0),dict.fromkeys(markers,16)]
for marker,value in itertools.product(markers,[0,16]):layouts.append({marker:value})
rng=random.Random(420)
for _ in range(128):layouts.append({marker:rng.choice([-1,0,16]) for marker in markers})
roots=[b'E:/OpenLeague',b'E:/RADS/solutions/lol_game_client_sln',b'E:/rads/solutions/lol_game_client_sln',b'E:/DevRoot',b'E:/devroot',b'E:/DEVROOT',b'E:/others',b'./',b'E:/NoRads/Resolutions/lol_game_client_sln/DevRoot']
cases=[run(root,attributes) for root,attributes in itertools.product(roots,layouts)]
actual_root=r.resolve();actual_attrs={}
for marker in markers:
 p=actual_root/marker
 actual_attrs[marker]=16 if p.is_dir() else 0 if p.exists() else -1
actual=run(str(actual_root).encode('ascii'),actual_attrs)
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entry='0x8b3140',score_entries=['0x8b31d0','0x8b3340','0x8b33e0'],native_addresses=len(visited),case_count=len(cases),markers=markers,cases=cases,actual_project=actual,adapters=['GetCurrentDirectoryA supplies controlled ASCII project roots; actual cwd retrieval and failure/length limits not executed.','GetFileAttributesA supplied controlled missing/file/directory masks; actual project marker existence/type separately queried with host filesystem.','Standard string assignment/free, lowercase transform and strstr adapted; original score branches, query ordering, weighting and mode comparison/tie handling execute.','Security cookie adapted; native image/data and original instruction paths remain unchanged.'],limits=['ASCII path/layout classification scope; other encodings, real cwd failures, other Windows attribute bits and process-global concurrency remain open.','Classifier is not the full configuration cache, localized filename branch, UI/persistence or whole-game completion proof.'])
(r/'data/4.20/native_config_layout_classifier_contract.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(cases=len(cases),native_addresses=len(visited),actual_project_scores=actual['scores'],actual_project_mode=actual['mode'])))
