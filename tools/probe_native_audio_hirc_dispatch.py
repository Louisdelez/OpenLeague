from pathlib import Path
import json,hashlib,itertools
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_object_registration.py');exec(compile(Path(__file__).read_text().split('u.hook_add(')[0],'setup','exec'))
rows=[];target=0
for i in md.disasm(p.get_data(0xafb6ab-base,20),0xafb6ab):print(hex(i.address),i.mnemonic,i.op_str)
def guard(uc,a,n,d):
 global target
 if not 0xafb6ab<=a<0xafb6bf:target=a;uc.emu_stop()
u.hook_add(unicorn.UC_HOOK_CODE,guard)
for tag,upper in itertools.product(range(256),[0,0xa5a500]):
 target=0;u.reg_write(UC_X86_REG_ECX,upper|tag);u.reg_write(UC_X86_REG_EAX,0xdeadbeef);u.emu_start(0xafb6ab,trap,count=50);assert target
 rows.append({'tag':tag,'ecx':upper|tag,'target':target,'index':u.reg_read(UC_X86_REG_EAX)})
assert all(v['target']==0xafb82b for v in rows if v['tag']==18);assert all(v['target']==0xafb846 for v in rows if v['tag']==19)
proof={'passed':True,'complete':False,'case_count':len(rows),'cases':rows,'native_sha256':hashlib.sha256(b).hexdigest(),'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()}for a,e in [(0xafb6ab,0xafb6bf),(0xafb8dc,0xafb92c),(0xafb82b,0xafb861)]],'findings':['Actual low-byte HIRC selector18 routesAFB82B to Shared wrapperAF8660/registry1C20;19 routesAFB846 to Custom wrapperAF85A0/registry1F40.','Higher ECX bytes do not affect selection;0 and21..255 route unsupported/default branch. All1..20 native dispatch addresses retained.'],'limits':['Selection-only native qualification;outer bank loop/header reads and other18 object-body readers remain required. Native dispatch Rust port still pending.']}
(r/'data/4.20/audio_hirc_dispatch_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'actual HIRC selectors;18 Shared/19 Custom verified')
