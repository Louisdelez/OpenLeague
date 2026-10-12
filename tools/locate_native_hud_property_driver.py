from pathlib import Path
import json,hashlib,datetime
r=Path('E:/OpenLeague')
exec(compile((r/'tools/inspect_native_clear_callers.py').read_text(encoding='utf-8').split('for target in ')[0],'HUD property driver PE prerequisites','exec'))
ranges=[]
for start,end in [(0x9a1a60,0x9a1e35),(0x9a3080,0x9a35d0)]:
 ranges.append(dict(start=hex(start),end=hex(end),instructions=[dict(address=hex(i.address),mnemonic=i.mnemonic,operands=i.op_str) for i in md.disasm(image[start-base:end-base],start)]))
strings={hex(p):image[p-base:p-base+200].split(b'\0')[0].decode('ascii',errors='backslashreplace') for p in [0x1080a90,0x109b3d0,0x10df4d0,0x10df57c]}
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),qualified=False,complete=False,native_sha256=hashlib.sha256(Path(source).read_bytes()).hexdigest(),ranges=ranges,strings=strings,candidates=['9A3080 appears to read BaseOffset then invoke qualified header reader9A5570; sets aspect field1d8 to1 before invoking9A1A60.','9A1A60 appears to tokenize keys, look up registered callbacks, accumulate callback return flags and validate per-kind required masks.','Required-mask candidates: Icon7e, Effect79e, Text381e; native execution and complete callback registry still need qualification.','9A1D10 appears to flip current/cached UV coordinate pairs for flags400/800.'],limits=['Bounded disassembly candidates only; no execution or Rust compatibility claim.','Need qualified key tokenization/string/map lookup, callback registration and return masks before full structural parser integration.'])
(r/'data/4.20/native_hud_property_driver_candidates.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(qualified=False,strings=strings,instructions=sum(len(v['instructions']) for v in ranges))))
