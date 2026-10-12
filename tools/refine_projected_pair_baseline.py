from pathlib import Path
import json,datetime
r=Path('E:/OpenLeague');p=r/'crates/client/src/projected_pixel_pair.rs';s=p.read_text(encoding='utf-8')
old='((entity==0 && changed==0)|| (entity!=0 && changed>0))'
assert s.count(old)==1
s=s.replace(old,'((entity==0 && f32::from_bits(word(3))>=24.)|| (entity!=0 && changed>0))')
old='*transform,projection.clone(),*msaa,Tonemapping::None,crate::native_gamma::Map10Gamma::native_map10(),layers));'
assert s.count(old)==1
s=s.replace(old,'''*transform,projection.clone(),if std::env::var("OPENLEAGUE_PAIR_NO_MSAA").as_deref()==Ok("1"){Msaa::Off}else{*msaa},
            Tonemapping::None,{
                let mut gamma=crate::native_gamma::Map10Gamma::native_map10();
                if std::env::var("OPENLEAGUE_PAIR_NO_GAMMA").as_deref()==Ok("1"){gamma.state.x=0.;}
                gamma
            },layers));''')
s=s.replace('"rgba_atlas_header_row":true,','"rgba_atlas_header_row":true,"diagnostic_no_gamma":std::env::var("OPENLEAGUE_PAIR_NO_GAMMA").as_deref()==Ok("1"),"diagnostic_no_msaa":std::env::var("OPENLEAGUE_PAIR_NO_MSAA").as_deref()==Ok("1"),')
p.write_text(s,encoding='utf-8')
for version,port,flag in [('v11_pair_dx12',10498,''),('v12_pair_dx12_no_gamma',10499,'OPENLEAGUE_PAIR_NO_GAMMA'),('v13_pair_dx12_no_msaa',10500,'OPENLEAGUE_PAIR_NO_MSAA')]:
    prefix=version.replace('_','-')
    s=(r/'tools/capture_projected_core_cycle_v10_pair_dx12.py').read_text(encoding='utf-8-sig').replace('10497',str(port)).replace('cycle-v10-pair-dx12','cycle-'+prefix).replace('capture_v10_pair_dx12','capture_'+version)
    if flag:s=s.replace("WGPU_BACKEND='dx12',",f"WGPU_BACKEND='dx12',{flag}='1',")
    (r/'tools'/('capture_projected_core_cycle_'+version+'.py')).write_text(s,encoding='utf-8')
d=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),complete=False,status='source_changed_build_pending',build_log='logs/projected-pair-baseline-controls-build.log',capture_scripts=['tools/capture_projected_core_cycle_'+v+'.py' for v in ['v11_pair_dx12','v12_pair_dx12_no_gamma','v13_pair_dx12_no_msaa']],limits=['Archive a rendered pre-cast pair after24seconds even when baseline differs; diagnostic camera gamma/MSAA controls do not alter ordinary gameplay.', 'Controls isolate rendering stages; they are not alternate acceptance criteria for the unmodified output.'])
(r/'docs/projected_pair_baseline_pending.json').write_text(json.dumps(d,indent=2)+'\n',encoding='utf-8');print('Rendered baseline archive and opt-in stage controls installed')
