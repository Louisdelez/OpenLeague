from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/discover_audio_emitter_clock_writes.py').read_text().split('start=0x93e000')[0],'setup','exec'))
import struct
regions=[]
for start,end in [(0xaebe20,0xaebe85),(0xaec110,0xaec160),(0xadc44d,0xadc49b),(0xb29a1c,0xb29a2c),(0xb2a230,0xb2a3c5),(0xb2a430,0xb2a6b7)]:
 off=pe.get_offset_from_rva(start-base);blob=raw[off:off+end-start];ins=list(md.disasm(blob,start))
 regions.append(dict(start=hex(start),end=hex(end),sha256=hashlib.sha256(blob).hexdigest(),instructions=[dict(address=hex(i.address),bytes=i.bytes.hex(),mnemonic=i.mnemonic,operands=i.op_str) for i in ins]))
tables=[]
for vt,origin in [(0xff0cdc,0xaebe39),(0xfeff88,0xadc474),(0xff27d4,0xb29a1f)]:
 off=pe.get_offset_from_rva(vt-base);v=struct.unpack('<18I',raw[off:off+72]);tables.append(dict(address=hex(vt),assignment=hex(origin),slots={hex(i*4):hex(a) for i,a in enumerate(v)}))
proof=dict(complete=False,kind='static table and instruction discovery; derived callbacks not yet executed',native_sha256=hashlib.sha256(raw).hexdigest(),tables=tables,regions=regions,correction='AEC110 restores base vtable then releases storage and restores FEFF50: destruction path, not constructor. AEBE20 is constructor with FF0CDC assignment atAEBE39.',findings=['ADC420 derived constructor installs FEFF88; duration virtual10/2C remain no-ops.','B299F0 derived constructor installs FF27D4; virtual10=B2A430,virtual2C=B2A230.','Derived callbacks inspect flags12D and low state nibble200 before dispatch; actual callback effects and eligibility for Map10 remain unqualified.'],next_action='Execute derived FF27D4 duration callbacks with actual virtual44 or explicit adapter, covering state nibble200 and flags12D, then trace action allocation/dispatch rather than infer PCM behavior.')
(r/'docs/audio_derived_voice_discovery.json').write_text(json.dumps(proof,indent=2)+'\n')
print('Recorded three native tables, six instruction regions, and destructor annotation correction.')
