from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_game_clock.py').read_text().split('\nrows=[]')[0],'setup','exec'))
voice=vector+0x10000;source=vector+0x11000;decoder=vector+0x12000
allocs=[];calls=[]
def hook(uc,a,size,user):
 if a==0xada670:
  sp=uc.reg_read(UC_X86_REG_ESP);n=read(sp+8);allocs.append(n);u.mem_write(decoder,bytes(1024));finish(decoder)
 elif a==0xb093c0:
  sp=uc.reg_read(UC_X86_REG_ESP);calls.append(dict(kind='plugin',voice=read(sp+4),source_kind=read(sp+8),plugin=read(sp+12)));finish(0)
 elif a==0xaecee0:
  calls.append(dict(kind='failure',voice=uc.reg_read(UC_X86_REG_ECX)));finish(0,4)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
rows=[]
expected={(2,0):84,(2,1):84,(2,2):84,(2,3):84,(1,1):104,(3,1):64,(1,2):392,(3,2):72}
for kind,codec in itertools.product([0,1,2,3,4,31],[0,1,2,3]):
 u.mem_write(voice,bytes(424));u.mem_write(source,bytes(32));w(voice+0x64,source);w(source+0x10,kind<<2);w(source+0x18,(codec<<16)|0x1234);allocs.clear();calls.clear()
 w(stack,end);w(stack+4,voice);u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(0xb27d40,end,count=5000);assert u.reg_read(UC_X86_REG_EIP)==end
 result=u.reg_read(UC_X86_REG_EAX)
 if (kind,codec) in expected:
  assert allocs==[expected[kind,codec]] and result==decoder and not calls
  assert read(decoder+0xc)==voice
 else:
  assert result==0 and not allocs
  assert calls[-1]['kind']=='failure'
 rows.append(dict(source_kind=kind,codec_high16=codec,plugin_id=(codec<<16)|0x1234,allocation_sizes=allocs.copy(),vtable=read(decoder) if result else None,calls=calls.copy()))
proof=dict(passed=True,native_sha256=hashlib.sha256(raw).hexdigest(),case_count=len(rows),cases=rows,limits=['Actual built-in constructors executed; source kind and plugin IDs supplied as raw fields, semantic codec names not inferred.','External plugin factory intercepted to return null; failure notification captured. No media parsing, decoder initialization or playback.'])
(r/'data/4.20/audio_decoder_factory.json').write_text(json.dumps(proof,indent=2)+'\n');print('PASS',len(rows),'native decoder selection cases')
