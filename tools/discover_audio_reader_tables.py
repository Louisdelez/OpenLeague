from pathlib import Path
import struct,json,hashlib
r=Path('E:/OpenLeague')
exec(compile((r/'tools/discover_audio_emitter_clock_writes.py').read_text(encoding='utf-8-sig').split('start=0x93e000')[0],'setup','exec'))
regions=[(base+s.VirtualAddress,base+s.VirtualAddress+s.Misc_VirtualSize) for s in pe.sections if s.Characteristics&0x20000000]
def iscode(v):return any(a<=v<b for a,b in regions)
rows=[];start=None;values=[]
for va in range(0xfef000,0xff4000,4):
 v=struct.unpack('<I',pe.get_data(va-base,4))[0]
 if iscode(v):
  if start is None:start=va;values=[]
  values.append(v)
 else:
  if start is not None and len(values)>=80:
   rows.append(dict(candidate_start=hex(start),slots=len(values),candidate_virtual13c=hex(values[79]),first_slots=[hex(x) for x in values[:5]]))
  start=None
proof=dict(native_sha256=hashlib.sha256(raw).hexdigest(),kind='static candidates, not verified class identities',candidates=rows,limits=['Contiguous function-pointer run can contain adjacent tables; constructor assignments must establish exact table starts.','No RTTI names CAkSound or CAkRanSeqCntr found in executable bytes. Candidate virtual13C values must not be used as proven reader entrypoints.'])
(r/'docs/audio_reader_table_candidates.json').write_text(json.dumps(proof,indent=2)+'\n');print(json.dumps(rows))
