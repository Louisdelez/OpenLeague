from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_audio_native_history.py').read_text().split('\nrows=[]')[0],'setup','exec'))
tls=vector+0x11000;visited=vector+0x12000;allowed=vector+0x13000
u.hook_add(unicorn.UC_HOOK_CODE,lambda uc,a,n,d:value_return(tls,0),begin=0xca9191,end=0xca9191)
def memset(uc,a,n,d):
 sp=u.reg_read(UC_X86_REG_ESP);dest=read(sp+4);value=read(sp+8)&255;size=read(sp+12)
 u.mem_write(dest,bytes([value])*size);value_return(dest,0)
u.hook_add(unicorn.UC_HOOK_CODE,memset,begin=0xca1d00,end=0xca1d00)
rows=[]
for count in [2,3,7]:
 weights=[1+3*i for i in range(count)]
 for mode in [0,1]:
  for weighted in [False,True]:
   for avoid in sorted(set([0,1,count-1,count,count+3])):
    u.mem_write(history,b'\0'*0x40);u.mem_write(entries,b'\0'*256);u.mem_write(bits,b'\0'*16);u.mem_write(visited,b'\0'*16)
    u.mem_write(container+0x8e,struct.pack('<H',avoid));u.mem_write(container+0x90,bytes([mode<<4,8 if weighted else 0]))
    w(history+4,sum(weights));w(history+8,sum(weights));u.mem_write(history+0xc,struct.pack('<HH',count,count))
    w(history+0x10,entries);w(history+0x18,64);w(history+0x1c,visited);w(history+0x20,bits);w(tls+0x14,17)
    steps=[];prior=None
    for step in range(count*8):
     w(stack,end);u.mem_write(stack+4,struct.pack('<III',history,allowed,0));u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,container)
     u.emu_start(0xb1e1e0,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end
     selected=u.reg_read(UC_X86_REG_EAX)&65535;assert selected<count and u.mem_read(allowed,1)==b'\1'
     if avoid or mode:assert selected!=prior
     prior=selected;length=read(history+0x14)
     recent=list(struct.unpack('<'+'H'*length,u.mem_read(entries,2*length))) if length else []
     steps.append(dict(selected=selected,rng_state=read(tls+0x14),recent=recent,remaining=struct.unpack('<HH',u.mem_read(history+0xc,4)),weight=read(history+8),visited=int.from_bytes(u.mem_read(visited,2),'little')))
    rows.append(dict(count=count,mode=mode,weighted=weighted,avoid=avoid,weights=weights,steps=steps))
proof=dict(passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entry='0xb1e1e0',cases=rows,limits=['Full selection function executed including native random, visited bitset, FIFO and cycle reset.','Playlist count/weight, CRT TLS lookup and memset adapted; history buffers preallocated.','Supplied positive weights and seed17; bank flag mapping, ownership and zero weights not yet qualified. No audible output.'])
(r/'data/4.20/audio_native_selection_cycles.json').write_text(json.dumps(proof,indent=2)+'\n')
print(json.dumps(dict(passed=True,sequences=len(rows),selections=sum(len(x['steps']) for x in rows))))
