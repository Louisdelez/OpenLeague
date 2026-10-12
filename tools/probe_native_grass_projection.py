from pathlib import Path
import sys,struct,json,hashlib,datetime,itertools,random
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile,unicorn
from unicorn.x86_const import *
r=Path('E:/OpenLeague');p=Path(r'D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe')
raw=p.read_bytes();pe=pefile.PE(data=raw);m=pe.get_memory_mapped_image();b=pe.OPTIONAL_HEADER.ImageBase
u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);u.mem_map(b,(len(m)+4095)&~4095);u.mem_write(b,m)
a=0x40000000;u.mem_map(a,0x40000);point=a;out=a+0x100;vp=a+0x200;world=a+0x300;view=a+0x400;projection=a+0x500;manager=a+0x1000;driver=a+0x22000;vt=a+0x23000;callback=a+0x24000;stack=a+0x30000;end=a+0x3f000
w=lambda addr,v:u.mem_write(addr,struct.pack('<I',v&0xffffffff));read=lambda addr:struct.unpack('<I',u.mem_read(addr,4))[0]
bits=lambda v:struct.unpack('<I',struct.pack('<f',v))[0]
identity=[1.,0.,0.,0.,0.,1.,0.,0.,0.,0.,1.,0.,0.,0.,0.,1.]
visited=set();current_world=identity;current_viewport=[0,0,800,600,0.,1.]
def finish(pop=0,result=0):
 sp=u.reg_read(UC_X86_REG_ESP);u.reg_write(UC_X86_REG_EIP,read(sp));u.reg_write(UC_X86_REG_ESP,sp+4+pop);u.reg_write(UC_X86_REG_EAX,result)
def hook(uc,addr,size,user):
 if addr==callback:
  u.mem_write(read(u.reg_read(UC_X86_REG_ESP)+4),struct.pack('<4I2f',*current_viewport));finish(4);return
 if addr in [0x8de480,0x716810]:
  u.mem_write(u.reg_read(UC_X86_REG_ECX),struct.pack('<16f',*(identity if addr==0x8de480 else current_world)));finish();return
 if addr==0xc975f5:finish(result=u.reg_read(UC_X86_REG_EAX));return
 assert 0x9854f0<=addr<0x98598d,hex(addr);visited.add(addr)
u.hook_add(unicorn.UC_HOOK_CODE,hook);w(0x2d79078,manager);w(manager+0x14,driver);w(driver,vt);w(vt+0xe0,callback);u.reg_write(UC_X86_REG_FPCW,0x037f)
translated=identity[:];translated[12:15]=[0.125,-0.25,1.5]
scaled=identity[:];scaled[0]=1.75;scaled[5]=0.5;scaled[10]=2.
oblique=identity[:];oblique[1]=0.125;oblique[6]=-0.5;oblique[8]=0.25
perspective=[1.5,0.,0.,0.,0.,2.,0.,0.,0.,0.,1.01,1.,0.,0.,-0.2,0.]
rng=random.Random(420);dense=[[rng.uniform(-2.,2.) for _ in range(16)] for _ in range(3)]
matrix_sets=[(identity,identity,identity),(translated,identity,identity),(scaled,oblique,perspective),(identity,oblique,perspective),tuple(dense),(identity,identity,[0.]*16)]
points=[[0.,0.,0.],[1.,1.,1.],[-1.,-1.,-1.],[0.25,-0.75,0.5],[1000.125,-999.25,1.],[0.,0.,-0.01],[1e-6,1e-6,1e-6]]
viewports=[[0,0,800,600,0.,1.],[17,31,803,607,0.125,0.875],[0,0,1,1,0.,1.],[2147483648,0,4294967295,600,0.,1.]]
cases=[];compound=[]
for pos,matrices,viewport in itertools.product(points,matrix_sets,viewports):
 current_world=list(matrices[0]);current_viewport=viewport
 u.mem_write(point,struct.pack('<3f',*pos));u.mem_write(vp,struct.pack('<4I2f',*viewport))
 for addr,mat in zip([world,view,projection],matrices):u.mem_write(addr,struct.pack('<16f',*mat))
 u.mem_write(out,struct.pack('<3I',*[0xcdcdcdcd]*3));w(stack,end)
 for i,ptr in enumerate([vp,projection,view,world]):w(stack+4+i*4,ptr)
 u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,out);u.reg_write(UC_X86_REG_EDX,point);u.emu_start(0x985680,end,count=1000)
 accepted=u.reg_read(UC_X86_REG_EAX)!=0;output=list(struct.unpack('<3I',u.mem_read(out,12)))
 if not accepted:assert output==[0xcdcdcdcd]*3
 row={'point_bits':[bits(v) for v in pos],'world_bits':[bits(v) for v in matrices[0]],'view_bits':[bits(v) for v in matrices[1]],'projection_bits':[bits(v) for v in matrices[2]],'viewport':viewport,'w_nonzero':accepted,'screen_bits':output};cases.append(row)
 if not accepted:continue
 # Execute actual wrapper and985680 together; only viewport/matrix providers adapted.
 u.mem_write(manager+0xa8,struct.pack('<16f',*matrices[1]));u.mem_write(manager+0xe8,struct.pack('<16f',*matrices[2]))
 for render_size,window in [([800,600],[0,0,800,600]),([1920,1080],[17,31,820,638]),([1,1],[-10,-20,20,40])]:
  for offset,value in zip([0x20328,0x2032c,0x20340,0x20344,0x20348,0x2034c],render_size+window):w(manager+offset,value)
  w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,point);u.reg_write(UC_X86_REG_EDX,out);u.emu_start(0x9854f0,end,count=1500)
  compound.append({'projection_case':len(cases)-1,'render_size':render_size,'window':window,'accepted':u.reg_read(UC_X86_REG_EAX)!=0,'screen_bits':list(struct.unpack('<3I',u.mem_read(out,12)))})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0x985680 /0x9854f0','native_addresses':len(visited),'cases':cases,'compound_cases':compound,'findings':['Native985680 transforms point by world then view then projection with individual SSE scalar operations; perspective divide is followed by viewport mapping.','Exact-zero homogeneous W returns zero and leaves output untouched. The wrapper9854F0 ignores that return, so its zero-W output uses uninitialized local data and is deliberately excluded from port qualification.','Native depth mapping is(ndcZ+1)*0.5+viewportMinZ; the viewportMaxZ field is not consumed by985680.','Native9854F0 remaps viewport coordinates to render target size and accepts depth in[0,1), XY in inclusive target bounds.'],'runtime_adapters':['All985680 projection arithmetic executes without adapters; fixtures supply matrices and viewport.','Compound9854F0 includes actual985680; driver viewport retrieval, world-matrix initialization/provider and security cookie adapted.'],'limits':['Historical matrices/viewport producers and live camera interoperability remain open. Fixture matrices are explicit numerical inputs, not claimed historical initialization.','Native x87 extended arithmetic may differ outside the tested cases; no universal precision equivalence claimed.','Zero-W wrapper path has undefined output and remains explicitly unsupported; no GPU grass mask integration claimed.']}
proof['x87_control_word']=0x037f
proof['limits'].append('x87 control word037F supplied explicitly (extended precision, nearest rounding); historical control-word initialization and other precision modes remain unqualified.')
(r/'data/4.20/grass_projection_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'projection_cases':len(cases),'compound_cases':len(compound),'native_addresses':len(visited),'passed':True}))
