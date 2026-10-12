from pathlib import Path
import sys, json, hashlib, re
sys.path.insert(0, r'E:\OpenLeague\tools\pythonlibs')
import pefile, capstone

OUT = Path(__file__).resolve().parent
PREVIOUS = Path(r'E:\mapslol3v3\loading_standard_ui_preparation')
PRODUCTION = Path(r'E:\OpenLeague')
old = json.loads((PREVIOUS/'source_regions.json').read_text())
native_path = Path(old['native_executable'])
native = native_path.read_bytes()
digest = hashlib.sha256(native).hexdigest()
assert digest == old['native_sha256'] == '402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
pe = pefile.PE(data=native)
base = pe.OPTIONAL_HEADER.ImageBase
mapped = pe.get_memory_mapped_image()
image = mapped + bytes(pe.OPTIONAL_HEADER.SizeOfImage - len(mapped))
md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_32)
md.detail = True
def read(address, size):
    data = image[address-base:address-base+size]
    assert len(data) == size
    return data
def region(role, address, size, extent, status):
    data = read(address, size)
    return dict(role=role,address=address,va_hex=f'0x{address:08x}',rva=address-base,
                rva_hex=f'0x{address-base:08x}',size=size,hex=data.hex(),sha256=hashlib.sha256(data).hexdigest(),
                extent=extent,implementation_status=status)
regions = []
selected_roles = {
    'resource_provider':'missing_native_port_boundary_only',
    'resource_provider_lower_bound':'missing_native_port',
    'resource_provider_key_compare':'missing_native_port',
    'resource_provider_missing':'missing_native_port_and_lifecycle',
    'resource_provider_ctor':'missing_native_port_and_lifecycle',
    'resource_provider_vtable':'not_in_runtime_image',
    'byte_compare_primitive':'missing_exact_native_port',
    'resource_provider_global':'not_in_runtime_image_or_produced',
}
for item in old['regions']:
    if item['role'] in selected_roles:
        assert bytes.fromhex(item['hex']) == read(item['address'], item['size'])
        assert item['sha256'] == hashlib.sha256(read(item['address'], item['size'])).hexdigest()
        regions.append(region(item['role'],item['address'],item['size'],'frozen_static_region',selected_roles[item['role']]))
regions += [
    region('nonempty_name_and_skin_selection',0x57d6fe,0x57d775-0x57d6fe,'caller_slice_before_call','missing_caller_prefix'),
    region('package_provider_call_instruction',0x57d775,5,'single_call_instruction','explicit_next_boundary'),
    region('diagnostic_empty_literal',0x1085b2d,1,'nul_terminated_literal','missing_diagnostic_dispatch'),
    region('negative_skin_diagnostic_literal',0x10899d8,12,'nul_terminated_literal','missing_diagnostic_dispatch'),
    region('service_vtable_extra_slot',0x10afe8c+0x4c,4,'vtable_slot','already_in_runtime_image'),
    region('service_global',0x2d787b8,4,'global_word','already_mapped_normal_publication_missing'),
    region('resource_key_string_copy_entry_only',0x99a310,64,'entry_window_not_full_function','missing_port_requires_full_body_and_oracle'),
]
meta_path = Path(r'E:\mapslol3v3\loading_metadata_stage\loading_metadata_sources.json')
metadata = json.loads(meta_path.read_text())
meta_roles = {
    0x72ae40:('service_extra','ported_public_API'),
    0x728500:('metadata_extra','ported_public_API'),
    0x564af0:('string24_assign','private_non_alias_full_assignment_only'),
    0x564f30:('string24_growth','private_non_alias_full_assignment_only'),
    0x564900:('string24_reset_destroy','ported_tutorial_contract_not_standard_drop'),
}
for item in metadata['regions']:
    if item['address'] in meta_roles:
        assert bytes.fromhex(item['hex']) == read(item['address'], item['size'])
        role,status=meta_roles[item['address']]
        regions.append(region(role,item['address'],item['size'],'previous_native_source_region',status))

# Inspect the negative-skin diagnostic only. Calls are not followed or executed;
# out-of-window edges remain unresolved rather than inferred from neighboring code.
start=0x991e60
budget=0x1000
seen={}
todo=[start]
edges=[]
calls=[]
while todo:
    pc=todo.pop()
    while pc not in seen:
        if not start <= pc < start+budget:
            edges.append(dict(kind='outside_window',target=pc)); break
        ins=next(md.disasm(read(pc,15),pc,count=1),None)
        if ins is None:
            edges.append(dict(kind='undecoded',address=pc)); break
        seen[pc]=ins
        nextpc=pc+ins.size
        if ins.mnemonic=='call':
            calls.append(dict(address=pc,rva=pc-base,target=ins.operands[0].imm if ins.operands[0].type==capstone.x86.X86_OP_IMM else None,operand=ins.op_str))
        if ins.mnemonic.startswith('ret') or ins.mnemonic in ('int3','ud2'): break
        if ins.group(capstone.CS_GRP_JUMP):
            target=ins.operands[0].imm if ins.operands[0].type==capstone.x86.X86_OP_IMM else None
            if target is None: edges.append(dict(kind='indirect_jump',address=pc,operand=ins.op_str))
            else: todo.append(target)
            if ins.mnemonic=='jmp': break
        pc=nextpc
end=max(a+ins.size for a,ins in seen.items())
regions.append(region('negative_skin_diagnostic',start,end-start,'bounded_reachable_function_no_callees_executed','missing_native_dispatch'))
diagnostic=dict(address=start,rva=start-base,size=end-start,reachable_instructions=len(seen),calls=calls,unresolved_edges=edges)
(OUT/'diagnostic_static.txt').write_text('\n'.join(f'{a:08x} {i.mnemonic} {i.op_str}' for a,i in sorted(seen.items()))+'\n')
(OUT/'prefix_static.txt').write_text('\n'.join(f'{i.address:08x} {i.mnemonic} {i.op_str}' for i in md.disasm(read(0x57d6fe,0x7c),0x57d6fe))+'\n')
(OUT/'resource_key_copy_entry_static.txt').write_text('\n'.join(f'{i.address:08x} {i.mnemonic} {i.op_str}' for i in md.disasm(read(0x99a310,64),0x99a310))+'\n')
source_proof=dict(native_source=str(native_path),native_sha256=digest,image_base=base,static_only=True,
                  native_executed=False,regions=regions,negative_diagnostic=diagnostic)
(OUT/'source_regions.json').write_text(json.dumps(source_proof,indent=2)+'\n')

files = [
    'crates/core/src/audio_loading_screen_packet.rs','crates/core/src/audio_loading_screen_packet_tests.rs',
    'crates/core/src/audio_loading_metadata.rs','crates/core/src/audio_loading_metadata_tests.rs',
    'crates/core/src/audio_replay_windows_loading_packets.rs','crates/core/src/audio_replay_windows_loading_metadata.rs',
    'crates/core/src/audio_replay_windows_events.rs','crates/core/src/audio_replay_runtime_image.rs',
    'crates/core/src/audio_replay_engine_thread.rs','crates/core/src/audio_replay_loading_owner.rs',
    'crates/core/src/audio_replay_metadata_text.rs','crates/client/src/native_particle_class.rs',
    'data/4.20/runtime/replay_runtime_image_manifest.json',
]
snapshot=[]
for file in files:
    p=PRODUCTION/file
    snapshot.append(dict(path=str(p),bytes=p.stat().st_size,sha256=hashlib.sha256(p.read_bytes()).hexdigest()))
(OUT/'production_snapshot.json').write_text(json.dumps(snapshot,indent=2)+'\n')
package=json.loads((PRODUCTION/'data/4.20/runtime/replay_runtime_image_manifest.json').read_text())
coverage=[]
for name,address,size in [('service_global',0x2d787b8,4),('service_extra_vtable_slot',0x10afe8c+0x4c,4),
                          ('package_manager_global',0x2d78f1c,4),('skin_diagnostic_literal',0x10899d8,12),
                          ('empty_diagnostic_literal',0x1085b2d,1),('package_provider_vtable',0x10d64a8,0x30)]:
    owners=[r['name'] for r in package['regions'] if r['address']<=address and address+size<=r['address']+r['size']]
    coverage.append(dict(name=name,address=address,size=size,owner_regions=owners,mapped=bool(owners)))
(OUT/'runtime_data_coverage.json').write_text(json.dumps(coverage,indent=2)+'\n')
print(json.dumps({'static_only':True,'regions':len(regions),'bytes':sum(r['size'] for r in regions),
                  'diagnostic':diagnostic,'data_coverage':coverage}))
