from pathlib import Path
import xml.etree.ElementTree as E
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_game_clock.py').read_text().split('\nrows=[]')[0],'setup','exec'))
registry=vector+0x16000;nodes=vector+0x18000;buffer=vector+0x19000;eventobj=vector+0x1a000;lock=vector+0x1b000
u.mem_write(lock,b'\xc2\x04\x00');w(0xfa4424,lock);w(0xfa4428,lock);w(0x14a7a08,registry)
manifest=json.loads((r/'data/4.20/ambient_audio_manifest.json').read_text());contract=json.loads((r/'data/4.20/ambient_audio_selection.json').read_text());wanted={e['id']:e for e in contract['events']};rows=[]
for bank in manifest['banks']:
 if 'xml' not in bank:continue
 for root in E.fromstring('<banks>'+Path(bank['xml']).read_text()+'</banks>').findall('./root'):
  path=Path(root.get('path'))/root.get('filename');rawbank=path.read_bytes()
  for node in root.findall('./object/list/object'):
   f=node.find("field[@name='ulID']")
   if f is None or int(f.get('value')) not in wanted:continue
   ident=int(f.get('value'));event=wanted.pop(ident);ids=[a['id'] for a in event['actions']]
   start=int(f.get('offset'));payload=rawbank[start:start+8+4*len(ids)]
   assert struct.unpack('<II',payload[:8])==(ident,len(ids)) and list(struct.unpack('<'+'I'*len(ids),payload[8:]))==ids
   u.mem_write(registry,bytes(4096));u.mem_write(nodes,bytes(512));u.mem_write(eventobj,bytes(64));u.mem_write(buffer,payload)
   for i,aid in enumerate(ids):
    p=nodes+i*64;bucket=registry+0xc80+0x18+(aid%193)*4;w(p+4,read(bucket));w(bucket,p);w(p+8,aid);w(p+12,2)
   w(stack,end);u.mem_write(stack+4,struct.pack('<II',buffer,len(payload)));u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,eventobj)
   u.emu_start(0xb1a960,end,count=2000);assert u.reg_read(UC_X86_REG_EIP)==end and u.reg_read(UC_X86_REG_EAX)==1
   cursor=read(eventobj+0x10);actual=[]
   while cursor:
    actual.append(read(cursor+8));assert read(cursor+12)==3;cursor=read(cursor+0x10);assert len(actual)<=len(ids)
   assert actual==ids
   rows.append(dict(event=ident,bank=str(path),bank_sha256=hashlib.sha256(rawbank).hexdigest(),offset=start,bytes=payload.hex(),loaded_actions=actual,reference_count=3))
assert not wanted and len(rows)==5
proof=dict(passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),loader='0xb1a960',bank_dispatch='0xafbea5',cases=rows,limits=['Actual event payload bytes loaded by native loader; native193bucket registry lookup and linked append execute unchanged. Lock imports adapted to single-thread ret4.','Existing action registry nodes supplied; full bank initialization, missing actions and repeated reload not covered.','Successful load preserves bank action order and increments action references. Audible playback remains unqualified.'])
(r/'data/4.20/audio_native_event_load_order.json').write_text(json.dumps(proof,indent=2)+'\n');print(json.dumps(dict(passed=True,events=len(rows),actions=sum(len(x['loaded_actions']) for x in rows))))
