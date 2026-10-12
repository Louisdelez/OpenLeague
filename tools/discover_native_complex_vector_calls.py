from pathlib import Path
import sys,json,hashlib,datetime,shutil
r=Path('E:/OpenLeague');sys.path.insert(0,str(r/'tools/pythonlibs'));import pefile,capstone
path=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe');raw=path.read_bytes();p=pefile.PE(data=raw);img=p.get_memory_mapped_image();pebase=p.OPTIONAL_HEADER.ImageBase;m=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32);ins=list(m.disasm(img[0x910eb0-pebase:0x913bbe-pebase],0x910eb0));calls=[]
for index,instruction in enumerate(ins):
 if instruction.mnemonic!='call' or instruction.op_str!='0x94aa60':continue
 context=ins[max(0,index-30):index+1];strings=[]
 for i in context:
  if i.mnemonic=='push' and i.op_str.startswith('0x'):
   address=int(i.op_str,16)
   if 0x1000000<=address<0x1200000:
    value=img[address-pebase:address-pebase+256].split(b'\0')[0]
    if value and all(32<=b<127 for b in value):strings.append({'address':hex(address),'value':value.decode('ascii')})
 calls.append({'call':hex(instruction.address),'string_candidates':strings,'context':[{'address':hex(i.address),'mnemonic':i.mnemonic,'operands':i.op_str} for i in context]})
proof={'updated_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'complete':False,'native_sha256':hashlib.sha256(raw).hexdigest(),'calls':calls,'limits':['Static original call contexts only. Dynamic argument values, missing-field fallback and field-specific consumers require execution before binding ordinary Map10 emitters.']};(r/'docs/native_complex_vector_calls.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps({'calls':len(calls),'fields':[v['string_candidates'] for v in calls]}))
