from pathlib import Path
import json,math,struct,hashlib,datetime,re,shutil
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_inibin_loader.py').read_text(encoding='utf-8').split('print(json.dumps(dict(bytes=')[0]
exec(compile(setup,'actual native Map10 INIBIN loader and accessors','exec'))
native_code_ranges.extend([(0x8ae340,0x8ae430),(0x8af290,0x8af830),(0xc998cc,0xc998e9),(0xc9b7d4,0xc9ba24),(0xc97ea8,0xc97f50)])
def integer_text(text):
 m=re.match(r'[\x09-\x0d\x20]*([+-]?)([0-9]+)',text);v=int(m.group(2))*(-1 if m.group(1)=='-' else 1) if m else 0;return max(-2147483648,min(2147483647,v))
cases=[]
for table in tables:
 for key in table['keys']:
  bit=table['bit'];source_value=native_decoded[str(key)];u.mem_write(destination,b'\xcc'*8)
  invoke(0x8ae340,config,struct.pack('<2I',key,destination));found=bool(u.reg_read(UC_X86_REG_EAX)&255);value=read32(destination);value=value if value<0x80000000 else value-0x100000000
  expected_found=bit in [1,4,5,12]
  if bit==1:expected=int(source_value) if math.isfinite(source_value) and -2147483648<=source_value<2147483648 else -2147483648
  elif bit==4:expected=source_value
  elif bit==5:expected=int(source_value)
  elif bit==12:expected=integer_text(source_value)
  else:expected=-858993460
  assert found==expected_found and value==expected,(key,bit,value,expected,found)
  cases.append(dict(key=key,bit=bit,value=value,found=found))
for key in [0,1,123,1806923398,4294967295]:
 if str(key) in native_decoded:continue
 u.mem_write(destination,b'\xcc'*8);invoke(0x8ae340,config,struct.pack('<2I',key,destination));assert not (u.reg_read(UC_X86_REG_EAX)&255) and read32(destination)==0xcccccccc
 cases.append(dict(key=key,bit=None,value=-858993460,found=False))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,loader='0x8b0380',getter='0x8ae340',source=str(source),source_sha256=hashlib.sha256(contents).hexdigest(),bytes=len(contents),consumed=cursor,case_count=len(cases),cases=cases,native_addresses=len(visited),tables=[dict(bit=t['bit'],count=t['count']) for t in tables],adapters=['Reuses original native Map10 INIBIN loader proof setup: file open/read/destructor, allocator/mutex/thread and security cookie boundaries adapted.','Config object and key-vector container initialized by harness; original binary type readers allocate/populate actual contents and original typed getter/storage accessors/search helpers execute.'],limits=['Actual recovered terrain INIBIN contains only float/byte/bool/vector3/text types. Other INIBIN scalar widths, duplicates and malformed files are not qualified by this sample.','Original complete configuration constructor/cache, user path, menu/persistence and game runtime integration remain open.'])
(r/'data/4.20/native_map10_typed_integer_contract.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(cases=len(cases),bytes=len(contents),typed_storage_from_actual_native_loader=True)))
