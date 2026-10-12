from pathlib import Path
import json,struct,itertools,datetime,hashlib,configparser,shutil
exec(Path('E:/OpenLeague/tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0])
owner=vector+0x8000;frame=stack-0x1000;actor=vector+0x9000;spell=vector+0xa000;flag=vector+0xb000;available_callback=vector+0xc000;cooldown_value=vector+0xc100
w(spell,vt);w(vt+8,available_callback);w(0x2d798b0,flag);w(flag+4,0)
available=False;resource_state=0;visited=set()
def hook(uc,a,n,unused):
 if a==available_callback:finish(int(available));return
 if a==0x74e6c0:
  # Original caller expects an x87 float return; supplied getter result only.
  u.reg_write(UC_X86_REG_EIP,vector+0xc200);return
 if a==0x76c430:finish(resource_state,8);return
 assert 0x76ece0<=a<=0x76ee82 or 0x76c610<=a<0x76c650 or 0x7d7b6f<=a<=0x7d7bf7 or vector+0xc200<=a<vector+0xc207,hex(a)
 if a<vector:visited.add(a)
u.mem_write(vector+0xc200,b'\xd9\x05'+struct.pack('<I',cooldown_value)+b'\xc3')
u.hook_add(unicorn.UC_HOOK_CODE,hook);u.reg_write(UC_X86_REG_FPCW,0x37f)
states=[]
for slot,available,cd,rank,allowed,resource_state in itertools.product(range(4),[False,True],[-1.0,0.0,.001,25.0],[0,1,5],[False,True],[0,5]):
 w(actor+0x4f4+slot*4,spell);w(spell+0x10,rank);u.mem_write(actor+8,b'\0');w(actor+0x460,0xffffffff if allowed else 0);w(actor+0x450,0);w(cooldown_value,struct.unpack('<I',struct.pack('<f',cd))[0])
 w(stack,end);w(stack+4,slot);w(stack+8,flag+0x100);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,actor);u.emu_start(0x76ece0,end,count=500)
 assert u.reg_read(UC_X86_REG_EIP)==end
 actual=u.reg_read(UC_X86_REG_EAX);expected=1 if not available else 4 if cd>0 else 2 if rank==0 else 3 if not allowed else resource_state
 assert actual==expected,(slot,available,cd,rank,allowed,resource_state,actual,expected)
 states.append(dict(slot=slot,available=available,cooldown=cd,rank=rank,allowed=allowed,resource_state=resource_state,state=actual))
source=p.parent/'DATA/Menu/hud/defaults/FastHUD.ini';parser=configparser.ConfigParser();parser.read(source,encoding='utf-8-sig');palette={}
for field,offset in [('EnabledColor',0x6fc),('DisabledColor',0x700),('EvolutionDisabledColor',0x704),('OutOfManaColor',0x708),('CooldownColor',0x70c),('FlashColor',0x710),('RollOverColor',0x714)]:
 red,green,blue,alpha=map(int,parser['Spells'][field].split());argb=(alpha<<24)|(red<<16)|(green<<8)|blue;palette[field]=argb;w(owner+offset,argb)
colors=[]
for state,override,hover,summoner,slot in itertools.product(range(6),[False,True],[False,True],[False,True],range(4)):
 u.mem_write(frame-0xe5,bytes([override]));w(frame-0xf4,int(summoner));u.mem_write(owner+0x154,bytes([summoner]));w(owner+0x150,slot if hover else 99)
 u.reg_write(UC_X86_REG_EBP,frame);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_EAX,state);u.reg_write(UC_X86_REG_ESI,owner);u.reg_write(UC_X86_REG_EDI,slot)
 u.emu_start(0x7d7b6f,0x7d7bf7,count=100);assert u.reg_read(UC_X86_REG_EIP)==0x7d7bf7
 selected='RollOverColor' if hover and (state==0 or override) else 'DisabledColor' if not override and state in [2,3] else 'CooldownColor' if not override and state==4 else 'OutOfManaColor' if not override and state==5 else 'EnabledColor'
 actual=u.reg_read(UC_X86_REG_EAX);assert actual==palette[selected]
 colors.append(dict(state=state,override=override,hover=hover,summoner=summoner,slot=slot,color=actual,color_field=selected))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),state_function='0x76ece0',palette_slice=['0x7d7b6f','0x7d7bf7'],palette=palette,palette_source=str(source),palette_source_sha256=hashlib.sha256(source.read_bytes()).hexdigest(),state_case_count=len(states),color_case_count=len(colors),native_addresses=len(visited),state_cases=states,color_cases=colors,limits=['Original availability and cooldown getter results supplied by callbacks; original resource-state controller76C430 adapted to supplied0/5 result. Getter and resource-cost producers are not qualified here.','Native mask getter76C610, rank/cooldown ordering, four ordinary slots and color selection execute original instructions. Character masks supplied; full crowd-control/death/targeting/variant producers remain open.','Palette comes from supplied FastHUD.ini Spells section; rollover pulse interpolation7830, pip/rank/cooldown effects, UI callbacks and whole framebuffer remain open.'])
(r/'data/4.20/native_hud_spell_states_contract.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');print(json.dumps({'state_cases':len(states),'color_cases':len(colors),'passed':True}))
