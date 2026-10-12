"""Compare every champion regeneration coefficient directly to original inibin fields."""
from pathlib import Path
import ast,struct,json,hashlib
root=Path(__file__).resolve().parents[1]
parser=Path(r'E:\mapslol3v3\tools\import_all_champions.py')
tree=ast.parse(parser.read_text(encoding='utf-8'))
selected=ast.Module(body=[n for n in tree.body if isinstance(n,ast.FunctionDef) and n.name in ['ini','hashkey']],type_ignores=[])
namespace={'struct':struct}
exec(compile(selected,'pure-native-inibin-parser','exec'),namespace)
ini,key=namespace['ini'],namespace['hashkey']
deploy=Path(r'D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy')
resources=json.loads((root/'data/4.20/champion_resources.json').read_text(encoding="utf-8"))
growth=json.loads((root/'data/4.20/champion_growth_420.json').read_text(encoding="utf-8"))
fields={'health_regen':'BaseStaticHPRegen','mana_regen':'BaseStaticMPRegen','health_regen_growth':'HPRegenPerLevel','mana_regen_growth':'MPRegenPerLevel'}
checks=[];mismatches=[]
for name,resource in resources.items():
    source=deploy/resource['resource'];native=ini(source)
    values={}
    for output,field in fields.items():
        value=native.get(key('Data',field),0)
        values[field]=value
        if abs(float(value)-growth[name][output])>0.00001:mismatches.append({'champion':name,'field':field,'native':value,'table':growth[name][output]})
    checks.append({'champion':name,'source':str(source),'sha256':hashlib.sha256(source.read_bytes()).hexdigest(),'values':values})
result={'checked':len(checks),'passed':not mismatches,'mismatches':mismatches,'native_coefficients':checks,'limits':['Native numeric coefficient agreement only; item/passive/healing-reduction modifiers and native runtime timing remain unqualified.']}
(root/'docs/native_regeneration_validation.json').write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'checked':len(checks),'passed':not mismatches,'mismatches':mismatches}))
raise SystemExit(bool(mismatches))
