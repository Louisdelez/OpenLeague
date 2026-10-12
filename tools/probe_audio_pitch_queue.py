from pathlib import Path
r=Path('E:/OpenLeague');s=(r/'tools/probe_audio_pitch_control_consumer.py').read_text(encoding='utf-8-sig').split('rows=[]')[0]
a=s.index(' if a==0xaf36b0:');z=s.index(' if a==0xaed710:',a);s=s[:a]+''' if a==trap+0x300:
  calls.append(dict(kind='virtual2c'));finish();return
 if a==trap+0x310:
  sp=u.reg_read(UC_X86_REG_ESP);calls.append(dict(kind='virtual10',value_bits=read(sp+4)));finish(pop=4);return
'''+s[z:]
exec(compile(s,'queue setup','exec'))
queue=0x14a7a7c;storage=heap+0x700;nodevt=heap+0x800;rows=[]
for cents in [-1200.,-200.,0.,200.,1200.]:
 for value in [0.,1.,2500.]:
  calls.clear();u.mem_write(heap,bytes(0x1000));u.mem_write(queue,bytes(0x20));w(queue+8,storage);w(queue+12,1);w(queue+16,1);w(queue+24,storage)
  w(heap,vt);w(heap+0xc,node);u.mem_write(heap+0x10,b'\1');w(vt+0x30,getter);w(node,nodevt);w(nodevt+0x2c,trap+0x300);w(nodevt+0x10,trap+0x310);u.mem_write(node+0x12c,b'\x20');w(node+0x48,123)
  u.mem_write(node+0x80,struct.pack('<f',cents));u.mem_write(duration,struct.pack('<f',value))
  def run(entry,receiver):
   sp=stack+0x1800;w(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,receiver);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.emu_start(entry,end,count=3000);assert u.reg_read(UC_X86_REG_EIP)==end
  run(0xb27f20,heap)
  payload=list(struct.unpack('<4I',u.mem_read(storage+4,16)));assert payload[:3]==[node,3,0]
  assert read(queue)==storage and read(queue+4)==storage and read(queue+20)==1
  assert [c['kind'] for c in calls]==['notification']
  assert calls[0]['args'][2]==payload[3]
  run(0xaf3aa0,0)
  assert [c['kind'] for c in calls]==['notification','virtual2c','virtual10'];assert calls[-1]['value_bits']==payload[3]
  assert read(queue)==0 and read(queue+4)==0 and read(queue+8)==storage and read(queue+20)==0
  assert u.mem_read(node+0x12d,1)[0]&1
  rows.append(dict(cents=cents,input=value,payload=payload,calls=list(calls),free_list_restored=True))
proof=dict(passed=True,complete=False,native_sha256=hashlib.sha256(b).hexdigest(),cases=rows,case_count=len(rows),entries=['0xb27f20','0xaee470','0xaf36b0','0xaf34d0','0xaf3aa0','0xaee720'],findings=['Original control3 enqueued in native pooled linked queue before callback delivery.','Original drain dispatches AEE720, sets node12Dbit0, invokes virtual2C then virtual10 with adjusted float, restores free node and clears queue/count.'],adapters=['One supplied preallocated queue node; allocator/full-queue paths excluded.','Virtual30 supplied input; virtual2C/10 captured; other pitch notification endpoints adapted as previous probe.'],limits=['Virtual callback implementations and value units not established. No PCM resampler/mixer or audible playback proof.'])
(r/'data/4.20/audio_pitch_queue_contract.json').write_text(json.dumps(proof,indent=2)+'\n')
print('PASS',len(rows),'native pitch enqueue/drain cases')
