from pathlib import Path
import hashlib,json,sys,datetime
sys.path.insert(0,'E:/OpenLeague/tools/pythonlibs')
import pefile
out=Path(__file__).resolve().parent
exe=Path('D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe')
raw=exe.read_bytes();digest=hashlib.sha256(raw).hexdigest();assert digest=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
pe=pefile.PE(data=raw);image=pe.get_memory_mapped_image();base=pe.OPTIONAL_HEADER.ImageBase
specs=[('wrapper_init',0x577d10,0xe0),('wrapper_construct',0x576280,0x184),('wrapper_destroy',0x576410,0x118),('global_publish',0x5c7e30,0x68),('global_control',0x5d7750,0xc4),('nested_publish',0x5c7d10,0x62),('nested_control',0x5d7680,0xc5),('global_dispose',0x5ddb80,0x31),('nested_dispose',0x5ddb70,15),('screen_selection',0x5765f0,0x2f0),('tutorial_constructor_window',0x5b2bb0,0x210),('tutorial_consumer',0x5b3230,0x9b),('standard_consumer',0x57d650,0x6bc),('standard_constructor_window',0x578460,0x140),('firstblood_constructor',0x71ecb0,0xe0),('nightmare_constructor_window',0x7226a0,0x160),('factory_register',0x72e2a0,0xe5),('component_constructors',0x730460,0x180),('factory_descriptor',0x732e50,0x9e),('factory_callback_window',0x7347f0,0x80),('factory_forward',0x730e00,0x16),('factory_invoke',0x7357e0,16),('factory_member_call',0x736440,0xa1),('virtual8_thunk',0x66a0ff,5),('standard_factory',0x71e9f0,0xa6),('firstblood_factory',0x71eaa0,0xa6),('nightmare_factory_window',0x71eb50,0xd0),('standard_record_lookup',0x5be170,0x77),('tutorial_record_lookup',0x5be1f0,0x7b),('standard_record_construct',0x576000,0x6d),('tutorial_record_construct',0x5e3da0,0x5f),('standard_node_alloc',0x5d5730,0x3a),('tutorial_node_alloc',0x5d57b0,0x37),('standard_value_alloc',0x5d32b0,0x30),('tutorial_value_alloc',0x5d34f0,0x3b),('tutorial_vtable',0x10863fc,20),('standard_vtable',0x1084ea4,32),('firstblood_vtable',0x10b0220,32),('nightmare_vtable',0x10b0200,32),('owner_control_vtables',0x1085e5c,32),('callback_vtable',0x10afce0,28),('callback_nested_vtable',0x10afc74,28),('component_vtables',0x10afdd0,36),('selection_strings',0x1088ab0,0xa0)]
regions=[]
for role,a,size in specs:
    data=image[a-base:a-base+size];assert len(data)==size
    regions.append({'role':role,'address':a,'size':size,'hex':data.hex(),'sha256':hashlib.sha256(data).hexdigest()})
(out/'recipient_sources.json').write_text(json.dumps({'native_sha256':digest,'analysis_only':True,'regions':regions},indent=2)+'\n')
# Confirm the prior qualified port's manifest members remain byte-identical.
prior=Path('E:/mapslol3v3/replay_packet95_agent/packet95_receipt.json'); receipt=json.loads(prior.read_text())
for entry in receipt['files']:
    f=Path(entry['path']);assert hashlib.sha256(f.read_bytes()).hexdigest()==entry['sha256'],f
files=[p for p in out.iterdir() if p.is_file() and p.name!='recipient_audit_manifest.json']
manifest={'created_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'scope':'Static identification of packet95 loading-screen recipients; next-lot preparation only','native_sha256':digest,'integrated':False,'complete':False,'native_execution_performed':False,'rust_compilation_performed':False,'network_executable_started':False,'production_modified':False,'qualified_prior_port_manifest_members_unchanged':True,'prior_receipt_sha256':hashlib.sha256(prior.read_bytes()).hexdigest(),'source_regions':len(regions),'source_bytes':sum(r['size'] for r in regions),'recipient_slot0':[0x57d650,0x5b3230],'payload_bytes_copied':25,'next_step':'Port and native-qualify57D650/5B3230, record lookups5BE170/5BE1F0 and their real UI dependencies; qualify constructors/publication/lifetime before connecting active recipient.','files':[{'path':str(p),'bytes':p.stat().st_size,'sha256':hashlib.sha256(p.read_bytes()).hexdigest()} for p in sorted(files)]}
(out/'recipient_audit_manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
print(json.dumps({k:manifest[k] for k in ['source_regions','source_bytes','native_execution_performed','qualified_prior_port_manifest_members_unchanged']}))
