from pathlib import Path
import json,zipfile,hashlib,datetime,shutil,re
r=Path('E:/OpenLeague');archive=r/'data/4.20/archives/menu/HUD.zip';archive_sha=hashlib.sha256(archive.read_bytes()).hexdigest();audit=json.loads((r/'data/4.20/native_hud_layout_source_audit.json').read_text(encoding='utf-8'));root=r/'data/4.20/hud_restored'
with zipfile.ZipFile(archive) as z:
 target=z.read('HUD/Elements/TargetBar_Buffs.ini');loss=z.read('HUD/Elements/LossOfControlUI.ini')
file=next(f for f in audit['files'] if f['path']=='HUD/Elements/TargetBar_Buffs.ini');records={c.get('Name'):c for c in file['records']};siblings=[records['TargetBuffCooldown'+str(i)] for i in range(7)]
colors={v['EffectColor1'] for v in siblings};assert colors=={'64, 64, 64, 100'} and 'EffectColor1' not in records['TargetBuffCooldown7'];assert target.endswith(b'EffectColor0: 0, 0, 0, 100')
assert b'BaseOffset:' not in loss
restored_target=target+b'\r\nEffectColor1: 64, 64, 64, 100\r\n';restored_loss=b'BaseOffset: 0,0\r\n'+loss
assets=[]
for path,old,new,reason in [('HUD/Elements/TargetBar_Buffs.ini',target,restored_target,'Append missingEffectColor1 using unanimous values in seven neighboring cooldown blocks; reconstructed, not claimed original missing bytes.'),('HUD/Elements/LossOfControlUI.ini',loss,restored_loss,'Prepend explicit zeroBaseOffset to enable qualified raw-stream header guard; supplied origin inferred for reconstruction, original alternative-loading path remains unknown.')]:
 dest=root/path;dest.parent.mkdir(parents=True,exist_ok=True);dest.write_bytes(new);assets.append(dict(requested=path,restored_path=str(dest.relative_to(r)).replace('\\','/'),original_sha256=hashlib.sha256(old).hexdigest(),restored_sha256=hashlib.sha256(new).hexdigest(),reason=reason,provenance='reconstructed_from_source_patterns',runtime_selected=False))
# Qualify the corrected final element through the original header/factory/property pipeline.
exec(compile((r/'tools/qualify_native_hud_source_records.py').read_text(encoding='utf-8').split('\naudit=json.loads')[0],'HUD repaired record prerequisites','exec'))
data=restored_target;u.mem_write(source_ptr,data+b'\0'*128);m=list(re.finditer(rb'(?m)^Type:',data))[-1];u.mem_write(owner,b'\0'*0x300);w(owner+4,named_registry);w(owner+0x1c4,sentinel);u.mem_write(obj,b'\xa5'*0x400);u.mem_write(origin,b'\0'*8)
for off,storage in [(0x24,all_list),(0x30,effect_list)]:w(owner+off,storage);w(owner+off+4,storage);w(owner+off+8,storage+64)
w(cursor,source_ptr+m.start());w(cursor+4,len(data)-m.start());w(kind_ptr,0);u.mem_write(name_ptr,b'\xa5'*64);warnings=0;events.clear()
invoke(0x9a5570,[cursor,kind_ptr,name_ptr]);assert u.reg_read(UC_X86_REG_EAX)&255==1;current_kind=read(kind_ptr);assert current_kind==2
w(0x14ae664,0);w(0x1222f40,0);invoke(0x9a52a0,[name_ptr,current_kind],owner);w(obj+0x1d8,0x3f800000);invoke(0x9a1a60,[cursor,obj,origin],owner)
assert u.reg_read(UC_X86_REG_EAX)&255==1 and read(obj+0x218)==0x64404040 and warnings==0
repaired_record=dict(name='TargetBuffCooldown7',accepted=True,warnings=0,color1_bgra_word=hex(read(obj+0x218)),input_hex=data[m.start():].hex(),output_hex=bytes(u.mem_read(obj,0x284)).hex(),consumed=read(cursor)-source_ptr-m.start())
# Independently qualify raw file header acceptance for both derived files.
exec(compile((r/'tools/qualify_native_hud_file_header.py').read_text(encoding='utf-8').split('\naudit=json.loads')[0],'HUD repaired headers prerequisites','exec'))
headers=[]
for path,data in [('HUD/Elements/TargetBar_Buffs.ini',restored_target),('HUD/Elements/LossOfControlUI.ini',restored_loss)]:
 size=len(data);u.mem_write(source_ptr,data+b'\0'*64);u.mem_write(file_name,path.encode('ascii')+b'\0');u.mem_write(owner,b'\0'*0x300);w(0,0);outcome=None;assignments=None;origin_bits=None;w(stack,end);w(stack+4,file_name);w(stack+8,fs);w(stack+12,0);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,owner);u.emu_start(0x9a3080,end,count=100000)
 assert outcome=='passed_header_boundary' and assignments==2 and origin_bits==[0,0];headers.append(dict(path=path,accepted_header=True,origin_bits=origin_bits))
assert hashlib.sha256(archive.read_bytes()).hexdigest()==archive_sha
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,original_archive_sha256=archive_sha,original_archive_unchanged=True,assets=assets,repaired_record=repaired_record,native_repaired_header_cases=headers,limits=['Two derived source repairs only; original archive preserved.','Missing color reconstructed from seven identical sibling values; zeroBaseOffset explicitly supplied, not claimed historical native fallback.','Original native property validation/header guard accept repaired inputs; complete file/resource loader and Rust/runtime use of derived files remain unverified.','No rendered HUD or complete game claim.'])
(root/'manifest.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');(r/'docs/native_hud_source_restoration.json').write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
print(json.dumps(dict(passed=True,derived_assets=2,original_archive_unchanged=True,native_repaired_record_accepted=True,native_repaired_headers=2,runtime_selected=False)))
