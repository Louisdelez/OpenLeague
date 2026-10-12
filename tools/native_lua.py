"""Read Lua 5.1 chunks and recover straight-line initialization data without executing calls."""
import struct
from pathlib import Path
class Chunk:
 def __init__(self,data):
  if data[:6]!=b"\x1bLua\x51\x00":raise ValueError("Expected Lua 5.1 bytecode")
  self.data=data;self.i=12;self.order="little" if data[6] else "big";self.int_size=data[7];self.size_t=data[8];self.num_size=data[10]
 def read(self,n):
  data=self.data[self.i:self.i+n]
  if len(data)!=n:raise ValueError("Truncated bytecode")
  self.i+=n;return data
 def integer(self,n=None):return int.from_bytes(self.read(n or self.int_size),self.order)
 def string(self):
  n=self.integer(self.size_t)
  return self.read(n)[:-1].decode("utf-8","strict") if n else None
 def function(self):
  source=self.string();first=self.integer();last=self.integer();flags=list(self.read(4));code=[self.integer(4) for _ in range(self.integer())];constants=[]
  for _ in range(self.integer()):
   tag=self.integer(1)
   if tag==0:value=None
   elif tag==1:value=bool(self.integer(1))
   elif tag==3:value=struct.unpack(("<" if self.order=="little" else ">")+("d" if self.num_size==8 else "f"),self.read(self.num_size))[0]
   elif tag==4:value=self.string()
   else:raise ValueError("Unknown constant tag")
   constants.append(value)
  children=[self.function() for _ in range(self.integer())]
  lines=[self.integer() for _ in range(self.integer())]
  locals=[(self.string(),self.integer(),self.integer()) for _ in range(self.integer())]
  upvalues=[self.string() for _ in range(self.integer())]
  return dict(source=source,lines=[first,last],flags=flags,code=code,constants=constants,functions=children,locals=locals,upvalues=upvalues)
def initialization(proto):
 registers={};globals={};constant=proto["constants"];stopped=None;top=0
 def operand(index):return constant[index-256] if index>=256 else registers.get(index)
 for pc,word in enumerate(proto["code"]):
  op=word&63;a=(word>>6)&255;c=(word>>14)&511;b=(word>>23)&511;bx=word>>14
  if op==0:registers[a]=registers.get(b)
  elif op==1:registers[a]=constant[bx]
  elif op==2:
   registers[a]=bool(b)
   if c:stopped=dict(pc=pc,opcode=op);break
  elif op==3:
   for register in range(a,b+1):registers[register]=None
  elif op==5:registers[a]=globals.get(constant[bx],{"external":constant[bx]})
  elif op==6:
   table=registers.get(b);key=operand(c);registers[a]=table.get(key) if isinstance(table,dict) else None
  elif op==7:globals[constant[bx]]=registers.get(a)
  elif op==9:
   table=registers.get(a)
   if not isinstance(table,dict):stopped=dict(pc=pc,opcode=op);break
   table[operand(b)]=operand(c)
  elif op==10:registers[a]={}
  elif op in (12,13,14,15,16,17):
   left,right=operand(b),operand(c)
   if not isinstance(left,(int,float)) or not isinstance(right,(int,float)):stopped=dict(pc=pc,opcode=op);break
   registers[a]={12:lambda:left+right,13:lambda:left-right,14:lambda:left*right,15:lambda:left/right,16:lambda:left%right,17:lambda:left**right}[op]()
  elif op==18:registers[a]=-registers[b]
  elif op==28:
   function=registers.get(a)
   if function!={"external":"Make3DPoint"} or b!=4:
    stopped=dict(pc=pc,opcode=op);break
   arguments=[registers.get(a+i) for i in range(1,4)]
   if not all(isinstance(v,(int,float)) for v in arguments):raise ValueError("Nonliteral native point")
   registers[a]={"x":arguments[0],"y":arguments[1],"z":arguments[2]};top=a+1
  elif op==34:
   if c==0:stopped=dict(pc=pc,opcode=op);break
   count=b if b else top-a-1;table=registers[a]
   for i in range(count):table[(c-1)*50+i+1]=registers.get(a+i+1)
  elif op==36:
   child=proto["functions"][bx];registers[a]={"function_lines":child["lines"]}
   # Upvalue binding pseudo-instructions are not part of the initialization data.
   if child["flags"][0]:stopped=dict(pc=pc,opcode=op,reason="closure upvalues");break
  elif op in (30,35):
   if op==30:break
  else:stopped=dict(pc=pc,opcode=op);break
 return {"globals":globals,"stopped":stopped}
