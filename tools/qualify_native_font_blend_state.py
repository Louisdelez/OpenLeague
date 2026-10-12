from pathlib import Path
import json,hashlib,datetime
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'native blend prerequisites','exec'))
device=vector+0x6000;vtable=vector+0x6100;calls=[]
def hook(uc,a,size,user):
 if a==vector+0x5000:
  sp=uc.reg_read(UC_X86_REG_ESP);instance,state,value=[read(sp+4+i*4) for i in range(3)];assert instance==device;calls.append([state,value]);finish(0,12);return
 visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);w(0x2d794b0,device);u.mem_write(0x2d79470,b'\0');w(device,vtable);w(vtable+0xe4,vector+0x5000)
mapping=[read(0x10e3248+i*4) for i in range(12)];operations=[read(0x10e27d0+i*4) for i in range(5)];cases=[]
for name,source,destination in [('fill_outline',1,6),('glow',6,7)]:
 for cached in [False,True]:
  calls.clear()
  for offset,value in zip([0,4,8,12,16],[source,source,destination,destination,0]):w(0x123ff48+offset,value if cached else 0xffffffff)
  w(stack,end);w(stack+4,destination);w(stack+8,destination);w(stack+12,0);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,source);u.reg_write(UC_X86_REG_EDX,source);u.emu_start(0x9ac600,end,count=1000)
  expected=[[19,mapping[source]],[207,mapping[source]],[20,mapping[destination]],[208,mapping[destination]],[171,operations[0]],[206,1]] if not cached else [[206,1]]
  assert calls==expected;assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_ESP)==stack+4
  cases.append({'pass':name,'cached':cached,'source_enum':source,'destination_enum':destination,'calls':list(calls)})
assert mapping[1]==2 and mapping[6]==5 and mapping[7]==6 and operations[0]==1
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0x9ac600','case_count':len(cases),'native_addresses':len(visited),'cases':cases,'blend_mapping':mapping,'operation_mapping':operations,'native_draw_calls_static':{'fill_outline':'0x8bed8f..0x8bed9a then0x8beeb3','glow':'0x8beea8..0x8beeb5'},'findings':['Native enum1 mapsD3DBLEND_ONE=2, enum6 mapsSRCALPHA=5, enum7 mapsINVSRCALPHA=6; operation0 mapsD3DBLENDOP_ADD=1.','Fill/outline draw-site numeric settings are sourceONE,destinationSRCALPHA for RGB and alpha; source shader alpha is inverse coverage.','Glow numeric settings sourceSRCALPHA,destinationINVSRCALPHA for RGB and alpha. Separate alpha blend enabled in both contexts.'],'limits':['Blend setter executes through adapted successful D3D SetRenderState provider with supplied device/global cache. Actual renderer draw pass, alpha write mask, render target format, sampler and GPU output remain unqualified.','Native draw-site argument identification is static disassembly; full draw/layout call not executed. OpenGL/disabled backend path unqualified.']}
(r/'data/4.20/native_font_blend_state_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'cases':len(cases),'native_addresses':len(visited),'passed':True}))
