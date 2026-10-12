from pathlib import Path
import json,hashlib,datetime,itertools,shutil
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'font-map lookup prerequisites','exec'))
manager=vector+0x6000;table=vector+0x7000;query_ref=vector+0x8000;query_str=vector+0x9000;stored_str=vector+0xa000
def h(name):
 value=0x1505
 for b in reversed(name):value=((value*33)^ (b+32 if 65<=b<=90 else b))&0xffffffff
 return value
def hook(uc,address,size,user):visited.add(address)
u.hook_add(unicorn.UC_HOOK_CODE,hook);w(0x14ae870,0);w(0x14ae664,0);cases=[]
for stored,requested,tag in itertools.product([None,b'$NormalFont',b'$normalfont',b'$NORMALFONT',b'$OtherFont'],[b'$NormalFont',b'$normalfont',b'$NORMALFONT',b'$MissingFont',b''],range(4)):
 u.mem_write(table,b'\xff'*0x200);w(table+4,7);w(manager,table)
 if stored is not None:
  bucket=h(stored)&7;slot=table+8+bucket*24;w(slot,0xffffffff);w(slot+4,bucket);w(slot+8,stored_str);w(stored_str,len(stored));w(stored_str+4,1);u.mem_write(stored_str+8,stored+b'\0')
 w(query_ref,query_str|tag);w(query_str,len(requested));w(query_str+4,1);u.mem_write(query_str+8,requested+b'\0');w(stack,end);w(stack+4,query_ref);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,manager);u.emu_start(0x9db990,end,count=1000);assert u.reg_read(UC_X86_REG_EIP)==end
 returned=u.reg_read(UC_X86_REG_EAX);matched=stored is not None and stored.lower()==requested.lower();assert returned==(slot+12 if matched else 0),(stored,requested,hex(returned))
 cases.append(dict(stored_hex=None if stored is None else stored.hex(),query_hex=requested.hex(),tag=tag,matched=matched,hash=h(requested)))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),case_count=len(cases),native_addresses=len(visited),cases=cases,limits=['Original9DB990/9DC0D0/CECED0/C9CF31lookup/hash/name comparison execute with supplied one-entry/eight-bucket table and string storage. ASCII case-insensitive name lookup.','Hash collision chains, insertion/replacement, non-ASCII/locale comparison, parser and fontmap lifetime remain separate.','Confirms name comparison for$NormalFontaliases; no active locale or GPU font loading qualification.'])
(r/'data/4.20/native_hud_font_map_lookup_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name);print(json.dumps(dict(passed=True,cases=len(cases),native_addresses=len(visited))))
