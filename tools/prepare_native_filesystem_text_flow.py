from pathlib import Path
r=Path('E:/OpenLeague');stage=Path(__file__).parent
text=(r/'tools/qualify_native_config_text_file_flow.py').read_text(encoding='utf-8')
text=text.replace("inputs={};active=b'';calls=[]","inputs={};active=b'';calls=[];streams={};stream_next=0x40018000;provider=0x40019000;w(provider,0x10c9854);w(0x2d6e4a0,provider);w(0x2d6e4b0,1)")
text=text.replace(' global active,frame',' global active,frame,stream_next')
start=text.index(' if a==0x8b4ef0:');stop=text.index(' if a==0x9933e0:',start)
text=text[:start]+''' if a==0xc9f6c9:
  path=cbytes(read(sp+4));result=0 if inputs[path] is not None else -1;calls.append(dict(kind='access',path=path.decode(),flags=read(sp+8),result=result));finish(result);return
 if a==0xc99533:
  out=read(sp+4);path=cbytes(read(sp+8));mode=cbytes(read(sp+12));data=inputs[path];calls.append(dict(kind='open',path=path.decode(),mode=mode.decode(),present=data is not None))
  p=0
  if data is not None:p=stream_next;stream_next+=16;streams[p]=dict(data=data,position=0)
  w(out,p);finish(0 if p else 2);return
 if a==0xc9f39b:finish(alloc(b'\\0'*read(sp+4)));return
 if a==0x564c20:ssowrite(this,bytes(u.mem_read(read(sp+4),read(sp+8))));finish(this,8);return
 if a==0xc9b375:
  assert read(sp+8)==0 and read(sp+12)==0 and read(sp+16)==64000;finish(0);return
 if a==0xc9cd17:finish(streams[read(sp+4)]['position']);return
 if a==0xc9ce75:
  stream=streams[read(sp+4)];offset=read(sp+8);offset=offset if offset<0x80000000 else offset-0x100000000;origin=read(sp+12);assert origin in [0,1,2];stream['position']=offset+([0,stream['position'],len(stream['data'])][origin]);finish(0);return
 if a==0xc9973d:
  dest=read(sp+4);element=read(sp+8);count=read(sp+12);stream=streams[read(sp+16)];chunk=stream['data'][stream['position']:stream['position']+element*count]
  if chunk:u.mem_write(dest,chunk)
  stream['position']+=len(chunk);finish(0 if element==0 else len(chunk)//element);return
 if a==0xc99855:
  del streams[read(sp+4)];calls.append(dict(kind='close'));finish(0);return
 if a==0xc98528:finish(uc.reg_read(UC_X86_REG_EAX));return
'''+text[stop:]
text=text.replace('(0x8b5030,0x8b5079)]','(0x8b5030,0x8b5079),(0x8b4ef0,0x8b4f5b),(0x8b5f90,0x8b6380),(0x71eca0,0x71eca4)]')
text=text.replace('allocation=heap;slots.clear();','allocation=heap;streams.clear();stream_next=0x40018000;w(0x2d77b20,1);w(0x14bef58,0);w(0x14bef40,0);slots.clear();')
marker=" assert len([x for x in calls if x['kind']=='close'])"
assert marker in text;text=text.replace(marker," assert not streams\n"+marker)
text=text.replace('native_config_text_file_flow_contract.json','native_filesystem_text_flow_contract.json')
marker="(r/'data/4.20/native_filesystem_text_flow_contract.json').write_text"
addition="""proof['filesystem_provider_executed']=True
proof['adapters']=['Original resource dispatch8B4EF0, simple provider8B6280/8B6360, file constructor8B5F90, size/seek/read/destructor, text loader/parser and cleanup execute original instructions.','CRT access/fopen_s/setvbuf/ftell/fseek/fread/fclose, allocation/free, strings/containers/memcpy/cookie adapted with controlled in-memory streams; no real filesystem operations.','Provider array contains the native simple-filesystem vtable, resource subsystem already initialized; archive provider absent.']
proof['limits']=['Native C++ provider/stream control flow only; actual CRT/Windows encoding/file permissions/failure/partial-read behavior and archive provider still open.','Successful open/read/seek/allocation plus missing/empty files; error cleanup, concurrent modifications and process-global initialization not fully qualified.','No complete configuration cache/menu/persistence or full game proof.']
"""
assert marker in text;text=text.replace(marker,addition+marker)
(stage/'qualify_native_filesystem_text_flow.py').write_text(text,encoding='utf-8')
print('Native filesystem provider and stream enabled in text loader probe.')
