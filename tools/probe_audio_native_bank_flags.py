from pathlib import Path
import xml.etree.ElementTree as E
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_game_clock.py').read_text().split('\nrows=[]')[0],'setup','exec'))
manifest=json.loads((r/'data/4.20/ambient_audio_manifest.json').read_text());contract=json.loads((r/'data/4.20/ambient_audio_selection.json').read_text());wanted={x['id']:x for x in contract['containers']};rows=[]
container=vector+0xa000;buffer=vector+0xb000
for bank in manifest['banks']:
 if 'xml' not in bank:continue
 for root in E.fromstring('<banks>'+Path(bank['xml']).read_text()+'</banks>').findall('./root'):
  path=Path(root.get('path'))/root.get('filename');bankbytes=path.read_bytes()
  for node in root.findall('./object/list/object'):
   ident=node.find("field[@name='ulID']")
   if ident is None or int(ident.get('value')) not in wanted:continue
   ident=int(ident.get('value'));expected=wanted.pop(ident)
   start=int(node.find(".//field[@name='sLoopCount']").get('offset'));last=int(node.find(".//field[@name='bIsGlobal']").get('offset'))+1
   data=bankbytes[start:last];assert len(data)==28
   u.mem_write(container,b'\0'*0xa0);u.mem_write(buffer,data)
   bp=stack-0x100;w(bp+8,buffer);u.reg_write(UC_X86_REG_EBP,bp);u.reg_write(UC_X86_REG_ESP,bp-0x100);u.reg_write(UC_X86_REG_ESI,container)
   u.emu_start(0xb1e5e5,0xb1e742,count=10000);assert u.reg_read(UC_X86_REG_EIP)==0xb1e742
   flags=bytes(u.mem_read(container+0x90,2));avoid=struct.unpack('<H',u.mem_read(container+0x8e,2))[0]
   assert ((flags[0]>>4)&3)==expected['random_mode'] and (flags[1]&7)==expected['mode']
   assert bool(flags[1]&128)==expected['global'] and bool(flags[1]&64)==expected['continuous']
   assert bool(flags[1]&16)==expected['reset_each_play_raw'] and avoid==expected['avoid_repeat']
   rows.append(dict(id=ident,bank=str(path),bank_sha256=hashlib.sha256(bankbytes).hexdigest(),offset=start,bytes=data.hex(),flags90=flags[0],flags91=flags[1],avoid=avoid))
assert not wanted and len(rows)==8
proof=dict(passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),region=['0xb1e5e5','0xb1e742'],containers=rows,limits=['Executes native post-base-property loader region and setters on fresh empty history state, using real bank bytes. Base loader and playlist insertion excluded.','Serialized _bIsUsingWeight byte skipped by this region; actual weight mode determined while adding playlist entries, still to qualify.','All8actual containers mode0, noncontinuous, global, reset flag1. Reset flag influence on noncontinuous selection remains to integrate carefully.'])
(r/'data/4.20/audio_native_bank_flags.json').write_text(json.dumps(proof,indent=2)+'\n');print(json.dumps(dict(passed=True,containers=len(rows))))
