from pathlib import Path
import struct,json
exec(Path('E:/mapslol3v3/decode_native_endgame_classic.py').read_text(encoding='utf-8').replace("exec(compile(s,'classic-eog','exec'))","exec(compile(s[:s.index('print(json.dumps')],'classic-eog','exec'))"))
shapes={};images={}
for kind,data in tags(b,offset):
 if kind in [2,22,32,83]:
  id=struct.unpack_from('<H',data)[0];bits=Bits(data,2);bounds=bits.rect();pos=bits.pos//8
  if kind==83:bits=Bits(data,pos);bits.rect();pos=bits.pos//8+1
  count=data[pos];pos+=1
  if count==255:count=struct.unpack_from('<H',data,pos)[0];pos+=2
  fill=[]
  for _ in range(count):
   type=data[pos];pos+=1
   if type in [0x40,0x41,0x42,0x43]:image=struct.unpack_from('<H',data,pos)[0];pos+=2;bits=Bits(data,pos);matrix=bits.matrix();pos=bits.pos//8;fill.append(dict(image=image,matrix=matrix))
   elif type==0:pos+=4 if kind in [32,83] else 3
   else:raise ValueError((id,type))
  shapes[id]=dict(bounds_px=bounds,fill=fill)
 if kind>=1000:
  print('external',kind,data[:80])
  if kind==1001:
   id,format,width,height=struct.unpack_from('<4H',data);images[id]=dict(width=width,height=height,format=format,filename=data[10:].split(b'\0')[0].decode())
  if kind==1009:
   id=struct.unpack_from('<H',data)[0];images[id]=dict(width=struct.unpack_from('<H',data,6)[0],height=struct.unpack_from('<H',data,8)[0],filename=data[12:].split(b'\0')[0].decode(errors='replace'))
report['shapes']=shapes;report['images']=images
Path('E:/mapslol3v3/native_endgame_classic_layout.json').write_text(json.dumps(report,indent=2),encoding='utf-8')
print(json.dumps(dict(shapes=shapes,images=images),indent=2))
