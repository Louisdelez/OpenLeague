from pathlib import Path
import json,struct
exec(Path('E:/mapslol3v3/inspect_announcer_registration.py').read_text().split('targets =')[0])
image=pe.get_memory_mapped_image()
def cstring(p):return image[p-base:p-base+700].split(b'\0')[0].decode('ascii',errors='backslashreplace')
print('strings',json.dumps({hex(p):cstring(p) for p in [0x10d5e54,0x10d5d24,0x10d5cf8,0x10d5d60,0x10d4bf4,0x10d5e60]}))
print('pointed strings',json.dumps({hex(p):cstring(struct.unpack_from('<I',image,p-base)[0]) for p in [0x10d60ac,0x10d623c]}))
print('vtable',[hex(v) for v in struct.unpack_from('<8I',image,0x10d5fa4-base)])
proof=json.loads(Path('E:/OpenLeague/data/4.20/replay_transport_configuration_probe.json').read_text())
print('cases',len(proof['cases']))
for c in proof['cases']:
 if c['fill']==0 and c['port']==12345 and c['supplied_wsa_startup_error']==0:
  p=c['object'];print(json.dumps({'host':c['host_hex'],'result':c['return_code'],'allocs':c['constructed']['allocations'],'configured_words':[(hex(a-p),hex(v)) for a,v in c['configured']['words'] if p<=a<p+224],'freed':c['destroyed']['freed']}))
