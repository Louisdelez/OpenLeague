"""Bounded static Lua5.1 chunk reader; no Lua/native/community execution.

Format references: lua.org/source/5.1/lundump.c.html and lopcodes.h.html.
Only straight-line literal global initialization is interpreted. Engine symbols,
callbacks, calls, branches and omitted server bodies remain unqualified.
"""
import hashlib,math,pathlib,struct
HEADER=bytes.fromhex('1b4c75615100010404040800')
OPS='MOVE LOADK LOADBOOL LOADNIL GETUPVAL GETGLOBAL GETTABLE SETGLOBAL SETUPVAL SETTABLE NEWTABLE SELF ADD SUB MUL DIV MOD POW UNM NOT LEN CONCAT JMP EQ LT LE TEST TESTSET CALL TAILCALL RETURN FORLOOP FORPREP TFORLOOP SETLIST CLOSE CLOSURE VARARG'.split()
class LuaReferenceError(ValueError):pass
class Reader:
 def __init__(self,raw):
  if len(raw)>64*1024*1024 or raw[:12]!=HEADER:raise LuaReferenceError('Unsupported Lua5.1 chunk header/size')
  self.raw=raw;self.p=12;self.functions=0
 def take(self,n):
  if n<0 or self.p+n>len(self.raw):raise LuaReferenceError('Truncated Lua5.1 chunk')
  b=self.raw[self.p:self.p+n];self.p+=n;return b
 def count(self):
  n=struct.unpack('<I',self.take(4))[0]
  if n>1000000:raise LuaReferenceError('Unbounded/negative Lua5.1 count')
  return n
 def string(self):
  n=self.count()
  if not n:return None
  b=self.take(n)
  if b[-1]!=0:raise LuaReferenceError('Unterminated Lua5.1 string')
  try:return b[:-1].decode('utf-8')
  except UnicodeDecodeError as e:raise LuaReferenceError('Non-UTF8 constant requires separate byte interpretation') from e
 def function(self,depth=0):
  if depth>100 or self.functions>100000:raise LuaReferenceError('Lua5.1 prototype depth/count limit')
  self.functions+=1;offset=self.p;source=self.string();line=self.count();last=self.count();nups,params,vararg,stack=struct.unpack('<4B',self.take(4))
  n=self.count();code=self.take(n*4);words=list(struct.unpack('<'+'I'*n,code));constants=[]
  for _ in range(self.count()):
   tag=self.take(1)[0]
   if tag==0:v=None
   elif tag==1:v=self.take(1)!=b'\0'
   elif tag==3:
    v=struct.unpack('<d',self.take(8))[0]
    if not math.isfinite(v):raise LuaReferenceError('Nonfinite Lua5.1 constant not qualified')
   elif tag==4:v=self.string()
   else:raise LuaReferenceError('Unknown Lua5.1 constant tag')
   constants.append(v)
  children=[self.function(depth+1) for _ in range(self.count())]
  self.take(self.count()*4)
  for _ in range(self.count()):self.string();self.count();self.count()
  for _ in range(self.count()):self.string()
  return {'offset':offset,'end':self.p,'source':source,'first_line':line,'last_line':last,'nups':nups,'parameters':params,'vararg_flags':vararg,'max_stack':stack,
   'words':words,'code_sha256':hashlib.sha256(code).hexdigest(),'constants':constants,'children':children}
 def parse(self):
  f=self.function()
  if self.p!=len(self.raw):raise LuaReferenceError('Trailing Lua5.1 bytes')
  return f

def literal_globals(proto):
 regs={};glob={};witnesses=[]
 def constant(i):
  if i>=len(proto['constants']):raise LuaReferenceError('Lua5.1 constant index out of bounds')
  return proto['constants'][i]
 if proto['children']:return {'qualified_straight_line_literals':False,'reason':'Nested function prototypes require semantic review','globals':{},'witnesses':[]}
 returned=False
 for pc,w in enumerate(proto['words']):
  op=w&63;a=(w>>6)&255;c=(w>>14)&511;b=(w>>23)&511;bx=w>>14
  if a>=proto['max_stack']:raise LuaReferenceError('Lua5.1 register out of bounds')
  if returned:return {'qualified_straight_line_literals':False,'reason':'Instructions after return','globals':{},'witnesses':[]}
  if op==0:
   if b not in regs:return {'qualified_straight_line_literals':False,'reason':'Uninitialized register','globals':{},'witnesses':[]}
   regs[a]=regs[b]
  elif op==1:regs[a]=constant(bx)
  elif op==2 and c==0 and b in [0,1]:regs[a]=bool(b)
  elif op==3:
   if b<a or b>=proto['max_stack']:raise LuaReferenceError('Lua5.1 nil register range invalid')
   for i in range(a,b+1):regs[i]=None
  elif op==5:
   name=constant(bx)
   if not isinstance(name,str):raise LuaReferenceError('Lua5.1 global name is not string')
   regs[a]=glob.get(name,{'unresolved_engine_global':name})
  elif op==7:
   name=constant(bx)
   if not isinstance(name,str) or a not in regs:raise LuaReferenceError('Lua5.1 global assignment invalid')
   glob[name]=regs[a];witnesses.append({'pc':pc,'name':name,'value':regs[a]})
  elif op==30 and b==1:returned=True
  else:return {'qualified_straight_line_literals':False,'reason':'Unsupported control/data flow '+(OPS[op] if op<len(OPS) else str(op))+' atpc'+str(pc),'globals':{},'witnesses':[]}
 if not returned:return {'qualified_straight_line_literals':False,'reason':'No terminal return','globals':{},'witnesses':[]}
 return {'qualified_straight_line_literals':True,'globals':glob,'witnesses':witnesses,'engine_symbol_values_not_resolved':True}

def inspect(path):
 raw=pathlib.Path(path).read_bytes();reader=Reader(raw);proto=reader.parse();meta=literal_globals(proto)
 def totals(p):return 1+sum(totals(x) for x in p['children'])
 return {'path':str(path),'bytes':len(raw),'sha256':hashlib.sha256(raw).hexdigest(),'reader_consumed_all_bytes':True,'top_level_instructions':len(proto['words']),
  'child_function_prototypes':totals(proto)-1,'top_level_code_sha256':proto['code_sha256'],'top_level_constants':proto['constants'],
  'literal_initialization':meta,'client_chunk_has_no_callback_prototypes':not proto['children'],
  'original_server_behavior_proven':False,'code_executed':False}
