"""Derive assignment-only input/output from128 frozen caller lifetimes.
No new native run and no successful Rust qualification is claimed.
"""
from pathlib import Path
import json,hashlib
out=Path(__file__).resolve().parent
source=Path(r'E:\mapslol3v3\loading_standard_ui_next\prefix_native_probe.json')
raw=source.read_bytes();digest=hashlib.sha256(raw).hexdigest()
assert digest=='e321a049a6ef3af573549b578fa7f3f79dc51f302808a4dcbd29b2f061a6d521'
native=json.loads(raw);cases=[]
for c in native['cases']:
    entry=next(e['string'] for e in c['events'] if e['op']=='prefix_entry')
    final=c['prefix_stop']['string'];fill=c['fill'];src=0x360002a8
    text=bytes.fromhex(c['override_hex']);src_descriptor=bytearray([fill]*24)
    src_descriptor[0]=0
    src_descriptor[16:20]=len(text).to_bytes(4,'little')
    source_heap=None
    if len(text)<16:
        src_descriptor[:len(text)]=text;src_descriptor[len(text)]=0
        src_descriptor[20:24]=(15).to_bytes(4,'little')
    else:
        def read_at(p):return next(e['value'] for e in c['events'] if e['op']=='read' and e['pointer']==p)
        pointer=read_at(src);cap=read_at(src+20)
        src_descriptor[:4]=pointer.to_bytes(4,'little');src_descriptor[20:24]=cap.to_bytes(4,'little')
        source_heap=next(b for b in c['prepared']['blocks'] if b['pointer']==pointer)
        assert source_heap['bytes']==cap+1 and bytes.fromhex(source_heap['hex'])[:len(text)]==text
    target_heap=None
    if entry['capacity']>=16:
        # Output72AD90 allocated a fresh poisoned buffer then copied exactly
        # length bytes and NUL; untouched tail remains allocator fill.
        data=bytes.fromhex(entry['text_hex'])+b'\0'
        data+=bytes([fill])*(entry['capacity']+1-len(data))
        allocation=next(a for a in c['state_at_boundary']['allocations'] if a['pointer']==entry['data'])
        assert allocation['bytes']==len(data)
        target_heap={'pointer':entry['data'],'bytes':len(data),'hex':data.hex()}
    final_heap=next((b for b in c['state_at_boundary']['blocks'] if b['pointer']==final['data']),None) if final['capacity']>=16 else None
    grew=len(text)>entry['capacity']
    allocation=next(a for a in c['state_at_boundary']['allocations'] if a['pointer']==final['data']) if grew else None
    assert c['state_at_boundary']['freed']==([entry['data']] if grew and entry['capacity']>=16 else [])
    cases.append({'fill':fill,'profile':c['profile'],'source':src,'source_descriptor_hex':src_descriptor.hex(),
                  'source_heap':source_heap,'destination':entry['address'],'destination_descriptor_hex':entry['hex'],
                  'destination_heap':target_heap,'assignment_called':bool(text),
                  'new_allocation':allocation,'expected_descriptor_hex':final['hex'],
                  'expected_heap':final_heap,'expected_assignment_frees':c['state_at_boundary']['freed'],
                  'expected_cleanup_frees':c['cleanup']['freed']})
proof={'source':str(source),'source_sha256':digest,'native_sha256':native['native_sha256'],
       'native_cases':len(cases),'new_native_execution':False,'cases':cases,
       'derivation':['Original128 caller lifetimes retain case order.',
           'String24 header/text at prefix entry and before each native stop are exact recorded bytes.',
           'Source descriptor is reconstructed from explicit diagnostic input, fill and native pointer/capacity reads.',
           'Fresh output heap tail is reconstructed from allocator poison; length bytes and NUL were written by native name provider.',
           'Only allocation/frees caused by override assignment are retained; parent/name-provider setup remains outside these focused cases.']}
(out/'loading_owned_string_probe.json').write_text(json.dumps(proof,indent=2)+'\n')
print(json.dumps({'derived_native_cases':len(cases),'assignments':sum(c['assignment_called'] for c in cases),'compiled':False}))
