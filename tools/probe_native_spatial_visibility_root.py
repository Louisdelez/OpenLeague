from pathlib import Path
import json,struct,itertools,datetime,hashlib,shutil
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'setup','exec'))
manager=vector+0x3000;rectangle=vector+0x3200;addresses=[vector+0x1000+i*0x100 for i in range(6)];bounds=[[-10,-10,10,10],[-10,-10,0,0],[0,-10,10,0],[-10,0,0,10],[0,0,10,10],[-10,-10,-5,-5]]
def hook(uc,a,size,user):
 assert 0x95ee00<=a<=0x95ee8c,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
queries=[[-30,-30,-20,-20],[-9,-9,-8,-8],[-4,-4,-3,-3],[-1,-1,1,1],[0,0,0,0],[10,10,10,10],[-10,10,-10,10],[1,-9,2,-8],[-9,1,-8,2],[1,1,2,2],[-2147483648,-2147483648,2147483647,2147483647],[1,1,-1,-1]];rows=[]
for query,present,root_count,child_count,deep,mask in itertools.product(queries,[False,True],[0,1],[0,1],[False,True],[0,1,3,15]):
 nodes=[]
 for i,a in enumerate(addresses):
  u.mem_write(a,b'\0'*0x80);children=[j+1 if mask&(1<<j) else None for j in range(4)] if i==0 else [5,None,None,None] if i==1 and deep else [None]*4
  count=root_count if i==0 else child_count if i==1 else 0
  for off,value in zip([0x10,0x14,0x18,0x1c],bounds[i]):w(a+off,value)
  w(a+0x48,count)
  for j,ch in enumerate(children):w(a+0x34+4*j,0 if ch is None else addresses[ch])
  nodes.append(dict(bounds=bounds[i],record_count=count,children=children))
 w(manager+4,addresses[0] if present else 0);u.mem_write(rectangle,struct.pack('<4i',*query));w(stack,end);w(stack+4,rectangle);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,manager);u.emu_start(0x95ee00,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
 value=u.reg_read(UC_X86_REG_EAX);selected=addresses.index(value) if value else None
 rows.append(dict(query=query,root=0 if present else None,nodes=nodes,selected=selected))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),cases=rows,native_instruction_addresses=len(visited),entry='95EE00',findings=['Descends only when current node has no records and exactly one child intersects the integer query rectangle.','Zero or multiple intersecting children return current node; absent root returns null.','Child overlap is inclusive and signed32-bit; touching borders can prevent descent.'],adapters=['Tree topology, integer bounds and per-node record counts supplied. Original95EE00 executes without call adapters.'],limits=['Tree allocation/maintenance, float-to-grid conversion95EBA0 and camera composition remain open.','No runtime renderer integration or complete-game acceptance.'])
(r/'data/4.20/spatial_visibility_root_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(cases=len(rows),native_addresses=len(visited))))
