from pathlib import Path
import importlib.util,json,sys
sys.dont_write_bytecode=True
OUT=Path(__file__).resolve().parent
path=Path(r'E:\OpenLeague\docs\loading_standard_resource_preparation\extract_resource.py')
spec=importlib.util.spec_from_file_location('index_native_source',path)
source=importlib.util.module_from_spec(spec);spec.loader.exec_module(source)
regions=[];texts=[]
for item in [('index_slot',0x5bd9b0,0x100),('index_node',0x5d2710,0x40),('allocate24',0x5d54a0,0x40),('hint',0x5d2950,0x220),('insert',0x5da5e0,0x200),('decrement',0x5ccfe0,0x80),('rotate_left',0x5c64e0,0x60),('rotate_right',0x5c6540,0x60)]:
    region,text=source.walk(*item);assert not region['edges'],item
    regions.append(region);texts.append(text)
(OUT/'source_index_read_regions.json').write_text(json.dumps({'source':str(source.EXE),'source_sha256':source.digest,'regions':regions},indent=2)+'\n')
(OUT/'source_index_read_functions.txt').write_text('\n\n'.join(texts)+'\n')
print(json.dumps({'regions':len(regions),'outside_edges':0,'source_sha256':source.digest}))
