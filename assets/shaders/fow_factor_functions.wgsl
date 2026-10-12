// Literal port of FogOfWar_PS.hls, normal overlay UV and visibility branches.
// Edge sharpener is #if0 in the original; tint uses original visibility, not height-adjusted t.
fn native_fow_factors(overlay:vec4<f32>,vis:f32,height:f32,mode:u32,edge:vec4<f32>)->vec4<f32> {
 var t=vis;
 if mode==1u {t=vis*height;}
 if mode==2u {t=mix(vis,1.0,height);}
 let color=mix(overlay.rgb,vec3<f32>(0.2,0.07,0.06),clamp(vis*edge.z,0.0,1.0));
 return vec4<f32>(color,mix(overlay.a,1.0,t));
}
