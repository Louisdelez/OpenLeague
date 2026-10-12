from pathlib import Path
import hashlib,json,struct
import pefile
source=Path(r'D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe')
expected='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
raw=source.read_bytes();digest=hashlib.sha256(raw).hexdigest();assert digest==expected
pe=pefile.PE(data=raw);assert pe.FILE_HEADER.Machine==0x14c and pe.OPTIONAL_HEADER.Magic==0x10b and pe.OPTIONAL_HEADER.ImageBase==0x400000
mapped=pe.get_memory_mapped_image();image=mapped+bytes(pe.OPTIONAL_HEADER.SizeOfImage-len(mapped))
regions=[
 ('crt_initialized_data',0,0x1222830,0xf00),
 ('crt_zero_initialized_storage',0,0x14ae5b0,0xc00),
 ('crt_dispatch_table',0,0x2da5300,33*4),
 ('transport_global_mutex_and_thread_pair',1,0x2d6ed50,40),
 ('transport_logger_and_counters',1,0x2d78ec0,0x5c),
 ('transport_allocation_functions',1,0x1225878,8),
 ('transport_thread_control_vtable',1,0x1085f2c,12),
 ('transport_logger_callback_vtable',1,0x1086078,12),
 ('transport_log_buffer',1,0x2d8d358,2560),
 ('transport_configuration_vtable',1,0x10d5fa4,8),
 ('transport_uid_and_validation_scratch',1,0x2d8dd58,144),
 ('stream_key_initial_tables',1,0x10dd320,4168),
 ('stream_transport_primary_vtable',1,0x10d6040,8),
 ('stream_transport_interface_vtable',1,0x10d6254,48),
 ('stream_transport_control_vtable',1,0x10d5fdc,12),
 ('stream_object_vtable',1,0x10d5f34,32),
 ('stream_state_machine_vtable',1,0x10d607c,40),
 ('stream_null_control_vtable',1,0x1085f4c,12),
 ('stream_manager_control_vtable',1,0x10d6030,12),
 ('stream_null_implementation_vtable',1,0x10d5fec,48),
 ('logger_composite_callback_vtable',1,0x10d5f64,12),
 ('recording_control_vtable',1,0x1085f8c,12),
 ('diagnostic_path_singleton_flag',1,0x2d8bab4,4),
 ('diagnostic_path_singleton_storage',1,0x2d8bac0,0x10a8),
 ('parent_metadata_vtable',1,0x10b00c4,100),
 ('parent_metadata_base_vtable',1,0x10b0138,4),
 ('parent_callback12_vtable',1,0x108606c,12),
 ('service_callback16_vtable',1,0x109b2d4,12),
 ('parent_callback_family_vtables',1,0x10afcfc,48),
 ('parent_callback_final_vtable',1,0x10afd34,12),
 ('parent_bundle_and_object_vtables',1,0x10b0128,8),
 ('game_service_vtable',1,0x10afe8c,180),
 ('game_service_curve_controls',1,0x1224d84,32),
 ('parent_current_identifier',1,0x123df84,4),
 ('parent_static_storage',1,0x2d78240,68),
 ('parent_singleton_registration',1,0x2d78288,1),
 ('parent_singleton_reinitialize',1,0x2d784e6,1),
 ('parent_singleton_pointer',1,0x2d78520,4),
 ('service_open_extra',1,0x2d62a48,4),
 ('service_receive_local_owner',1,0x2d62878,4),
 ('service_owner_metadata_global',1,0x2d787b8,4),
 ('service_owner_sentinel',1,0x2d5f448,4),
 ('owner_metadata_default',1,0x123b12c,4),
 ('owner_metadata_vtables',1,0x10a0360,48),
 ('service_packet_switch_targets',1,0x58c1ac,496),
 ('service_packet_switch_indices',1,0x58c39c,301),
 ('packet95_receiver_pair',1,0x14c761c,8),
 ('loading_control_vtables',1,0x1085e5c,32),
 ('loading_language_literal',1,0x1088ab0,6),
 ('loading_language_global',1,0x2d78d08,4),
 ('loading_active_global',1,0x2d77e44,4),
 ('loading_tutorial_constructor_flag',1,0x14c758b,1),
 ('replay_packet_object_vtable',1,0x10d6048,12),
 ('process_clock_origin_and_frequency',1,0x14bef48,16),
 ('process_clock_frequency_ready',1,0x2d79080,1),
 ('process_clock_frequency_cache',1,0x2d79158,8),
 ('process_clock_once_flag',1,0x2d75530,4),
 ('process_clock_callback_vtable',1,0x10de608,4),
 ('process_clock_mutex_ready',1,0x14af61c,1),
 ('process_clock_mutex_pointer',1,0x14af620,4),
 ('process_clock_outer_state_and_section',1,0x14b1840,28),
 ('loading_package_manager_global',1,0x2d78f1c,4),


 ('loading_resource_hash_globals',1,0x2d6edf0,16),
 ('loading_resource_static_initializer_table',1,0xfa6b74,16),
 ('loading_resource_manager_vtable',1,0x10d6450,8),
 ('loading_resource_configuration_literal',1,0x10d666c,16),
 ('loading_resource_shared_literal',1,0x10bf2d4,9),
 ('loading_resource_forwarding_literal',1,0x10d6880,13),
 ('loading_resource_interface_literal',1,0x10d6b34,12),
 ('loading_resource_configuration_hash_slot',1,0x10d640c,4),
 ('loading_resource_interface_hash_slot',1,0x10d6320,4),
 ('loading_resource_shared_hash_slot',1,0x10d62ec,4),
 ('loading_resource_forwarding_hash_slot',1,0x10d6354,4),
]
output=bytearray(b'OL420RT\0'+struct.pack('<II',1,len(regions))+bytes.fromhex(digest));manifest=[]
for name,group,address,size in regions:
 rva=address-pe.OPTIONAL_HEADER.ImageBase
 sections=[s for s in pe.sections if s.VirtualAddress<=rva and rva+size<=s.VirtualAddress+max(s.Misc_VirtualSize,s.SizeOfRawData)]
 assert len(sections)==1,(name,hex(address),size)
 data=image[rva:rva+size];assert len(data)==size
 offset=len(output)+12;output+=struct.pack('<III',group,address,size)+data
 manifest.append({'name':name,'group':group,'address':address,'size':size,'payload_offset':offset,'section':sections[0].Name.rstrip(b'\0').decode('ascii'),'sha256':hashlib.sha256(data).hexdigest()})
stage=Path('E:/mapslol3v3/loading_resource_manager_integration');(stage/'replay_runtime_image.bin').write_bytes(output)
proof={'schema':1,'native_source':str(source),'native_sha256':digest,'image_base':pe.OPTIONAL_HEADER.ImageBase,'production_data':True,'extraction':'Initial PE32 mapped bytes; no emulator execution, test fixture, patched API pointer, constructed thread or captured runtime state. Uninitialized section bytes use the PE loader zero-fill.','regions':manifest,'package_sha256':hashlib.sha256(output).hexdigest(),'package_bytes':len(output)}
(stage/'replay_runtime_image_manifest.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'regions':len(regions),'bytes':len(output),'package_sha256':proof['package_sha256'],'native_sha256':digest}))
