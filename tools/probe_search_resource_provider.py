from pathlib import Path
import json,struct,datetime
r=Path('E:/OpenLeague');prefix=(r/'tools/probe_map_resource_lookup.py').read_text(encoding='utf-8').split('\ncases=[]')[0];exec(compile(prefix,'native resource prerequisites','exec'))
root=0x40008000;local=0x40008100;query=0x40008200;temporary=0x4000e000;fallback=0x4000f000
write32(0x2d8de60,1);u.mem_write(0x2d8de48,bytes(24));write32(0x2d8de5c,15)
cases=[]
fixtures=[('no-context',[],{}),('first-priority',[{'FOWTexture':'first/FOWTexture'},{'FOWTexture':'second/FOWTexture'}],{}),('second-context',[{}, {'FOWTexture':'second/FOWTexture'}],{}),('empty-first',[{'FOWTexture':''},{'FOWTexture':'second/FOWTexture'}],{}),('parent-with-no-context',[],{'FOWTexture':'parent/FOWTexture'}),('parent-before-later-contains',[{}, {'FOWTexture':'second/FOWTexture'}],{'FOWTexture':'parent/FOWTexture'}),('parent-fallback',[{}],{'FOWTexture':'parent/FOWTexture'}),('default-texture',[{'DefaultFogOfWarOverlay.dds':'Data/Shaders/TEXTURE/DefaultFogOfWarOverlay.dds'}],{})]
for name,contexts,parent_entries in fixtures:
 for key in ['FOWTexture','DefaultFogOfWarOverlay.dds','missing.dds']:
  cursor=0x40008300;provider(fallback,parent_entries);provider(root,{f'context{i}':'' for i in range(len(contexts))},fallback if parent_entries else 0);write32(root,0x10d62c8)
  head=read32(root+8)
  def nodes(node):
   if node==head:return []
   return nodes(read32(node))+[node]+nodes(read32(node+8))
  for node,entries in zip(nodes(read32(head+4)),contexts):
   provider(temporary,entries);u.mem_write(node+0x28,bytes(16));write32(node+0x28,read32(temporary+8))
  chain=0
  for i in reversed(range(len(contexts))):
   at=cursor;cursor+=0x100;u.mem_write(at,bytes(32));write32(at,chain);sso(at+4,f'context{i}');chain=at
  write32(0x2d78f20,chain);sso(query,key)
  invoke(0x904ec0,root,struct.pack('<I',query));present=bool(u.reg_read(UC_X86_REG_EAX)&255)
  invoke(0x904cd0,root,struct.pack('<I',query));resolved=text(u.reg_read(UC_X86_REG_EAX))
  expected=next((entries[key] for entries in contexts if entries.get(key)),parent_entries.get(key,''));exists=bool(contexts) and any(key in entries or key in parent_entries for entries in contexts)
  assert present==exists and resolved==expected,(name,key,present,resolved,expected,exists)
  # Original setter binds the actual per-map provider to this derived search provider.
  provider(local,{'terrain.ini':'Levels/Map10/terrain.ini'});invoke(0x905000,local,struct.pack('<I',root));assert read32(local+0x10)==root
  invoke(0x90a4a0,local,struct.pack('<I',query));assert bool(u.reg_read(UC_X86_REG_EAX)&255)==present
  invoke(0x90a480,local,struct.pack('<I',query));assert text(u.reg_read(UC_X86_REG_EAX))==resolved
  cases.append(dict(name=name,contexts=contexts,parent=parent_entries,key=key,present=present,resolved=resolved,map_parent_setter_verified=True))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,cases=cases,native_addresses=len(visited),methods={'path':'0x904CD0','exists':'0x904EC0','parent_setter':'0x905000','search_vtable':'0x10D62C8'},limits=['Original derived provider cached-context lookup, native string/tree searches, chain traversal and basic-provider delegation execute. Explicit cached tables and linked search contexts supplied.','Search-context producer2D78F20, cold cache insertion/enumeration and actual per-map/global constructor remain open. Diagnostic context order/paths are not inferred production selections.','Native contains ignores parent when search-context list is empty; path getter still falls back to parent. Empty context path skipped by path getter while contains remains true.','Lazy global empty-string initialization bypassed with original layout; no file/lookup/string comparison adapters.'])
(r/'data/4.20/search_resource_provider_contract.json').write_text(json.dumps(proof,indent=2)+'\n');print(json.dumps(dict(cases=len(cases),native_addresses=len(visited))))
