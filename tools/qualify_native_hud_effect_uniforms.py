from pathlib import Path
import json,struct,datetime,hashlib
r=Path('E:/OpenLeague')
exec(compile((r/'tools/probe_native_hud_formatted_scanner.py').read_text(encoding='utf-8').split('\nu.hook_add(')[0],'HUD effect prerequisites','exec'))
element=vector+0x6000;instance=vector+0x7000;visited=set()
def hook(uc,address,size,user):
 visited.add(address)
 if address==0x9a3574:uc.reg_write(UC_X86_REG_EIP,end)
u.hook_add(unicorn.UC_HOOK_CODE,hook)
source=json.loads((r/'data/4.20/native_hud_source_records_contract.json').read_text(encoding='utf-8'));inputs=[]
for c in source['cases']:
 if c['kind']==2 and c['accepted']:inputs.append((c['path']+'@'+str(c['offset']),bytes.fromhex(c['output_hex'])))
repair=json.loads((r/'docs/native_hud_source_restoration.json').read_text(encoding='utf-8'));inputs.append(('restored TargetBuffCooldown7',bytes.fromhex(repair['repaired_record']['output_hex'])))
for v in range(256):
 data=bytearray(0x284);struct.pack_into('<I',data,0x40,2);data[0x214:0x21c]=bytes([v,(v*3)%256,255-v,(v*7)%256,(v*11)%256,v,(v*13)%256,255-v]);struct.pack_into('<4I',data,0x204,0x80000000,0x7fc01234,0x7f800000,v<<24);inputs.append(('byte-edge-'+str(v),bytes(data)))
cases=[]
for label,data in inputs:
 u.mem_write(element,data);u.mem_write(instance,b'\xa5'*0x80);u.reg_write(UC_X86_REG_EDI,element);u.reg_write(UC_X86_REG_ECX,instance);u.reg_write(UC_X86_REG_MXCSR,0x1f80);u.emu_start(0x9a3496,end,count=2000);assert u.reg_read(UC_X86_REG_EIP)==end
 out=bytes(u.mem_read(instance,0x80));assert read(element+0x200)==instance
 assert out[0x24:0x34]==data[0x204:0x214]
 assert out[:0x24]==b'\xa5'*0x24 and out[0x54:]==b'\xa5'*(0x80-0x54)
 cases.append(dict(label=label,params_hex=data[0x204:0x214].hex(),colors_bgra_hex=data[0x214:0x21c].hex(),output_hex=out[0x24:0x54].hex()))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),case_count=len(cases),native_addresses=len(visited),factor_bits=read(0x1138a30),cases=cases,limits=['Original9A3496..9A3574 instructions execute with supplied element/instance storage and MXCSR1F80.','Effect lookup, instance allocation/lifetime, textures, groups, GPU execution and drawing remain separate.','Nonfinite parameter bits copied verbatim, not treated as validated gameplay values.'])
(r/'data/4.20/native_hud_effect_uniforms_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8');print(json.dumps(dict(passed=True,cases=len(cases),native_addresses=len(visited),factor_bits=hex(proof['factor_bits']))))
