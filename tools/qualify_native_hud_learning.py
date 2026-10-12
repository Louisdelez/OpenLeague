from pathlib import Path
import struct,itertools,json,datetime,hashlib,shutil
exec(Path('E:/OpenLeague/tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0])
owner=vector+0x8000;actor=vector+0x9000;frame=stack-0x1000;iface=vector+0xb000;callback=vector+0xc000;handles=[];captured=[]
w(0x2d77f48,actor);w(iface,vt);w(vt+0x1c,callback)
for kind,offset in [('icon',0x2f8),('overlay',0x308),('arrow',0x318),('frame',0x328)]:
 for slot in range(4):
  h=vector+0xa000+len(handles)*0x40;w(owner+offset+slot*4,h);w(h+0x20,iface);w(h+0x24,len(handles));handles.append((kind,slot))
def hook(uc,a,n,unused):
 if a==callback:
  sp=u.reg_read(UC_X86_REG_ESP);kind,slot=handles[read(sp+4)];captured.append(dict(kind=kind,slot=slot,enabled=bool(read(sp+8)&255)));finish(0,8);return
 assert 0x7d9bc0<=a<=0x7d9c59,hex(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);cases=[]
for slot,blocked,expanded,animating in itertools.product(range(4),[False,True],[False,True],[False,True]):
 captured.clear();w(actor+0x22b4,(1<<slot) if blocked else 0);u.mem_write(owner+0x6a8,bytes([expanded]));u.mem_write(frame-0x40,b'\0'*0x20)
 for reg,value in [(UC_X86_REG_EBP,frame),(UC_X86_REG_ESP,stack),(UC_X86_REG_ESI,owner),(UC_X86_REG_EDI,owner+0x318+slot*4),(UC_X86_REG_EDX,1<<slot),(UC_X86_REG_EBX,256*animating)]:u.reg_write(reg,value)
 u.emu_start(0x7d9bc0,0x7d9c59,count=100);assert len(captured)==4
 states={x['kind']:x['enabled'] for x in captured};expected=dict(icon=not blocked and animating,overlay=blocked and animating,arrow=not blocked and expanded,frame=not blocked and expanded);assert states==expected
 cases.append(dict(slot=slot,blocked=blocked,expanded=expanded,animating=animating,states=states))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),slice=['0x7d9bc0','0x7d9c59'],case_count=len(cases),cases=cases,mask_field='actor+0x22b4',panel_open_field='owner+0x6a8',limits=['Original enable/disable branches execute native instructions. Virtual element setters adapted to capture booleans. Actor unavailable-mask and panel-open/fade producers supplied; their original population/transition not qualified.','Native expanded icon/overlay fade, glow7D7830, collapse, tooltip, pointer handlers and native learn-event production remain open.','Rust integration uses shared authoritative progression for supported Annie/Garen; other champion rank schemes remain open.'])
(r/'data/4.20/native_hud_learning_contract.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name);print(json.dumps({'cases':len(cases),'passed':True}))
