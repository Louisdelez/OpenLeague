from pathlib import Path
for mode,oldport,newport in [('normal',16017,16019),('diagnostic',16018,16020)]:
 s=Path('E:/mapslol3v3/capture_actor_fow_'+mode+'.py').read_text(encoding='utf-8').replace(str(oldport),str(newport)).replace('fow-actor-'+mode,'fow-vertex-'+mode).replace('fow_actor_'+mode+'_runtime_capture.json','fow_vertex_'+mode+'_runtime_capture.json')
 Path('E:/mapslol3v3/capture_fow_vertex_'+mode+'.py').write_text(s,encoding='utf-8')
