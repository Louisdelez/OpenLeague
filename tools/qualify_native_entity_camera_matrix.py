"""Native entity direction matrix, virtual getter and mode3 producer chain."""
from pathlib import Path
import json,struct,random
r=Path(__file__).resolve().parents[1]
exec(compile((r/'tools/qualify_native_camera_angles.py').read_text(encoding='utf-8').split('trig=[]')[0],'angle setup','exec'))
allowed.extend([(0x6ab520,0x6ab774),(0x8de480,0x8de568),(0x600ed0,0x600ed7)])
mat=entity+0x18c0;vector=heap+0x5000
getters=[]
for table in [0x10924dc,0x1091d84]:
 assert read32(table+0x20)==0x600ed0
 address=run(0x600ed0,ecx=entity+0x3e0);assert address==mat
 getters.append({'vtable':hex(table),'virtual20':hex(read32(table+0x20)),'receiver_entity_offset':0x3e0,'returned_entity_offset':address-entity})
# Install actual native vtable;565910 executes original600ED0 rather than supplied callback.
write32(entity+0x3e0,0x1091d84)
randomizer=random.Random(420)
vectors=[[0.,0.,0.],[0.,0.,1.],[1.,0.,0.],[0.,1.,0.],[0.,-1.,0.],[-1.,0.,0.],[0.,0.,-1.],[.4,-.8,.4],[1e-8,0.,0.],[-0.,0.,-0.],[10000.,-.1,-10000.]]+[[randomizer.uniform(-100,100) for _ in range(3)] for _ in range(40)]
rows=[];chains=[]
initial=bits([1.,2.,3.,50.,5000.,0.,0.,1.,0.,1.,0.,103.,0.,1000.,1000.,0.]);initial[12]=2;initial[15]=0xdeadbeef
for values in vectors:
 u.mem_write(vector,struct.pack('<3f',*values));u.mem_write(mat,b'\xa5'*64);run(0x6ab520,[vector],mat)
 out=list(struct.unpack('<16I',u.mem_read(mat,64)));rows.append({'direction_bits':bits(values),'matrix_bits':out})
 for angles in [[0.,0.],[45.,56.],[-90.,-30.],[180.,89.]]:
  fields=angles+[20.,3.,40.];position=[7000.,50.,8000.];u.mem_write(state,struct.pack('<5f',*fields));u.mem_write(entity+0x60,struct.pack('<3f',*position));u.mem_write(camera,struct.pack('<16I',*initial));calls=[]
  run(0x565910,[camera],state);assert not calls
  chains.append({'direction_bits':bits(values),'state_bits':bits(fields),'entity_position_bits':bits(position),'initial_camera_bits':initial,'output_camera_bits':list(struct.unpack('<16I',u.mem_read(camera,64)))})
proof={'native_sha256':digest,'passed':True,'complete':False,'matrix_cases':rows,'getter_cases':getters,'camera_chain_cases':chains,'limits':['Full6AB520 direction matrix +8DE480 identity +8DE500 copy +66D6E0 reciprocal sqrt execute without adapters. Inputs supplied; no original movement update/event binding claimed.','Full565910 camera follows actual native virtual20 vtable1091D84 ->600ED0 ->entity18C0; no matrix getter adapter used in chain cases. Vtable10924DC has same getter. Constructor stores inspected statically; full entity constructors not executed.','Other matrix mutators6AB380/5657E0 and actual native movement/animation producers remain unqualified. Core/client runtime binding incomplete.']}
(r/'data/4.20/entity_camera_matrix_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print('Native entity matrix:',len(rows),'matrices,',len(getters),'getters,',len(chains),'full camera chains')
