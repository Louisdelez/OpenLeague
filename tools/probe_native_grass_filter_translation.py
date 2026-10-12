from pathlib import Path
import json,struct,hashlib,datetime,itertools
r=Path('E:/OpenLeague')
source=Path('E:/mapslol3v3/probe_native_grass_constant_upload.py').read_text(encoding='utf-8').split('quad=json.loads')[0]
exec(compile(source,'sampler setup','exec'));cases=[]
for stage,key,value in itertools.product([0,1,15],[4,5,6],[0,1,2,3]):
 samplers=[];w(driver+0x164+(stage*8+key)*4,0xffffffff)
 w(stack,end);w(stack+4,stage);w(stack+8,key);w(stack+12,value);u.reg_write(UC_X86_REG_ESP,stack);u.reg_write(UC_X86_REG_ECX,driver)
 u.emu_start(0x9c2270,end,count=1000);assert u.reg_read(UC_X86_REG_EIP)==end
 if samplers!=[[stage,key+1,value]]:print('Translation difference',stage,key,value,samplers,flush=True)
 assert len(samplers)==1 and samplers[0][:2]==[stage,key+1]
 cases.append(dict(stage=stage,key=key,abstract_value=value,device_calls=list(samplers)))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),passed=True,complete=False,native_sha256=hashlib.sha256(raw).hexdigest(),entry='0x9c2270',original_instruction_addresses=len(visited),cases=cases,runtime_adapters=['Actualcache/enumtranslation/dispatch run; D3DSetSamplerStateAPI returnsS_OK andrecordsarguments.'],limits=['TranslationnotGPUacceptance: abstract3mapsD3D4, notanisotropic3; unsupportedbyRust. NONE0isnotacceptedforMAG/MIN. Rustsupportlimitedto point/linearMAG/MINandNONE/POINT/LINEARmip.', 'Doesnotestablishactualmaskdrawinheritedfilterproducer.'])
(r/'data/4.20/grass_filter_translation_contract.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
print(json.dumps(dict(cases=len(cases),native_addresses=len(visited))))
