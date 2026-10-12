use crate::{Connection, Match};
use bevy::prelude::*;
use std::collections::HashMap;
#[derive(Component)]
pub struct HealthBar;
#[derive(Component)]
pub struct HealthFill;
/// Screen-space bars follow authoritative entity positions and HP; they do not mutate gameplay.
pub fn update(
    mut commands: Commands,
    state: Res<Match>,
    connection: Res<Connection>,
    cameras: Query<(Entity, &Camera), With<Camera3d>>,
    transforms: TransformHelper,
    mut bars: Local<HashMap<u32, Entity>>,
    mut roots: Query<(&mut Node, &Children), (With<HealthBar>, Without<HealthFill>)>,
    mut fills: Query<(&mut Node, &mut BackgroundColor), (With<HealthFill>, Without<HealthBar>)>,
) {
    if std::env::var_os("OPENLEAGUE_SCREENSHOT").is_some()
        && std::env::var("OPENLEAGUE_PROBE_ENV_ONLY").as_deref() == Ok("1")
    {
        return;
    }
    let Some(snapshot) = &state.snapshot else {
        return;
    };
    if snapshot.winner.is_some() {for (mut node, _) in &mut roots {node.display=Display::None;}return;}
    let Some((camera_entity, camera)) = cameras.iter().next() else {
        return;
    };
    let Ok(camera_transform)=transforms.compute_global_transform(camera_entity) else {return;};
    let own_team = snapshot
        .players
        .iter()
        .find(|p| Some(p.id) == connection.id)
        .map(|p| p.team);
    let actors: Vec<_> = snapshot
        .players
        .iter()
        .map(|p| {
            (
                p.id,
                p.team,
                p.position,
                p.height + 170.,
                p.health,
                p.max_health,
            )
        })
        .chain(snapshot.units.iter().map(|u| {
            (
                u.id,
                u.team,
                u.position,
                u.height + if u.kind.structure() { 300. } else { 110. },
                u.health,
                u.max_health,
            )
        }))
        .collect();
    let gone: Vec<_> = bars
        .keys()
        .filter(|id| !actors.iter().any(|a| a.0 == **id))
        .copied()
        .collect();
    for id in gone {
        if let Some(entity) = bars.remove(&id) {
            commands.entity(entity).despawn();
        }
    }
    for (id, team, position, height, health, max_health) in actors {
        let screen = camera.world_to_viewport(
            &camera_transform,
            Vec3::new(position.x / 20., height / 20., position.z / 20.),
        );
        let color = if team == 2 {
            Color::srgb(0.95, 0.72, 0.15)
        } else if Some(team) == own_team {
            Color::srgb(0.15, 0.85, 0.25)
        } else {
            Color::srgb(0.9, 0.18, 0.18)
        };
        let entity = *bars.entry(id).or_insert_with(|| {
            commands
                .spawn((
                    Node {
                        position_type: PositionType::Absolute,
                        width: Val::Px(48.),
                        height: Val::Px(5.),
                        display: Display::None,
                        ..default()
                    },
                    BackgroundColor(Color::srgb(0.08, 0.08, 0.08)),
                    HealthBar,
                ))
                .with_children(|parent| {
                    parent.spawn((
                        Node {
                            width: Val::Percent(100.),
                            height: Val::Percent(100.),
                            ..default()
                        },
                        BackgroundColor(color),
                        HealthFill,
                    ));
                })
                .id()
        });
        if let Ok((mut node, children)) = roots.get_mut(entity) {
            if let Ok(screen) = screen.as_ref().map_err(|_| ()).and_then(|screen| {
                if health > 0. {
                    Ok(screen)
                } else {
                    Err(())
                }
            }) {
                node.display = Display::Flex;
                node.left = Val::Px(screen.x - 24.);
                node.top = Val::Px(screen.y);
            } else {
                node.display = Display::None;
            }
            for child in children.iter() {
                if let Ok((mut fill, mut background)) = fills.get_mut(child) {
                    fill.width = Val::Percent((health / max_health.max(1.)).clamp(0., 1.) * 100.);
                    background.0 = color;
                }
            }
        }
    }
}
#[cfg(test)]
mod tests {
 use super::*;
 use bevy::camera::{CameraProjection,RenderTargetInfo};
 #[test]
 fn camera_motion_updates_bar_same_frame_before_transform_propagation(){
  let nav=openleague_core::Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap();
  let mut sim=openleague_core::Simulation::new(nav).unwrap();let id=sim.join("garen").unwrap();
  let player=sim.players.get_mut(&id).unwrap();player.position=openleague_core::Point{x:7000.,z:7000.};
  let snap=sim.snapshot();let p=&snap.players[0];let anchor=Vec3::new(p.position.x/20.,(p.height+170.)/20.,p.position.z/20.);
  let mut app=App::new();app.insert_resource(Match{snapshot:Some(snap),..default()}).insert_resource(Connection{link:crate::session_connection::Link::legacy(),welcome_history:Default::default(),socket:std::net::UdpSocket::bind("127.0.0.1:0").unwrap(),id:Some(id),session:None,sequence:0,last_join:std::time::Instant::now(),champion:"garen".into(),summoners:[None;2],rejection:String::new(),assembler:Default::default()});
  app.add_systems(PostUpdate,update.after(bevy::camera::CameraUpdateSystems).before(bevy::ui::UiSystems::Prepare));
  let mut projection=PerspectiveProjection::default();projection.update(1280.,800.);
  let mut camera=Camera::default();camera.computed.target_info=Some(RenderTargetInfo{physical_size:UVec2::new(1280,800),scale_factor:1.});camera.computed.clip_from_view=projection.get_clip_from_view();
  let pose=Transform::from_translation(anchor+Vec3::new(0.,60.,80.)).looking_at(anchor,Vec3::Y);
  let root=app.world_mut().spawn((Transform::default(),GlobalTransform::default())).id();
  let entity=app.world_mut().spawn((camera,Camera3d::default(),pose,GlobalTransform::from(pose),ChildOf(root))).id();
  app.update();app.update();
  let bar=app.world_mut().query_filtered::<Entity,With<HealthBar>>().single(app.world()).unwrap();
  let initial=app.world().get::<Node>(bar).unwrap().left;
  // GlobalTransform is deliberately stale: no TransformPlugin runs in this app.
  app.world_mut().get_mut::<Transform>(root).unwrap().translation.x=30.;
  app.update();
  let world=GlobalTransform::from(*app.world().get::<Transform>(root).unwrap()) * *app.world().get::<Transform>(entity).unwrap();
  let expected=app.world().get::<Camera>(entity).unwrap().world_to_viewport(&world,anchor).unwrap();
  let node=app.world().get::<Node>(bar).unwrap();assert_eq!(node.display,Display::Flex);assert_eq!(node.left,Val::Px(expected.x-24.));assert_eq!(node.top,Val::Px(expected.y));assert_ne!(node.left,initial);
  app.world_mut().get_mut::<Transform>(root).unwrap().translation.x=0.;app.update();assert_eq!(app.world().get::<Node>(bar).unwrap().left,initial);
 }
}
