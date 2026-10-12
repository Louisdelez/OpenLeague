from pathlib import Path
import json,struct,datetime
r=Path('E:/OpenLeague');setup=(r/'tools/probe_fow_source_release.py').read_text(encoding='utf-8').split('\ncases=[]')[0];exec(compile(setup,'native postprocess driver prerequisites','exec'))
driver=heap+0x1d000;renderer=heap+0x1e000;write32(0x2d78a34,driver);write32(0x2d79078,renderer);trace=[]
def calls(uc,a,size,user):
 names={0x982b40:'renderer_reset',0x6b5310:'begin',0x6b5080:'upscaled_upload',0x6b4f70:'direct_upload',0x6b5450:'fade',0x6b55e0:'blur',0x6b53b0:'end'}
 if a in names:
  name=names[a];top=u.reg_read(UC_X86_REG_ESP);event=dict(call=name,previous_bits=read32(driver+0x10))
  if name in ['upscaled_upload','direct_upload','fade']:event['argument_bits']=read32(top+4)
  trace.append(event);finish(pop=4 if name in ['upscaled_upload','direct_upload','fade'] else 0)
u.hook_add(unicorn.UC_HOOK_CODE,calls)
interval=struct.unpack('<f',u.mem_read(0x1138a84,4))[0];cases=[]
for upscale in [False,True]:
 for previous,now in [(0.,0.),(0.,interval),(0.,struct.unpack('<f',struct.pack('<I',read32(0x1138a84)+1))[0]),(0.,.1),(0.,23.),(.5,.52),(.5,.6)]:
  trace.clear();u.mem_write(driver,bytes(0x28));u.mem_write(driver+0x19,bytes([int(upscale)]));u.mem_write(driver+0x10,struct.pack('<f',previous));invoke(0x6b57a0,0,struct.pack('<f',now))
  elapsed=struct.unpack('<f',struct.pack('<f',now-previous))[0];due=elapsed>interval;expected=['renderer_reset','begin','upscaled_upload' if upscale else 'direct_upload']+(['fade','blur'] if due else [])+['end'];assert [e['call'] for e in trace]==expected
  if due:
   assert next(e for e in trace if e['call']=='blur')['previous_bits']==struct.unpack('<I',struct.pack('<f',previous))[0]
  else:assert read32(driver+0x10)==struct.unpack('<I',struct.pack('<f',previous))[0]
  cases.append(dict(upscale=upscale,previous=previous,now=now,due=due,new_previous_bits=read32(driver+0x10),trace=list(trace)))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=digest,entry='0x6b57a0',native_addresses=len({a for a in visited if 0x6b57a0<=a<0x6b5843}),interval_bits=read32(0x1138a84),cases=cases,limits=['Original full driver control flow and original x87 remainder/timestamp commit execute; GPU begin/upload/fade/blur/end calls are explicit tracing adapters.','Confirms fade then blur then timestamp commit, and both uploaded/direct branches; original texture swap internals and D3D draw/device are not executed.','Does not prove original GPU result, complete constructor/graphics context or original-frame alignment for live Bevy render loop.'])
(r/'data/4.20/fow_postprocess_driver_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(dict(cases=len(cases),native_addresses=proof['native_addresses'],interval=interval)))
