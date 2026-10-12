from pathlib import Path
import json,struct,itertools,datetime,hashlib,shutil
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'setup','exec'))
volume=vector+0x4000;output=vector+0x2000;values=vector+0x2200;rect=vector+0x4500
planes=[[1.,0.,0.,10.],[0.,1.,0.,10.],[0.,0.,1.,10.],[0.,0.,-1.,10.],[0.,-1.,0.,10.],[-1.,0.,0.,10.]];selectors=[[3,4,5]]*3+[[0,1,2]]*3
u.mem_write(volume+0x6c,struct.pack('<24f',*[v for p in planes for v in p]));u.mem_write(volume+0xcc,struct.pack('<18I',*[v for p in selectors for v in p]))
def hook(uc,a,size,user):
 if a==0x5bd2f0:
  sp=u.reg_read(UC_X86_REG_ESP);obj=u.reg_read(UC_X86_REG_ECX);tail=read(obj+4);assert tail<read(obj+8);w(tail,read(read(sp+4)));w(obj+4,tail+4);finish(0,4);return
 assert 0x9601c0<=a<=0x960346 or 0x8e35c0<=a<=0x8e3720,hex(a)
 visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
def invoke(entry,obj,args):
 w(stack,end)
 for i,v in enumerate(args):w(stack+4+4*i,v)
 u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,obj);u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.emu_start(entry,end,count=30000);assert u.reg_read(UC_X86_REG_EIP)==end;return u.reg_read(UC_X86_REG_EAX)
rows=[]
for initial,bypass,root_bounds,shift,children in itertools.product([-1,0,1],[False,True],[[-5,-5,5,5,-5.,5.],[-20,-20,20,20,-20.,20.],[30,30,40,40,30.,40.]],[0.,9.,30.],[False,True]):
 nodes=[]
 for i in range(5):
  node=vector+0x1000+i*0x100;head=vector+0x3000+i*0x20;u.mem_write(node,b'\0'*0x80);w(node+0x44,head)
  bounds=root_bounds if i==0 else [-2,-2,2,2,-2.,2.]
  for off,v in zip([0x10,0x14,0x18,0x1c],bounds[:4]):w(node+off,v)
  u.mem_write(node+0x20,struct.pack('<2f',*bounds[4:]));records=[]
  for j,x in enumerate([-15.,0.,15.]):
   link=vector+0x5000+i*0x100+j*0x20;item=vector+0x8000+i*0x400+j*0x80
   w(head if j==0 else link-0x20,link);w(link,head);w(link+8,item)
   position=[x+shift,0.,0.];u.mem_write(item,struct.pack('<3f',*position));u.mem_write(item+0x10,struct.pack('<6f',-1.,-1.,-1.,1.,1.,1.));w(item+0x3c,100+i*3+j)
   records.append(dict(id=100+i*3+j,position=position,minimum=[-1.,-1.,-1.],maximum=[1.,1.,1.]))
  nodes.append(dict(bounds=[bounds[0],bounds[4],bounds[1],bounds[2],bounds[5],bounds[3]],records=records,children=[1,2,3,4] if i==0 and children else []))
 if children:
  for j in range(4):w(vector+0x1000+0x34+4*j,vector+0x1100+0x100*j)
 w(output,values);w(output+4,values);w(output+8,values+1024);u.mem_write(0x2d78f7c,bytes([bypass]))
 invoke(0x9601c0,vector+0x1000,[output,rect,volume,initial&0xffffffff]);actual=[read(a) for a in range(values,read(output+4),4)]
 rows.append(dict(initial=initial,bypass=bypass,nodes=nodes,selected=actual))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),cases=rows,planes=planes,selectors=selectors,native_instruction_addresses=len(visited),entries=['9601C0','8E35C0','8E36B0'],findings=['Original recursive traversal and both actual plane tests execute over root and four populated children.','Classification-1 rejects subtree; classification0 tests records unless global bypass; nonzero classification appends records directly.','For classification0, original child loop classifies current node bounds before recursing into each child; child bounds are not substituted.'],adapters=['Explicit finite axis-aligned volume and tree/list layouts; actual tree construction, root query95EBA0 and floor/ceil grid conversion remain open.','Vector push5BD2F0 adapted with supplied spare capacity; record identity and traversal order preserved.'],limits=['Finite small-coordinate cases only; no full camera-volume composition, tree update or runtime integration.','Native query output still needs sorter735920 before the separately qualified visibility merge.'])
(r/'data/4.20/spatial_visibility_query_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(cases=len(rows),native_addresses=len(visited))))
