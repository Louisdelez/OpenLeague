from pathlib import Path
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_game_clock.py').read_text().split('\nrows=[]')[0],'setup','exec'))
blend=vector+0xc000;outgoing=vector+0xc100;incoming=vector+0xc200
assert struct.unpack('<f',u.mem_read(0x1138960,4))[0]==0.
assert struct.unpack('<f',u.mem_read(0x1138c74,4))[0]==1.
def weight(address):
 entry=thunk+(0x100 if address==0x88d6d0 else 0x140)
 u.mem_write(entry,b'\xe8'+struct.pack('<i',address-entry-5)+b'\xd9\x1d'+struct.pack('<I',out)+b'\xc3')
 call(entry,blend)
 return struct.unpack('<f',u.mem_read(out,4))[0]
rows=[]
for has_out,has_in,duration,speed,elapsed in itertools.product([False,True],[False,True],[0.,.5,1.,2.],[0.,.5,1.,2.],[0.,.125,.5,1.,2.,4.]):
 for a in [blend,outgoing,incoming]:u.mem_write(a,b'\0'*0x40)
 w(blend+0xc,outgoing if has_out else 0);w(blend+0x10,incoming if has_in else 0);w(outgoing+4,1);w(incoming+4,1)
 for a,v in [(outgoing+0x14,duration),(incoming+0x10,duration),(blend+0x18,8.+elapsed),(blend+0x1c,8.),(blend+0x20,speed)]:u.mem_write(a,struct.pack('<f',v))
 wo=weight(0x88d6d0);wi=weight(0x88d750)
 eo=max(0.,1.-elapsed*speed/duration) if has_out and duration>0 else 0.
 ei=(min(1.,elapsed*speed/duration) if duration>0 else 1.) if has_in else 0.
 assert (wo,wi)==(eo,ei),(has_out,has_in,duration,speed,elapsed,wo,wi,eo,ei)
 call(0x88d640,blend);done=bool(u.reg_read(UC_X86_REG_EAX)&255)
 expected=(wo<=0.) if has_out else (wi>=1.) if has_in else False
 assert done==expected
 assert weight(0x88d6d0)==wo and weight(0x88d750)==wi
 rows.append(dict(outgoing=has_out,incoming=has_in,duration=duration,speed=speed,elapsed=elapsed,out_weight=wo,in_weight=wi,done=done))
proof=dict(passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entries=['0x88d6d0','0x88d750','0x88d640'],cases=rows,findings=['Outgoing max(0,1-elapsed*speed/duration); incoming min(1,elapsed*speed/duration), finite nonnegative profiles.','Completion prioritizes outgoing if present, otherwise incoming; no records returns false.','Zero duration completes immediately for present records; fixed elapsed and speed preserve weights on repeated evaluations.'],limits=['No full layer integration or queued replacement; negative/nonfinite values excluded.','Callers and blend setup still require qualification.'])
(r/'data/4.20/animation_blend_weights_contract.json').write_text(json.dumps(proof,indent=2)+'\n')
print('PASS native blend weights and completion',len(rows),'cases')
