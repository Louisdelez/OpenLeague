from pathlib import Path
import hashlib,json
import pefile
out=Path('E:/mapslol3v3/replay_metadata_text_agent')
prior=json.loads(Path('E:/mapslol3v3/replay_manager_agent/metadata_setter_sources.json').read_text())
path=Path(prior['native_source']);raw=path.read_bytes();digest=hashlib.sha256(raw).hexdigest()
assert digest=='402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862'
pe=pefile.PE(data=raw);base=pe.OPTIONAL_HEADER.ImageBase
roles={'put_string_extra','put_string_c','find_composite','copy_pair_extra','copy_pair_string','create_node56','insert_node56','create_node48','insert_node48','link_rebalance56','link_rebalance48','erase_string_node'}
regions=[r for r in prior['regions'] if r['role'] in roles]
for address,length,role in [(0x564900,0x50,'destroy_sso'),(0x564af0,0x130,'copy_sso_substring'),(0x564c20,0x100,'assign_bytes'),(0x564f30,0x190,'grow_sso'),(0x5fe7f0,0x63,'move_sso'),(0x735740,0x38,'allocate_node56'),(0x663fd0,0x38,'allocate_node48'),(0x5c23e0,0x60,'iterator_successor'),(0x5ccfe0,0x60,'iterator_predecessor'),(0x5c64e0,0x60,'rotate_left'),(0x5c6540,0x60,'rotate_right'),(0x5c65a0,0x20,'maximum')]:
 data=pe.get_data(address-base,length);regions.append({'address':address,'length':length,'role':role,'sha256':hashlib.sha256(data).hexdigest(),'hex':data.hex()})
for r in regions:
 data=pe.get_data(r['address']-base,r['length']);assert data.hex()==r['hex'] and hashlib.sha256(data).hexdigest()==r['sha256']
out.joinpath('metadata_text_sources.json').write_text(json.dumps({'native_source':str(path),'native_sha256':digest,'regions':regions,'runtime_image_additions':[]},indent=2)+'\n')
proof=json.loads(out.joinpath('replay_metadata_text_probe.json').read_text());visited=set(proof['native_code_visited'])
branches={'two_child_transplant':0x5c4740,'successor_is_right_child':0x5c474c,'successor_below_right_child':0x5c4750,'left_red_sibling':0x5c47cd,'left_near_red_rotation':0x5c4807,'left_final_rotation':0x5c481c,'right_red_sibling':0x5c4847,'right_near_red_rotation':0x5c4898,'right_final_rotation':0x5c48ad,'black_sibling_recolor':0x5c4873,'root_or_red_exit':0x5c4887}
out.joinpath('native_branch_observations.json').write_text(json.dumps({k:{'address':hex(a),'executed':hex(a) in visited} for k,a in branches.items()},indent=2)+'\n')
print(json.dumps({'regions':len(regions),'native_sha256':digest,'runtime_image_additions':0}))
