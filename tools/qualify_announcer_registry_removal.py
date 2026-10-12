from pathlib import Path
import json,struct,itertools,hashlib
root=Path('E:/OpenLeague');bootstrap=root/'tools/qualify_native_audio_legacy_paths.py';__file__=str(bootstrap)
exec(compile(bootstrap.read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)',''),__file__,'exec'))
lookup_path=root/'data/4.20/audio_announcer_object_lookup_contract.json';lookup=json.loads(lookup_path.read_text(encoding='utf-8'))
custom_free=end+0x600;free_calls=[];manager=0
def capture(uc,address,size,user):
    if address in [0xc98528,custom_free]:
        sp=u.reg_read(UC_X86_REG_ESP);pointer=read32(sp+4)
        free_calls.append({'pointer':pointer,'custom':address==custom_free,'context':read32(sp+8) if address==custom_free else None,'count_at_free':read32(manager+8),'previous_next_at_free':read32(read32(pointer+4)),'next_previous_at_free':read32(read32(pointer)+4)})
        finish()
u.hook_add(unicorn.UC_HOOK_CODE,capture)
def query(key):
    sp=stack+0xd000;u.mem_write(sp,struct.pack('<II',end,key));u.reg_write(UC_X86_REG_ESP,sp);u.emu_start(0x62b380,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end;return u.reg_read(UC_X86_REG_EAX)
queries=[0,1,2,16,17,42,99,100,200,0x7fffffff,0x80000000,0xdeadbeef,0xfffffffe,0xffffffff]
cases=[]
for index,layout in enumerate(lookup['layouts']):
    if not layout['keys']:continue
    manager=layout['manager'];original=dict(layout['words']);original[manager+8]=len(layout['keys'])
    nodes={value:address-8 for address,value in layout['words'] if heap+0x2000<=address<heap+0x3000 and (address-(heap+0x2000))%32==8}
    values={key:original[node+12] for key,node in nodes.items()}
    for order,custom in itertools.product(['ascending','descending','alternating'],[False,True]):
        for address,value in original.items():write32(address,value)
        write32(0x14bef40,custom_free if custom else 0);write32(0x14bef44,0x13572468)
        keys=sorted(nodes)
        if order=='descending':keys.reverse()
        if order=='alternating':keys=keys[::2]+keys[1::2][::-1]
        remaining=set(keys);freed=set();steps=[]
        for key in keys:
            node=nodes[key];free_calls.clear();expected_next=read32(node)
            sp=stack+0xe000;result=heap+0xa000;u.mem_write(sp,struct.pack('<III',end,result,node));u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,manager)
            u.emu_start(0x64dd60,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end;assert read32(result)==expected_next
            remaining.remove(key);freed.add(node);assert len(free_calls)==1 and free_calls[0]['pointer']==node
            assert read32(manager+8)==len(remaining)
            results=[{'key':q,'result':query(q)} for q in queries]
            assert all(entry['result']==values.get(entry['key'],0) if entry['key'] in remaining else entry['result']==0 for entry in results)
            words=[[address,read32(address)] for address in sorted(original) if not any(start<=address<start+16 for start in freed)]
            steps.append({'key':key,'node':node,'returned_next':read32(result),'free_calls':list(free_calls),'words':words,'lookups':results})
        assert read32(layout['head'])==layout['head'] and read32(layout['head']+4)==layout['head']
        cases.append({'layout':index,'manager':manager,'order':order,'custom_free':custom,'initial_words':list(original.items()),'steps':steps})
proof={'native_sha256':digest,'lookup_contract_sha256':hashlib.sha256(lookup_path.read_bytes()).hexdigest(),'passed':True,'complete':False,'cases':cases,'limits':['Actual64DD60 unlink, signed CRT hash, bucket first/last adjustments and original62B380 lookup executed through108 full removal sequences918 removals with12852 subsequent native lookups. Initialized valid unique-key layouts supplied.','Standard/custom deallocation imports adapted. Count and neighbor links observed before free; removed storage excluded from live snapshots. Missing/sentinel/malformed node removal and throwing/custom deallocation, insertion/rehash, locking and actor lifetimes remain open.']}
(root/'data/4.20/audio_announcer_registry_removal_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'sequences':len(cases),'removals':sum(len(c['steps']) for c in cases),'lookups':sum(len(s['lookups']) for c in cases for s in c['steps']),'passed':True}))
