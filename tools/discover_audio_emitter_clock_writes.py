from pathlib import Path
import sys,json,hashlib
r=Path('E:/OpenLeague');sys.path.insert(0,str(r/'tools/pythonlibs'))
import pefile,capstone
ctx=json.loads((r/'data/4.20/ambient_audio_context.json').read_text())
p=next(p for p in Path(ctx['banks'][0]['path']).parents if p.name=='deploy')/'League of Legends.exe'
raw=p.read_bytes();pe=pefile.PE(data=raw);base=pe.OPTIONAL_HEADER.ImageBase
md=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32);md.skipdata=True
start=0x93e000;end=0x941000;off=pe.get_offset_from_rva(start-base)
a=list(md.disasm(raw[off:off+end-start],start));hits=[]
for n,i in enumerate(a):
 dst=i.op_str.split(',')[0]
 if ('0xb0]' in dst or '0xa8]' in dst) and i.mnemonic in ('mov','movss','fstp') and 'esp' not in dst and 'ebp' not in dst:
  region=[dict(address=hex(j.address),bytes=j.bytes.hex(),mnemonic=j.mnemonic,operands=j.op_str) for j in a[max(0,n-10):n+5]]
  hits.append(dict(address=hex(i.address),context=region))
out=dict(complete=False,kind='static discovery only; linear decoding candidates require function-boundary and execution validation',source=str(p),sha256=hashlib.sha256(raw).hexdigest(),range=[hex(start),hex(end)],writes=hits)
(r/'docs/audio_emitter_clock_write_discovery.json').write_text(json.dumps(out,indent=2)+'\n')
for h in hits:
 print('\n'+h['address'])
 for i in h['context']:print(i['address'],i['mnemonic'],i['operands'])
