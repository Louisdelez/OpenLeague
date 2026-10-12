from pathlib import Path
import json,struct,hashlib,datetime,zipfile,re
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_hud_formatted_scanner.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'HUD header prerequisites','exec'))
u.hook_add(unicorn.UC_HOOK_CODE,scanner_hook)
u.mem_map(0x50000000,0x100000);data_ptr=0x50000000
cursor=vector+0xe000;kind_ptr=vector+0xe010;name_ptr=vector+0xe020
white=b' \t\n\r\v\f'
def line(data,pos):
 output=bytearray()
 while pos<len(data) and len(output)<1023:
  c=data[pos];pos+=1
  if c==10:break
  if c!=13:output.append(c)
 return bytes(output).split(b'\0')[0],pos
def token(line,prefix):
 if not line.startswith(prefix):return None
 s=line[len(prefix):].lstrip(white)
 if not s:return None
 return re.split(rb'[\x09-\x0d ]',s,1)[0][:31]
def reference(data):
 pos=0;out=bytearray(b'\xa5'*32);kind=0xa5a5a5a5
 first,pos=line(data,pos);t=token(first,b'Type:')
 if t is None:return False,kind,bytes(out),pos
 k={b'icon':1,b'effect':2,b'text':3}.get(t.lower())
 if k is None:return False,kind,bytes(out),pos
 kind=k;second,pos=line(data,pos);name=token(second,b'Name:')
 if name is None:return False,kind,bytes(out),pos
 out[:len(name)+1]=name+b'\0'
 return True,kind,bytes(out),pos
inputs=[]
archive=r/'data/4.20/archives/menu/HUD.zip';audit=json.loads((r/'data/4.20/native_hud_layout_source_audit.json').read_text(encoding='utf-8'))
with zipfile.ZipFile(archive) as z:
 for f in audit['files']:
  data=z.read(f['path']);assert hashlib.sha256(data).hexdigest()==f['sha256']
  for m in re.finditer(rb'(?m)^Type:',data):
   # Keep actual original two header lines and a following byte; properties are consumed separately.
   first_end=data.find(b'\n',m.start());second_end=data.find(b'\n',first_end+1)
   end_offset=second_end+2 if second_end!=-1 else len(data)
   inputs.append((f['path']+':'+str(m.start()),data[m.start():end_offset]))
assert len(inputs)==703
for data in [b'',b'\n',b' Type: Icon\nName: x\n',b'type: Icon\nName: x\n',b'Type: icon\nName: x\n',b'Type: ICON\nName: x\n',b'Type: Effect\r\nName: a:b\r\nRest',b'Type: Text\nName: x y\n',b'Type: Icon\nName:\n',b'Type: Icon\nname: x\n',b'Type: Icon\n\nName: x\n',b'Type: Unknown\nName: x\n',b'Type:Icon\nName:x',b'Type:\tTeXt extra\nName:\vx\n',b'Type: Icon\0junk\nName: y\n',b'Type: Icon\nName: '+b'a'*40+b'\n',b'Type: '+b'a'*40+b'\nName: x\n',b'Type: Icon\rName: x',b'Type: Icon\nName: x\0y\n']:
 inputs.append(('edge',data))
cases=[]
for label,data in inputs:
 u.mem_write(data_ptr,data+b'\0'*32);w(cursor,data_ptr);w(cursor+4,len(data));w(kind_ptr,0xa5a5a5a5);u.mem_write(name_ptr,b'\xa5'*64)
 w(stack,end);w(stack+4,cursor);w(stack+8,kind_ptr);w(stack+12,name_ptr);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_EFLAGS,2)
 u.emu_start(0x9a5570,end,count=200000);assert u.reg_read(UC_X86_REG_EIP)==end
 actual=(bool(u.reg_read(UC_X86_REG_EAX)&255),read(kind_ptr),bytes(u.mem_read(name_ptr,32)),read(cursor)-data_ptr)
 assert actual==reference(data),(label,data,actual,reference(data))
 cases.append(dict(source=label,input_hex=data.hex(),accepted=actual[0],kind=actual[1],name_storage_hex=actual[2].hex(),consumed=actual[3],remaining=read(cursor+4)))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),source_archive_sha256=hashlib.sha256(archive.read_bytes()).hexdigest(),entry='0x9a5570',native_addresses=len(visited),source_header_count=703,case_count=len(cases),cases=cases,findings=['Original scanner and case-insensitive CRT comparison execute; Type values Icon/Effect/Text map to1/2/3.','Headers require consecutive Type/Name lines, exact case-sensitive key literals, values use whitespace-delimited31byte tokens; CR discarded during line collection.','Colon in name remains unchanged; strchr result is unused.','Type write precedes Name validation; failures can preserve partially changed state.'],runtime_adapters=['Cookie/log/errno/thread/DecodePointer boundaries reused from property text contract; supplied default C locale.'],limits=['Record headers only; BaseOffset, comment/blank skipping by outer loop, properties, registration, textures and rendering remain open.','ASCII inputs; process startup and general locale compatibility unqualified.'])
(r/'data/4.20/native_hud_record_header_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(passed=True,source_headers=703,cases=len(cases),native_addresses=len(visited))))
