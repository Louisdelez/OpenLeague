from pathlib import Path
import json,itertools,hashlib
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text().split('\nu.hook_add(')[0],'setup','exec'))
locale=vector+0x6000;conv=vector+0x6100;time=vector+0x7000;counters=vector+0x8000;payload=vector+0x9000
regions=[];calls=[];freed=[];access=set();collect=True
snapshot=lambda:{n:bytes(u.mem_read(a,z)).hex()for n,a,z in regions}
def ref(j):return payload+j*0x200
def counter(j):return counters+j*32
def hook(uc,a,z,user):
 if a==0xc98528:
  sp=u.reg_read(UC_X86_REG_ESP);p=read(sp+4);calls.append({'kind':'free','reference':p,'at_call':snapshot()});freed.append(p);finish(0);return
 assert base<=a<base+len(image),hex(a)
def memory(uc,kind,a,z,value,user):
 if collect and base<=a<base+len(image):access.update(range(a,a+z))
u.hook_add(unicorn.UC_HOOK_CODE,hook);u.hook_add(unicorn.UC_HOOK_MEM_READ|unicorn.UC_HOOK_MEM_WRITE,memory)
def run(conversion,count,strings,ctype,custom_time):
 u.mem_write(locale,bytes(0xb8));u.mem_write(conv,bytes(0x60));u.mem_write(time,bytes(0x200));u.mem_write(counters,bytes(22*32));u.mem_write(payload,bytes([0xa5])*31*0x200)
 for j in range(22):w(counter(j),count)
 w(locale+0x84,0 if conversion=='null'else 0x1222558 if conversion=='static'else conv)
 if conversion=='defaults':u.mem_write(conv,bytes(u.mem_read(0x1222558,0x60)))
 elif conversion=='heap':
  for j,offset in enumerate([0,4,8,0xc,0x10,0x14,0x18,0x1c,0x20,0x24,0x30,0x34,0x38,0x3c,0x40,0x44,0x48,0x4c,0x50,0x54,0x58,0x5c]):w(conv+offset,ref(j))
 w(locale+0x78,counter(0));w(locale+0x80,counter(1));w(locale+0x7c,counter(2));w(locale+0x88,counter(3)if ctype else 0)
 w(locale+0x8c,ref(22)+0xfe);w(locale+0x94,ref(23)+0x80);w(locale+0x98,ref(24)+0x80)
 w(locale+0x9c,time if custom_time else 0x12230d8);w(time+0xb0,count)
 for j in range(6):
  active=strings=='all'or(strings=='alternating'and j%2==0);a=locale+0x1c+j*16;w(a-8,0x11220000+j if active else 0x12230d4);w(a,counter(4+j));w(a-12,int(active));w(a-4,counter(10+j));w(locale+0xa0+j*4,ref(25+j))
 calls.clear();freed.clear();before=snapshot();w(stack,end);w(stack+4,locale);u.reg_write(UC_X86_REG_ESP,stack);u.emu_start(0xca8a15,end,count=20000);assert u.reg_read(UC_X86_REG_EIP)==end
 return {'conversion':conversion,'count':count,'strings':strings,'ctype':ctype,'custom_time':custom_time,'before':before,'after':snapshot(),'calls':list(calls),'freed':list(freed),'terminal':True}
for args in itertools.product(['null','static','defaults','heap'],[0,1],['none','all','alternating'],[False,True],[False,True]):run(*args)
collect=False;intervals=[]
for a in sorted({v&~3 for v in access}):
 if intervals and a==intervals[-1][1]:intervals[-1][1]=a+4
 else:intervals.append([a,a+4])
intervals.extend([(locale,locale+0xb8),(conv,conv+0x60),(time,time+0x200),(counters,counters+22*32),(payload,payload+31*0x200)]);merged=[]
for a,b in sorted(intervals,key=lambda v:v[0]):
 if merged and a<=merged[-1][1]:merged[-1][1]=max(b,merged[-1][1])
 else:merged.append([a,b])
regions=[(f'bank_{a:08x}',a,b-a)for a,b in merged];rows=[run(*args)for args in itertools.product(['null','static','defaults','heap'],[0,1],['none','all','alternating'],[False,True],[False,True])]
p={'passed':True,'complete':False,'case_count':len(rows),'terminal_case_count':len(rows),'native_sha256':hashlib.sha256(raw).hexdigest(),'entry':'0xca8a15','helpers':['0xcc7e5a','0xcc82f7','0xcc8564'],'regions':[{'name':n,'reference':a,'size':z}for n,a,z in regions],'cases':rows,'limits':['Actual CA8A15 locale destructor and all3 embedded conversion/time free helpers execute; only C98528 allocator free boundary supplied. NULL/static/copied defaults/dynamic conversion pointers, live/zero refcounts, conditional string groups, ctype original FE/80 interior-pointer rebasing and static/custom time records captured with all call-entry/final banks.','Controlled locale structures and passive post-free snapshots supplied. All dynamic conversion/ctype/string payloads have distinct allocation identities; no duplicate-free or alias scenario claimed. Custom time payload pointers NULL, so original free(NULL) order observed. Thread destructor integration and normal locale producers, actual allocator, concurrency and SEH remain unqualified. Rust replay pending.']}
(r/'data/4.20/audio_crt_custom_locale_destruction_preparation.json').write_text(json.dumps(p,indent=2)+'\n',encoding='utf-8')
(r/'tools/probe_native_audio_crt_custom_locale_destruction.py').write_text(Path(__file__).read_text(encoding='utf-8'),encoding='utf-8')
print('Captured',len(rows),'actual locale destructor and all3 real nested free helpers;',len(regions),'canonical regions')
