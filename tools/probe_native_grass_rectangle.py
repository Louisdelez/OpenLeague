from pathlib import Path
import sys, struct, json, hashlib, datetime, itertools, math
sys.path.insert(0, 'E:/OpenLeague/tools/pythonlibs')
import pefile, unicorn
from unicorn.x86_const import *
r=Path('E:/OpenLeague')
p=Path(r'D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe')
raw=p.read_bytes(); pe=pefile.PE(data=raw); memory=pe.get_memory_mapped_image(); base=pe.OPTIONAL_HEADER.ImageBase
u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32)
u.mem_map(base,(len(memory)+4095)&~4095);u.mem_write(base,memory)
arena=0x40000000;u.mem_map(arena,0x40000)
box=arena;out=arena+0x100;manager=arena+0x1000;stack=arena+0x30000;end=arena+0x3f000
w=lambda a,v:u.mem_write(a,struct.pack('<I',v&0xffffffff))
read=lambda a:struct.unpack('<I',u.mem_read(a,4))[0]
f32=lambda v:struct.unpack('<f',struct.pack('<f',v))[0]
bits=lambda v:struct.unpack('<I',struct.pack('<f',v))[0]
visited=set();corners=[];outputs=[];statuses=[]
def hook(uc,a,size,user):
 if a==0x9854f0:
  point=struct.unpack('<3f',u.mem_read(u.reg_read(UC_X86_REG_ECX),12));corners.append([bits(v) for v in point])
  index=len(corners)-1;u.mem_write(u.reg_read(UC_X86_REG_EDX),struct.pack('<3f',*outputs[index]))
  sp=u.reg_read(UC_X86_REG_ESP);u.reg_write(UC_X86_REG_EIP,read(sp));u.reg_write(UC_X86_REG_ESP,sp+4);u.reg_write(UC_X86_REG_EAX,statuses[index]);return
 assert 0x986510<=a<0x986753,hex(a)
 visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);w(0x2d79078,manager)
boxes=[[0.,0.,0.,10.,20.,30.],[-100.25,-5.5,3.75,15.75,44.25,9.125],[1.,2.,3.,1.,2.,3.]]
screen_sets=[[[10.9+i,20.9-i,0.5] for i in range(8)], [[-12.9, -15.9,0.5],[900.9,700.9,0.5]]*4, [[-0.9,-0.2,0.5],[0.9,0.2,0.5]]*4, [[float('nan'),float('inf'),0.5],[2147483648.,-2147483648.,0.5]]*4]
def cvtt(v):
 v=f32(v)
 return math.trunc(v) if math.isfinite(v) and -2147483648<=v<2147483648 else -2147483648
cases=[]
for aabb,margin,viewport,screen,mask in itertools.product(boxes,[0.,0.3,1.],[(800,600),(1,1),(0,0)],screen_sets,[0,1,128,255]):
 margin=f32(margin);corners=[];outputs=screen;statuses=[int(mask&(1<<i)!=0) for i in range(8)]
 u.mem_write(box,struct.pack('<6f',*aabb));w(manager+0x20328,viewport[0]);w(manager+0x2032c,viewport[1]);w(stack,end);w(stack+4,out);w(stack+8,bits(margin))
 u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,box);u.emu_start(0x986510,end,count=1200)
 expanded=[]
 for axis in range(3):
  expansion=f32(f32(f32(aabb[axis+3]-aabb[axis])*0.5)*margin)
  expanded.append([f32(aabb[axis]-expansion),f32(aabb[axis+3]+expansion)])
 expected_corners=[[bits(x),bits(y),bits(z)] for x,y,z in itertools.product(*expanded)]
 assert corners==expected_corners,(corners,expected_corners)
 xy=[[cvtt(v[0]),cvtt(v[1])] for v in outputs]
 expected=[max(0,min(v[0] for v in xy)),max(0,min(v[1] for v in xy)),min(viewport[0],max(v[0] for v in xy)),min(viewport[1],max(v[1] for v in xy))] if mask else [-1,-1,0,0]
 actual=list(struct.unpack('<4i',u.mem_read(out,16)))
 assert actual==expected,(actual,expected)
 assert u.reg_read(UC_X86_REG_EAX)==out
 cases.append({'aabb':aabb,'margin_bits':bits(margin),'viewport':viewport,'projection_output_bits':[[bits(v) for v in row] for row in outputs],'projection_success_mask':mask,'expanded_corner_bits':corners,'screen_rectangle':actual})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0x986510','native_addresses':len(visited),'cases':cases,'findings':['Native986510 expands each AABB half-span by the supplied margin and projects all eight corners in XYZ nested order.','Projected XY use SSE CVTTSS2SI truncation, including invalid-to-INT_MIN conversion; min/max include every corner regardless of its success flag.','If every corner projection reports failure the output is[-1,-1,0,0]; otherwise only lower edges clamp to zero and upper edges to viewport width/height. No rectangle normalization occurs.'],'runtime_adapters':['Original986510 instructions and constants execute;9854F0 supplies independent three-float screen points and success flags to isolate rectangle aggregation.','Viewport manager and caller stack supplied; no GPU or camera simulation.'],'limits':['Actual9854F0 camera projection, actor AABB producer and semantic eligibility gates remain open.','Quarter-resolution rectangle scaling/merging, target initialization, draw and actual native mask pixels remain unqualified.']}
(r/'data/4.20/grass_rectangle_contract.json').write_text(json.dumps(proof,indent=2,allow_nan=False)+'\n',encoding='utf-8')
print(json.dumps({'cases':len(cases),'corner_projections':len(cases)*8,'native_addresses':len(visited),'passed':True}))
