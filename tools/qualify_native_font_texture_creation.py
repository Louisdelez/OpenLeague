from pathlib import Path
import json,hashlib,datetime,itertools,struct,shutil
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_hud_formatted_scanner.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'font texture prerequisites','exec'))
owner=vector+0x6000;texture=vector+0x6200;manager=vector+0x6400;device=vector+0x6800;vtable=vector+0x6900;result=vector+0x6b00;secondary_image=vector+0x7000;events=[]
def hook(uc,a,instruction_size,user):
 sp=uc.reg_read(UC_X86_REG_ESP)
 if a==0x98a770:finish(texture);events.append(['texture_handle']);return
 if a==vector+0x5000:
  args=[read(sp+4+i*4) for i in range(3)];assert args==[0,0,2];events.append(['format_supported',*args]);finish(1,12);return
 if a==0x98aff0:
  assert uc.reg_read(UC_X86_REG_ECX)==texture;events.append(['gpu_create',read(texture+0x60),read(texture+0x64),read(texture+0x7c),read(texture+0x6c),read(texture+0x78),read(texture+0x80)]);u.mem_write(texture+8,b'\2');finish(0);return
 if a==0x6bd820:
  args=[read(sp+4+i*4) for i in range(6)];assert args==[size,size,0,0,2,1];events.append(['secondary_cpu',*args]);finish(secondary_image);return
 scanner_hook(uc,a,instruction_size,user)
u.hook_add(unicorn.UC_HOOK_CODE,hook);w(0x2d79078,manager);w(manager+0x14,device);w(device,vtable);w(vtable+0x24,vector+0x5000)
cases=[]
for size,extra,shadow,secondary in itertools.product([256,512],[0,1],[False,True],[False,True]):
 events.clear();calls.clear();u.mem_write(owner,b'\xa5'*32);u.mem_write(texture,b'\0'*0x100);w(result,0xa5);w(stack,end)
 for index,value in enumerate([secondary,shadow,extra,size,result]):w(stack+4+index*4,int(value))
 u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,owner);u.emu_start(0x8c0040,end,count=3000)
 assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_ESP)==stack+24 and u.reg_read(UC_X86_REG_EAX)==owner and read(result)==0
 assert read(owner)==extra and read(owner+4)==size and read(owner+8)==texture and read(owner+12)==(secondary_image if shadow else 0)
 assert bytes(u.mem_read(owner+16,3))==bytes([int(shadow),int(secondary),0]);assert read(texture+0x7c)==2 and read(texture+0x80)==0x12257e8
 assert read(texture+0x78)==4 and read(texture+0x6c)==int(not secondary)
 cases.append({'size':size,'extra':extra,'shadow':shadow,'secondary':secondary,'texture_format_enum':2,'format_descriptor':hex(read(texture+0x80)),'events':list(events),'allocation_bytes':size*size*4})
descriptor=list(struct.unpack_from('<14I',image,0x12257e8-base));pack_cases=[]
for values in itertools.product([0,1,128,255],repeat=4):
 w(stack,end)
 for index,value in enumerate(values):w(stack+4+index*4,value)
 u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(descriptor[12],end,count=100);actual=u.reg_read(UC_X86_REG_EAX);expected=(values[0]<<24)|(values[1]<<16)|(values[2]<<8)|values[3];assert actual==expected
 pack_cases.append({'arguments':list(values),'packed':actual,'little_endian_bytes':list(actual.to_bytes(4,'little'))})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'creation_entry':'0x8c0040','texture_wrapper_entry':'0x9896a0','case_count':len(cases),'native_addresses':len(visited),'format_enum':2,'format_descriptor_address':'0x12257e8','format_descriptor_words':descriptor,'pack_entry':hex(descriptor[12]),'pack_case_count':len(pack_cases),'cases':cases,'pack_cases':pack_cases,'limits':['Original atlas constructor and texture wrapper execute; texture allocation, hardware format validation/create and secondary image allocator explicitly supplied successful providers. Actual GPU lock/upload/draw/errors/lifetime remain open.','Original format descriptor2 has32bits/fourbytes;8bit channels at shifts24/16/8/0 and256packing cases executed. Hardware format adapter/color interpretation still requires consumer verification.','Native allocation counter increments; reference lifecycle/destruction and compiler macro/backend variants unqualified.']}
(r/'data/4.20/native_font_texture_creation_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
for name in ['qualify_native_font_texture_creation.py','qualify_native_font_blend_state.py']:shutil.copy2(Path('E:/mapslol3v3')/name,r/'tools'/name)
print(json.dumps({'creation_cases':len(cases),'pack_cases':len(pack_cases),'native_addresses':len(visited),'passed':True}))
