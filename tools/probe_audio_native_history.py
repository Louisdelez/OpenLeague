from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_game_clock.py').read_text().split('\nrows=[]')[0],'setup','exec'))
container=vector+0xa000;history=vector+0xb000;playlist=vector+0xc000;table=vector+0xd000;entries=vector+0xe000;bits=vector+0xf000
countfn=vector+0x10000;weightfn=countfn+0x20
w(container+0x68,playlist);w(playlist,table);w(table+0xc,countfn);w(table+0x28,weightfn)
def value_return(value,pop):
 sp=u.reg_read(UC_X86_REG_ESP);ret=read(sp);u.reg_write(UC_X86_REG_EAX,value);u.reg_write(UC_X86_REG_ESP,sp+4+pop);u.reg_write(UC_X86_REG_EIP,ret)
def accessor(uc,a,n,d):
 if a==countfn:value_return(len(weights),0)
 else:value_return(weights[read(u.reg_read(UC_X86_REG_ESP)+4)],4)
u.hook_add(unicorn.UC_HOOK_CODE,accessor,begin=countfn,end=countfn)
u.hook_add(unicorn.UC_HOOK_CODE,accessor,begin=weightfn,end=weightfn)
rows=[]
for count in [2,3,7]:
 weights=[1+3*i for i in range(count)]
 for avoid in sorted(set([0,1,count-1,count,count+3])):
  u.mem_write(history,b'\0'*0x40);u.mem_write(entries,b'\0'*256);u.mem_write(bits,b'\0'*16)
  u.mem_write(container+0x8e,struct.pack('<H',avoid));w(history+8,sum(weights));u.mem_write(history+0xc,struct.pack('<H',count))
  w(history+0x10,entries);w(history+0x18,64);w(history+0x20,bits)
  recent=[];steps=[];limit=min(avoid,count-1)
  for step in range(24):
   eligible=[i for i in range(count) if i not in recent];selected=eligible[step%len(eligible)]
   call(0xb1ea80,container,struct.pack('<II',history,selected));assert u.reg_read(UC_X86_REG_EAX)==1
   if avoid:recent=(recent+[selected])[-limit:]
   length=read(history+0x14);actual=list(struct.unpack('<'+'H'*length,u.mem_read(entries,2*length))) if length else []
   mask=int.from_bytes(u.mem_read(bits,2),'little');remaining=struct.unpack('<H',u.mem_read(history+0xc,2))[0]
   assert actual==recent and mask==sum(1<<i for i in recent)
   assert remaining==count-len(recent) and read(history+8)==sum(weights[i] for i in range(count) if i not in recent)
   steps.append(dict(selected=selected,recent=actual,eligible_count=remaining,eligible_weight=read(history+8)))
  rows.append(dict(count=count,avoid=avoid,weights=weights,steps=steps))
proof=dict(passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entry='0xb1ea80',cases=rows,limits=['Playlist count and weight virtual accessors adapted to fixture arrays; native history and bitset mutations execute unchanged.','History capacity preallocated64; allocation failure not covered. Only valid non-recent selection inputs.','This is standard-random history update, not shuffle bag reset, global/local ownership, or full event playback.'])
(r/'data/4.20/audio_native_history_contract.json').write_text(json.dumps(proof,indent=2)+'\n')
print(json.dumps(dict(passed=True,sequences=len(rows),steps=sum(len(x['steps']) for x in rows))))
