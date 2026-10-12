from pathlib import Path
import json,hashlib,datetime,itertools,shutil
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'native face size prerequisites','exec'))
owner=vector+0x6000;face=vector+0x7000;metrics=vector+0x8000;sizing_calls=[]
def hook(uc,a,size,user):
 if a==0xc3d780:
  sp=uc.reg_read(UC_X86_REG_ESP);args=[read(sp+4+i*4) for i in range(5)];assert args[0]==face and args[1]==0 and args[3:]==[dpi_x,dpi_y]
  char_height=args[2];assert char_height<0x80000000
  value=max(0,char_height//64+offset) if profile=='offset' else (char_height*dpi_y+64*72//2)//(64*72)
  sizing_calls.append(dict(character_height_26_6=char_height,metric_height=value,return_code=0));w(metrics+0x20,value<<6);finish(0);return
 visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);cases=[]
for requested,flags,dpi_x,dpi_y,(profile,offset) in itertools.product([8,17,23,32],[0,4,0x10,0x14],[72,96],[72,96,100],[('offset',-1),('offset',0),('offset',1),('dpi',0)]):
 sizing_calls.clear();u.mem_write(owner,b'\0'*0x30);w(owner+0x18,face);w(face+0x58,metrics);w(0x14beb98,dpi_x);w(0x14beb80,dpi_y);w(stack,end);w(stack+4,requested);w(stack+8,flags);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,owner)
 u.emu_start(0x8c1d50,end,count=150000);assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_ESP)==stack+12
 assert sizing_calls[0]['character_height_26_6']==requested*64
 cases.append(dict(requested_size=requested,flags=flags,dpi_x=dpi_x,dpi_y=dpi_y,metric_profile=profile,metric_offset=offset,calls=list(sizing_calls),final_character_height_26_6=sizing_calls[-1]['character_height_26_6'],final_metric_height=sizing_calls[-1]['metric_height']))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entry='0x8c1d50',sizing_call='0xc3d780',case_count=len(cases),native_addresses=len(visited),cases=cases,limits=['Original sizing argument/flags and metric-driven up/down loop execute; sizing function/metric provider supplied as explicit monotonic offset and DPI profiles, not actual font rasterization.','Initial request is size<<6, width0 and supplied DPI; flag10 chooses adjustment by one26.6unit. Return code ignored in this original branch; only successful provider profiles exercised.','Actual FreeType version/load flags, face metrics, zero/extreme inputs, invalid/backend errors and termination guarantees not qualified.','No native glyph bitmap or engine HUD drawing proof.'])
(r/'data/4.20/native_font_face_sizing_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name);print(json.dumps(dict(passed=True,cases=len(cases),native_addresses=len(visited))))
