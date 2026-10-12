"""Execute original Icon UV selector and quad emitter; no graphics callback adapters."""
from pathlib import Path
import struct, json, hashlib, datetime, itertools
exec(Path('E:/OpenLeague/tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0])
owner=vector+0x6000; element=vector+0x7000; output=vector+0x8000
rect=vector+0x9000; color=rect+0x20; index=rect+0x30; vp=rect+0x40; ip=rect+0x44
vb=vector+0xa000; ib=vector+0xb000
def bits(values): return list(struct.unpack('<'+str(len(values))+'I',struct.pack('<'+str(len(values))+'f',*values)))
def floats(values): return [struct.unpack('<f',struct.pack('<I',x))[0] for x in values]
def f32(x): return struct.unpack('<f',struct.pack('<f',x))[0]
def run(address,ecx,edx,args):
    w(stack,end)
    for n,arg in enumerate(args):w(stack+4+4*n,arg)
    u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,ecx);u.reg_write(UC_X86_REG_EDX,edx)
    u.emu_start(address,end,count=500)
    assert u.reg_read(UC_X86_REG_EIP)==end
def observe(uc,address,length,data):
    assert 0x9a4f30<=address<=0x9a5029 or 0x99e8d0<=address<=0x99ea0a,hex(address)
    visited.add(address)
u.hook_add(unicorn.UC_HOOK_CODE,observe)
uv_cases=[]
uv_pairs=[([0,0,1,1],[0,0,1,1]),([.2,.7,.8,.9],[.7,.2,.9,.8]),([1,1,0,0],[0,0,1,1]),([-.5,2,1.25,-1],[.1,-.25,2,.75])]
for flag,blend,fraction,pair,unused in itertools.product([1,0x41,0x40],[0,.125,.5,1,1.5,-.25],[0,.25,1,1.25],uv_pairs,[0,0xdeadbeef]):
    a,b=map(lambda v:floats(bits(v)),pair)
    u.mem_write(element,bytes(0x228));w(element+0x48,flag);w(owner+0x18,bits([blend])[0]);w(element+0x1d0,bits([fraction])[0])
    u.mem_write(element+0x204,struct.pack('<4f',*a));u.mem_write(element+0x214,struct.pack('<4f',*b));u.mem_write(output,b'\xa5'*16)
    run(0x9a4f30,owner,0,[element,unused,output])
    actual=list(struct.unpack('<4I',u.mem_read(output,16)))
    expected=[f32(f32(f32(y-x)*blend)+x) for x,y in zip(a,b)]
    if flag&0x40:expected[2]=f32(f32(f32(expected[2]-expected[0])*fraction)+expected[0])
    assert actual==bits(expected),(flag,blend,fraction,actual,bits(expected))
    uv_cases.append(dict(flags=flag,blend_bits=bits([blend])[0],fraction_bits=bits([fraction])[0],first_bits=bits(a),second_bits=bits(b),unused_argument=unused,output_bits=actual))
quad_cases=[]
rects=[[0,0,1,1],[-.003125,.86083335,.246875,1],[1,1,-1,-2],[-0.0,1.0,0.0,1.0]]
for rectangle,uv,packed,base_index,missing in itertools.product(rects,[p[0] for p in uv_pairs],[0xffffffff,0xc8ffffff,0x00a1b2c3],[0,4,65534,65535,0xffffffff],['none','vertex','index']):
    rb=bits(rectangle);ub=bits(uv);u.mem_write(rect,struct.pack('<4I',*rb));u.mem_write(output,struct.pack('<4I',*ub));w(color,packed);w(index,base_index)
    w(vp,0 if missing=='vertex' else vb);w(ip,0 if missing=='index' else ib);u.mem_write(vb,b'\xa5'*96);u.mem_write(ib,b'\xa5'*12)
    run(0x99e8d0,rect,color,[output,index,vp,ip])
    vertices=bytes(u.mem_read(vb,96));indices=bytes(u.mem_read(ib,12));emitted=missing=='none'
    expected=b''.join(struct.pack('<6I',rb[x],rb[y],0,packed,ub[x],ub[y]) for x,y in [(0,1),(2,1),(0,3),(2,3)]) if emitted else b'\xa5'*96
    expected_indices=struct.pack('<6H',*[((base_index&0xffff)+n)&0xffff for n in [0,2,1,1,2,3]]) if emitted else b'\xa5'*12
    assert vertices==expected and indices==expected_indices
    assert read(index)==((base_index+4)&0xffffffff if emitted else base_index)
    assert read(vp)==(vb+96 if emitted else (0 if missing=='vertex' else vb))
    assert read(ip)==(ib+12 if emitted else (0 if missing=='index' else ib))
    quad_cases.append(dict(rect_bits=rb,uv_bits=ub,color=packed,base_index=base_index,missing=missing,vertices_hex=vertices.hex(),indices_hex=indices.hex(),next_index=read(index)))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),source=str(p),entries=['0x9a4f30','0x99e8d0'],native_addresses=len(visited),uv_case_count=len(uv_cases),quad_case_count=len(quad_cases),uv_cases=uv_cases,quad_cases=quad_cases,runtime_adapters=[],inputs=['Caller-owned rect/color/UV, element fields and allocated output buffers supplied.','Original owner+0x18 blend producer and fraction producer remain separate.'],findings=['UV lerp uses separate SSE subtraction/multiply/add; flag0x40 clips right UV with element+0x1D0 fraction. Second stack argument unused.','Quad output is four24-byte vertices ordered TL/TR/BL/BR, z0 and packed ARGB, six16-bit indices0,2,1,1,2,3; base counter adds4 as32-bit, indices use low16-bit.','Either null output pointer suppresses all writes and base advance.'],limits=['Does not qualify original shader, sampler, blend/gamma, matrix, buffer allocation/lifetime or final framebuffer.','Static Icon widgets are not yet drawn in normal OpenLeague; full HUD and game remain incomplete.'])
(r/'data/4.20/native_hud_icon_geometry_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({k:proof[k] for k in ['passed','uv_case_count','quad_case_count','native_addresses']}))
