from pathlib import Path
source=Path('E:/mapslol3v3/probe_native_material_draw_state.py').read_text(encoding='utf-8').split('cases=[]')[0]
source=source.replace('(0x95ad40<=a<=0x95adbf or','(0x9ac500<=a<0x9ac5f4 or 0x95b300<=a<0x95b3c2 or 0x95ad40<=a<=0x95adbf or')
exec(compile(source,__file__,'exec'))
reference=struct.unpack('<f',u.mem_read(0x1138c30,4))[0];assert reference==struct.unpack('<f',struct.pack('<f',0.9))[0];cases=[]
for initial,color_write in itertools.product(range(16),range(16)):
 alpha=bool(initial&1);depth=bool(initial&2);blend=bool(initial&4);depth_write=bool(initial&8)
 w(0x123ff20,(0x4000000 if alpha else 0)|(0x1000000 if depth else 0)|(0x8000000 if blend else 0));w(0x123ff60,color_write|(0x10000000 if depth_write else 0))
 for address in [0x123ff40,0x123ff44,*range(0x123ff48,0x123ff5c,4)]:w(address,0xffffffff)
 w(context+0x34,arena+0x7000);w(context+0x38,arena+0x7000);w(stack,end);w(stack+4,0);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,context);calls=[];u.emu_start(0x95b300,end,count=2000);assert u.reg_read(UC_X86_REG_EIP)==end
 expected=[]
 if not alpha:expected.append([15,1])
 expected.extend([[25,5],[24,229]])
 if color_write:expected.append([168,0])
 if not depth:expected.append([7,1])
 if not depth_write:expected.append([14,1])
 if blend:expected.append([27,0])
 expected.extend([[15,0],[168,15],[14,0],[27,1],[19,5],[207,5],[20,6],[208,6],[171,1],[206,1]])
 assert calls==expected,(initial,color_write,calls,expected)
 assert read(0x123ff20)&0x4000000==0 and read(0x123ff60)==15
 cases.append({'initial_state_bits':initial,'initial_color_write':color_write,'calls':calls.copy(),'final_alpha_enabled':False,'final_depth_write':False,'final_blend_enabled':True})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0x95b300','native_addresses':len(visited),'native_reference_float':reference,'quantized_reference_byte':229,'cases':cases,'findings':['Native selector7 special helper enables alpha test GREATER with authored reference0.9, quantized229; disables color writes and enables depth writing with no blending for first stage.','Helper then disables alpha test, restores all color writes, disables depth writing and enables SRCALPHA/INVSRCALPHA color/separate-alpha blend for subsequent stage.'],'runtime_adapters':['Original native instructions execute with zero batch rows, D3D setter callbacks recording actual calls, explicit cache/device/manager state, security cookie return adapter.'],'limits':['Actual nonempty draw batches and context state persistence through95AFC0/95B140 remain unfinished.','Original render ordering, framebuffer precision and production depth-only phase are not yet integrated.','This proof does not claim the current single blended branch fully matches the native two-stage selector7 path.']}
(r/'data/4.20/selector7_depth_phase_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'cases':len(cases),'native_addresses':len(visited),'reference_byte':229,'passed':True}))
