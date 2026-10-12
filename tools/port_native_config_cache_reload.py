from pathlib import Path
import shutil,json
r=Path('E:/OpenLeague');stage=Path(__file__).parent
shutil.copy2(stage/'native_config_cache_reload.rs',r/'crates/client/src/native_config_cache_reload.rs')
p=r/'crates/client/src/main.rs';text=p.read_text(encoding='utf-8')
if 'mod native_config_cache_reload;' not in text:text='mod native_config_cache_reload;\n'+text
p.write_text(text,encoding='utf-8')
# Correct the scope wording of the successful control-flow proof; executable
# branches and fixtures are unchanged by this metadata correction.
p=r/'data/4.20/native_config_cache_reload_flow_contract.json';proof=json.loads(p.read_text(encoding='utf-8'))
proof['adapters'][-1]='Original cache control flow, lowercase/slash normalization, defaults construction, Spells exclusions, overlay decisions, replacement, dirty clearing, last-entry update and localized filename8B2ED0 branches execute.'
proof['adapters'].append('Localized file predicate8B5170 supplies controlled booleans; native filesystem/resource predicate implementation not executed. Standard character/c-string append, comparison, bounded output copy and string boundary calls adapted. ASCII locale/global flag supplied; no localized file created.')
proof['limits'][0]='Cache control-flow/call contract only; original path resolver, constructor contents, dictionary allocation/lookup/lifetime, loader/file handling and localized file predicates remain open.'
p.write_text(json.dumps(proof,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
for name in ['port_native_config_cache_reload.py','native_config_cache_reload.rs','qualify_native_config_cache_reload_flow.py']:shutil.copy2(stage/name,r/'tools'/name)
print('Native reload call plan ported; constructor/resource I/O/cache ownership remain open.')
