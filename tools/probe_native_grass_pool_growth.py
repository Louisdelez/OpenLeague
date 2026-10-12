from pathlib import Path
import json,datetime
r=Path('E:/OpenLeague');s=Path('E:/mapslol3v3/probe_native_grass_pool.py').read_text(encoding='utf-8')
s=s.replace('assert size in [12,0x50]','assert 0<size<=512',1)
s=s.replace("if size==0x50:owned.append(p);events.append(dict(kind='allocate_node',node=owned.index(p)))", "if read32(s)==0x95fcb1:owned.append(p);events.append(dict(kind='allocate_node',node=owned.index(p)))\n  elif read32(s)==0x96af88:events.append(dict(kind='reserve_pool',capacity=size//4))",1)
s=s.replace("write32(0x2d712b0,pool+4*32)","write32(0x2d712b0,pool+4*len(initial_pool))",1)
s=s.replace('read32(pool+i*4)', 'read32(read32(0x2d712a8)+i*4)')
s=s.replace('read32(0x2d712ac)-pool','read32(0x2d712ac)-read32(0x2d712a8)')
s=s.replace('before_reuse=dict(queue=', 'before_reuse=dict(pool_capacity=(read32(0x2d712b0)-read32(0x2d712a8))//4,queue=',1)
s=s.replace('initial_pool=initial_pool,destroy_events=', 'initial_pool=initial_pool,initial_pool_capacity=len(initial_pool),destroy_events=',1)
s=s[:s.index('proof=dict(')]
exec(compile(s,'originalpoolgrowthandcopy','exec'))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='0x95fda0',actual_growth='0x96af60',native_addresses=len(visited),cases=cases,runtime_adapters=['Only9933E0 suppliesmappedstorage andC98528 release returns; nativegrowth policy,reserve/copy andpoolpush/reuse execute.'],limits=['Smallvalid capacity states withsuccessallocations; capacityexceptions/OOM,customallocatorhooks andglobalmulti-context ownership remainopen.','Actual actorregistration/treeproviders,partialexistingchildren andnormalgrassrender integration remainopen.'])
(r/'data/4.20/grass_pool_growth_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(dict(cases=len(cases),native_addresses=len(visited),growth_cases=sum(any(e['kind']=='reserve_pool' for e in c['destroy_events']) for c in cases))))
