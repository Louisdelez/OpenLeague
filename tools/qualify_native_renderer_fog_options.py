from pathlib import Path
import json,struct,hashlib,datetime,itertools
r=Path('E:/OpenLeague')
prefix=(r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0]
exec(compile(prefix,'isolated PE renderer options','exec'))
frame=stack+0x1000;submissions=[]
def macro_pairs(ptr):
 start,stop=read(ptr),read(ptr+4)
 return [dict(name=string(read(a)),value=string(read(a+4))) for a in range(start,stop,8)]
def renderer_hook(uc,a,size,user):
 visited.add(a)
 if a==0x980fa0:
  sp=uc.reg_read(UC_X86_REG_ESP);args=list(struct.unpack('<5I',uc.mem_read(sp+4,20)))
  submissions.append(dict(arguments=args[:4],macro_vector=macro_pairs(args[4])))
  finish(1,20);return
 assert (0x960918<=a<0x96096f or 0x987830<=a<0x9878be or 0x77de90<=a<0x77df05),hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,renderer_hook)
cases=[]
for palette,enabled,quality in itertools.product([0,1,2,3],[False,True],[-1,0,1,2,3,4]):
 w(frame-0x24,storage);w(frame-0x20,storage);w(frame-0x1c,storage+1024)
 for i,value in enumerate([1920,1080,32,0]):w(frame+8+i*4,value)
 w(0x2d79058,palette);w(0x1225904,quality);u.mem_write(0x14be79f,bytes([enabled]))
 u.reg_write(UC_X86_REG_EBP,frame);u.reg_write(UC_X86_REG_ESP,stack);submissions.clear()
 u.emu_start(0x960918,0x96096f,count=3000);assert u.reg_read(UC_X86_REG_EIP)==0x96096f
 names=['COLORPALETTE_SPECTATOR' if palette==1 else 'COLORPALETTE_COLORBLIND' if palette==2 else 'COLORPALETTE_DEFAULT']
 if enabled:
  names+=['VERTEX_FOG'] if quality==0 else ['FOG_PIXELSHADER_BLEND']
  if quality==1:names+=['FOG_QUALITY_LOW']
  elif (quality&0xffffffff)>=2:names+=['FOG_TEXTURED_OPACITY']
 expected=[dict(name=n,value='1') for n in names]
 assert len(submissions)==1 and submissions[0]==dict(arguments=[1920,1080,32,0],macro_vector=expected)
 cases.append(dict(palette=palette,fog_enabled=enabled,fog_quality=quality,submission=submissions[0]))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,
 native_sha256=hashlib.sha256(raw).hexdigest(),case_count=len(cases),native_addresses=len(visited),cases=cases,
 entry='0x960918',stop='0x96096f',renderer_initialization_boundary='0x980fa0',fog_macro_builder='0x987830',
 findings=['Global2D79058 selects COLORPALETTE_SPECTATOR(1), COLORPALETTE_COLORBLIND(2), or COLORPALETTE_DEFAULT(other). It is not a renderer backend selector.',
 'Original renderer-options tail appends palette then fog pairs and passes this vector as fifth argument of renderer initialization980FA0.',
 '980FA0 creates/initializes the render device and later submits shader registrations to9804C0; it is not itself a direct shader compiler.'],
 adapters=['Enter native options builder tail with preallocated frame/vector, width1920/height1080/format32/flags0.',
 'Renderer initializer boundary captures arguments and returns success; native palette selection, fog builder and pair append execute.'],
 limits=['Full renderer initialization and its shader registry/compiler paths not executed.',
 'Composition of static descriptor defines and global/environment macros remains unqualified; final effective shader variants and GPU execution remain open.',
 'Supplied palette/quality/enable values do not prove final runtime settings.'])
(r/'data/4.20/native_renderer_fog_options_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(cases=len(cases),native_addresses=len(visited),palette_and_fog_submission=True,static_define_merge=False)))
