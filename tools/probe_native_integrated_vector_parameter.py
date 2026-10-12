"""Original94AA60 integrated-vector fixture flags1/2, not caller binding claims."""
from pathlib import Path
import shutil,json
r=Path('E:/OpenLeague');vector_parameter_source=(r/'tools/probe_native_vector_parameter.py').read_text(encoding='utf-8')
for mode in [1,2]:
 modified=vector_parameter_source.replace('write32(sp+28,0)','write32(sp+28,'+str(mode)+')').replace("for name,fields,key,default,count in inputs:","for name,fields,key,default,count in [v for v in inputs if not v[0].startswith('map:')]:").replace("'rotation_mode':0","'rotation_mode':"+str(mode)).replace('vector_parameter_contract.json',f'integrated_vector_parameter_mode{mode}_contract.json').replace('Nonrotation only; native','Integrated-mode fixtures only; native')
 exec(compile(modified,f'integrated vector mode{mode}','exec'))
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
