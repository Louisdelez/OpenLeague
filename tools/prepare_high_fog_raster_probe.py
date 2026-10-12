from pathlib import Path
import json,datetime,hashlib,itertools
r=Path('E:/OpenLeague');settings=json.loads((r/'data/4.20/map_fog_settings.json').read_text(encoding='utf-8'));old=json.loads((r/'data/4.20/fow_height_raster_cases.json').read_text(encoding='utf-8'))
def body(name):
 s=(r/f'assets/shaders/{name}_fow_vertex.wgsl').read_text(encoding='utf-8');return s[s.index('    // Fog.hls:'):s.index('    return out;')]
assert body('environment')==body('terrain')
cases=[]
actual=[c for c in old['cases'] if c['kind']=='actual_map_triangle' and c['units']==20.][::35]
fixtures=[[0.,100.,300.],[-900.,-500.,0.],[-1000.,-800.,-300.],[22.222299,188.8889,100.],[-100.,300.,400.],[0.,0.,0.],[300.,300.,300.]]
inputs=[('actual_map_triangle',c['native_y'],[1.,1.,1.]) for c in actual]
inputs += [('controlled_perspective',ys,ws) for ys,ws in itertools.product(fixtures,[[1.,1.,1.],[.5,1.,2.],[1.,3.,.75]])]
d0=settings['fog_data0'];d1=settings['fog_data1']
for kind,ys,ws in inputs:
 top=[1.-(d1[0]+(1.-d1[0])*max(0.,min(1.,y*d0[0]+d0[1]))) for y in ys]
 far=[y*d1[1]+d1[2] for y in ys];den=sum(1/w for w in ws)
 t=sum(a/w for a,w in zip(top,ws))/den;v=sum(a/w for a,w in zip(far,ws))/den
 cases.append(dict(kind=kind,native_y=ys,units=20.,clear=d0,fog1=d1,clip_w=ws,expected=[t,v,max(0.,min(1.,v)),1.]))
proof=dict(updated_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),complete=False,cases=cases,actual_map_triangle_cases=len(actual),perspective_cases=14,
 production_vertex_sha256={n:hashlib.sha256((r/f'assets/shaders/{n}_fow_vertex.wgsl').read_bytes()).hexdigest() for n in ['terrain','environment']},
 limits=['Triangles rasterized at controlled one-pixel centroids; native map height triples retained, geometry X/Z and camera positions adapted.',
 'Shared production vertex arithmetic extracted unchanged. Map10 radial coefficient makes its radial term nonpositive at all fixture screen positions.',
 'Fragment returns top, unbounded far and far clamped after interpolation; full cloud/colormap/vision/color blend and original D3D frame remain separate.'])
(r/'data/4.20/native_high_fog_raster_cases.json').write_text(json.dumps(proof,indent=2)+'\n',encoding='utf-8')
helper='''struct Result {world_position:vec4<f32>,position:vec4<f32>,native_high_fog:vec4<f32>};
fn calculate(y:f32,clip:vec4<f32>,high_fog0:vec4<f32>,high_fog1:vec4<f32>,units:f32)->vec2<f32> {
 var out:Result;out.world_position=vec4<f32>(0.0,y,0.0,1.0);out.position=clip;
 let terrain_coordinates=vec4<f32>(0.0,0.0,units,0.0);let native_xz=vec2<f32>(0.0);let cloud_phase=vec4<f32>(0.0);
'''+body('environment')+'return out.native_high_fog.xy;\n}'
source=(r/'crates/client/examples/fow_height_raster_probe.rs').read_text(encoding='utf-8')
source=source[source.index('use wgpu::*;'):].replace('bevy::tasks::block_on','bevy_tasks::block_on')
source=source.replace('include_str!("../../../data/4.20/fow_height_raster_cases.json")','&std::fs::read_to_string("data/4.20/native_high_fog_raster_cases.json").unwrap()')
source=source.replace('include_str!("../../../assets/shaders/fow_vertex_height_functions.wgsl")',json.dumps(helper))
source=source.replace('clip_w:vec4<f32>};','clip_w:vec4<f32>,layer:vec4<f32>};')
source=source.replace('out.fades=native_fow_vertex_height(transported_y*p.heights.w,p.clear,vec4<f32>(0.0,-1000.0,0.01,10.0));','out.fades=calculate(transported_y,out.position,p.clear,p.layer,p.heights.w);')
source=source.replace('vec4<f32>(in.fades,1.0,1.0)','vec4<f32>(in.fades,clamp(in.fades.y,0.0,1.0),1.0)')
source=source.replace('floats.push(0.);}','floats.push(0.);floats.extend(c["fog1"].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32));}')
source=source.replace('assert_eq!(&actual[i*4+2..i*4+4],&[1.,1.],"raster coverage case{i}");for channel in 0..2','assert_eq!(actual[i*4+3],1.,"raster coverage case{i}");for channel in 0..3')
a=source.index('    let receipt=');source=source[:a]+'''    let receipt=serde_json::json!({"passed":true,"complete":false,"adapter":info.name,"backend":format!("{:?}",info.backend),"rasterized_cases":cases.len(),"actual_map_triangle_cases":proof["actual_map_triangle_cases"],"perspective_cases":proof["perspective_cases"],"maximum_error":maximum_error,"tolerance":0.00001,"limits":proof["limits"]});std::fs::write("logs/native-high-fog-raster-gpu.json",serde_json::to_vec_pretty(&receipt).unwrap()).unwrap();println!("Vulkan high fog raster cases{} maximum error{maximum_error}",cases.len());
}
'''
Path('E:/mapslol3v3/high_fog_raster_gpu.rs').write_text(source,encoding='utf-8');print(json.dumps(dict(raster_cases=len(cases),actual_triangles=len(actual))))
