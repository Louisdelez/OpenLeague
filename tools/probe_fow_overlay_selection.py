from pathlib import Path
import json,datetime
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_projected_sampler.py').read_text(encoding='utf-8').split('cases=[]')[0],'native setup','exec'))
cases=[];frame=sp+0x100;map_descriptor=heap+0x1f300
write32(0x2d78f1c,map_descriptor)
for found in [False,True]:
 for long in [False,True]:
  write32(frame-0x14,32 if long else 15);write32(frame-0x18,20 if long else 8)
  pointer=heap+0x1f500
  u.mem_write(pointer,b'Custom_FogOverlay.dds\0')
  if long:write32(frame-0x28,pointer)
  else:u.mem_write(frame-0x28,b'fog.dds\0')
  u.reg_write(UC_X86_REG_EAX,int(found));u.reg_write(UC_X86_REG_ECX,0);u.reg_write(UC_X86_REG_ESI,heap+0x1f700);u.reg_write(UC_X86_REG_EBP,frame);u.reg_write(UC_X86_REG_ESP,sp)
  u.emu_start(0x6b308c,0x6b30b2,count=10000);assert u.reg_read(UC_X86_REG_EIP)==0x6b30b2
  stack=u.reg_read(UC_X86_REG_ESP);arg0=read32(stack);arg1=read32(stack+4)
  if found:assert arg0==(pointer if long else frame-0x28) and arg1==heap+0x1f700
  else:assert arg0==0x10a0338 and arg1==map_descriptor+0x80
  cases.append({'property_found':found,'string_heap_storage':long,'loader_filename_pointer':hex(arg0),'loader_context_pointer':hex(arg1)})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'native_sha256':digest,'passed':True,'complete':False,'cases':cases,'entry':'0x6b308c','stop_before_texture_loader':'0x6b30b2','runtime_adapters':[],'limits':['Original conditional path and load arguments executed; property-reader boolean and SSO/heap string prerequisites explicitly supplied.','Map10 actual property result and texture resolver are not executed or proved.']}
(r/'data/4.20/fow_overlay_selection_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps({'cases':len(cases),'native_addresses':len(visited),'map10_selection_qualified':False}))
