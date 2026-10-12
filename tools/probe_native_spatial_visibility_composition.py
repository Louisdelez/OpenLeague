from pathlib import Path
import json,struct,itertools,datetime,hashlib,shutil
r=Path('E:/OpenLeague')
source=(r/'tools/probe_native_spatial_visibility_query.py').read_text(encoding='utf-8').split('rows=[]')[0]
source=source.replace('assert 0x9601c0<=a<=0x960346 or 0x8e35c0<=a<=0x8e3720,hex(a)','assert base<=a<base+len(image),hex(a)')
exec(compile(source,'recursive query setup','exec'))
manager=vector+0x4800;w(0x2da52e8,1);w(0x14ae660,1);grid_bounds=[[-64,-64,64,64],[-64,-64,0,0],[0,-64,64,0],[-64,0,0,64],[0,0,64,64]];rows=[]
for center,half,root_records,present,bypass in itertools.product([-30.,-15.,0.,15.,30.],[.5,7.25,20.],[False,True],[False,True],[False,True]):
 planes=[[1.,0.,0.,half-center],[0.,1.,0.,10.],[0.,0.,1.,half-center],[0.,0.,-1.,half+center],[0.,-1.,0.,10.],[-1.,0.,0.,half+center]];volume_bounds=[center-half,-10.,center-half,center+half,10.,center+half]
 u.mem_write(volume+0x6c,struct.pack('<24f',*[v for p in planes for v in p]));u.mem_write(volume+0x114,struct.pack('<6f',*volume_bounds));nodes=[]
 for i in range(5):
  node=vector+0x1000+i*0x100;head=vector+0x3000+i*0x20;u.mem_write(node,b'\0'*0x80);w(node+0x44,head);w(head,head);records=[];gb=grid_bounds[i]
  for off,v in zip([0x10,0x14,0x18,0x1c],gb):w(node+off,v)
  u.mem_write(node+0x20,struct.pack('<2f',-10.,10.));count=3 if i!=0 or root_records else 0;w(node+0x48,count)
  for j in range(count):
   link=vector+0x5000+i*0x100+j*0x20;item=vector+0x8000+i*0x400+j*0x80;w(head if j==0 else link-0x20,link);w(link,head);w(link+8,item)
   position=[(gb[0]+gb[2])/2+[-15.,0.,15.][j],0.,(gb[1]+gb[3])/2];u.mem_write(item,struct.pack('<3f',*position));u.mem_write(item+0x10,struct.pack('<6f',-1.,-1.,-1.,1.,1.,1.));w(item+0x3c,100+i*3+j);records.append(dict(id=100+i*3+j,position=position,minimum=[-1.,-1.,-1.],maximum=[1.,1.,1.]))
  children=[1,2,3,4] if i==0 else []
  for j,ch in enumerate(children):w(node+0x34+4*j,vector+0x1000+0x100*ch)
  nodes.append(dict(grid_bounds=gb,bounds=[gb[0],-10.,gb[1],gb[2],10.,gb[3]],records=records,children=children))
 w(manager+4,vector+0x1000 if present else 0);w(output,values);w(output+4,values);w(output+8,values+1024);u.mem_write(0x2d78f7c,bytes([bypass]));u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff)
 invoke(0x95eba0,manager,[output,volume]);selected=[read(a) for a in range(values,read(output+4),4)]
 rows.append(dict(planes=planes,selectors=selectors,volume_bounds=volume_bounds,root=0 if present else None,bypass=bypass,nodes=nodes,selected=selected))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),cases=rows,native_instruction_addresses=len(visited),entries=['95EBA0','95EE00','9601C0','8E35C0','8E36B0','CA5F30','CA1E40'],adapters=['Original full95EBA0 grid/root/classification/recursive query composition executes; vector append with spare capacity adapted.','Axis-aligned translated volumes and tree layouts supplied; original camera builder and tree maintenance remain separate.','SSE CRT feature globals enabled with MXCSR1F80/x87CW37F.'],limits=['No original camera query/registry integration, sort or visibility-list merge composition yet.','Finite axis-aligned volume inputs only; no oblique, nonfinite, alternate FP or complete rendering acceptance.'])
(r/'data/4.20/spatial_visibility_composition_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(cases=len(rows),native_addresses=len(visited))))
