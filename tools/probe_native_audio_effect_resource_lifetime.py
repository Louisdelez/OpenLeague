from pathlib import Path
import itertools,json,hashlib
r=Path('E:/OpenLeague');setup=(r/'tools/probe_native_audio_effect_resource_tables.py').read_text(encoding='utf-8').split('\nrows=[];blob=')[0];setup=setup.replace('u.hook_add(unicorn.UC_HOOK_CODE,guard_all)','tables_hook=u.hook_add(unicorn.UC_HOOK_CODE,guard_all)');exec(compile(setup,'tables_setup','exec'))
u.mem_map(heap+0x10000,0x10000);registries=heap+0x10000;seed=heap+0x4000;put(0x14a7a08,'I',registries);put(registry,'III',0x810003,0xb3e260,0xb3df60);put(0x14a7abc,'II',registry,1)
regions.extend([(0xb25170,0xb25224),(0xb25230,0xb252e4),(0xafd490,0xafd4ac),(0xafd4b0,0xafd4b7),(0xaf9530,0xaf9593),(0xb252f0,0xb253f0),(0xaf6650,0xaf66bb),(0xb25010,0xb25100)])
locks={read(0xfa4424,'I')[0]:'lock',read(0xfa4428,'I')[0]:'unlock'};previous=guard_all;category=False
def guard_lifetime(uc,a,n,d):
 if a in locks:
  calls.append({'kind':locks[a],'category':category});ret(1,4);return
 previous(uc,a,n,d)
u.hook_del(tables_hook);u.hook_add(unicorn.UC_HOOK_CODE,guard_lifetime)
def invoke(entry,args=(),this=0):
 sp=stack+0x8000;put(sp,'I'*(len(args)+1),trap,*args);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,this);u.emu_start(entry,trap,count=20000);assert u.reg_read(UC_X86_REG_EIP)==trap;return u.reg_read(UC_X86_REG_EAX)
actual=json.loads((r/'data/4.20/audio_effect_actual_bank_contract.json').read_text(encoding='utf-8'));data=bytes.fromhex(actual['sources'][0]['payload']);u.mem_write(bank,data);rows=[]
tables=json.loads((r/'data/4.20/audio_effect_resource_tables_contract.json').read_text(encoding='utf-8'));nonempty=next(c['bank_payload']for c in tables['cases']if c['packet']=='both');payloads=[(v['key'],v['payload'])for v in actual['sources']]+[('controlled_nonempty',nonempty)]
for source_key,payload,category,id,pattern,fail_nth,seeded in ((k,v,c,i,p,f,s)for(k,v),c,i,p,f,s in itertools.product(payloads,[False,True],[0,193,0xffffffff],[0,0xa5,0xff],[0,1,2],[False,True])):
 data=bytes.fromhex(payload);u.mem_write(bank,data)
 calls.clear();allocations.clear();next_pointer=heap+0xc000;count_allocate=0;consumed=0;u.mem_write(registries,bytes(0x2600));table=registries+(0x1c20 if category else 0x1f40);other=registries+(0x1f40 if category else 0x1c20);bucket=id%193;put(table+0x31c,'I',7);put(other+0x31c,'I',42);put(other+24+bucket*4,'I',0x30004400)
 u.mem_write(seed,bytes([pattern])*48);put(seed,'IIIIII',0xff2380 if category else 0xff2394,0,id,7,0xffffffff,0);u.mem_write(seed+24,bytes(24));put(table+24+bucket*4,'I',seed if seeded else 0)
 if seeded:allocations.append({'reference':seed,'size':48,'freed':False})
 initial=[{**v,'raw':bytes(u.mem_read(v['reference'],v['size'])).hex()}for v in allocations];stages=[];reference=invoke(0xb25230 if category else 0xb25170,[id])
 def snapshot(stage,result):
  stages.append({'stage':stage,'result':result,'head':read(table+24+bucket*4,'I')[0],'count':read(table+0x31c,'I')[0],'other_head':read(other+24+bucket*4,'I')[0],'other_count':read(other+0x31c,'I')[0],'allocations':[{**v,'raw':bytes(u.mem_read(v['reference'],v['size'])).hex()}for v in allocations],'calls':list(calls)})
 snapshot('create',reference)
 if reference:
  snapshot('load',invoke(0xb254c0,[bank,len(data)],reference));assert read(reference+16,'I')[0]==(0xffffffff if fail_nth==2 else 0x810003);assert (read(reference+20,'I')[0]==0)==(fail_nth==2);snapshot('acquire',invoke(0xaf9530,[id],table));snapshot('release_retained',invoke(0xb25370 if category else 0xb252f0,(),reference));snapshot('release_zero',invoke(0xb25370 if category else 0xb252f0,(),reference))
 rows.append({'source_key':source_key,'category':category,'id':id,'pattern':pattern,'failure_nth':fail_nth,'seeded':seeded,'bank_payload':data.hex(),'initial_allocations':initial,'stages':stages})
proof={'passed':True,'complete':False,'case_count':len(rows),'cases':rows,'native_sha256':hashlib.sha256(b).hexdigest(),'source':actual['sources'][0],'regions':[{'start':hex(a),'end':hex(e),'sha256':hashlib.sha256(p.get_data(a-base,e-a)).hexdigest()}for a,e in regions],'adapters':['Only physical pool/virtual allocation/free,mutex and memcpy boundaries. Actual resource constructors/base constructor/register/lookup/retain/release-zero/unlink/destructors/parameter factory/Init/Term and bank reader execute.'],'findings':['48-byte resources initialize refs1,pluginFFFFFFFF,param/tables0 and exact vtable;prepend in one of2 registries of193 buckets under mutex.','Lookup retains first matching ID;release decrements under mutex. Zero release locks recursively for unlink,then destroys owned tables/parameter and physically frees48-byte object.','Init.bnk original Meter payload read after actual resource construction,including object or parameter allocation failure.'],'limits':['Both untouched actual Meter sources and one controlled nonempty media/RTPC payload qualified through destruction;other plugin classes and unusual/shared curve storage remain unqualified.','Selected forced constructor duplicate/head cases do not prove outer bank loader duplicate avoidance. Lock interfaces do not prove OS concurrent behavior.','Native HIRC dispatch/stream/bank-held references remain required;not normal voice/device/audio acceptance.']}
(r/'data/4.20/audio_effect_resource_lifetime_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('PASS',len(rows),'actual resource creation/registration/bank loading/retain/release-zero cases')
