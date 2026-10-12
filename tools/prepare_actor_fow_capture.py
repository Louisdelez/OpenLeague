from pathlib import Path
base=Path('E:/mapslol3v3/capture_fow_environment.py').read_text(encoding='utf-8')
for mode,port in [('normal',16017),('diagnostic',16018)]:
 s=base.replace('16016',str(port)).replace('fow-environment','fow-actor-'+mode).replace('149','150').replace('fow_environment_runtime_capture.json','fow_actor_'+mode+'_runtime_capture.json')
 marker="WGPU_BACKEND='vulkan',";extra="OPENLEAGUE_ACTOR_FOW_PROBE=str(r/'logs/fow-actor-"+mode+"-bindings.json'),"
 if mode=='diagnostic':extra+="OPENLEAGUE_FOW_MASK_PROBE='1',"
 s=s.replace(marker,marker+extra)
 needle="stages=json.loads((r/'logs/fow-actor-"+mode+"-stages.json').read_text());readback="
 assert needle in s;s=s.replace(needle,"actors=json.loads((r/'logs/fow-actor-"+mode+"-bindings.json').read_text());"+needle)
 s=s.replace("except (FileNotFoundError,json.JSONDecodeError):stages=None;readback=None", "except (FileNotFoundError,json.JSONDecodeError):actors={};stages=None;readback=None")
 s=s.replace("if stages and stages['frames']>3", "if actors.get('bound_meshes',0)>0 and actors['skinned_meshes']>0 and actors['ready_materials']==actors['bound_meshes'] and all(m==0 for m in actors['factor_modes']) and stages and stages['frames']>3")
 s=s.replace("'normal_server':True,", "'normal_server':True,'actor_bindings':actors,'actor_mask_diagnostic':"+str(mode=='diagnostic')+",")
 s=s.replace('Native coefficient and LIT-derived factors applied; actors still use ordinary materials. Whole original-renderer fidelity remains open.', 'Native base factors bound to current loaded gameplay/ambient model descendants; all122champions/skins and original shader-variant fidelity remain open.')
 Path('E:/mapslol3v3/capture_actor_fow_'+mode+'.py').write_text(s,encoding='utf-8')
print('Normal and mask-diagnostic actor captures prepared')
