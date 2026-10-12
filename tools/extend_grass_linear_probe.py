from pathlib import Path
r=Path('E:/OpenLeague');p=r/'crates/client/examples/grass_mask_gpu_probe.rs';s=p.read_text(encoding='utf-8')
s=s.replace('    let width = 1024u32; let height = 512u32;','''    let width = 1024u32; let height = 512u32;
    let profile=std::env::var("OPENLEAGUE_GRASS_FILTER_PROFILE").unwrap_or_else(|_|"point".into());
    let linear=match profile.as_str() {"point"=>false,"linear"=>true,_=>panic!("unqualified filter profile")};
    let output=std::env::var("OPENLEAGUE_GRASS_PROBE_OUTPUT").unwrap_or_else(|_|"logs/grass-mask-gpu".into());
    let inherited_filters=if linear {[2,2,0]} else {grass_pass_state::RESET_D3D_FILTERS};''')
s=s.replace('grass_pass_state::mask_sampler(grass_pass_state::RESET_D3D_FILTERS)','grass_pass_state::mask_sampler(inherited_filters)')
s=s.replace('    let bindings: Vec<_> = quads.iter().map(|quad| {','''    if linear {quads.push(grass_quad::OffsetCache::default().prepare([16,304,401,497],[9,13,233,251],Some([256,256]),2).unwrap());}
    let bindings: Vec<_> = quads.iter().map(|quad| {''')
s=s.replace('let mut covered=0; let mut overwritten=0;','let mut covered=0; let mut overwritten=0; let mut max_error=0u8; let mut channel_errors=[0u64;2];')
old='''            let sx=((uv[0] as f64+(p[0]-d[0] as f64)/d[2] as f64*uv[2] as f64)*256.).floor().clamp(0.,255.) as usize;
            let sy=((uv[1] as f64+(p[1]-d[1] as f64)/d[3] as f64*uv[3] as f64)*256.).floor().clamp(0.,255.) as usize;
            expected.copy_from_slice(&brush[(sy*256+sx)*4..(sy*256+sx)*4+4]);'''
new='''            let sx=(uv[0] as f64+(p[0]-d[0] as f64)/d[2] as f64*uv[2] as f64)*256.;
            let sy=(uv[1] as f64+(p[1]-d[1] as f64)/d[3] as f64*uv[3] as f64)*256.;
            if linear {
                // Independent bilinear reference at texel centers, with clamp-to-edge addressing.
                let fx=sx-0.5;let fy=sy-0.5;let ix=fx.floor();let iy=fy.floor();let tx=fx-ix;let ty=fy-iy;
                let sample=|x:f64,y:f64,c:usize|brush[(y.clamp(0.,255.) as usize*256+x.clamp(0.,255.) as usize)*4+c] as f64;
                expected=std::array::from_fn(|c|((sample(ix,iy,c)*(1.-tx)+sample(ix+1.,iy,c)*tx)*(1.-ty)+(sample(ix,iy+1.,c)*(1.-tx)+sample(ix+1.,iy+1.,c)*tx)*ty).round().clamp(0.,255.) as u8);
            } else {
                let sx=sx.floor().clamp(0.,255.) as usize;let sy=sy.floor().clamp(0.,255.) as usize;
                expected.copy_from_slice(&brush[(sy*256+sx)*4..(sy*256+sx)*4+4]);
            }'''
assert old in s;s=s.replace(old,new)
s=s.replace('let at=((y*width+x)*4) as usize; assert_eq!(&data[at..at+4],&expected,"pixel{x},{y}");','''let at=((y*width+x)*4) as usize;
        for channel in 0..4 {let error=data[at+channel].abs_diff(expected[channel]);assert!(error<=if linear {1} else {0},"pixel{x},{y},channel{channel}:actual{}expected{}",data[at+channel],expected[channel]);max_error=max_error.max(error);channel_errors[error as usize]+=1;}''')
s=s.replace('std::fs::write("logs/grass-mask-gpu.rgba",&*data)','std::fs::write(format!("{output}.rgba"),&*data)')
s=s.replace('"native_reset_d3d_filters":grass_pass_state::RESET_D3D_FILTERS,','"native_reset_d3d_filters":grass_pass_state::RESET_D3D_FILTERS,"inherited_d3d_filters":inherited_filters,"filter_profile":profile,"max_channel_error":max_error,"allowed_channel_error":if linear {1} else {0},"channel_errors":channel_errors,')
s=s.replace('"Reset point/no-mip filters, quad clamp addressing, BGRA8 target and clear color have native API evidence.','"Point/linear no-mip filter profile supplied explicitly; quad clamp addressing, BGRA8 target and clear color have native API evidence.')
s=s.replace('std::fs::write("logs/grass-mask-gpu.json",serde_json::to_vec_pretty(&receipt).unwrap())','std::fs::write(format!("{output}.json"),serde_json::to_vec_pretty(&receipt).unwrap())')
s=s.replace('overwritten);','overwritten);println!("Filter profile:{profile}; maximum8bit channelerror:{max_error}");')
p.write_text(s,encoding='utf-8');print('Point and linear GPU profiles installed; one-byte tolerance only for bilinear UNORM rounding.')
