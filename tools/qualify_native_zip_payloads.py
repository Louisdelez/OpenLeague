from pathlib import Path
import json,zipfile,hashlib,datetime,shutil,time
r=Path('E:/OpenLeague')
setup=(Path(__file__).parent/'probe_native_zip_inflate.py').read_text(encoding='utf-8').split('\nsource=')[0]
# Keep the original inflater running in Unicorn, without Python callbacks on
# every codec instruction. Trace wrappers and adapt only actual I/O/allocator calls.
setup=setup.replace('u.hook_add(unicorn.UC_HOOK_CODE,hook);',"\nfor begin,stop in [(0x8b9390,0x8b9442),(0x8b9640,0x8b97e4)]+[(a,a) for a in [0xc9f39b,0xc98528,0xc975f5,0xc9973d,0xc9ce75]]:u.hook_add(unicorn.UC_HOOK_CODE,hook,begin=begin,end=stop)\n")
exec(compile(setup,'native ZIP codec prerequisites','exec'))
root=Path('D:/LeagueOfLegendsV2/4.20/Client');archives=[];cases=[];golden=bytearray();started=time.time()
for source in sorted(root.rglob('*.zip')):
 data=source.read_bytes();relative=source.as_posix().split('/deploy/DATA/',1)[1];dest=r/'data/4.20/archives'/relative;dest.parent.mkdir(parents=True,exist_ok=True)
 if dest.exists():assert dest.read_bytes()==data
 else:dest.write_bytes(data)
 archive_id=len(archives);archives.append(dict(source=str(source),path=dest.relative_to(r).as_posix(),sha256=hashlib.sha256(data).hexdigest(),bytes=len(data)))
 with zipfile.ZipFile(source) as z:
  for info in z.infolist():
   assert info.compress_type in [0,8] and info.file_size<0x800000
   expected=z.read(info);offset=info.header_offset;allocation=0x41000000;payload=data;pos=0
   u.mem_write(archive,b'\0'*0x120);u.mem_write(entry,b'\0'*32);u.mem_write(buffer,b'\0'*max(info.file_size,1))
   w(archive,stream);w(archive+0x108,entry);w(archive+0x10c,entry+32)
   for off,value in [(0,offset),(4,0),(8,info.compress_type),(12,info.compress_size),(16,info.file_size),(20,info.CRC),(24,archive)]:w(entry+off,value)
   w(vec,buffer);w(vec+4,buffer+info.file_size);w(vec+8,buffer+info.file_size);w(stack,end);w(stack+4,0);w(stack+8,vec)
   u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,archive);u.emu_start(0x8b9750,end,count=200000000)
   assert u.reg_read(UC_X86_REG_EIP)==end,(info.filename,hex(u.reg_read(UC_X86_REG_EIP)))
   actual=bytes(u.mem_read(buffer,info.file_size));assert actual==expected and u.reg_read(UC_X86_REG_EAX)==info.file_size,info.filename
   start=len(golden);golden.extend(actual)
   cases.append(dict(archive=archive_id,name=info.filename,method=info.compress_type,uncompressed_size=info.file_size,compressed_size=info.compress_size,crc=info.CRC,local_offset=offset,data_offset=read(entry+4),returned_bytes=u.reg_read(UC_X86_REG_EAX),sha256=hashlib.sha256(actual).hexdigest(),golden_offset=start))
   if len(cases)%50==0:print(json.dumps(dict(verified=len(cases),decoded_bytes=len(golden),elapsed_seconds=round(time.time()-started,1))),flush=True)
fixture=r/'data/4.20/native_zip_payloads.bin';fixture.write_bytes(golden)
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,entry='0x8b9750 + 0x8b9390 + 0x8b9640 + original zlib',native_sha256=hashlib.sha256(raw).hexdigest(),case_count=len(cases),native_addresses=len(visited),native_codec_executed=True,instruction_trace_scope='Wrapper functions only; original inflater executes without per-instruction Python callbacks.',archives=archives,cases=cases,golden=dict(path=fixture.relative_to(r).as_posix(),bytes=len(golden),sha256=hashlib.sha256(golden).hexdigest()),adapters=['Original stored/DEFLATE payload reader, local-header offsets, inflate initialization, raw inflater and teardown execute original instructions. CRT seek/read and memory allocation/free/cookie adapted.','Original archive bytes and central metadata supplied; entry vector/output capacity preallocated, process allocator initialized. Native output compared byte-for-byte with independently decoded zipfile output.'],limits=['Successful complete streams and allocations; vector growth, malformed DEFLATE, short reads, allocation errors and archive mounting still open.','No full resource-provider/HUD/game acceptance.'])
(r/'data/4.20/native_zip_payload_contract.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for name in ['qualify_native_zip_payloads.py','probe_native_zip_inflate.py']:
 p=Path('E:/mapslol3v3')/name
 if p.resolve()!=(r/'tools'/name).resolve():shutil.copy2(p,r/'tools'/name)
print(json.dumps(dict(passed=True,entries=len(cases),golden_bytes=len(golden),native_addresses=len(visited),elapsed_seconds=round(time.time()-started,1))),flush=True)
