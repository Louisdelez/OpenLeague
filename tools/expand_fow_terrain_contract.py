from pathlib import Path
r=Path('E:/OpenLeague')
s=(r/'tools/probe_fow_terrain_ray.py').read_text(encoding='utf-8')
s=s.replace('for starts_in_brush in [False,True]:','for starts_in_brush,source_metric in [(False,0.),(True,0.),(True,64.),(True,512.)]:')
s=s.replace('u.mem_write(bits,bytes(8));',"u.mem_write(desc,struct.pack('<f',source_metric));u.mem_write(bits,bytes(8));")
s=s.replace("'source_height':0.","'source_height':source_metric")
s=s.replace("'Terrain data is a synthetic flag column, not Map10.","'Terrain data is a synthetic flag column with supplied source metric0/64/512, not Map10.")
exec(compile(s,'extended native terrain cases','exec'))
