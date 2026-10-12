from pathlib import Path
import json,hashlib,datetime,zipfile,shutil
r=Path('E:/OpenLeague')
exec(compile((r/'tools/qualify_native_zip_local_header.py').read_text(encoding='utf-8').split('\ncases=[]')[0],'ZIP local-header prerequisites','exec'))
root=Path('D:/LeagueOfLegendsV2/4.20/Client');cases=[];archives=[]
for source in sorted(root.rglob('*.zip')):
 payload=source.read_bytes();archive_id=len(archives)
 archives.append(dict(path=str(source),sha256=hashlib.sha256(payload).hexdigest(),bytes=len(payload)))
 with zipfile.ZipFile(source) as z:
  for info in z.infolist():
   offset=info.header_offset;header=payload[offset:offset+30];assert len(header)==30
   pos=0;calls.clear();u.mem_write(entry,b'\0'*32)
   w(entry,offset);w(entry+8,info.compress_type);w(entry+12,info.compress_size);w(entry+16,info.file_size);w(entry+20,info.CRC);w(entry+24,owner);w(owner,stream)
   w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,entry);u.emu_start(0x8b9390,end,count=1000)
   assert u.reg_read(UC_X86_REG_EIP)==end
   result=u.reg_read(UC_X86_REG_EAX)
   expected=offset+30+int.from_bytes(header[26:28],'little')+int.from_bytes(header[28:30],'little')
   matched=(int.from_bytes(header[:4],'little')==0x04034b50 and int.from_bytes(header[8:10],'little')==info.compress_type and int.from_bytes(header[14:18],'little')==info.CRC and int.from_bytes(header[18:22],'little')==info.compress_size and int.from_bytes(header[22:26],'little')==info.file_size)
   assert result==(expected if matched else 0)
   cases.append(dict(archive=archive_id,name=info.filename,method=info.compress_type,offset=offset,compressed=info.compress_size,uncompressed=info.file_size,crc=info.CRC,header=list(header),native_result=result,metadata_matched=matched))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,entry='0x8b9390',native_sha256=hashlib.sha256(raw).hexdigest(),archives=archives,cases=cases,case_count=len(cases),metadata_matched=sum(c['metadata_matched'] for c in cases),native_addresses=len(visited),adapters=['Original native ZIP local-header instructions execute against original archive bytes; CRT seek/read/cookie adapted. Central-directory metadata supplied by Python zipfile, not original native mounting.'],limits=['Payload inflation/read validation, CRC validation, central-directory native loader and resource routing remain open.','No new production executable or complete HUD/texture integration is proved by this header check.'])
(r/'data/4.20/native_zip_original_headers_contract.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(archives=len(archives),entries=len(cases),matched=proof['metadata_matched'],methods=sorted(set(c['method'] for c in cases)))))
