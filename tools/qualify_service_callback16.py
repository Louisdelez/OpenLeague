from pathlib import Path
import json,itertools
root=Path('E:/OpenLeague');source=(root/'tools/qualify_active_service_lifetimes.py').read_text().split('\ncases=[]')[0];exec(compile(source,'native setup','exec'))
cases=[];callback=heap+0x9800
for poison,owner,method,extra,flags in itertools.product([0,165],[0,service],[0,0x72c780],[0,0xffffffff],[0,1,256,257]):
 cursor=arena;fail=False;allocations.clear();freed.clear();u.mem_write(0x2d77b20,b'\1');write32(0x14bef58,0);write32(0x14bef40,0)
 for offset,value in [(0,0x10afd08),(4,owner),(8,method),(12,extra)]:write32(callback+offset,value)
 cloned=call(0x7340c0,callback,[]);assert cloned!=0;clone={'allocations':list(allocations),'freed':list(freed),'words':[[cloned+i,read32(cloned+i)] for i in range(0,16,4)]};allocations.clear();freed.clear();returned=call(0x578010,cloned,[flags]);assert returned==cloned
 disposed={'allocations':list(allocations),'freed':list(freed),'words':[[cloned+i,read32(cloned+i)] for i in range(0,16,4)] if flags&1==0 else []};cases.append({'poison':poison,'owner':owner,'method':method,'extra':extra,'flags':flags,'clone_result':cloned,'clone':clone,'delete_result':returned,'disposed':disposed})
p={'passed':True,'complete':False,'native_sha256':digest,'cases':cases,'limits':['Actual7340C0 sixteen-byte service callback clone and578010 scalar delete run64 lifetimes with supplied owner/method/extra words, two allocator fill patterns and four delete flags. Actual clone reads and vtable publication; no callback helper outcomes substituted.','Clone allocator startup preconfigured and operator-new/free primitives supplied. Callback invocation, allocation failure, custom allocator/free mutations and native59CC60 Replay timing composition remain open. Rust replay not yet added.']};(root/'data/4.20/audio_game_service_callback16_contract.json').write_text(json.dumps(p,indent=2)+'\n');print(json.dumps({'native_callback16_lifetimes_prepared':len(cases)}))
