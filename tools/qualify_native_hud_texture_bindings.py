from pathlib import Path
import json,datetime,hashlib,shutil
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'texture binding prerequisites','exec'))
owner=vector+0x6000;element=vector+0x7000;manager=vector+0x8000;requests=[];handles={}
def hook(uc,address,size,user):
 if address==0x99e040:
  sp=uc.reg_read(UC_X86_REG_ESP);ptr=read(sp+4);name=bytes(uc.mem_read(ptr,32)).split(b'\0')[0]
  assert uc.reg_read(UC_X86_REG_ECX)==manager
  if name not in handles:handles[name]=0x50000000+len(handles)*0x100
  requests.append(name.decode());finish(handles[name],4);return
 if address==0x9a35c3:uc.reg_write(UC_X86_REG_EIP,end);return
 visited.add(address)
u.hook_add(unicorn.UC_HOOK_CODE,hook);w(owner+8,manager);cases=[]
source=json.loads((r/'data/4.20/native_hud_file_loop_contract.json').read_text(encoding='utf-8'));selected={}
for c in source['cases']:
 if c['variant']=='restored' or c['path'] not in selected:selected[c['path']]=c
assert len(selected)==32
for c in selected.values():
 for record in c['accepted']:
  initial=bytes.fromhex(record['output_hex']);kind=int.from_bytes(initial[0x40:0x44],'little')
  if kind not in [1,2]:continue
  requests.clear();u.mem_write(element,initial);w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_EBX,owner);u.reg_write(UC_X86_REG_EDI,element);u.emu_start(0x9a35ae if kind==1 else 0x9a3574,end,count=1000);assert u.reg_read(UC_X86_REG_EIP)==end
  expected=[];bindings=[]
  for name_offset,slot in ([(0x1e0,0x200)] if kind==1 else [(0x21c,0x25c),(0x23c,0x260)]):
   name=initial[name_offset:name_offset+32].split(b'\0')[0]
   if kind==1 or name:expected.append(name.decode());assert read(element+slot)==handles[name]
   else:assert read(element+slot)==int.from_bytes(initial[slot:slot+4],'little')
   bindings.append(dict(name_hex=name.hex(),slot=slot,requested=kind==1 or bool(name)))
  assert requests==expected
  cases.append(dict(path=c['path'],name=record['name'],kind=kind,bindings=bindings,requests=list(requests)))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),case_count=len(cases),native_addresses=len(visited),cases=cases,limits=['Original icon/effect texture assignment branch executes on all selected source nontext elements, including restored overlays.','Named texture supplier is adapted to deterministic opaque addresses; separately qualified cache/creation not reexecuted here. No GPU texture loading or drawing.','Text fonts, effect instance creation and full original resource/group file-loading loop remain separate.'])
(r/'data/4.20/native_hud_texture_bindings_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name);print(json.dumps(dict(passed=True,cases=len(cases),handles=len(handles),native_addresses=len(visited))))
