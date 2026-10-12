from pathlib import Path
import json,hashlib
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_projectile_team_visibility.py').read_text().split('\nrows=[]')[0],'setup','exec'))
rows=[]
for state in ['absent','expired','live']:
 for a,n in [(provider,0x60),(body,0x600),(handle,0x20),(owner_control,0x20)]:u.mem_write(a,b'\0'*n)
 w(provider,0x10b0d20);w(body,0x10b2b5c)
 if state!='absent':
  w(provider+4,handle);w(provider+8,owner_control);w(handle,body);w(owner_control+4,30 if state=='live' else 0);w(owner_control+8,30)
 result=bool(run(0x718ed0,provider,[])&255);assert result==(state=='live'),(state,result)
 rows.append(dict(owner_state=state,visible=result))
proof=dict(complete=False,passed=True,native_sha256=hashlib.sha256(raw).hexdigest(),cases=rows,findings=['Provider table10B0D20 slot20 ->718ED0 acquires weak owner and calls body virtual98.','Concrete projectile body table10B2B5C slot98 ->586220 is mov al,1; ret.','Absent or expired owner returns false; live projectile body returns true independently of FOW.'],limits=['Concrete projectile provider only; other actor bodies and root team filter/mask producers remain open.','Material GPU FOW attenuation is separate and is already bound in fow_visibility_texture::bind_materials.','No full match visibility acceptance.'])
(r/'data/4.20/projectile_provider_visibility_contract.json').write_text(json.dumps(proof,indent=2)+'\n');print(json.dumps(proof))
