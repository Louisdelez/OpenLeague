from pathlib import Path
import json,struct,hashlib,datetime,itertools,re
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_hud_formatted_scanner.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'HUD string property prerequisites','exec'))
warnings=0
def string_hook(uc,a,size,user):
 global warnings
 if a==0x5642d0:warnings+=1
 scanner_hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,string_hook)
registry=json.loads((r/'data/4.20/native_hud_property_registry_contract.json').read_text(encoding='utf-8'))
entries={v['name']:int(v['callback'],16) for v in registry['registrations']}
names=['Group','Texture','Effect','Font','EffectTexture0'];audit=json.loads((r/'data/4.20/native_hud_layout_source_audit.json').read_text(encoding='utf-8'));values={p:set() for p in names}
for file in audit['files']:
 for record in file['records']:
  for k,v in record['_ordered_properties']:
   if k in values:values[k].add(v)
counts={p:len(v) for p,v in values.items()}
edges=['',' ','\t\r\n','None','HUDAtlas','Font With Spaces','a:b','  hello  world  ','x\ny','x\0y','a'*31,'a'*32,'a'*40,'\tFoo\rBar\nRest']
cases=[]
for prop in names:
 for value,kind,prefill in itertools.product(sorted(values[prop]|set(edges)),[1,2,3],[0,0xa5]):
  warnings=0;initial=bytearray([prefill]*0x30c);struct.pack_into('<I',initial,0x40,kind);u.mem_write(obj,bytes(initial));u.mem_write(text,b'\0'*1024);u.mem_write(text,value.encode('ascii')+b'\0')
  w(stack,end);w(stack+4,obj);w(stack+8,text);w(stack+12,0);w(stack+16,origin);u.reg_write(UC_X86_REG_ESP,stack)
  u.emu_start(entries[prop],end,count=250000);assert u.reg_read(UC_X86_REG_EIP)==end
  v=value.encode('ascii').split(b'\0')[0].lstrip(b' \t\n\r\v\f')
  v=(v.split(b'\n',1)[0] if prop in ['Effect','Font'] else re.split(rb'[\x09-\x0d ]',v,1)[0])[:31]
  eligible=(prop=='Group' or prop=='Texture' and kind in [1,2] or prop in ['Effect','EffectTexture0'] and kind==2 or prop=='Font' and kind==3)
  result=0;offset=0x20 if prop=='Group' else 0x21c if prop=='Texture' and kind==2 else 0x23c if prop=='EffectTexture0' else 0x1e0
  expected=bytearray(initial)
  if eligible and v:
   expected[offset:offset+len(v)+1]=v+b'\0';result={'Group':2,'Texture':0x20,'Effect':0x80,'Font':0x800,'EffectTexture0':1}[prop]
  actual=bytes(u.mem_read(obj,len(initial)));assert actual==expected and u.reg_read(UC_X86_REG_EAX)==result and warnings==int(result==0),(prop,value,kind,hex(u.reg_read(UC_X86_REG_EAX)))
  cases.append(dict(property=prop,value=value,kind=kind,prefill=prefill,result=result,warnings=warnings,field_offset=offset,field_storage_hex=bytes(u.mem_read(obj+offset,32)).hex(),all_other_bytes_unchanged=True))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),case_count=len(cases),property_count=5,source_unique_values=counts,native_addresses=len(visited),cases=cases,findings=['Original CRT bounded string scanning and5native callbacks execute; all bytes compared.','Group/Texture/EffectTexture0 use31byte whitespace tokens. Effect/Font use31byte non-newline scansets, preserving internal and trailing spaces after leading whitespace.','Output NUL appended after token; trailing field bytes retain prior contents.','Texture uses icon1e0 or effect21c fields; Effect and EffectTexture0 are Effect-only; Font Text-only.'],runtime_adapters=['Default C locale/thread, DecodePointer, cookie, errno and logger boundaries reused from property scanner qualification.'],limits=['5string properties only; resource/font/effect handle resolution and full file/owner initialization remain open.','Audit source values and listed ASCII edges, not a full file parser qualification.','Does not prove texture/font rendering or HUD interactions.'])
(r/'data/4.20/native_hud_string_properties_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(passed=True,properties=5,cases=len(cases),source_unique_values=counts,native_addresses=len(visited))))
