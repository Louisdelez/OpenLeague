from pathlib import Path
import json,struct,itertools,datetime,hashlib,shutil
r=Path('E:/OpenLeague')
source=(r/'tools/probe_native_projectile_factory_pose.py').read_text(encoding='utf-8').split('rows=[]')[0]
source=source.replace(" if a==0x6c9490:events.append('entity-bounds-update');finish(0);return",''' if a==0x95f370:events.append(dict(kind='grid',center=words(obj,3)));finish(0);return
 if a==0x95ff10:events.append(dict(kind='node-update'));finish(0,4);return
 if a==0x95f060:events.append(dict(kind='extents',minimum=words(read(sp+4),3),maximum=words(read(sp+8),3)));finish(0,8);return''')
exec(compile(source,'bounds setup','exec'))
handle=vector+0xb000;record=vector+0xb100;node=vector+0xb200;rows=[]
actor=vector+0xc000;config=vector+0xd000;position_ptr=vector+0xe000
for position,coefficient,live,registered,previous,attached in itertools.product([[0.,0.,0.],[500.,600.,700.],[-55.5,2.25,99.75]],[0.,1.,250.,500.],[False,True],[False,True],[[0.,0.,0.],[300.,400.,500.]],[False,True]):
 u.mem_write(wrapper,b'\0'*0x200);u.mem_write(troy,b'\0'*0x180);u.mem_write(control,b'\0'*0x20);u.mem_write(record,b'\0'*0x80)
 w(troy,0x10d6db4)
 u.mem_write(actor,b'\0'*0x240);w(actor+0xe8,config);u.mem_write(config+0x138,struct.pack('<f',coefficient));u.mem_write(position_ptr,struct.pack('<3f',*position));run(0x921f60,actor,[position_ptr])
 w(troy+0x114,actor);u.reg_write(UC_X86_REG_EDI,troy);u.emu_start(0x940df4,0x940e53,count=1000);assert u.reg_read(UC_X86_REG_EIP)==0x940e53
 bounds=list(struct.unpack('<6f',u.mem_read(troy+0xe0,24)))
 w(wrapper+0x11c,troy);w(wrapper+0x120,control);w(control+4,3 if live else 0);w(control+8,3)
 initial=[9.,8.,7.,6.,5.,4.];u.mem_write(wrapper+0x95,struct.pack('<6f',*initial));w(wrapper+0xcc,handle if registered else 0);w(handle+8,record);u.mem_write(record,struct.pack('<3f',*previous));w(record+0x28,node if attached else 0)
 events=[];run(0x6c9490,wrapper,[])
 rows.append(dict(position=position,coefficient=coefficient,bounds_bits=list(struct.unpack('<6I',struct.pack('<6f',*bounds))),initial_bits=list(struct.unpack('<6I',struct.pack('<6f',*initial))),live=live,registered=registered,previous_bits=list(struct.unpack('<3I',struct.pack('<3f',*previous))),attached=attached,owner_bounds=words(wrapper+0x95,6),center=words(record,3),events=events.copy()))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),cases=rows,native_instruction_addresses=len(visited),entries=['921F60','940DF4..940E53','6C9490','9284A0','71A5B0'],adapters=['Original position/group-vis producer and bounded native bounds export executed before original owner transfer; supplied weak owner and optional spatial record.','95F370 grid recomputation,95FF10 node maintenance and95F060 extent setter captured at entry.'],limits=['Finite position and group-vis inputs; bounded export bypasses full frame scheduling; downstream mutations remain open.','No client integration or full game acceptance.'])
(r/'data/4.20/projectile_spatial_bounds_producer_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(len(rows),len(visited))
