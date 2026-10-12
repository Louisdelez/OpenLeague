from pathlib import Path
import itertools,json,shutil,re
r=Path('E:/OpenLeague');__file__=str(r/'tools/qualify_native_audio_legacy_paths.py')
source=Path(__file__).read_text(encoding='utf-8').split('hash_inputs=')[0].replace('u.hook_add(unicorn.UC_HOOK_CODE,hook)','')
exec(compile(source,__file__,'exec'))
u.mem_unmap(0,0x1000) # The shared CRT harness maps low storage; null-fault qualification must not.
actor=heap+0x1000;write32(actor+0x18b8,0)
def capture(uc,a,size,user):assert 0x400000<=a<0x1000000,hex(a)
def invalid(uc,access,address,size,value,user):faults.append({'address':address,'size':size,'access':access});return False
u.hook_add(unicorn.UC_HOOK_CODE,capture);u.hook_add(unicorn.UC_HOOK_MEM_INVALID,invalid);cases=[]
for entry,kind in itertools.product([0x6d4670,0x6d4700,0x6d46b0],[0,1,2,3,4,5,6,0xffffffff]):
 faults=[];write32(actor+0x2290,kind);sp=stack+0xc000;write32(sp,end);write32(sp+4,actor);u.reg_write(UC_X86_REG_ESP,sp)
 try:
  u.emu_start(entry,end,count=100000);assert u.reg_read(UC_X86_REG_EIP)==end;output=cbytes(u.reg_read(UC_X86_REG_EAX)).decode('ascii');error=None
 except unicorn.UcError as e:output=None;error=str(e)
 bypass=entry==0x6d46b0 and kind in [4,5]
 assert ((not faults and output=='nexus' and error is None) if bypass else (faults==[{'address':12,'size':4,'access':unicorn.UC_MEM_READ_UNMAPPED}] and output is None and error is not None)),(hex(entry),kind,faults,output,error)
 cases.append({'entry':hex(entry),'kind':kind,'lane_owner':0,'faults':faults.copy(),'output':output,'error':error})
proof={'native_sha256':digest,'passed':True,'complete':False,'cases':cases,'limits':['Original callbacks execute with a null lane-owner pointer. Lane read faults at address12; kind4/5 lane-or-nexus returns nexus without the invalid access.','Rust rejects unavailable storage explicitly instead of reproducing a host-process crash. Live field ownership/provenance and normal playback remain incomplete.']}
(r/'data/4.20/audio_announcer_null_lane_owner_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
shutil.copy2(Path('E:/mapslol3v3/qualify_announcer_null_lane_owner.py'),r/'tools/qualify_announcer_null_lane_owner.py')
print(json.dumps({'native_null_lane_owner_cases':len(cases)}))
