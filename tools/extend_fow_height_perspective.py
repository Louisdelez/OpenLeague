from pathlib import Path
import json
r=Path('E:/OpenLeague');p=r/'data/4.20/fow_height_raster_cases.json';d=json.loads(p.read_text(encoding='utf-8'))
for c in d['cases']:c['clip_w']=[1.,1.,1.]
fixtures=[];coefficient=d['cases'][-1]['clear'][0]
for c in d['cases']:
 if c['kind']!='explicit_height_fixture':continue
 c=dict(c);c['kind']='explicit_perspective_fixture';c['clip_w']=[.5,1.,2.]
 weights=[1./w for w in c['clip_w']];expected=sum(max(0.,min(1.,y*coefficient+10.))*weight for y,weight in zip(c['native_y'],weights))/sum(weights);c['expected']=[expected,expected];fixtures.append(c)
d['cases'].extend(fixtures);p.write_text(json.dumps(d,indent=2)+'\n',encoding='utf-8')
p=r/'crates/client/examples/fow_height_raster_probe.rs';s=p.read_text(encoding='utf-8');s=s.replace('struct Input {heights:vec4<f32>,clear:vec4<f32>};','struct Input {heights:vec4<f32>,clear:vec4<f32>,clip_w:vec4<f32>};')
s=s.replace('out.position=vec4<f32>(center+points[v]/dimensions.xy,0.0,1.0);','let w=p.clip_w[v];out.position=vec4<f32>((center+points[v]/dimensions.xy)*w,0.0,w);')
needle='floats.extend(c["clear"].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32));';assert needle in s;s=s.replace(needle,needle+'floats.extend(c["clip_w"].as_array().unwrap().iter().map(|v|v.as_f64().unwrap() as f32));floats.push(0.);')
s=s.replace('"fixture_cases":12','"fixture_cases":24,"perspective_fixture_cases":12').replace('orthographic centroid fixtures from actual map triangles.','orthographic centroid fixtures from actual map triangles and explicit reciprocal-W perspective fixtures.').replace('perspective cases and final color','full live perspective camera attribution and final color');p.write_text(s,encoding='utf-8')
print('Perspective fixture cases12 added; raster total',len(d['cases']))
