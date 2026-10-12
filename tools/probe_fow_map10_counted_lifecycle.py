from pathlib import Path
import json,datetime,struct,hashlib
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_projected_sampler.py').read_text(encoding='utf-8').split('cases=[]')[0],'native setup','exec'))
mask_path=r/'data/4.20/fow_map10_owned_contract.json';mask_proof=json.loads(mask_path.read_text());assert mask_proof['native_sha256']==digest
source_a=heap+0x1f300;source_b=heap+0x1f500;manager=heap+0x1f900;counts=heap+0x12000;pixels=heap+0x8000;bits_a=heap+0x1a000;bits_b=heap+0x1b000;n=128
def set_mask(source,bit_address,case):
 assert case['dimension']==n
 u.mem_write(bit_address,struct.pack('<'+'I'*len(case['words']),*case['words']));write32(source+0x40,bit_address)
 x0,z0,x1,z1=case['rect']
 for offset,value in [(0xc,x0),(0x10,x1),(0x14,z0),(0x18,z1)]:write32(source+0x40+offset,value)
def call(entry,source,adding=False):
 write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp)
 if adding:
  region=source+0x40;u.reg_write(UC_X86_REG_ECX,region)
  for offset,value in [(4,n),(8,pixels),(12,manager+0x14),(16,read32(region+0xc)),(20,read32(region+0x10)),(24,read32(region+0x14)),(28,read32(region+0x18))]:write32(sp+offset,value)
 else:u.reg_write(UC_X86_REG_ECX,manager);write32(sp+4,source)
 u.emu_start(entry,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end
def capture(action):
 c=bytes(u.mem_read(counts,n*n));p=bytes(u.mem_read(pixels,n*n))
 return dict(action=action,counts=[[i,v] for i,v in enumerate(c) if v],pixels=[[i,v] for i,v in enumerate(p) if v],applied=[bool(u.mem_read(s+0x44,1)[0]) for s in [source_a,source_b]])
cases=[]
for a,b in [(1,3),(3,5),(7,9),(9,11),(13,15),(19,21)]:
 u.mem_write(source_a,bytes(0x80));u.mem_write(source_b,bytes(0x80));u.mem_write(manager,bytes(0x40));u.mem_write(counts,bytes(n*n));u.mem_write(pixels,bytes(n*n))
 write32(manager+0x10,n);write32(manager+0x14,counts);write32(manager+0x18,pixels);ma=mask_proof['cases'][a];mb=mask_proof['cases'][b]
 set_mask(source_a,bits_a,ma);set_mask(source_b,bits_b,mb);outputs=[]
 call(0x6b2d80,source_a,True);outputs.append(capture('add_a'))
 call(0x6b2d80,source_b,True);outputs.append(capture('add_b'))
 call(0x6b3ef0,source_a);set_mask(source_a,bits_a,mb);call(0x6b2d80,source_a,True);outputs.append(capture('replace_a_with_b'))
 call(0x6b3ef0,source_b);outputs.append(capture('remove_b'))
 call(0x6b3ef0,source_b);outputs.append(capture('repeat_remove_b'))
 call(0x6b3ef0,source_a);outputs.append(capture('remove_a'))
 assert not outputs[-1]['counts'] and not outputs[-1]['pixels']
 cases.append(dict(mask_a=a,mask_b=b,dimension=n,outputs=outputs))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,mask_proof='data/4.20/fow_map10_owned_contract.json',mask_proof_sha256=hashlib.sha256(mask_path.read_bytes()).hexdigest(),native_addresses=len(visited),runtime_adapters=[],cases=cases,limits=['Map10 masks are supplied from previously executed original generator contract; this probe executes original add/remove counters and source retirement wrapper, not the generator again.','Six source replacement/removal sequences qualify count and texture rollback; actual source team/creation/scheduling/removal queue/destructor and live GPU binding remain open.'])
(r/'data/4.20/fow_map10_counted_lifecycle_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(dict(sequences=len(cases),native_addresses=len(visited))))
