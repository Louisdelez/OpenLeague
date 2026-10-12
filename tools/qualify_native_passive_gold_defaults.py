"""Original static CVA gold defaults and Map10 explicit source overrides."""
from pathlib import Path
import json,re,struct,datetime,hashlib,itertools
r=Path(__file__).resolve().parents[1]
exec(compile((r/'tools/qualify_native_camera_random_shake.py').read_text(encoding='utf-8').split('sequences=[]')[0],'setup','exec'))
allowed.extend([(0x4fe3f0,0x4fe464),(0x4fe710,0x4fe784),(0x5642d0,0x5642d1),(0x9933e0,0x9933e1),(0x6b5e10,0x6b5e11)])
node=heap+0xb000;calls=[]
def config_hook(uc,a,size,user):
 sp=u.reg_read(UC_X86_REG_ESP)
 if a==0x5642d0:
  calls.append({'call':'diagnostic','format':cbytes(read32(sp+4)).decode(),'name':cbytes(read32(sp+8)).decode()});finish()
 elif a==0x9933e0:
  assert read32(sp+4)==12;calls.append({'call':'allocate','bytes':12});finish(eax=node)
 elif a==0x6b5e10:
  assert u.reg_read(UC_X86_REG_ECX)==node;calls.append({'call':'register','variable':read32(read32(sp+4))});finish(pop=4)
u.hook_add(unicorn.UC_HOOK_CODE,config_hook)
cases=[]
for entry,state in itertools.product([(0x4fe3f0,0x123a338,'ai_AmbientGoldAmount'),(0x4fe710,0x123a378,'ai_AmbientGoldInterval')],[0,node]):
 start,variable,name=entry;calls=[];write32(0x2d78a58,state);u.mem_write(node,b'\xa5'*12);write32(variable+12,0xdeadbeef);run(start)
 assert calls[0]['name']==name and calls[0]['format']=='CVA Reg %s\n';assert calls[-1]['variable']==variable
 expected_alloc=state==0;assert any(c['call']=='allocate' for c in calls)==expected_alloc;assert read32(0x2d78a58)==node
 cases.append({'entry':start,'variable':variable,'name':name,'initial_registry':state,'value_bits':read32(variable+12),'vtable':read32(variable),'registry_words':list(struct.unpack('<3I',u.mem_read(node,12))),'calls':calls})
assert {c['name']:struct.unpack('<f',struct.pack('<I',c['value_bits']))[0] for c in cases}=={'ai_AmbientGoldAmount':8.,'ai_AmbientGoldInterval':5.}
source=Path(json.loads((r/'data/4.20/camera_map10_settings.json').read_text(encoding='utf-8'))['source']);text=source.read_text(encoding='utf-8-sig');keys=['ai_AmbientGoldDelay','ai_AmbientGoldInterval','ai_DisableAmbientGoldWhileDead','ai_AmbientGoldDelayFirstBlood'];values={}
for key in keys:
 m=re.search(r'^'+re.escape(key)+r'\s*=\s*([-+0-9.]+)',text,re.M);assert m,key;values[key]=float(m.group(1))
assert re.search(r'^ai_AmbientGoldAmount\s*=',text,re.M) is None
limits=['Full native static amount/interval initializers executed; diagnostic/allocation/registry adapters record arguments. Runtime CVA file parsing/globalpatching not qualified.','Nativedefault8gold/5seconds, Map10delay75/interval5/deadflag0 directly recovered. Amount absent from suppliedMap10Constants.var; using native default, not community9.5.','Original server payment cadence and precise first boundary not recovered. Reconstructed discrete8gold payments starting75seconds at150tick intervals; latejoins wait nextglobalboundary.','FirstBlood delay30 setting recorded for mode investigation, not switched after ordinary CLASSIC firstblood. Item/mastery/champion/altar passiveincome modifiers still unqualified; no invented fallback.','Existing killreward and fullgame coverage retain unresolved nativebounty/XP/assist/VFX/audio/services scope.']
contract={'native_executable_sha256':digest,'passed':True,'complete':False,'cases':cases,'map_source':str(source),'map_source_sha256':hashlib.sha256(source.read_bytes()).hexdigest(),'map_values':values,'amount_override_present':False,'limits':limits};(r/'data/4.20/passive_gold_native_contract.json').write_text(json.dumps(contract,indent=2)+'\n',encoding='utf-8')
rules={'amount':8.,'interval_seconds':values['ai_AmbientGoldInterval'],'delay_seconds':values['ai_AmbientGoldDelay'],'disable_while_dead':bool(values['ai_DisableAmbientGoldWhileDead']),'first_blood_mode_delay_seconds':values['ai_AmbientGoldDelayFirstBlood'],'limits':limits};(r/'data/4.20/passive_gold_rules.json').write_text(json.dumps(rules,indent=2)+'\n',encoding='utf-8');print('Native amount/interval:',len(cases),'initializers; Map10delay75, amount8, interval5, deadflag0')
