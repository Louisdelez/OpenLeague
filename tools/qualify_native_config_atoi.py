from pathlib import Path
import json,struct,hashlib,datetime,itertools,re,shutil
r=Path('E:/OpenLeague');prefix=(r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0];exec(compile(prefix,'native CRT integer prerequisites','exec'))
buffer=vector+0x6000;errno=vector+0x7000
assert read(0x14ae870)==0
locale=read(0x12232f8);table=read(locale+0x90);assert read(locale+0x74)==1
def native_hook(uc,a,size,user):
 if a==0xc9b780:finish(errno);return
 assert 0xc998cc<=a<0xc998e9 or 0xc9b7d4<=a<0xc9ba24 or 0xc97ea8<=a<0xc97f50,hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,native_hook)
def expected(data):
 data=data.split(b'\0',1)[0];m=re.match(rb'[\x09-\x0d\x20]*([+-]?)([0-9]+)',data)
 if not m:return 0,False
 value=int(m.group(2));value=-value if m.group(1)==b'-' else value
 return max(-2147483648,min(2147483647,value)),not -2147483648<=value<=2147483647
samples=[b'',b'0',b'000',b'3',b'+4',b'-1',b'.5',b'1.9',b'0x10',b'1e9',b'--4',b'+-4',b'true',b'TRUE',b'false',b'\0' ,b'12\0-7',b'999999999999999999999999999999999999999',b'-999999999999999999999999999999999999999']
for value,space,suffix in itertools.product([-2147483650,-2147483648,-1,0,1,4,2147483647,2147483648,4294967295,4294967296],[b'',b' ',b'\t',b'\n\r\v\f',b'  \t'],[b'',b'tail',b'.5',b' 7']):samples.append(space+str(value).encode()+suffix)
for byte,suffix in itertools.product(range(256),[b'0',b'12',b'-4']):samples.append(bytes([byte])+suffix)
samples=list(dict.fromkeys(samples));cases=[]
for data,initial_errno in itertools.product(samples,[0,123]):
 u.mem_write(buffer,data+b'\0');w(errno,initial_errno);w(stack,end);w(stack+4,buffer);u.reg_write(UC_X86_REG_ESP,stack)
 u.emu_start(0xc998cc,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
 result=u.reg_read(UC_X86_REG_EAX);result=result if result<0x80000000 else result-0x100000000
 value,overflow=expected(data);assert result==value,(data,result,value);assert read(errno)==(34 if overflow else initial_errno)
 cases.append(dict(bytes=list(data),initial_errno=initial_errno,value=result,range_error=overflow,errno_after=read(errno)))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,entry='0xc998cc',native_sha256=hashlib.sha256(raw).hexdigest(),native_addresses=len(visited),case_count=len(cases),cases=cases,c_locale_address=hex(locale),c_ctype_table_address=hex(table),c_ctype_table_sha256=hashlib.sha256(bytes(u.mem_read(table,512))).hexdigest(),findings=['Actual native CRT atoi/strtol wrapper and C-locale character classification execute unchanged from original PE default locale.','Base10 parses optional sign/ASCII whitespace and digit prefix, stops at nondigit/NUL, returns0 without digits. Overflow saturates signed32 and sets ERANGE34; success preserves supplied errno.','All256 possible leading byte values included, plus signed boundaries, long overflows, suffixes and embedded NUL.'],adapters=['CRT errno accessorC9B780 returns supplied thread errno cell; thread allocation/access not executed.'],limits=['Native CRT numeric conversion scope; original8AF830 true-string fallback and typed/text configuration reader/cache remain open.','Static original C locale; alternate locales, file parsing/encoding, user options and complete game acceptance unqualified.'])
(r/'data/4.20/native_config_atoi_contract.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(cases=len(cases),native_addresses=len(visited),locale=hex(locale),overflow_errno=34)))
