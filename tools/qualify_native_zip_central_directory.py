from pathlib import Path
import json,hashlib,datetime,zipfile,shutil
r=Path('E:/OpenLeague')
exec(compile((r/'tools/qualify_native_config_cache_policy.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'ZIP prerequisites','exec'))
archive=0x40010000;stream=0x40012000;eocd_ptr=0x40014000;entries=0x40018000;payload=b'';pos=0;allocation=0x41000000;calls=[]
def hook(uc,a,size,user):
 global pos,allocation
 sp=uc.reg_read(UC_X86_REG_ESP);this=uc.reg_read(UC_X86_REG_ECX)
 if a==0xc975f5:finish(uc.reg_read(UC_X86_REG_EAX));return
 if a==0x8ba210:
  count=read(sp+4);assert this==archive+0x108 and count<2000
  initial=read(this)==0
  w(this,entries);w(this+4,entries+32*count);w(this+8,entries+32*count)
  if count and initial:u.mem_write(entries,b'\0'*(count*32))
  finish(this,4);return
 if a==0xc9f39b:
  count=read(sp+4);p=allocation;allocation+=count+16;assert allocation<0x41100000
  u.mem_write(p,b'\0'*count);finish(p);return
 if a==0xc9ce75:
  assert read(sp+4)==stream;offset=read(sp+8);origin=read(sp+12)
  assert origin in [0,1];pos=offset if origin==0 else pos+offset;calls.append(['seek',pos,origin]);finish(0);return
 if a==0xc9973d:
  dest,sz,count,fp=[read(sp+i) for i in [4,8,12,16]];assert fp==stream and pos+sz*count<=len(payload)
  u.mem_write(dest,payload[pos:pos+sz*count]);pos+=sz*count;calls.append(['read',sz,count]);finish(count);return
 assert (0x8b97f0<=a<0x8b9a04) or (0xc9f8b6<=a<0xc9f8d1) or (0xc9f8d1<=a<0xc9f926),hex(a)
 visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook);u.mem_write(0x2d77b20,b'\x01');w(0x14bef58,0)
sources=[];cases=[]
for source in sorted(Path('D:/LeagueOfLegendsV2/4.20/Client').rglob('*.zip')):
 original=source.read_bytes();eid=original.rfind(b'PK\x05\x06');assert eid>=0
 end_record=original[eid:eid+22];central_offset=int.from_bytes(end_record[16:20],'little')
 with zipfile.ZipFile(source) as z:infos=z.infolist()
 assert int.from_bytes(end_record[10:12],'little')==len(infos)
 central_positions=[];p=central_offset
 for i in infos:
  assert original[p:p+4]==b'PK\x01\x02';central_positions.append(p)
  p+=46+sum(int.from_bytes(original[p+j:p+j+2],'little') for j in [28,30,32])
 assert p==eid
 source_id=len(sources);sources.append(dict(path=str(source),sha256=hashlib.sha256(original).hexdigest(),bytes=len(original),entry_count=len(infos),central_offset=central_offset))
 for stop in [None,0,len(infos)//2,len(infos)-1]:
  data=bytearray(original)
  if stop is not None:data[central_positions[stop]]=0
  payload=bytes(data);pos=0;allocation=0x41000000;calls.clear();u.mem_write(archive,b'\0'*0x120);w(archive,stream);u.mem_write(eocd_ptr,end_record[4:]);w(stack,end);w(stack+4,eocd_ptr)
  u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,archive);u.emu_start(0x8b97f0,end,count=2000000)
  assert u.reg_read(UC_X86_REG_EIP)==end
  count=(read(archive+0x10c)-read(archive+0x108))//32;assert count==(len(infos) if stop is None else stop)
  rows=[]
  for index,info in enumerate(infos[:count]):
   p=entries+32*index;row=dict(name=list(cbytes(read(p+28))),local_offset=read(p),cached_data_offset=read(p+4),method=read(p+8),compressed_size=read(p+12),uncompressed_size=read(p+16),crc=read(p+20))
   expected=dict(name=list(info.filename.encode('ascii')),local_offset=info.header_offset,cached_data_offset=0,method=info.compress_type,compressed_size=info.compress_size,uncompressed_size=info.file_size,crc=info.CRC)
   assert row==expected,(index,row,expected)
   assert read(p+24)==archive;rows.append(row)
  cases.append(dict(source=source_id,invalid_signature_at=stop,entry_count=count,entries=rows))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,entry='0x8b97f0',native_sha256=hashlib.sha256(raw).hexdigest(),case_count=len(cases),native_addresses=len(visited),original_archives=sources,cases=cases,adapters=['Original central-directory parser and bounded string length/copy execute. CRT seek/read, vector resize, allocation and cookie adapted.','End record supplied from original bytes; native EOCD scanning/opening not executed.'],limits=['Names below native256-byte local buffer, complete reads and successful allocation only; malformed sizes, long names and I/O failures remain open.','Invalid central signature truncates the vector to previous entries; no error is propagated by this routine.','Archive mounting, insertion/duplicates, payload loading, EOCD scanning and runtime integration remain open.'])
(r/'data/4.20/native_zip_central_directory_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(cases=len(cases),native_addresses=len(visited),original_entries=sum(s['entry_count'] for s in sources))))
