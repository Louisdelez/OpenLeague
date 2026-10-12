// Ports native Fade.ps_2_0 and FastSeparableGaussianBlur.ps_2_0.
// Explicit GPU verification/compute stage; live parameter/provider integration is separate.
struct Parameters { coefficients:vec4<f32>, mode:vec4<f32> }
@group(0) @binding(0) var source:texture_2d<f32>;
@group(0) @binding(1) var linear_clamp:sampler;
@group(0) @binding(2) var<uniform> params:Parameters;
@group(0) @binding(3) var result:texture_storage_2d<rgba8unorm,write>;
@group(0) @binding(4) var current:texture_2d<f32>;
fn fade_value(desired:f32,old:f32,p:vec4<f32>)->f32 {
    if desired>=p.w {return desired;}
    if old<desired {return min(desired,old+p.x);}
    if old>desired {return max(desired,old-p.y);}
    return desired;
}
@compute @workgroup_size(8,8)
fn main(@builtin(global_invocation_id) id:vec3<u32>) {
    let dimensions=textureDimensions(source);
    if id.x>=dimensions.x || id.y>=dimensions.y {return;}
    let uv=(vec2<f32>(id.xy)+vec2<f32>(0.5))/vec2<f32>(dimensions);
    let p=params.coefficients;
    let center=textureSampleLevel(source,linear_clamp,uv,0.0).r;
    var value:f32;
    if params.mode.x<0.5 {
        let old=textureSampleLevel(current,linear_clamp,uv,0.0).r;
        value=fade_value(center,old,p);
    } else {
        value=center*p.z;
        value+=textureSampleLevel(source,linear_clamp,uv+p.xy,0.0).r*p.w;
        value+=textureSampleLevel(source,linear_clamp,uv-p.xy,0.0).r*p.w;
    }
    textureStore(result,vec2<i32>(id.xy),vec4<f32>(value,value,value,1.0));
}
