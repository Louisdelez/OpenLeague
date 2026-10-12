from pathlib import Path
import ctypes,itertools,json,struct,zlib,traceback
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_replay_transport_configuration.py').read_text().split('\ncases=[]')[0],'address prerequisites','exec'))
api=ctypes.windll.ws2_32
api.inet_addr.argtypes=[ctypes.c_char_p];api.inet_addr.restype=ctypes.c_uint32
api.inet_ntoa.argtypes=[ctypes.c_uint32];api.inet_ntoa.restype=ctypes.c_char_p
api.gethostbyname.argtypes=[ctypes.c_char_p];api.gethostbyname.restype=ctypes.c_void_p
class HostEnt(ctypes.Structure):_fields_=[('name',ctypes.c_void_p),('aliases',ctypes.c_void_p),('kind',ctypes.c_short),('length',ctypes.c_short),('addresses',ctypes.POINTER(ctypes.c_void_p))]
data=(ctypes.c_ubyte*512)();assert api.WSAStartup(0x202,ctypes.byref(data))==0
old_windows=transport_windows;events=[];dns_mode='fail';format_fail=False
def transport_windows(dll,name,sp):
 if name=='inet_addr':
  value=cbytes(read32(sp+4));result=api.inet_addr(value);events.append({'kind':name,'text_hex':value.hex(),'result':result});finish(eax=result,pop=4);return True
 if name=='gethostbyname':
  assert cbytes(read32(sp+4))==b'localhost';ptr=api.gethostbyname(b'localhost');assert ptr;host=ctypes.cast(ptr,ctypes.POINTER(HostEnt)).contents;assert host.kind==2 and host.length==4 and host.addresses[0]
  value=ctypes.string_at(host.addresses[0],4);p=heap+0xd800;u.mem_write(p,bytes(40));write32(p+12,p+16);write32(p+16,p+24);u.mem_write(p+24,value);events.append({'kind':name,'address_hex':value.hex()});finish(eax=p,pop=4);return True
 if name=='inet_ntoa':
  address=read32(sp+4);value=api.inet_ntoa(address);assert value;u.mem_write(heap+0xd880,value+b'\0');events.append({'kind':name,'address':address,'text_hex':value.hex()});finish(eax=heap+0xd880,pop=4);return True
 if name=='getaddrinfo':
  nameptr,service,hints,output=[read32(sp+i) for i in range(4,20,4)];assert cbytes(nameptr)==b''
  events.append({'kind':name,'host_hex':'','service_hex':cbytes(service).hex(),'hints':[read32(hints+i*4) for i in range(8)],'mode':dns_mode})
  if dns_mode=='fail':write32(output,0);finish(eax=11001,pop=16);return True
  p=heap+0xda00;u.mem_write(p,bytes(96));write32(output,p)
  if dns_mode=='empty':write32(output,0)
  elif dns_mode=='ipv6_only':write32(p+4,23)
  elif dns_mode=='ipv6_then_ipv4':write32(p+4,23);write32(p+28,p+32);write32(p+36,2);write32(p+56,p+64);u.mem_write(p+64,bytes.fromhex('020034120a010203')+bytes(8))
  else:raise AssertionError(dns_mode)
  finish(eax=0,pop=16);return True
 if name=='freeaddrinfo':events.append({'kind':name});finish(pop=4);return True
 if name=='WSAAddressToStringA':
  address,length,protocol,output,capacity=[read32(sp+i) for i in range(4,24,4)]
  events.append({'kind':name,'sockaddr_hex':bytes(u.mem_read(address,length)).hex(),'capacity':read32(capacity),'supplied_failure':format_fail})
  if format_fail:write32(capacity,200);finish(eax=10014,pop=20);return True
 return old_windows(dll,name,sp)
# Verify the entire native CRC table against the polynomial used by the Rust port.
table=[]
for i in range(256):
 value=i
 for bit in range(8):value=(value>>1)^(0xedb88320 if value&1 else 0)
 table.append(value)
assert bytes(u.mem_read(0x10d3300,1024))==struct.pack('<256I',*table)
# Solve the32-bit linear CRC map for a valid IPv4 address whose UID is zero.
base_crc=zlib.crc32(bytes(6));columns=[zlib.crc32(bytes(2)+(1<<i).to_bytes(4,'little'))^base_crc for i in range(32)];basis={}
for i,value in enumerate(columns):
 mask=1<<i
 while value:
  bit=value.bit_length()-1
  if bit not in basis:basis[bit]=(value,mask);break
  v,m=basis[bit];value^=v;mask^=m
value=base_crc;mask=0
while value:
 v,m=basis[value.bit_length()-1];value^=v;mask^=m
collision=mask.to_bytes(4,'little');assert zlib.crc32(bytes(2)+collision)==0
hosts=[b'',b'localhost',b'127.0.0.1',b'0.0.0.0',b'127.1',b'0177.0.0.1',b'0x7f000001',b'255.255.255.255',b'256.0.0.1',b'example.invalid',b'::1',b' LOCALHOST',b'LOCALHOST',b'127.0.0.1\0ignored',b'.'.join(str(v).encode() for v in collision)]
cases=[]
try:
 profiles=list(itertools.product([0,165],hosts,[0,1,1023,1024,65535],['fail'],[False]))
 profiles+=[(fill,b'',port,mode,False) for fill,port,mode in itertools.product([0,165],[0,1024],['empty','ipv6_only','ipv6_then_ipv4'])]
 profiles+=[(fill,b'127.0.0.1',1024,'fail',True) for fill in [0,165]]
 for fill,host,port,dns_mode,format_fail in profiles:
  poison=fill;u.mem_write(heap+0xa000,host+b'\0');u.mem_write(heap+0xb000,str(port).encode()+b'\0');u.mem_write(heap+0xc000,bytes([fill])*16);u.mem_write(heap+0xc100,bytes([fill])*128);write32(heap+0xc200,128);u.mem_write(0x2d8ddd8,bytes([fill])*16);events.clear()
  result=call(0x8fd3f0,0,[heap+0xa000,heap+0xb000,heap+0xc000,heap+0xc100,heap+0xc200,1])
  cases.append({'fill':fill,'host_hex':host.hex(),'port':port,'dns_profile':dns_mode,'formatter_failure':format_fail,'return_uid':result,'sockaddr_hex':bytes(u.mem_read(heap+0xc000,16)).hex(),'text_hex':bytes(u.mem_read(heap+0xc100,128)).hex(),'capacity':read32(heap+0xc200),'validation_scratch_hex':bytes(u.mem_read(0x2d8ddd8,16)).hex(),'events':list(events)})
 result={'passed':True,'native_sha256':digest,'cases':cases,'crc_polynomial':0xedb88320,'crc_table_hex':bytes(u.mem_read(0x10d3300,1024)).hex(),'crc_zero_ipv4':list(collision),'limits':['Original8FD3F0/8FD2B0/8FD3C0/8FD4B0/8FD060/8FD0F0/8FCF20 and CRC helper bodies execute. Inet conversion and localhost resolution use actual Windows APIs; native boundary captures only localhost IPv4 and maps the hostent representation toPE32.','Empty-name getaddrinfo error/success lists and formatter failure are supplied profiles. Normal formatter is actual Windows WSAAddressToStringA. Socket16 bytes and text128 bytes begin with explicit fill0/A5; native localhost and empty-list success preserve caller stack residues. keep_port=1, as used by8FCA30.','Ports passed to8FD3F0 are decimal strings in theu16 range, matching8FCA30. General arbitrary atoi strings and keep_port=0 are outside these cases. Native zero UID still means failure to the caller even after formatting.']}
except Exception as e:
 traceback.print_exc();result={'passed':False,'completed':len(cases),'error':repr(e),'pc':hex(u.reg_read(UC_X86_REG_EIP)),'events':events}
finally:assert api.WSACleanup()==0
Path('E:/mapslol3v3/replay_address_probe.json').write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8')
print(json.dumps({k:v for k,v in result.items() if k not in ['cases','limits','crc_table_hex']}))
