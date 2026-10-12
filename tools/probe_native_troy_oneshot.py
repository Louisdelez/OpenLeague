"""Whole93EE30 one-shot dispatch with active raw descriptors and owner lookup."""
from pathlib import Path
import json,datetime,ctypes,shutil,itertools
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_troy_resume.py').read_text(encoding='utf-8').split('\npatterns=')[0]
setup=setup.replace("'0x93ed60<=a<0x93ef76'", "'0x93ee30<=a<0x93eedc'")
setup=setup.replace('0x17c if primary else 0x194','0x14c if primary else 0x164')
exec(compile(setup,'oneshot setup','exec'))
time_profiles=[(0,0),(bits(.5),0),(bits(1.),0),(0x3f7fffff,0),(bits(-1.),0),(0x7f800000,0),(0xff800000,0),(0x7fa01234,0),(0x7f800000,0x7f800000),(1,0)]
cases=[];returns=[0,0]
for index,(flags,descriptors,(time,start),(present,eligibility)) in enumerate(itertools.product([0,1,2,0x20,0x80,0xff],[(0,0),(1,0),(0,1),(1,1)],time_profiles,[(False,0),(True,0),(True,1),(True,255)])):
 captures=[];position=[0x7fa01234,0x80000000,0x3f800000]
 for corrected in [False,True]:
  enabled=corrected;events=[];u.mem_write(actor,b'\0'*0x200);u.mem_write(wrapper,b'\0'*0x200);write32(actor,engine);write32(actor+4,wrapper);write32(engine+4,audio_vtable)
  for name,offset in [('primary',0x18),('secondary',0x1c)]:write32(audio_vtable+offset,entries[name])
  write32(wrapper+0xc8,owner if present else 0);write32(owner,owner_vtable);write32(owner_vtable+0x24,entries['eligible']);write32(owner_vtable+0x50,entries['owner_id'])
  u.mem_write(actor+0x1dc,bytes([flags]));write32(actor+0xa8,start);write32(actor+0xb0,time);u.mem_write(actor+0x90,b''.join(v.to_bytes(4,'little') for v in position))
  for n,offset in enumerate([0x14c,0x164]):u.mem_write(actor+offset,bytes([0x41+n])*24);write32(actor+offset+16,descriptors[n])
  sp=stack+0x8000;write32(sp,end);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_ECX,actor);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff);u.reg_write(UC_X86_REG_MXCSR,0x1f80)
  u.emu_start(0x93ee30,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_ESP)==sp+4 and restore is None
  captures.append({'flags':u.mem_read(actor+0x1dc,1)[0],'events':events.copy(),'time':hex(read32(actor+0xb0))})
 cases.append({'flags':flags,'descriptors':list(descriptors),'time':hex(time),'start':hex(start),'position':[hex(v) for v in position],'owner_present':present,'eligibility':eligibility,'emulator':captures[0],'cpu':captures[1]})
for addr in blocks:kernel.VirtualFree(addr,0,0x8000)
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'entry':'93EE30','cases':cases,'actual_cpu_sse_operations':cpu_calls,'emulator_cpu_case_disagreements':sum(c['emulator']!=c['cpu'] for c in cases),'adapters':['Whole93EE30 runs, with actual93FAE0 owner helper and explicit virtual24/50 owner endpoints. Audio virtual18/1C capture raw24-byte descriptors, positions, elapsed times and owner id.','Audio endpoints are capture adapters; actual playback not proven. Native ret and restored stack checked. Independent actual CPU SSE and x87 copy supplied.'],'limits':['Concrete audio playback and owner endpoint producers unqualified. Full frame/rendition unintegrated.','Default masked FP controls only; endpoint callbacks do not mutate actor state.']}
(r/'data/4.20/troy_oneshot_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'cases':len(cases),'sse':cpu_calls,'disagreements':proof['emulator_cpu_case_disagreements']}))
