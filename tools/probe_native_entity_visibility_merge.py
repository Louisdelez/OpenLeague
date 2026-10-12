from pathlib import Path
import json,struct,itertools,datetime,hashlib,shutil
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'setup','exec'))
old_array=vector+0x1000;new_array=vector+0x2000;table=vector+0x4000;frame=stack+0x800;activate=end+0x100;deactivate=end+0x110;events=[]
w(table+0x68,activate);w(table+0x6c,deactivate)
descriptors={i:vector+0x5000+i*0x20 for i in range(1,5)};objects={i:vector+0x7000+i*0x200 for i in range(1,4)};reverse={v:k for k,v in objects.items()}
def hook(uc,a,size,user):
 if a==0x71a872:u.emu_stop();return
 if a in [activate,deactivate]:events.append(dict(id=reverse[u.reg_read(UC_X86_REG_ECX)],active=a==activate));finish(0);return
 assert 0x71a785<=a<0x71a872 or 0x71a8b0<=a<=0x71a900,hex(a)
 visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
profiles=[[],[0],[1],[2],[1,2],[1,1],[1,3],[1,2,3],[4],[0,1],[1,2,2],[2,4]];rows=[]
for old,new,mode in itertools.product(profiles,profiles,range(4)):
 events=[];eligible={};states=[]
 for i in range(1,5):
  obj=objects.get(i,0);w(descriptors[i]+4,obj)
  if obj:
   active=mode!=1 and (mode!=3 or i!=2);flags=0 if mode==2 or (mode==3 and i==3) else 0x212
   w(obj,table);u.mem_write(obj+0xad,bytes([active]));w(obj+0xb0,flags);eligible[i]=active and bool(flags&0x200)
   states.append(dict(id=i,active=active,flags=flags))
 for arr,items in [(old_array,old),(new_array,new)]:
  for j,i in enumerate(items):w(arr+j*4,descriptors.get(i,0))
 w(frame-0x150,old_array);w(frame-0x14c,old_array+4*len(old));w(0x2d628e8,new_array);w(0x2d628ec,new_array+4*len(new));u.reg_write(UC_X86_REG_EBP,frame);u.reg_write(UC_X86_REG_ESP,stack-8)
 u.emu_start(0x71a785,0x71a872,count=10000);assert u.reg_read(UC_X86_REG_EIP)==0x71a872
 expected=[]
 for i in sorted(set(old+new)):
  if eligible.get(i,False):
   delta=new.count(i)-old.count(i)
   expected.extend(dict(id=i,active=delta>0) for _ in range(abs(delta)))
 assert events==expected,(old,new,mode,events,expected)
 rows.append(dict(previous=old,current=new,objects=states,events=events.copy()))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),cases=rows,native_instruction_addresses=len(visited),range='71A785..71A872 plus71A8B0..71A900',findings=['Sorted current-only entries invoke virtual68; previous-only entries invoke virtual6C; equal entries invoke neither.','Null handles, null object pointers, inactive objects and objects without type bit200 are skipped.','Duplicate handles are consumed pairwise, not deduplicated; unmatched duplicates invoke repeated callbacks.'],adapters=['Sorted previous/current descriptor arrays supplied. Descriptors point to explicit object activity/type/table.','Virtual68/6C record ordered calls; native concrete activation/deactivation bodies were qualified separately in48sequences.','Stop before local container destruction; original list copy, frustum builder9863A0, tree query95EBA0 and sorter735920 remain unqualified.'],limits=['No native spatial query or runtime registry integration claimed.','Callback mutations of lists/objects and reentrancy not exercised.','No rendered camera transition or complete game acceptance.'])
(r/'data/4.20/entity_visibility_merge_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(passed=True,cases=len(rows),native_addresses=len(visited))))
