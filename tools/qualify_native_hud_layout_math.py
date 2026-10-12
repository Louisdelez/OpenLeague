from pathlib import Path
import json,struct,hashlib,datetime,itertools,shutil,math
r=Path('E:/OpenLeague')
exec(compile((Path(__file__).parent/'probe_native_hud_formatted_scanner.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'native HUD layout prerequisites','exec'))
u.hook_add(unicorn.UC_HOOK_CODE,scanner_hook)
w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(0xca1da7,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
owner=vector+0x6000;parent=vector+0x7000;output=vector+0xd000
f32=lambda x:struct.unpack('<f',struct.pack('<f',x))[0]
bits=lambda x:struct.unpack('<I',struct.pack('<f',x))[0]
constant=lambda p:struct.unpack('<f',u.mem_read(p,4))[0]
put=lambda p,v:u.mem_write(p,struct.pack('<'+'f'*len(v),*v))
geometries=[dict(rect=[.383125,.776666667,.413125,.816666667],anchors=[.5,1.,.5,1.],offset=[.02,-.01],fractions=[1.,1.],aspect=1.),dict(rect=[-.025,.1,.234,.337],anchors=[-.5,.7,.25,.9],offset=[.1,-.1],fractions=[.5,.75],aspect=1.25)]
cases=[]
for flags,dimensions,scalar,mode,geometry in itertools.product([0,2,0x20,0x80,0x1000,0x1080,0x22,0x10a2],[(1024,768),(1280,800),(1920,1080),(2560,1440)],[-1.,0.,1.],range(3),geometries):
 calls.clear();u.reg_write(UC_X86_REG_FPCW,0x27f);u.reg_write(UC_X86_REG_FPSW,0);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80);g={k:[f32(x) for x in v] if isinstance(v,list) else f32(v) for k,v in geometry.items()};width,height=dimensions;u.mem_write(owner,b'\0'*0x40);u.mem_write(obj,b'\0'*0x300);u.mem_write(parent,b'\0'*0x100);put(owner+0x18,[scalar]);w(owner+0x1c,width);w(owner+0x20,height);w(obj+0x48,flags);w(obj+0x50,parent if mode==2 else 0)
 put(obj+0x1a8,g['anchors']);put(obj+0x1b8,g['offset']);put(obj+0x1c0,g['rect']);put(obj+0x1d0,g['fractions']+[g['aspect']]);put(parent+0x80,[.05,.02])
 w(stack,end);w(stack+4,obj);w(stack+8,output);w(stack+12,int(mode!=0));u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,owner)
 try:u.emu_start(0x9a4b30,end,count=250000)
 except unicorn.UcError as e:raise RuntimeError((str(e),hex(u.reg_read(UC_X86_REG_EIP)),calls[-15:])) from e
 assert u.reg_read(UC_X86_REG_EIP)==end,(flags,dimensions,hex(u.reg_read(UC_X86_REG_EIP)))
 actual=list(struct.unpack('<4I',u.mem_read(output,16)));values=list(g['rect']);a=g['anchors']
 if mode:values=[f32(v+g['offset'][k%2]) for k,v in enumerate(values)]
 if not flags&0x22:
  scale=1. if flags&0x80 else f32(f32(scalar*constant(0x1138ba4))+constant(0x1138ba4))
  values=[f32(f32(f32(v-a[k])*scale)+a[k]) for k,v in enumerate(values)]
 if mode==2:values=[f32(v+f32([.05,.02][k%2])) for k,v in enumerate(values)]
 values[2]=f32(f32(f32(values[2]-values[0])*g['fractions'][0])+values[0]);values[3]=f32(f32(f32(values[3]-values[1])*g['fractions'][1])+values[1])
 if not flags&0x20:
  t=f32(f32(f32(height)*constant(0x1138a18))*g['aspect']);sx=f32(t*constant(0x11391c8)/width);sy=f32(f32(t*constant(0x11391ac))/f32(height));values=[f32(f32(f32(v-a[k])*[sx,sy][k%2])+a[k]) for k,v in enumerate(values)]
 if not flags&0x1000:
  values[0]=f32(math.floor(f32(f32(width)*values[0]))/f32(width));values[2]=f32(math.ceil(width*values[2])/f32(width))
 values[1]=f32(math.floor(f32(f32(height)*values[1]))/f32(height));values[3]=f32(math.ceil(height*values[3])/f32(height))
 expected=[bits(v) for v in values]
 assert actual==expected,(flags,dimensions,scalar,mode,g,actual,expected,calls[-10:])
 cases.append(dict(flags=flags,width=width,height=height,owner_scalar_bits=bits(scalar),include_motion=mode!=0,parent_offset_bits=[bits(f32(x)) for x in [.05,.02]] if mode==2 else None,rect_bits=[bits(x) for x in g['rect']],anchor_bits=[bits(x) for x in g['anchors']],offset_bits=[bits(x) for x in g['offset']],fractions_bits=[bits(x) for x in g['fractions']],aspect_bits=bits(g['aspect']),output_bits=actual))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,entry='0x9a4b30',native_sha256=hashlib.sha256(raw).hexdigest(),case_count=len(cases),native_addresses=len(visited),cases=cases,adapters=['Owner/element/group fields and positive viewport dimensions supplied; original constructors/settings producers remain open.','Original transform/SSE/x87 arithmetic and original CRT ceil execute; initialized CRT dispatch, thread/DecodePointer context and cookie/errno/logger adapters reused.'],limits=['Finite supplied states, four viewport sizes and listed flags; zero/nonfinite dimensions and other FP modes remain open.','Flags1000 disable horizontal snap only; vertical edges still snap in executed code.','No full source parser, widget visibility/type construction, drawing or original framebuffer qualification.'])
proof.update(supplied_x87_control_word='0x027f',supplied_mxcsr='0x1f80',x87_stack_empty_before_each_case=True)
proof['adapters'].append('Explicit x87 precision53/masked exceptions and SSE nearest/default masks supplied; x87 stack reset before each independent case.')
(r/'data/4.20/native_hud_layout_math_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(cases=len(cases),native_addresses=len(visited),passed=True)))
