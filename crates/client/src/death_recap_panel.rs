//! Local persistent own-death panel; not a recreation of the native Flash movie.
//! Reads only the already accepted atomic snapshot, never an attacker entity.
use bevy::{prelude::*, window::PrimaryWindow};
use openleague_core::{death_recap::{self, Amount, Source}, Snapshot};

type Identity = (u64, u32, Option<u64>);

#[derive(Clone, Debug, PartialEq)]
struct DisplayRow { source: String, physical: String, magical: String, true_damage: String, lethal: bool }
#[derive(Clone, Debug, PartialEq)]
struct Panel {
    // Full-width identity is retained for UI ownership, never rendered as an actor ID.
    identity: (u64, u32, u64, u64),
    rows: Vec<DisplayRow>, summary: String, footnote: String,
}

fn number(value: f64) -> String {
    if value == 0. { "0".into() }
    else if value < 0.05 { "<0,1".into() }
    else if value >= 10_000. { format!("{value:.1e}") }
    else { format!("{value:.1}").replace('.', ",") }
}
fn amount(value: Amount) -> String {
    format!("{} / {}", number(f64::from(value.health_removed)), number(f64::from(value.shield_absorbed)))
}
fn source_label(source: &Source) -> String {
    use openleague_core::world::Kind;
    match source {
        // Canonical names are ASCII after decode; a corrupt but valid long label
        // still cannot overrun the source column or acquire a new actor identity.
        Source::Champion { champion } => if champion.len() <= 22 { champion.clone() }
            else { format!("{}…", &champion[..21]) },
        Source::Unit { kind, .. } => match kind {
            Kind::Melee => "Sbire de mêlée", Kind::Caster => "Sbire mage", Kind::Siege => "Sbire de siège",
            Kind::Super => "Super-sbire", Kind::Monster => "Monstre", Kind::Pet => "Invocation", Kind::Boss => "Boss",
            Kind::Turret => "Tourelle", Kind::Fountain => "Fontaine", Kind::Inhibitor => "Inhibiteur", Kind::Nexus => "Nexus",
        }.into(),
        Source::Unknown => "Source masquée".into(),
        Source::Other => "Autres sources visibles".into(),
    }
}

/// `identity` comes from Connection::inventory_input_identity AFTER receive.
/// A legacy identity has no epoch and cannot display this private OLSR channel.
fn panel(snapshot: &Snapshot, identity: Option<Identity>, presentation_ready: bool) -> Option<Panel> {
    let (session, victim, Some(epoch)) = identity? else { return None; };
    if !presentation_ready || session == 0 || epoch == 0 || snapshot.session != session
        || snapshot.winner.is_some() || snapshot.result.is_some() { return None; }
    let mut owners = snapshot.players.iter().filter(|p| p.id == victim);
    let owner = owners.next()?;
    if owners.next().is_some() || owner.team > 1 || !owner.health.is_finite() || owner.health > 0.
        || owner.respawn_at.is_none() { return None; }
    let recap = death_recap::decode_view(snapshot.death_recap.as_ref(), session, victim, snapshot.tick).ok()??;
    let mut health = 0_f64; let mut shield = 0_f64;
    let rows = recap.rows.iter().map(|row| {
        for value in [row.physical, row.magical, row.true_damage] {
            health += f64::from(value.health_removed); shield += f64::from(value.shield_absorbed);
        }
        DisplayRow { source: source_label(&row.source), physical: amount(row.physical),
            magical: amount(row.magical), true_damage: amount(row.true_damage), lethal: row.lethal }
    }).collect();
    let seconds = (recap.death_tick - recap.window_start) as f64 / openleague_core::TICK_RATE as f64;
    Some(Panel { identity: (session, victim, epoch, recap.death_ordinal), rows,
        summary: format!("Période {} s · PV perdus {} · Bouclier {}", number(seconds), number(health), number(shield)),
        footnote: if recap.truncated {
            "Historique partiel : limite de conservation atteinte. † inclut le coup fatal. Montants arrondis.".into()
        } else { "† inclut le coup fatal. Montants arrondis. Les sources masquées restent anonymes.".into() },
    })
}

#[derive(Clone, Copy, Debug, PartialEq)]
struct Layout { left: f32, top: f32, width: f32, height: f32, row: f32, font: f32 }
fn layout(width: f32, height: f32, rows: usize) -> Option<Layout> {
    if !width.is_finite() || !height.is_finite() || width < 640. || height < 480.
        || rows == 0 || rows > death_recap::MAX_ROWS { return None; }
    let panel_width = (width - 32.).min(700.);
    let row = ((height - 152.) / (rows as f32 + 7.)).min(25.);
    Some(Layout { left: (width - panel_width) * 0.5, top: 100., width: panel_width,
        height: row * (rows as f32 + 7.), row, font: (row * 0.78).min(16.) })
}

#[derive(Component)] struct RecapRoot;
#[derive(Resource, Default)] struct Live { root: Option<Entity>, signature: Option<(Panel, Layout)> }
fn clear(commands: &mut Commands, live: &mut Live) {
    if let Some(root) = live.root.take() { commands.entity(root).try_despawn(); }
    live.signature = None;
}
fn text(parent: &mut ChildSpawnerCommands, font: &TextFont, value: impl Into<String>, rect: [f32; 4], color: Color) {
    parent.spawn((Text::new(value), font.clone(), TextColor(color), bevy::picking::Pickable::IGNORE,
        bevy::ui::FocusPolicy::Pass, Node { position_type: PositionType::Absolute, left: Val::Px(rect[0]),
            top: Val::Px(rect[1]), width: Val::Px(rect[2]), height: Val::Px(rect[3]), ..default() }));
}
fn reconcile(commands: &mut Commands, live: &mut Live, roots: &Query<(), With<RecapRoot>>,
    next: Option<(Panel, Layout)>, font: Handle<Font>) {
    let Some((panel, layout)) = next else { clear(commands, live); return; };
    if live.signature.as_ref() == Some(&(panel.clone(), layout)) && live.root.is_some_and(|root| roots.get(root).is_ok()) { return; }
    clear(commands, live);
    let face = TextFont { font: FontSource::Handle(font), font_size: FontSize::Px(layout.font), ..default() };
    let normal = Color::srgb_u8(232, 229, 217);
    let root = commands.spawn((RecapRoot, Name::new("LocalOwnerDeathRecap"), GlobalZIndex(75),
        bevy::picking::Pickable::IGNORE, bevy::ui::FocusPolicy::Pass,
        BackgroundColor(Color::srgba(0.025, 0.04, 0.06, 0.96)),
        Node { position_type: PositionType::Absolute, left: Val::Px(layout.left), top: Val::Px(layout.top),
            width: Val::Px(layout.width), height: Val::Px(layout.height), ..default() })).with_children(|children| {
        let usable = layout.width - 24.; let columns = [usable * 0.35, usable * 0.22, usable * 0.22, usable * 0.21];
        text(children, &face, "RÉCAPITULATIF DE MORT", [12., 6., usable, layout.row], Color::srgb_u8(234, 196, 112));
        text(children, &face, &panel.summary, [12., layout.row, usable, layout.row], normal);
        text(children, &face, "Chaque colonne : PV retirés / bouclier absorbé", [12., layout.row * 2., usable, layout.row], normal);
        let mut x = 12.;
        for (index, label) in ["Source", "Physique", "Magique", "Brut"].into_iter().enumerate() {
            text(children, &face, label, [x, layout.row * 3., columns[index], layout.row], normal); x += columns[index];
        }
        for (index, row) in panel.rows.iter().enumerate() {
            let mut x = 12.; let y = layout.row * (index as f32 + 4.);
            let label = if row.lethal { format!("† {}", row.source) } else { row.source.clone() };
            let color = if row.lethal { Color::srgb_u8(255, 208, 124) } else { normal };
            for (column, value) in [label.as_str(), &row.physical, &row.magical, &row.true_damage].into_iter().enumerate() {
                text(children, &face, value, [x, y, columns[column], layout.row], color); x += columns[column];
            }
        }
        text(children, &face, &panel.footnote, [12., layout.row * (panel.rows.len() as f32 + 4.5), usable, layout.row * 2.], normal);
    }).id();
    live.root = Some(root); live.signature = Some((panel, layout));
}

pub struct Plugin;
impl bevy::app::Plugin for Plugin {
    fn build(&self, app: &mut App) {
        app.init_resource::<Live>().add_systems(Update, update.after(crate::receive).after(crate::shop_ui::update));
    }
}
fn update(mut commands: Commands, state: Res<crate::Match>, connection: Res<crate::Connection>,
    clock: Res<crate::native_effect_clock::EffectClock>, shop: Res<crate::shop_ui::Filters>,
    windows: Query<&Window, With<PrimaryWindow>>, roots: Query<(), With<RecapRoot>>,
    assets: Res<AssetServer>, mut live: ResMut<Live>) {
    let next = (|| {
        if shop.open { return None; } // Keep ordinary purchases usable while dead; no input is intercepted.
        let snapshot = state.snapshot.as_ref()?;
        let view = panel(snapshot, connection.inventory_input_identity(), clock.presentation_ready())?;
        let window = windows.single().ok()?;
        let layout = layout(window.width(), window.height(), view.rows.len())?;
        Some((view, layout))
    })();
    reconcile(&mut commands, &mut live, &roots, next, assets.load("fonts/DejaVuSans.ttf"));
}

#[cfg(test)]
#[path = "death_recap_panel_tests.rs"]
mod tests;
