from pathlib import Path
import json
p=json.loads(Path('E:/OpenLeague/data/4.20/native_hud_font_creation_contract.json').read_text())
def rounded(n,bits):
 shift=max(0,n.bit_length()-bits)
 if not shift:return n,0
 top=n>>shift;tail=n-(top<<shift);half=1<<(shift-1)
 return top+int(tail>half or tail==half and top&1),shift
def size(height,requested,precision):
 n,e=rounded(height*11184811,precision);e-=33
 n,s=rounded(n*requested,precision);e+=s
 n,s=rounded(n,53);e+=s
 return ((n<<e) if e>=0 else ((n+(1<<-e)-1)>>-e))&0xffffffff
bad=[c for c in p['cases'] if size(c['height'],c['requested_size'],53 if c['control_word']==0x27f else 64)!=c['scaled_size']]
print(json.dumps(dict(cases=len(p['cases']),mismatches=len(bad),examples=bad[:3])))
assert not bad
