from pathlib import Path
import json,hashlib,sys
r=Path('E:/OpenLeague');sys.path.insert(0,str(r/'tools/pythonlibs'))
import pefile,capstone
source=json.loads((r/'docs/native_projection_discovery.json').read_text())['source'];raw=Path(source).read_bytes();pe=pefile.PE(data=raw);base=pe.OPTIONAL_HEADER.ImageBase
cs=capstone.Cs(capstone.CS_ARCH_X86,capstone.CS_MODE_32)
def decode(a,n):return [dict(address=hex(i.address),mnemonic=i.mnemonic,operands=i.op_str) for i in cs.disasm(pe.get_data(a-base,n),a)]
phase=decode(0x58d327,0x33);calls=[x['operands'] for x in phase if x['mnemonic']=='call'];assert calls==['0x717df0','0x593750','0x7ef3d0','0x71a6e0','0x7185d0','0x95ed30']
removal=decode(0x717ca0,0x70);assert any(x['address']=='0x717cf1' and x['operands']=='dword ptr [eax + 0x48]' for x in removal)
assert any(x['address']=='0x717cfa' and x['operands']=='dword ptr [eax + 8]' for x in removal)
game_loop=decode(0x58cdad,0x58d289-0x58cdad)
key_calls=[x for x in game_loop if x['mnemonic']=='call' and x['operands'] in ['0x717df0','0x739cf0','0x7185d0']]
assert [(x['address'],x['operands']) for x in key_calls]==[('0x58ce78','0x717df0'),('0x58d12c','0x739cf0'),('0x58d1ab','0x7185d0')]
proof=dict(complete=False,kind='static native instruction audit',native_sha256=hashlib.sha256(raw).hexdigest(),phase=phase,game_loop_key_calls=key_calls,game_loop_instructions=game_loop,game_loop_label=pe.get_data(0x108b0cc-base,80).split(bytes([0]))[0].decode("ascii"),removal_tail=removal,particle_frame_entry=decode(0x940570,80),particle_frame_dispatch=decode(0x92b306,0x9f),particle_manager_entry=decode(0x92b1d0,0x5f),particle_manager_global_install=decode(0x928b38,0x23),particle_loading_dispatch=decode(0x58dd55,0x12),loading_labels={hex(a):pe.get_data(a-base,100).split(bytes([0]))[0].decode("ascii") for a in [0x108b38c,0x108b39c,0x108b3ac,0x108b3c0]},render_route_particle_caller=decode(0x58d2c8,0x92),alternate_render_caller=decode(0x58d12c,0x19),particle_alternate_dispatch=decode(0x739d32,0xf),subsequent_entity_update=decode(0x58dde1,5),particle_manager_table_install=decode(0x928bc2,12),particle_manager_vtable_slot=dict(table="0x10d6c70",slot="0x24",target="0x92b1d0"),intermediate_manager=decode(0x7ef3d0,57),findings=['Normal GAMESTATE_GAMELOOP state2 calls entity update717DF0, particle dispatch739CF0, then removal drain7185D0; alternate state3 has a different order.','717AF0 clears registry slot before virtual48 cleanup and virtual8 destruction, then decrements object count.'],limits=['Static normal-state2 call order is verified; complete runtime branch selection remains unqualified.','A stop requested by the post-particle removal drain is consumed on a subsequent particle pass; individual resource behavior is qualified separately.','No runtime implementation changed by this audit.'])
(r/'docs/projectile_removal_order_audit.json').write_text(json.dumps(proof,indent=2)+'\n');print('Verified phase call sequence and cleanup/destructor ordering')
