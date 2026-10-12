from pathlib import Path
import sys,struct,json,hashlib,datetime,itertools
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile,unicorn
from unicorn.x86_const import *
r=Path('E:/OpenLeague');p=Path(r'D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe')
raw=p.read_bytes();pe=pefile.PE(data=raw);m=pe.get_memory_mapped_image();b=pe.OPTIONAL_HEADER.ImageBase
u=unicorn.Uc(unicorn.UC_ARCH_X86,unicorn.UC_MODE_32);u.mem_map(b,(len(m)+4095)&~4095);u.mem_write(b,m)
a=0x40000000;u.mem_map(a,0x50000);rect=a;uvrect=a+0x100;context=a+0x200;color=a+0x300;manager=a+0x10000;driver=a+0x32000;vt=a+0x33000;callbacks=a+0x34000;stack=a+0x40000;end=a+0x4f000;default=a+0x5000
w=lambda addr,v:u.mem_write(addr,struct.pack('<I',v&0xffffffff));read=lambda addr:struct.unpack('<I',u.mem_read(addr,4))[0]
bits=lambda v:struct.unpack('<I',struct.pack('<f',v))[0]
visited=set();events=[];constants={};texture_bindings=[]
counts={0x70:3,0x94:1,0x58:1,0x8c:3,0x84:1,0x3c:4,0x50:1,0x20:6}
def args(n):return [read(u.reg_read(UC_X86_REG_ESP)+4+i*4) for i in range(n)]
def finish(pop=0,value=0):
 sp=u.reg_read(UC_X86_REG_ESP);u.reg_write(UC_X86_REG_EIP,read(sp));u.reg_write(UC_X86_REG_ESP,sp+4+pop);u.reg_write(UC_X86_REG_EAX,value)
def hook(uc,addr,size,user):
 if callbacks<=addr<callbacks+0x100:
  slot=addr-callbacks;values=args(counts[slot]);events.append({'driver_slot':slot,'arguments':values})
  if slot==0x94:w(values[0],1)
  if slot==0x8c:constants[values[0]]=list(struct.unpack('<'+'I'*(values[2]*4),u.mem_read(values[1],values[2]*16)))
  finish(counts[slot]*4);return
 if addr==0x983cb0:texture_bindings.append(args(2));finish(8);return
 if addr==0x9844c0:events.append({'pixel_selector':args(1)});finish(4);return
 if addr in [0x5f6620,0xc975f5]:finish(value=u.reg_read(UC_X86_REG_EAX));return
 assert 0x986760<=addr<0x986959 or 0x986ad0<=addr<0x986d42,hex(addr);visited.add(addr)
u.hook_add(unicorn.UC_HOOK_CODE,hook);w(0x2d79078,manager);w(manager+0x14,driver);w(driver,vt);w(manager+0x2035c,0xffffffff);w(0x14bef38,default)
for slot in counts:w(vt+slot,callbacks+slot)
cases=[]
for destination,source,size,api,warm in itertools.product([[2,5,12,25],[-1,-1,0,0],[0,0,0,0],[16777217,-12,16777221,7]],[[0,0,800,600],[10,20,31,41]],[(800,600),(803,607),None],[0,1,2],[False,True]):
 events=[];constants={};texture_bindings=[];u.mem_write(rect,struct.pack('<4i',*destination));u.mem_write(uvrect,struct.pack('<4i',*source));w(color,0xffffffff);w(0x1225c58,api);w(0x2d9101c,int(warm));w(0x2d90ff4,bits(0.25))
 if size is not None:w(context+0x60,size[0]);w(context+0x64,size[1])
 w(stack,end);w(stack+4,uvrect);w(stack+8,color);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,rect);u.reg_write(UC_X86_REG_EDX,context if size else 0);u.emu_start(0x986760,end,count=2500)
 assert texture_bindings==[[context if size else default,0]]
 assert all(slot in constants for slot in [4,5,6])
 sampler=[e['arguments'] for e in events if e.get('driver_slot')==0x70];assert sampler==[[0,0,2],[0,1,2],[0,0,0],[0,1,0]]
 draws=[e['arguments'] for e in events if e.get('driver_slot')==0x20];assert draws==[[1,0,0,4,0,2]]
 assert constants[6]==[bits(1.)]*4
 cases.append({'destination_rectangle':destination,'source_rectangle':source,'source_size':size,'api_flag':api,'offset_cache_warm':warm,'initial_cached_offset_bits':bits(.25),'final_cached_offset_bits':read(0x2d90ff4),'destination_xywh_bits':constants[4],'source_uv_origin_span_bits':constants[5],'color_rgba_bits':constants[6],'source_texture':'context' if size else 'default','sampler_calls':sampler,'draw_arguments':draws[0]})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0x986760 ->0x986ad0','native_addresses':len(visited),'cases':cases,'findings':['Actual rectangle/quad code binds the supplied context itself to sampler0, or global14BEF38 for nullcontext; this source is not an invented white texture.','Source UV comes from a separate integer rectangle divided by signed context dimensions; apiFlag1applies one-texel offset and vertical flip.','Destination origin includes a lazily cached offset, then the low-level quad applies another API-dependent half-pixel offset. Width/height are signed integer differences.','Driver receives destinationxywh at vertex constant4, sourceUVorigin/span at5, normalized packed color at6, and indexed quad draw[1,0,0,4,0,2]; slot0address state2is set before and0after.'],'runtime_adapters':['All986760 and986AD0 arithmetic executes; shader/state/texture/driver buffer uploads and indexed draw are recording adapters; security/profiling helpers preserve return registers.','Sourcecontext/default handles and renderer cache supplied explicitly.'],'limits':['Global default texture/context producer, native driver enum interpretation and buffers/vertex shader, exact texel sampling and GPU pixels remain open.','These fixtures do not prove the source context represents a scene texture, a visibility mask or a particular bitmap.','No live grass mask integrated.']}
(r/'data/4.20/grass_quad_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'cases':len(cases),'native_addresses':len(visited),'passed':True}))
