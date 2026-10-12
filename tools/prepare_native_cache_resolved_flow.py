from pathlib import Path
r=Path('E:/OpenLeague');stage=Path(__file__).parent
text=(r/'tools/qualify_native_config_cache_reload_flow.py').read_text(encoding='utf-8')
old=''' if a==0x8b5700:
  ssowrite(uc.reg_read(UC_X86_REG_EDX),resolved[0].encode());ssowrite(read(sp+4),resolved[1].encode());ssowrite(read(sp+8),resolved[2].encode());finish(0);return'''
new=''' if a==0xc9c850:
  p=read(sp+4);index=cbytes(p).rfind(bytes([read(sp+8)&255]));finish(0 if index<0 else p+index);return
 if a==0x564ea0:
  data=ssoread(this);capacity=read(sp+4);p=allocate(capacity+1);u.mem_write(p,data+b'\\0');w(this,p);w(this+0x14,max(16,capacity));finish(1,8);return
 if a==0x6ee4b0:
  assert read(sp+4)==0 and not ssoread(this);ssowrite(this,bytes(u.mem_read(read(sp+8),read(sp+12))));finish(this,12);return
 if a==0x5f82a0:ssowrite(this,ssoread(this)+bytes([read(sp+8)&255])*read(sp+4));finish(this,8);return'''
assert old in text;text=text.replace(old,new)
text=text.replace('(0x8b2ed0,0x8b30d0)]','(0x8b2ed0,0x8b30d0),(0x8b5700,0x8b585a)]')
text=text.replace('native_config_cache_reload_flow_contract.json','native_config_cache_resolved_flow_contract.json')
marker="(r/'data/4.20/native_config_cache_resolved_flow_contract.json').write_text"
addition="""proof['path_splitter_executed']=True
proof['adapters'][0]='Original8B5700 path splitter executes inside8ACEF0 cache reload; CRT strrchr and standard string allocation/insertion/assignment boundaries adapted.'
proof['limits'][0]='Cache reload with native path splitter/locale filename control flow; constructor contents, dictionary implementation/lifetime, loader/file handling and resource provider predicates remain open.'
"""
assert marker in text;text=text.replace(marker,addition+marker)
text=text.replace('whole cache control flow with constructor/path/dictionary adapters','whole cache control flow including native path splitter; constructor/dictionary/providers adapted')
(stage/'qualify_native_cache_resolved_flow.py').write_text(text,encoding='utf-8')
print('Native path splitter enabled within full reload probe; preceding contract preserved.')
