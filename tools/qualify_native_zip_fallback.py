from pathlib import Path
import json,datetime,hashlib,zipfile,shutil
r=Path('E:/OpenLeague')
exec(compile((r/'tools/qualify_native_zip_central_directory.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'native ZIP fallback prerequisites','exec'))
central_hook=hook
def fallback_hook(uc,a,size,user):
 if a==0xc9cd17:finish(pos);return
 if 0x8b9a10<=a<0x8b9c33:visited.add(a);return
 central_hook(uc,a,size,user)
u.hook_add(unicorn.UC_HOOK_CODE,fallback_hook);u.mem_write(0x2d77b20,b'\x01');w(0x14bef58,0)
archives=[];cases=[]
for source in sorted(Path('D:/LeagueOfLegendsV2/4.20/Client').rglob('*.zip')):
 original=source.read_bytes();archive_id=len(archives);archives.append(dict(path=str(source),sha256=hashlib.sha256(original).hexdigest()))
 with zipfile.ZipFile(source) as z:infos=z.infolist()
 for stop in [None,0,len(infos)//2,len(infos)-1]:
  mutable=bytearray(original)
  if stop is not None:mutable[infos[stop].header_offset]=0
  payload=bytes(mutable);allocation=0x41000000;pos=0;calls.clear();u.mem_write(archive,b'\0'*0x120);u.mem_write(entries,b'\0'*(2000*32))
  w(archive,stream);w(archive+0x108,entries);w(archive+0x10c,entries);w(archive+0x110,entries+2000*32)
  # Make the undefined first metadata word visible instead of accidentally zeroing it.
  u.mem_write(stack-0x200,b'\xa5'*0x200);w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,archive);u.emu_start(0x8b9a10,end,count=2000000)
  assert u.reg_read(UC_X86_REG_EIP)==end
  count=(read(archive+0x10c)-entries)//32;assert count==(len(infos) if stop is None else stop)
  rows=[]
  for index,info in enumerate(infos[:count]):
   p=entries+32*index;offset=info.header_offset;header=original[offset:offset+30]
   expected_offset=offset+30+int.from_bytes(header[26:28],'little')+int.from_bytes(header[28:30],'little')
   row=dict(name=list(cbytes(read(p+28))),cached_data_offset=read(p+4),method=read(p+8),compressed_size=read(p+12),uncompressed_size=read(p+16),crc=read(p+20))
   assert row==dict(name=list(info.filename.encode('ascii')),cached_data_offset=expected_offset,method=info.compress_type,compressed_size=info.compress_size,uncompressed_size=info.file_size,crc=info.CRC)
   assert read(p+24)==archive
   row['undefined_local_offset_word']=read(p);rows.append(row)
  cases.append(dict(archive=archive_id,invalid_signature_at=stop,entry_count=count,entries=rows))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,entry='0x8b9a10',native_sha256=hashlib.sha256(raw).hexdigest(),case_count=len(cases),native_addresses=len(visited),archives=archives,cases=cases,adapters=['Original fallback local-header scanner, CRC/method/sizes/cached data offsets, name length/copy, entry copy and signature stop execute. CRT seek/read/ftell, allocation/cookie adapted.','Entry vector capacity supplied to avoid unqualified growth; stack prefilledA5 to expose undefined metadata word.'],limits=['First entry metadata word (local header offset) is uninitialized stack data; cached data offset is initialized and bypasses that word during ordinary payload reads. Safe Rust must not reproduce undefined memory contents.','No descriptors/ZIP64, long names, short reads, allocation errors, vector growth or full mount integration qualified.','Standalone scanner only; opening dispatch proved separately.'])
(r/'data/4.20/native_zip_fallback_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(cases=len(cases),native_addresses=len(visited),undefined_words=sorted(set(row['undefined_local_offset_word'] for c in cases for row in c['entries'])))))
