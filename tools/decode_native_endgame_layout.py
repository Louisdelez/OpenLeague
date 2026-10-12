from pathlib import Path
import json,struct,zlib,hashlib
root=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/DATA/Menu_SC4')
p=root/'EndOfGame_Default.gfx';raw=p.read_bytes();b=raw[:8]+zlib.decompress(raw[8:])
class Bits:
 def __init__(self,b,pos=0):self.b=b;self.pos=pos*8
 def u(self,n):
  v=0
  for _ in range(n):v=(v<<1)|((self.b[self.pos//8]>>(7-self.pos%8))&1);self.pos+=1
  return v
 def s(self,n):v=self.u(n);return v-(1<<n) if n and v&(1<<(n-1)) else v
 def align(self):self.pos=(self.pos+7)//8*8
 def matrix(self):
  sx=sy=1.;r0=r1=0.
  if self.u(1):n=self.u(5);sx=self.s(n)/65536;sy=self.s(n)/65536
  if self.u(1):n=self.u(5);r0=self.s(n)/65536;r1=self.s(n)/65536
  n=self.u(5);tx=self.s(n)/20;ty=self.s(n)/20;self.align();return dict(scale=[sx,sy],rotate=[r0,r1],translate_px=[tx,ty])
 def rect(self):n=self.u(5);v=[self.s(n)/20 for _ in range(4)];self.align();return v
def tags(b,pos=0):
 while pos<len(b):
  h=struct.unpack_from('<H',b,pos)[0];pos+=2;k=h>>6;n=h&63
  if n==63:n=struct.unpack_from('<I',b,pos)[0];pos+=4
  data=b[pos:pos+n];assert len(data)==n;pos+=n;yield k,data
  if k==0:return
bits=Bits(b,8);stage=bits.rect();offset=bits.pos//8+4
exports={};sprites={};texts={};images={};action_strings=[]
def place(data):
 flags=data[0];depth=struct.unpack_from('<H',data,1)[0];pos=3;out=dict(flags=flags,depth=depth)
 if flags&2:out['character']=struct.unpack_from('<H',data,pos)[0];pos+=2
 if flags&4:bits=Bits(data,pos);out['matrix']=bits.matrix();pos=bits.pos//8
 if flags&8:
  bits=Bits(data,pos);hasadd=bits.u(1);hasmult=bits.u(1);n=bits.u(4)
  if hasmult:out['color_mult']=[bits.s(n) for _ in range(4)]
  if hasadd:out['color_add']=[bits.s(n) for _ in range(4)]
  bits.align();pos=bits.pos//8
 if flags&16:out['ratio']=struct.unpack_from('<H',data,pos)[0];pos+=2
 if flags&32:end=data.index(0,pos);out['name']=data[pos:end].decode();pos=end+1
 return out
for kind,data in tags(b,offset):
 if kind in [56,76]:
  count=struct.unpack_from('<H',data)[0];pos=2
  for _ in range(count):id=struct.unpack_from('<H',data,pos)[0];pos+=2;end=data.index(0,pos);exports[data[pos:end].decode()]=id;pos=end+1
 elif kind==39:
  id,frames=struct.unpack_from('<HH',data);sprites[id]=dict(frames=frames,placements=[place(d) for k,d in tags(data,4) if k==26])
 elif kind==37:
  id=struct.unpack_from('<H',data)[0];bits=Bits(data,2);bounds=bits.rect();texts[id]=dict(bounds_px=bounds,remaining_hex=data[bits.pos//8:].hex())
 elif kind==1008:id,atlas,left,top,right,bottom=struct.unpack('<6H',data);images[id]=dict(atlas=atlas,rect_px=[left,top,right,bottom])
report=dict(source=str(p),sha256=hashlib.sha256(raw).hexdigest(),stage_px=stage,exports=exports,sprites=sprites,texts=texts,subimages=images,complete=False,limits=['Layout transforms decoded from original PlaceObject2 tags. ActionScript, Scaleform timeline, text localization and behavior not executed.'])
Path('E:/mapslol3v3/native_endgame_layout.json').write_text(json.dumps(report,indent=2),encoding='utf-8')
print(json.dumps(dict(stage=stage,exports=exports,display=sprites.get(exports.get('EndOfGameDisplay')),victory=sprites.get(exports.get('victoryBkg')),defeat=sprites.get(exports.get('defeatBkg')),texts=texts),indent=2))
