from pathlib import Path
import itertools,json,datetime,hashlib,struct,shutil
r=Path('E:/OpenLeague')
exec(compile((r/'tools/qualify_native_config_cache_policy.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'archive prerequisites','exec'))
entry=0x40010000;owner=0x40011000;stream=0x40012000;pos=0;payload=b'';calls=[]
def hook(uc,a,size,user):
 global pos
 sp=uc.reg_read(UC_X86_REG_ESP)
 if a==0xc975f5:finish(uc.reg_read(UC_X86_REG_EAX));return
 if a==0xc9ce75:
  assert read(sp+4)==stream and read(sp+12)==0
  pos=read(sp+8);calls.append(['seek',pos]);finish(0);return
 if a==0xc9973d:
  dest,sz,count,fp=[read(sp+i) for i in [4,8,12,16]]
  assert fp==stream and pos+sz*count<=len(payload)
  u.mem_write(dest,payload[pos:pos+sz*count]);pos+=sz*count
  calls.append(['read',sz,count]);finish(count);return
 assert 0x8b9390<=a<0x8b9443,hex(a)
 visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
cases=[]
for offset,cached,method,lengths,mutation in itertools.product([0,17,4096],[0,123456],[0,8],[(0,0),(12,0),(12,27)],['none','signature','method','crc','compressed','uncompressed']):
 fn,extra=lengths;crc=0xdeadbeef;compressed=71;uncompressed=101
 header=bytearray(struct.pack('<IHHHHHIIIHH',0x04034b50,20,0,method,0,0,crc,compressed,uncompressed,fn,extra))
 fields={'signature':(0,4),'method':(8,2),'crc':(14,4),'compressed':(18,4),'uncompressed':(22,4)}
 if mutation in fields:
  start,size=fields[mutation];header[start]^=1
 payload=b'\0'*offset+header+b'F'*fn+b'X'*extra+b'data';pos=0;calls.clear()
 u.mem_write(entry,b'\0'*32);w(entry,offset);w(entry+4,cached);w(entry+8,method);w(entry+12,compressed);w(entry+16,uncompressed);w(entry+20,crc);w(entry+24,owner);w(owner,stream)
 w(stack,end);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,entry)
 u.emu_start(0x8b9390,end,count=1000);assert u.reg_read(UC_X86_REG_EIP)==end
 result=u.reg_read(UC_X86_REG_EAX);expected=cached or (offset+30+fn+extra if mutation=='none' else 0)
 assert result==expected and read(entry+4)==(expected if expected else cached)
 assert calls==([] if cached else [['seek',offset],['read',4,1]]+([] if mutation=='signature' else [['read',26,1]]))
 cases.append(dict(offset=offset,cached=cached,method=method,compressed=compressed,uncompressed=uncompressed,crc=crc,header=list(header),mutation=mutation,result=result,cached_after=read(entry+4),calls=list(calls)))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,entry='0x8b9390',case_count=len(cases),native_addresses=len(visited),native_sha256=hashlib.sha256(raw).hexdigest(),cases=cases,adapters=['Original ZIP local-header signature, method, CRC, compressed/uncompressed sizes, offset arithmetic and cache execute. CRT seek/read and cookie adapted; successful complete reads with supplied metadata.'],limits=['Central-directory mounting, decompression, CRC verification of payload and archive index insertion are not executed.','Native read results are ignored; truncated files, seek failure and uninitialized stack effects are not qualified.','No complete resource provider/runtime game proof.'])
(r/'data/4.20/native_zip_local_header_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(cases=len(cases),native_addresses=len(visited))))
