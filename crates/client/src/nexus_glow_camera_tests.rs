//! CPU publication check: mutate the real camera controller, not a supplied basis.
use super::*;
use bevy::mesh::VertexAttributeValues;
use crate::nexus_glow_live::{Backend,Diagnostics,Ticket};
use crate::nexus_idle_particles::Host;

fn vertices(world:&World,t:&Ticket)->[Vec3;4]{
    let mesh=world.resource::<Assets<Mesh>>().get(t.mesh).unwrap();
    let VertexAttributeValues::Float32x3(p)=mesh.attribute(Mesh::ATTRIBUTE_POSITION).unwrap() else{panic!()};
    std::array::from_fn(|i|Vec3::from_array(p[i]))
}
fn center(p:[Vec3;4])->Vec3{p.into_iter().sum::<Vec3>()*0.25}
fn normal(p:[Vec3;4])->Vec3{(p[1]-p[0]).cross(p[2]-p[1]).normalize()}

#[test]
fn real_native_camera_yaw_changes_startup_and_simple_vertices_while_particle_and_handles_survive(){
    let mut app=crate::nexus_glow_live::tests::fixture();app.update();
    for (simple,now) in [(false,60.1),(true,75.1)]{
        if simple{
            {let mut host=app.world_mut().resource_mut::<Host>();for r in &mut host.frame.requests{
                r.cycle.serial+=100;r.descriptor.resource=r.descriptor.resource.replace(".troy","_on.troy");}}
            crate::nexus_glow_live::tests::advance(&mut app,75.);
        }
        let old=app.world().resource::<Backend>().tickets()[0].clone();let before=vertices(app.world(),&old);
        let old_direction=Vec3::from_array(app.world().resource::<NativeCamera>().native_parameters().unwrap().direction).normalize();
        {
            let mut camera=app.world_mut().resource_mut::<NativeCamera>();
            // Native assembly uses yaw - previous_yaw. Keep the original
            // reference; assigning it to the new yaw would cancel the rotation.
            camera.defaults.yaw_degrees+=90.;
            camera.pose(Vec3::new(200.,0.,200.),0.,now as f32).unwrap();
            let posed_direction=Vec3::from_array(camera.native_parameters().unwrap().direction).normalize();
            assert!(old_direction.dot(posed_direction)<0.95,"controlled camera yaw did not change the view");
        }
        crate::nexus_glow_live::tests::advance(&mut app,now);
        assert_eq!(app.world().resource::<Diagnostics>().error,None);
        let current=app.world().resource::<Backend>().tickets().into_iter().find(|t|t.particle==old.particle).unwrap();
        assert_eq!((current.particle,current.draw,current.mesh,current.material),(old.particle,old.draw,old.mesh,old.material));
        let after=vertices(app.world(),&current);
        assert!(center(before).distance(center(after))<0.0001);
        assert!(before.iter().zip(after).any(|(a,b)|a.distance(b)>0.1));
        let direction=Vec3::from_array(app.world().resource::<NativeCamera>().native_parameters().unwrap().direction).normalize();
        assert!(old_direction.dot(direction)<0.95);
        // Independent geometric relation, without calling either billboard helper.
        assert!(normal(before).dot(old_direction).abs()>0.9999);
        assert!(normal(after).dot(direction).abs()>0.9999);
    }
}
