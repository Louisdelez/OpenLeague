from pathlib import Path
import shutil
r=Path('E:/OpenLeague')
__file__=str(r/'tools/qualify_announcer_object_lookup.py')
s=Path('E:/mapslol3v3/qualify_announcer_object_lookup.py').read_text(encoding='utf-8')
s=s.replace('def capture(uc,a,size,user):assert 0x400000<=a<0x1000000,hex(a)', 'def capture(uc,a,size,user):\n if a==0x5c6867:hashes.append(u.reg_read(UC_X86_REG_EDX))\n assert 0x400000<=a<0x1000000,hex(a)')
s=s.replace('selected=[];sp=','selected=[];hashes=[];sp=')
s=s.replace("cases.append({'layout':index,'key':key,'bucket':selected[0],'result':result})", "assert hashes==[native_hash_model(key)];cases.append({'layout':index,'key':key,'bucket':selected[0],'hash':hashes[0],'result':result})")
s=s.replace('audio_announcer_object_lookup_contract.json','audio_announcer_object_hash_contract.json')
exec(compile(s,__file__,'exec'))
shutil.copy2(Path('E:/mapslol3v3/qualify_announcer_object_hash.py'),r/'tools/qualify_announcer_object_hash.py')
