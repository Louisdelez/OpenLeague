from pathlib import Path
import json,struct,datetime,hashlib,ast
r=Path('E:/OpenLeague');loader_setup=(r/'tools/probe_fow_event_creation_generated.py').read_text(encoding='utf-8').split('\ncases=[]')[0]
loader_setup=loader_setup.replace('0x70100000','0x72000000').replace('u.mem_map(0x70000000,0x100000)','u.mem_map(0x70000000,0x2000000)');exec(compile(loader_setup,'native INIBIN prerequisites','exec'))
import capstone
dis=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32)
thread_calls={}
cookie_calls={};cookie_skips=[]
for start,length in [(0x8b0380,0x50),(0x8afb10,0x50),(0x8afc30,0x50)]:
 for i in dis.disasm(bytes(u.mem_read(start,length)),start):
  if i.mnemonic=='call' and i.op_str=='dword ptr [0xfa4378]':thread_calls[i.address]=i.address+i.size
for i in dis.disasm(bytes(u.mem_read(0x8ae000,0x2400)),0x8ae000):
 if i.mnemonic=='call' and i.op_str=='0xc975f5':cookie_calls[i.address]=i.address+i.size
config=0x40009000;key_vectors=0x40009200;file_object=0x40009400;file_vtable=0x40009500;path_buffer=0x40009600;destination=0x40009800
read_stub=end+0x600;close_stub=end+0x620;native_code_ranges+= [(read_stub,read_stub+1),(close_stub,close_stub+1)]
write32(file_object,file_vtable);write32(file_vtable,close_stub);write32(file_vtable+0x24,read_stub);write32(0x2d78db4,0x40009900)
u.mem_write(read_stub,b'\xcc');u.mem_write(close_stub,b'\xcc')
contents=b'';cursor=0;opens=[];reads=[];closes=0
def returned(value,cleanup):
 top=u.reg_read(UC_X86_REG_ESP);ret=read32(top);u.reg_write(UC_X86_REG_EAX,value);u.reg_write(UC_X86_REG_ESP,top+4+cleanup);u.reg_write(UC_X86_REG_EIP,ret)
def text(ptr):return bytes(u.mem_read(ptr,160)).split(b'\0')[0].decode('ascii')
def io(uc,a,size,user):
 global cursor,closes
 if a in cookie_calls:cookie_skips.append(hex(a));u.reg_write(UC_X86_REG_EIP,cookie_calls[a])
 elif a in thread_calls:u.reg_write(UC_X86_REG_EAX,1);u.reg_write(UC_X86_REG_EIP,thread_calls[a])
 elif a==0x8b4ef0:
  top=u.reg_read(UC_X86_REG_ESP);opens.append(dict(path=text(read32(top+4)),mode=text(read32(top+8))));returned(file_object,8)
 elif a==read_stub:
  assert u.reg_read(UC_X86_REG_ECX)==file_object
  top=u.reg_read(UC_X86_REG_ESP);out=read32(top+4);size=read32(top+8);count=read32(top+12);n=size*count
  assert cursor+n<=len(contents),(cursor,n,len(contents));u.mem_write(out,contents[cursor:cursor+n]);reads.append(dict(offset=cursor,size=size,count=count));cursor+=n;returned(count,12)
 elif a==close_stub:closes+=1;returned(0,4)
 elif a==0x8ae5cd:u.reg_write(UC_X86_REG_EIP,0x8ae5d2)
u.hook_add(unicorn.UC_HOOK_CODE,io)
tree=ast.parse(Path('E:/mapslol3v3/tools/import_all_champions.py').read_text(encoding='utf-8'));parser={'struct':struct};exec(compile(ast.Module(body=[n for n in tree.body if isinstance(n,ast.FunctionDef) and n.name in ['ini','hashkey']],type_ignores=[]),'reference INIBIN parser','exec'),parser)
discovery=json.loads((r/'docs/native_projection_discovery.json').read_text());source=Path(discovery['source']).parent/'LEVELS/Map10/terrain.inibin';contents=source.read_bytes();cursor=0;allocation_cursor=0x70000000
u.mem_write(config,bytes(0x180));write32(config+0x71,15);u.mem_write(key_vectors,bytes(14*12));write32(config+0x7c,key_vectors);write32(config+0x80,key_vectors+14*12);write32(config+0x84,key_vectors+14*12)
u.mem_write(path_buffer,b'Levels/Map10/terrain.ini\0')
invoke(0x8b0380,config,struct.pack('<I',path_buffer));assert u.reg_read(UC_X86_REG_EAX)&255==1;assert cursor==len(contents) and closes==1
assert opens==[dict(path='Levels/Map10/terrain.inibin',mode='rb')],opens
u.mem_write(config+0x148,b'\1')
queries=[]
for key,fallback in [('fadeStart',-1000000.),('fadeFinish',-2000000.),('edgeEnhancement',0.),('edgeTintPoint',0.),('blurKernelSigma',-1.)]:
 u.mem_write(destination,b'\xcc'*4)
 invoke(0x8afb10,config,struct.pack('<5I',destination,0,0,int(parser['hashkey']('FoW',key)),struct.unpack('<I',struct.pack('<f',fallback))[0]))
 found=bool(u.reg_read(UC_X86_REG_EAX)&255);bits=read32(destination);result=struct.unpack('<f',struct.pack('<I',bits))[0];assert not found and result==fallback,(key,found,result)
 queries.append(dict(key=key,default=fallback,found=found,result=result,result_bits=bits))
invoke(0x8afc30,config,struct.pack('<5I',destination,0,0,int(parser['hashkey']('FoW','upscale')),1));assert not (u.reg_read(UC_X86_REG_EAX)&255) and u.mem_read(destination,1)[0]==1
parsed=parser['ini'](source);tables=[]
for bit in range(13):
 kp=read32(key_vectors+bit*12);ke=read32(key_vectors+bit*12+4);count=(ke-kp)//4
 native_keys=list(struct.unpack('<'+'I'*count,u.mem_read(kp,count*4))) if count else []
 tables.append(dict(bit=bit,count=count,keys=native_keys))
assert {str(key) for t in tables for key in t['keys']}==set(parsed)
native_decoded={};native_float_bits={}
for t in tables:
 bit=t['bit'];keys=t['keys'];n=len(keys)
 if not n:continue
 vp=read32(config+0x88+bit*12)
 if bit==1:values=list(struct.unpack('<'+'f'*n,u.mem_read(vp,n*4)))
 elif bit==4:values=list(u.mem_read(vp,n))
 elif bit==5:values=[bool(u.mem_read(vp+i//8,1)[0]&(1<<(i%8))) for i in range(n)]
 elif bit==7:values=[list(struct.unpack('<3f',u.mem_read(vp+i*12,12))) for i in range(n)]
 elif bit==12:
  offsets=struct.unpack('<'+'H'*n,u.mem_read(vp,n*2));strings=read32(config+0x13c)
  values=[text(strings+offset) for offset in offsets]
 else:raise AssertionError(('new unqualified actual type',bit))
 for key,value in zip(keys,values):native_decoded[str(key)]=value
 if bit==1:
  for i,key in enumerate(keys):native_float_bits[str(key)]=read32(vp+i*4)
 elif bit==7:
  for i,key in enumerate(keys):native_float_bits[str(key)]=[read32(vp+i*12+j*4) for j in range(3)]
assert native_decoded==parsed
typed_queries=[]
for table in [t for t in tables if t['bit'] in [1,5]]:
 for key in table['keys']:
  expected=native_decoded[str(key)];invoke(0x8afb10 if table['bit']==1 else 0x8afc30,config,struct.pack('<5I',destination,0,0,key,0))
  found=bool(u.reg_read(UC_X86_REG_EAX)&255)
  value=struct.unpack('<f',u.mem_read(destination,4))[0] if table['bit']==1 else bool(u.mem_read(destination,1)[0])
  assert found and value==expected,(key,found,value,expected)
  typed_queries.append(dict(key=str(key),bit=table['bit'],result=value,found=found))
print(json.dumps(dict(bytes=len(contents),reads=len(reads),open=opens,allocations=len(allocations))),flush=True)
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='0x8b0380',source=str(source),source_sha256=hashlib.sha256(contents).hexdigest(),bytes=len(contents),consumed=cursor,opens=opens,reads=reads,closes=closes,native_addresses=len({a for a in visited if 0x8b0380<=a<0x8b062b or 0x8bb4d0<=a<0x8bba80}),limits=['Original binary path construction, header, all type reader calls, native vector allocation and string table load execute against actual original terrain INIBIN bytes.','File open/read/destructor and thread import are adapters. Key-vector container and config object storage supplied; whole config constructor/cache and text/default overlay remain open.','Allocator/mutex/cookie boundaries adapted; no normal GPU fog completion or whole original filesystem/archive IO acceptance claimed.'])
(r/'data/4.20/native_map10_inibin_loader_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
proof.update(tables=tables,decoded_reference=parsed,native_decoded=native_decoded,float_queries=queries,upscale_query=dict(default=True,found=False,result=True),cookie_skips=sorted(set(cookie_skips)),native_query_addresses=len({a for a in visited if 0x8ae000<=a<0x8b0380}))
proof['typed_queries']=typed_queries
proof['native_float_bits']=native_float_bits
(r/'data/4.20/native_map10_inibin_loader_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(keys=len(parsed),float_queries=queries,tables=[dict(bit=t['bit'],count=t['count']) for t in tables],cookie_skips=proof['cookie_skips'])))
