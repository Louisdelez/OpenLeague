//! Ordinary Pause key, clickable HUD command and local status. Only accepted server clock directives
//! change the displayed pause state; input sends one request, never a replay.
use bevy::{input::{ButtonState, InputSystems, keyboard::{KeyboardFocusLost, KeyboardInput}}, prelude::*, window::PrimaryWindow};
use openleague_core::session_transport as t;

type Identity = (u64, u32, Option<u64>);
const REQUEST_TIMEOUT: f64 = 3.; // Local feedback deadline, not a server timeout.

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
enum Mode { Running, Paused, Resuming }
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
enum Feedback { Disabled, Refused, Unavailable, Timeout, Changed }
#[derive(Clone, Copy)]
struct Pending { sequence: u64, paused: bool, sent_at: f64 }

#[derive(Default)]
pub(crate) struct State {
    identity: Option<Identity>,
    observed: Option<(u64, Mode)>,
    pending: Option<Pending>,
    feedback: Option<Feedback>,
    available: bool,
    last_wall: Option<f64>,
}

impl State {
    /// Clock status is sampled only after receive and only at a new applied
    /// ordinal. A local countdown reaching zero cannot pretend that the final
    /// authoritative resume packet has arrived.
    pub(crate) fn update(&mut self, identity: Option<Identity>, enabled: bool,
        clock: (u64, bool, bool), now: f64) {
        // An unavailable link is not a new identity. Keep the last received
        // clock ordinal/status through that gap, while consuming pending input.
        if identity.is_some() && self.identity != identity { *self = Self { identity, ..Self::default() }; }
        self.available = enabled && identity.is_some() && now.is_finite()
            && self.last_wall.is_none_or(|last| now >= last);
        if !self.available {
            self.pending = None;
            self.last_wall = now.is_finite().then_some(now);
            return;
        }
        self.last_wall = Some(now);
        let (ordinal, paused, resuming) = clock;
        if self.observed.is_some_and(|(last, _)| ordinal < last) {
            self.available = false; self.pending = None; self.feedback = Some(Feedback::Unavailable); return;
        }
        if self.observed.is_none_or(|(last, _)| ordinal > last) {
            let mode = if resuming { Mode::Resuming } else if paused { Mode::Paused } else { Mode::Running };
            self.observed = Some((ordinal, mode));
            if let Some(pending) = self.pending.take() {
                let matched = if pending.paused { mode == Mode::Paused } else { mode != Mode::Paused };
                self.feedback = (!matched).then_some(Feedback::Changed);
            }
        }
        if self.pending.is_some_and(|pending| now - pending.sent_at >= REQUEST_TIMEOUT) {
            self.pending = None; self.feedback = Some(Feedback::Timeout);
        }
    }

    pub(crate) fn request(&mut self, connection: &mut crate::Connection, now: f64) -> bool {
        if !self.available || self.identity != connection.inventory_input_identity()
            || !now.is_finite() || self.last_wall.is_some_and(|last| now < last) {
            self.pending = None; self.feedback = Some(Feedback::Unavailable); return false;
        }
        if self.pending.is_some() { return false; }
        let paused = match self.observed.map(|(_, mode)| mode) {
            Some(Mode::Running) => true,
            Some(Mode::Paused) => false,
            _ => return false,
        };
        match connection.send_pause_tracked(paused) {
            Ok(sequence) => {
                self.pending = Some(Pending { sequence, paused, sent_at: now });
                self.feedback = None; true
            }
            Err(_) => { self.feedback = Some(Feedback::Unavailable); false }
        }
    }

    /// Secure rejection matches the exact full-width context and request
    /// sequence. Legacy has no correlation field: only known pause-specific
    /// reasons can resolve its pending request; other errors remain untouched.
    pub(crate) fn rejected(&mut self, context: Option<t::Context>, sequence: Option<u64>, reason: &str) {
        let Some(pending) = self.pending else { return; };
        let matches = match (self.identity, context, sequence) {
            (Some((session, player, Some(epoch))), Some(c), Some(seq)) =>
                (session, player, epoch) == (c.session, c.player, c.epoch) && seq == pending.sequence,
            (Some((_, _, None)), None, None) => matches!(reason,
                "pause disabled by local match host" | "pause budget exhausted" |
                "match is already paused" | "match is not paused" | "resume already scheduled"),
            _ => false,
        };
        if !matches { return; }
        self.pending = None;
        self.feedback = Some(if reason == "pause disabled by local match host" { Feedback::Disabled } else { Feedback::Refused });
    }

    fn button_label(&self) -> (&'static str, bool) {
        if !self.available { return ("Pause indisponible", false); }
        if self.pending.is_some() { return ("Demande envoyee", false); }
        match self.observed.map(|(_, mode)| mode) {
            Some(Mode::Running) => ("Pause", true),
            Some(Mode::Paused) => ("Reprendre", true),
            Some(Mode::Resuming) => ("Reprise en cours", false),
            None => ("En attente", false),
        }
    }

    fn label(&self) -> String {
        if !self.available { return "Pause indisponible : connexion, horloge ou partie inactive".into(); }
        let status = match self.observed.map(|(_, mode)| mode) {
            Some(Mode::Running) => "Partie en cours | Pause : demander une pause",
            Some(Mode::Paused) => "PARTIE EN PAUSE | Pause : demander la reprise",
            Some(Mode::Resuming) => "Reprise en cours | attente du serveur",
            None => "Pause : attente de l'etat du serveur",
        };
        let detail = if let Some(pending) = self.pending {
            if pending.paused { "Demande de pause envoyee..." } else { "Demande de reprise envoyee..." }
        } else {
            match self.feedback {
                Some(Feedback::Disabled) => "Pause refusee : le serveur ne l'autorise pas",
                Some(Feedback::Refused) => "Demande refusee par le serveur",
                Some(Feedback::Unavailable) => "Demande non envoyee : connexion indisponible",
                Some(Feedback::Timeout) => "Aucune confirmation recue ; demande non renvoyee",
                Some(Feedback::Changed) => "L'etat a ete modifie par le serveur",
                None => "",
            }
        };
        if detail.is_empty() { status.into() } else { format!("{status}\n{detail}") }
    }
}

#[derive(Resource, Default)]
struct Controls { window: Option<Entity>, identity: Option<Identity>, armed: bool, held: bool, tap: bool }
impl Controls {
    fn suspend(&mut self) { self.held = false; self.tap = false; self.armed = false; }
    fn key(&mut self, key: KeyCode, state: ButtonState, repeat: bool) {
        if key != KeyCode::Pause { return; }
        match state {
            ButtonState::Released => self.held = false,
            ButtonState::Pressed if !repeat && !self.held => { self.held = true; self.tap = true; }
            _ => {}
        }
    }
    // Bevy UI reports a fresh left/touch press via Interaction. It enters the
    // same one-frame tap and the same human/identity gate as the physical key.
    // A held Interaction is never a retry after a focus or connection gap.
    fn button(&mut self, interaction: Interaction, changed: bool) {
        self.tap |= changed && interaction == Interaction::Pressed;
    }
    fn consume(&mut self, identity: Option<Identity>, enabled: bool) -> bool {
        if self.identity != identity { self.identity = identity; self.suspend(); }
        if !enabled || identity.is_none() || self.window.is_none() { self.suspend(); return false; }
        if !self.armed { self.suspend(); self.armed = true; return false; }
        std::mem::take(&mut self.tap)
    }
}

#[derive(Component)]
struct PauseHud;
#[derive(Component)]
struct PauseButton;
#[derive(Component)]
struct PauseButtonLabel;
pub struct Plugin;
impl bevy::app::Plugin for Plugin {
    fn build(&self, app: &mut App) {
        app.init_resource::<Controls>().add_systems(Startup, setup)
            .add_systems(PreUpdate, collect.after(InputSystems))
            .add_systems(Update, drive.after(crate::receive).after(crate::shop_ui::update));
    }
}
fn setup(mut commands: Commands, assets: Res<AssetServer>) {
    // Small ordinary overlay using an already installed font. Layout and wording
    // are local UI policy, not a recreation of a native tournament panel.
    commands.spawn((PauseHud, Text::new("Pause : attente du serveur"),
        TextFont { font: FontSource::Handle(assets.load("fonts/DejaVuSans.ttf")), font_size: FontSize::Px(16.), ..default() },
        TextColor(Color::srgb_u8(255, 240, 180)), GlobalZIndex(20),
        bevy::picking::Pickable::IGNORE, bevy::ui::FocusPolicy::Pass,
        Node { position_type: PositionType::Absolute, left: Val::Px(16.), top: Val::Px(70.), ..default() }));
    // Local ordinary control, separate from the status. Text passes picking to
    // its button; no global mouse/key state or gameplay mapping is consumed.
    commands.spawn((Button, PauseButton, GlobalZIndex(20),
        BackgroundColor(Color::srgb_u8(54, 58, 63)), bevy::ui::FocusPolicy::Block,
        Node { position_type: PositionType::Absolute, left: Val::Px(16.), top: Val::Px(126.),
            width: Val::Px(184.), height: Val::Px(36.), justify_content: JustifyContent::Center,
            align_items: AlignItems::Center, ..default() })).with_children(|button| {
        button.spawn((PauseButtonLabel, Text::new("En attente"),
            TextFont { font: FontSource::Handle(assets.load("fonts/DejaVuSans.ttf")), font_size: FontSize::Px(16.), ..default() },
            TextColor(Color::srgb_u8(255, 255, 255)), bevy::picking::Pickable::IGNORE, bevy::ui::FocusPolicy::Pass));
    });
}
fn collect(mut controls: ResMut<Controls>, mut keys: MessageReader<KeyboardInput>,
    mut lost: MessageReader<KeyboardFocusLost>, windows: Query<(Entity, &Window), With<PrimaryWindow>>) {
    controls.tap = false;
    let focus_lost = lost.read().next().is_some(); lost.clear();
    let Ok((entity, window)) = windows.single() else { controls.suspend(); controls.window = None; keys.clear(); return; };
    if controls.window != Some(entity) { controls.suspend(); controls.window = Some(entity); }
    if focus_lost || !window.focused { controls.suspend(); controls.window = None; keys.clear(); return; }
    for key in keys.read().filter(|key| key.window == entity) { controls.key(key.key_code, key.state, key.repeat); }
}
fn drive(mut controls: ResMut<Controls>, mut connection: ResMut<crate::Connection>, mut state: ResMut<crate::Match>,
    clock: Res<crate::native_effect_clock::EffectClock>, time: Res<Time<Real>>, shop: Res<crate::shop_ui::Filters>,
    windows: Query<(Entity, &Window), With<PrimaryWindow>>,
    mut texts: Query<&mut Text, (With<PauseHud>, Without<PauseButtonLabel>)>,
    mut buttons: Query<(Ref<Interaction>, &mut BackgroundColor), With<PauseButton>>,
    mut button_labels: Query<&mut Text, (With<PauseButtonLabel>, Without<PauseHud>)>) {
    let identity = connection.inventory_input_identity();
    let live = state.snapshot.as_ref().is_some_and(|snapshot| Some(snapshot.session) == connection.session
        && snapshot.winner.is_none() && snapshot.result.is_none());
    let enabled = connection.ready() && clock.presentation_ready() && live;
    let now = time.elapsed_secs_f64();
    state.pause_control.update(identity, enabled, clock.pause_ui_status(), now);
    let human = enabled && !shop.open && !shop.focused
        && windows.single().is_ok_and(|(entity, window)| window.focused && controls.window == Some(entity));
    if let Ok((interaction, _)) = buttons.single() {
        controls.button(*interaction, interaction.is_changed());
    }
    if controls.consume(identity, human) { state.pause_control.request(&mut connection, now); }
    let label = state.pause_control.label();
    for mut text in &mut texts { if **text != label { **text = label.clone(); } }
    let (button_label, can_request) = state.pause_control.button_label();
    for mut text in &mut button_labels { if **text != button_label { **text = button_label.into(); } }
    for (interaction, mut color) in &mut buttons {
        let rgb = if !human || !can_request { (54, 58, 63) }
            else if *interaction == Interaction::Pressed { (30, 83, 123) }
            else if *interaction == Interaction::Hovered { (48, 114, 160) }
            else { (35, 91, 132) };
        *color = BackgroundColor(Color::srgb_u8(rgb.0, rgb.1, rgb.2));
    }
}

#[cfg(test)]
#[path = "ordinary_pause_tests.rs"]
mod tests;
