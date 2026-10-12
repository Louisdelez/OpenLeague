"""943ADA..943B58 tail with actual8DE500 matrix copies and8DEC10 inverse."""
from pathlib import Path
import json,datetime,ctypes,shutil,itertools,struct
r=Path('E:/OpenLeague')
setup=(r/'tools/probe_native_troy_reset.py').read_text(encoding='utf-8').split('\nfor index,(complex_count')[0]
exec(compile(setup,'simple finish setup','exec'))
instance=heap+0x9000;storage=heap+0xa000;frame=stack+0x4000
identity=[bits(1.) if i in [0,5,10,15] else 0 for i in range(16)]
translated=identity.copy();translated[12:15]=[bits(100.),bits(-20.),bits(.5)]
scaled=translated.copy();scaled[0]=bits(2.);scaled[5]=bits(.5);scaled[10]=bits(-1.);scaled[1]=bits(.25)
rotated=identity.copy();rotated[0]=0;rotated[2]=bits(-1.);rotated[8]=bits(1.);rotated[10]=0
matrices=[identity,translated,scaled,rotated,[0]*16]
threshold=read32(0x11389ac)
for first in [threshold-1,threshold+1,0x7fa01234]:m=identity.copy();m[0]=first;matrices.append(m)
fallbacks=[identity,[0x7fa01234 if i%2 else 0xffa05678 for i in range(16)]]
times=[0,0x80000000,0x7fa01234,0x7f800000];cases=[]
for matrix,expired,present,active,time,fallback in itertools.product(matrices,[0,1,255],[False,True],[0,1,0xffffffff],times,fallbacks):
 u.mem_write(instance,b'\0'*0x160);u.mem_write(storage,b'\0'*0xb0);u.mem_write(instance+0x94,struct.pack('<16I',*matrix));u.mem_write(instance+0x14,b'\xcc'*64);u.mem_write(instance+0x54,b'\xdd'*64);write32(instance+0xc,storage if present else 0);write32(storage+0xa4,active);write32(instance+0xdc,0xffa05678);u.mem_write(instance+8,b'\xff');u.mem_write(0x2d77410,struct.pack('<16I',*fallback))
 sp=frame-0xa0;u.mem_write(sp-0x100,b'\0'*0x240);u.mem_write(sp+0xf,bytes([expired]));write32(frame,0);write32(frame+4,end);write32(frame+8,time);write32(frame+12,0);u.reg_write(UC_X86_REG_ESP,sp);u.reg_write(UC_X86_REG_EBP,frame);u.reg_write(UC_X86_REG_EBX,instance);u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.reg_write(UC_X86_REG_FPCW,0x37f);u.reg_write(UC_X86_REG_FPTAG,0xffff)
 events=[];enabled=False;u.emu_start(0x943ada,end,count=10000);assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_ESP)==frame+16
 cases.append({'matrix':matrix,'fallback':fallback,'expired':expired,'present':present,'active':active,'time':time,'native':{'previous':list(struct.unpack('<16I',u.mem_read(instance+0x14,64))),'inverse':list(struct.unpack('<16I',u.mem_read(instance+0x54,64))),'last_time':read32(instance+0xdc),'finished':u.mem_read(instance+8,1)[0]}})
for address in blocks:kernel.VirtualFree(address,0,0x8000)
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'passed':True,'complete':False,'native_sha256':digest,'range':'943ADA..943B58','cases':cases,'adapters':['Original full tail with original8DE500 copy and8DEC10 inverse runs without math adapters. Eight controlled matrix profiles, two explicit inverse fallbacks, expiration bytes0/1/255, missing/present storage, active counts0/1/MAX and raw time words.','Native ret8 and restored stack checked. Inputs include NaN-triggered fallback and raw NaN fallback words.'],'limits':['Matrix/pose production and global2D77410fallback producer not qualified by this fragment. Selected matrix profiles only; arbitrary nonfinite nonfallback inverse outputs remain separate.','No ordinary rendering, complete Simple producer or full-game acceptance. Default FP controls.']}
(r/'data/4.20/simple_finish_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'cases':len(cases),'tail_and_native_inverse':True}))
