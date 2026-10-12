from pathlib import Path
import json,datetime,hashlib,struct,itertools
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_projectile_default_mask_activation.py').read_text(encoding='utf-8').split('\nrows=[]')[0],'setup','exec'))
rows=[]
for position,ended in itertools.product([[0.,0.,0.],[7400.,2.,7700.],[-55.,24.,-90.]],[False,True]):
 for address,size in [(wrapper,0x200),(troy,0x180),(control,0x20)]:u.mem_write(address,b'\0'*size)
 live=True;events=[];u.mem_write(nameptr,b'ambient.troy\0');u.mem_write(posptr,struct.pack('<3f',*position))
 run(0x93fd60,troy,[0,nameptr,0]);w(wrapper,0x10a4960);w(wrapper+0xb0,0x212);w(0x2d628c0,0)
 run(0x7172b0,0,[0,posptr,0,0,0],nameptr)
 if ended:w(wrapper+0x12c,0);w(wrapper+0x124,1)
 before=words(troy+0x40,3)
 assert run(0x6c9210,wrapper,[])==1
 initialized=words(troy+0x40,3);result=run(0x6c97b0,wrapper,[0])
 assert initialized==list(struct.unpack('<3I',struct.pack('<3f',*position)))
 assert result==int(not ended)
 rows.append(dict(position=position,ended=ended,before=before,initialized=initialized,after_update=words(troy+0x40,3),update_return=result))
proof=dict(passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),cases=rows,entries=['7172B0','6C8E30','6C9210','6C97B0'],findings=['Deferred initialization forwards factory position even when End already set wrapper124=1 and12C=0.','Subsequent wrapper update rejects ended wrapper without clearing initialized resource position.'],adapters=['Inherited factory resource and wrapper allocation adapters from projectile factory qualification.','End stores supplied from separately qualified5B5440 marker. No animation timeline execution here.','Original6C9210 executes with supplied clock7.0; no graphical particle pass exercised.'],limits=['No full resource loader or complete animation-start callback.','Orientation/provider and physical audio remain separate.'])
(r/'data/4.20/ambient_ended_initialization_contract.json').write_text(json.dumps(proof,indent=2),encoding='utf-8')
print(json.dumps(dict(passed=True,cases=len(rows))))
