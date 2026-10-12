from pathlib import Path
import json,struct,datetime
r=Path('E:/OpenLeague');s=Path('E:/mapslol3v3/probe_native_grass_parent_insertion.py').read_text(encoding='utf-8')
s=s[:s.index('exec(compile(s,')]+'''s=s.replace("events.append(dict(kind='destroy',level=([parent]+ancestors).index(u.reg_read(UC_X86_REG_ECX))));ret(0)","events.append(dict(kind='destroy',level=([parent]+ancestors).index(u.reg_read(UC_X86_REG_ECX))))",1)
s=s.replace("chain=[parent]+ancestors[:depth]", "recycle=terrain+0x9000;write32(0x2d712a8,recycle);write32(0x2d712ac,recycle);write32(0x2d712b0,recycle+128);\\n chain=[parent]+ancestors[:depth]\\n for level,outer in enumerate(ancestors):\\n  stop=terrain+0x8200+level*0x20;write32(outer+0x44,stop);write32(stop,stop);write32(stop+4,stop)",1)
s=s.replace("root_member_count=read32(root+0x48),vertical_bits=", "root_member_count=read32(root+0x48),pool_levels=[([parent]+ancestors).index(read32(recycle+i*4)) for i in range((read32(0x2d712ac)-recycle)//4)],vertical_bits=",1)
exec(compile(s,'actualparentdestructionpoolandinsertion','exec'))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='0x95ff10',native_addresses=len(visited),cases=cases,runtime_adapters=['Onlyallocation9933E0 andfreeC98528; originalparentreindex,pruning,destructor95FDA0,poolpush androotinsertion execute.'],limits=['Explicitvalidparent/ancestor/rootlists,preallocatedpool androotnochildren. Poolgrowth,actualtreeproviders andnormalactorregistry/livegrassmask remainopen.'])
(r/'data/4.20/grass_parent_pool_contract.json').write_text(json.dumps(proof,indent=2)+'\\n',encoding='utf-8');print(json.dumps(dict(cases=len(cases),native_addresses=len(visited))))
'''
exec(compile(s,'generateparentpoolprobe','exec'))
