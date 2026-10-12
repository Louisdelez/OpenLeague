from pathlib import Path
import json,struct,hashlib,datetime,itertools,re
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_hud_formatted_scanner.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'HUD integer property prerequisites','exec'))
warnings=0
def integer_hook(uc,a,size,user):
 global warnings
 if a==0x5642d0:warnings+=1
 scanner_hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,integer_hook)
registry=json.loads((r/'data/4.20/native_hud_property_registry_contract.json').read_text(encoding='utf-8'))
entries={v['name']:int(v['callback'],16) for v in registry['registrations']}
bits={'Enabled':1,'AlwaysRespond':4,'Draggable':8,'KeepMaxScale':0x80,'AutoRect':0x200,'DropShadow':0x10,'FlipX':0x400,'FlipY':0x800,'NoPixelSnappingX':0x1000,'Alpha':1}
names=list(bits)+['Layer','Size'];audit=json.loads((r/'data/4.20/native_hud_layout_source_audit.json').read_text(encoding='utf-8'))
values={p:set() for p in names}
for file in audit['files']:
 for record in file['records']:
  for k,v in record['_ordered_properties']:
   if k in values:values[k].add(v)
source_counts={p:len(v) for p,v in values.items()}
edge=['',' ','0','1','-1','+2','1.5','0x10','true','+','-','\t-2147483648tail','2147483647','2147483648','4294967295','4294967296','99999999999999999999','1\0x']
def parsed(s):
 s=s.split('\0',1)[0];m=re.match(r'[\x09-\x0d ]*([+-]?[0-9]+)',s)
 return int(m.group(1))&0xffffffff if m else None
cases=[]
for prop in names:
 for value,kind,initial_flags in itertools.product(sorted(values[prop]|set(edge)),[1,2,3],[0,0xffffffff]):
  warnings=0;initial=bytearray(0x30c);struct.pack_into('<I',initial,0x40,kind);struct.pack_into('<I',initial,0x48,initial_flags);struct.pack_into('<I',initial,0x224,0x80);struct.pack_into('<I',initial,0x1a4,0xa5a5a5a5);struct.pack_into('<I',initial,0x204,0xa5a5a5a5)
  u.mem_write(obj,bytes(initial));u.mem_write(text,b'\0'*1024);u.mem_write(text,value.encode('ascii')+b'\0');w(stack,end);w(stack+4,obj);w(stack+8,text);w(stack+12,0);w(stack+16,origin);u.reg_write(UC_X86_REG_ESP,stack)
  u.emu_start(entries[prop],end,count=250000);assert u.reg_read(UC_X86_REG_EIP)==end
  expected=bytearray(initial);number=parsed(value)
  eligible=not (prop=='Alpha' and kind!=1 or prop in ['DropShadow','Size'] and kind!=3 or prop in ['FlipX','FlipY'] and kind not in [1,2])
  result=0
  if eligible and number is not None:
   result=4 if prop=='Layer' else 0x1000 if prop=='Size' else 1
   if prop in ['Layer','Size']:struct.pack_into('<I',expected,0x1a4 if prop=='Layer' else 0x204,number)
   elif number:
    offset=0x224 if prop=='Alpha' else 0x48;old=struct.unpack_from('<I',expected,offset)[0];struct.pack_into('<I',expected,offset,old|bits[prop])
  actual=bytes(u.mem_read(obj,len(initial)));assert actual==expected and u.reg_read(UC_X86_REG_EAX)==result and warnings==int(result==0),(prop,value,kind,number,u.reg_read(UC_X86_REG_EAX),warnings)
  cases.append(dict(property=prop,value=value,kind=kind,initial_flags=initial_flags,result=result,warnings=warnings,output_flags=read(obj+0x48),output_icon_flags=read(obj+0x224),output_layer=read(obj+0x1a4),output_size=read(obj+0x204),all_other_bytes_unchanged=True))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),case_count=len(cases),property_count=len(names),source_unique_values=source_counts,native_addresses=len(visited),cases=cases,findings=['Original integer scanf conversion and12native property handlers execute; all element bytes checked.','Boolean-like properties only OR bits for nonzero integers; value0 does not clear existing bits.','Alpha is icon-only bit at224, not a floating opacity scalar. DropShadow and Size are Text-only; FlipX/Y are Icon/Effect-only.','Layer contributes required mask4; Size mask1000; boolean property handlers return1.','Decimal signed prefix and wrapping32bit integer overflow match listed source and edge cases.'],runtime_adapters=['Default C locale/thread, DecodePointer, cookie, errno and logger boundaries reused from property scanner qualification.'],limits=['12integer property callbacks only; string/color/effect/float callbacks and full file/owner initialization remain open.','All supplied source values plus listed ASCII edges; general CRT locale/process compatibility not proved.','Does not prove UI rendering, interaction or complete game.'])
(r/'data/4.20/native_hud_integer_properties_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(passed=True,properties=len(names),cases=len(cases),source_unique_values=source_counts,native_addresses=len(visited))))
