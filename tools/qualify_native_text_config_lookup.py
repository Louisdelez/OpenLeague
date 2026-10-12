from pathlib import Path
import json,hashlib,datetime,shutil,itertools
r=Path('E:/OpenLeague');exec(compile((r/'tools/probe_native_environment_macros.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'native text lookup prerequisites','exec'))
u.mem_map(0x41000000,0x800000);heap=0x41000000;owner=vector+0x8000;sentinel=vector+0x9000;buckets=vector+0xa000;output=vector+0xb000;keyptr=vector+0xc000
def allocate(data):
 global heap
 p=heap;heap+=(len(data)+32+15)//16*16;assert heap<0x41800000;u.mem_write(p,data+b'\0');return p
def ssoread(p):return bytes(u.mem_read(read(p) if read(p+20)>=16 else p,read(p+16)))
def ssowrite(p,data):
 u.mem_write(p,b'\0'*24)
 if len(data)<16:u.mem_write(p,data+b'\0');w(p+20,15)
 else:w(p,allocate(data));w(p+20,max(31,len(data)))
 w(p+16,len(data))
def hook_lookup(uc,a,size,user):
 sp=uc.reg_read(UC_X86_REG_ESP);this=uc.reg_read(UC_X86_REG_ECX)
 if a==0x564af0:
  src=read(sp+4);start=read(sp+8);count=read(sp+12);data=ssoread(src);ssowrite(this,data[start:] if count==0xffffffff else data[start:start+count]);finish(this,12);return
 if a==0x564c20:ssowrite(this,bytes(u.mem_read(read(sp+4),read(sp+8))));finish(this,8);return
 assert any(begin<=a<stop for begin,stop in [(0x8ae0e0,0x8ae17a),(0x5c6830,0x5c68d8),(0xc9b47b,0xc9b487)]),hex(a);visited.add(a)
u.hook_add(unicorn.UC_HOOK_CODE,hook_lookup)
def bucket_index(key):
 signed=key^0xdeadbeef;signed=signed if signed<0x80000000 else signed-0x100000000
 quotient=abs(signed)//127773*(-1 if signed<0 else 1);remainder=signed-quotient*127773
 state=(remainder*16807-quotient*2836)&0xffffffff
 if state&0x80000000:state=(state+0x7fffffff)&0xffffffff
 return state&7
def populate(entries):
 global heap
 heap=0x41000000;u.mem_write(owner,b'\0'*32);u.mem_write(sentinel,b'\0'*40);w(owner+4,sentinel);w(owner+12,buckets);w(owner+24,7);w(owner+28,8)
 groups=[[] for _ in range(8)];slots={}
 for row in sorted(entries,key=lambda row:row['hash']):
  p=allocate(b'\0'*40);w(p+8,row['hash']);ssowrite(p+12,row['value'].encode('latin1'));groups[bucket_index(row['hash'])].append(p);slots[row['hash']]=p
 linear=[p for group in groups for p in group]
 for i,p in enumerate(linear):w(p,linear[i+1] if i+1<len(linear) else sentinel);w(p+4,linear[i-1] if i else sentinel)
 w(sentinel,linear[0] if linear else sentinel);w(sentinel+4,linear[-1] if linear else sentinel)
 for i,group in enumerate(groups):w(buckets+i*8,group[0] if group else sentinel);w(buckets+i*8+4,group[-1] if group else sentinel)
 return slots
def run(key,fallback,initial,alias,slots):
 destination=slots[key]+12 if alias else output
 if not alias:ssowrite(output,initial)
 default_ptr=0 if fallback is None else allocate(fallback);w(keyptr,key);w(stack,end)
 for i,v in enumerate([destination,0,0,key,default_ptr,0]):w(stack+4+i*4,v)
 u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,owner);u.emu_start(0x8ae0e0,end,count=100000)
 assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_ESP)==stack+28
 return bool(u.reg_read(UC_X86_REG_EAX)&255),ssoread(destination)
proof_parser=json.loads((r/'data/4.20/native_game_cfg_parser_contract.json').read_text(encoding='utf-8'));original=proof_parser['actual_game_cfg']['result']['entries']
synthetic=[dict(hash=key,value=value) for key,value in zip([0,1,2,3,7,8,127,128,2147483647,2147483648,4294967294,4294967295],['','0','true','three\0tail','long original value for heap storage','4','-3','x','5','6','7','8'])]
tables=[];cases=[]
for table_name,entries in [('original_defaults',original),('synthetic_boundaries',synthetic)]:
 slots=populate(entries);values={row['hash']:row['value'].encode('latin1') for row in entries};table_index=len(tables);tables.append(dict(name=table_name,entries=[dict(hash=row['hash'],value=row['value']) for row in entries]))
 missing=[k for k in [0,1,9,123,2147483647,2147483648,4294967295,0xdeadbeef] if k not in slots]
 for key,fallback,initial in itertools.product(list(slots)+missing,[None,b'',b'fallback-long-value\0ignored'],[b'',b'previous heap value should be replaced']):
  found,value=run(key,fallback,initial,False,slots);expected=values.get(key,b'' if fallback is None else fallback.split(b'\0',1)[0]);assert found==(key in slots) and value==expected,(table_name,key,found)
  cases.append(dict(table=table_index,hash=key,fallback=None if fallback is None else list(fallback),initial=list(initial),alias=False,found=found,value=list(value)))
 for key in slots:
  found,value=run(key,None,b'',True,slots);assert found and value==values[key];cases.append(dict(table=table_index,hash=key,fallback=None,initial=list(value),alias=True,found=found,value=list(value)))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),lookup='0x8ae0e0',map_find='0x5c6830',native_addresses=len(visited),case_count=len(cases),tables=tables,cases=cases,adapters=['Native eight-bucket list storage/links/contents supplied from recovered default entries and controlled boundary keys; allocation/insertion/resizing not executed.','Standard string copy/assign boundaries adapted; original lookup, hash-bucket arithmetic, ordered traversal, found/fallback/alias branches and fallback C-string length execute.'],limits=['Text lookup and map search scope; original cache, file population, user path, typed reader and full runtime settings remain open.','Only supplied valid eight-bucket layout qualified; full insertion/resizing/lifetime and alternate encodings remain unqualified.'])
(r/'data/4.20/native_text_config_lookup_contract.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(cases=len(cases),native_addresses=len(visited),original_default_entries=len(original))))
