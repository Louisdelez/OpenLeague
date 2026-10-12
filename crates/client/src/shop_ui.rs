//! Functional historical data shop. Full catalog and original layout remain incomplete.
use super::*;
use bevy::input::keyboard::{KeyboardInput, KeyboardFocusLost};
#[path = "shop_text_input.rs"]
mod text_input;
#[derive(Resource)]
pub(super) struct Filters {
    pub focused: bool,
    pub open: bool,
    query: String,
    category: u8,
    inspected: Option<u32>,
}
impl Default for Filters {
    fn default() -> Self {
        Self {
            focused: false,
            open: std::env::var_os("OPENLEAGUE_SHOP_OPEN").is_some(),
            query: std::env::var("OPENLEAGUE_SHOP_QUERY").unwrap_or_default(),
            category: 0,
            inspected: std::env::var("OPENLEAGUE_SHOP_PREVIEW_ITEM")
                .ok()
                .and_then(|s| s.parse().ok()),
        }
    }
}
#[derive(Component)]
pub(super) struct ShopPanel;
#[derive(Component)]
pub(super) struct ShopButton(Action);
#[derive(Component)]
pub(super) enum ShopControl {
    Search,
    Category(u8),
    Clear,
}
#[derive(Component)]
pub(super) struct InventoryLabel;
#[derive(Component)]
pub(super) struct SearchLabel;
#[derive(Component)]
pub(super) struct DetailLabel;
#[derive(Component)]
pub(super) struct PriceLabel(u32);
fn item_name(id: u32) -> &'static str {
    openleague_core::shop::catalog()
        .iter()
        .find(|i| i.id == id)
        .map(|i| i.name.as_str())
        .unwrap_or("Inconnu")
}
fn normalized(value: &str) -> String {
    value
        .to_lowercase()
        .chars()
        .map(|c| match c {
            'é' | 'è' | 'ê' | 'ë' => 'e',
            'à' | 'â' => 'a',
            'î' | 'ï' => 'i',
            'ô' => 'o',
            'ù' | 'û' => 'u',
            'ç' => 'c',
            _ => c,
        })
        .collect()
}
fn matches(i: &openleague_core::shop::Item, f: &Filters) -> bool {
    let name = normalized(&i.name);
    let search = normalized(&f.query);
    let v = i.bonuses;
    search.split_whitespace().all(|q| name.contains(q))
        && match f.category {
            0 => true,
            1 => {
                v.armor_penetration > 0.
                    || v.armor_penetration_percent > 0.
                    || v.damage > 0.
                    || v.attack_speed > 0.
                    || v.critical_chance > 0.
                    || v.critical_damage > 0.
            }
            2 => {
                v.health > 0. || v.armor > 0. || v.magic_resist > 0. || v.health_regen_percent > 0.
            }
            // Local utility group keeps mana/movement and includes the implemented
            // potions classified Consumable by original item data / Data Dragon4.20.1.
            3 => i.consumable.is_some() || v.mana > 0. || v.mana_regen_percent > 0. || v.move_speed > 0.,
            4 => v.ability_power > 0. || v.cooldown_reduction > 0. || v.magic_penetration > 0. || v.magic_penetration_percent > 0.,
            _ => false,
        }
}
pub fn setup(mut commands: Commands, assets: Res<AssetServer>, filters: Res<Filters>) {
    let font = TextFont {
        font: FontSource::Handle(assets.load("fonts/DejaVuSans.ttf")),
        font_size: FontSize::Px(14.),
        ..default()
    };
    commands
        .spawn((
            Node {
                position_type: PositionType::Absolute,
                left: Val::Px(18.),
                top: Val::Px(18.),
                width: Val::Px(390.),
                flex_direction: FlexDirection::Column,
                padding: UiRect::all(Val::Px(10.)),
                row_gap: Val::Px(4.),
                display: if filters.open {
                    Display::Flex
                } else {
                    Display::None
                },
                ..default()
            },
            BackgroundColor(Color::srgba(0.02, 0.03, 0.05, 0.95)),
            ShopPanel,
        ))
        .with_children(|parent| {
            parent.spawn((Text::new("Boutique - P pour ouvrir/fermer"), font.clone()));
            parent.spawn((
                Text::new(format!(
                    "Catalogue partiel : {} objets actifs",
                    openleague_core::shop::catalog().len()
                )),
                font.clone(),
            ));
            parent
                .spawn((
                    Button,
                    Node {
                        padding: UiRect::all(Val::Px(5.)),
                        ..default()
                    },
                    BackgroundColor(Color::srgb(0.1, 0.12, 0.15)),
                    ShopControl::Search,
                ))
                .with_children(|p| {
                    p.spawn((
                        Text::new("Rechercher un objet..."),
                        font.clone(),
                        SearchLabel,
                    ));
                });
            parent
                .spawn(Node {
                    flex_direction: FlexDirection::Row,
                    column_gap: Val::Px(4.),
                    ..default()
                })
                .with_children(|p| {
                    for (id, name) in [
                        (0, "Tous"),
                        (1, "Combat"),
                        (2, "Defense"),
                        (3, "Utilitaire"),
                        (4, "Magie"),
                    ] {
                        p.spawn((
                            Button,
                            Node {
                                padding: UiRect::all(Val::Px(4.)),
                                ..default()
                            },
                            BackgroundColor(Color::srgb(0.1, 0.2, 0.3)),
                            ShopControl::Category(id),
                        ))
                        .with_children(|c| {
                            c.spawn((Text::new(name), font.clone()));
                        });
                    }
                    p.spawn((
                        Button,
                        Node {
                            padding: UiRect::all(Val::Px(4.)),
                            ..default()
                        },
                        BackgroundColor(Color::srgb(0.2, 0.15, 0.1)),
                        ShopControl::Clear,
                    ))
                    .with_children(|c| {
                        c.spawn((Text::new("Effacer"), font.clone()));
                    });
                });
            parent
                .spawn(Node {
                    flex_direction: FlexDirection::Row,
                    flex_wrap: FlexWrap::Wrap,
                    column_gap: Val::Px(4.),
                    row_gap: Val::Px(4.),
                    ..default()
                })
                .with_children(|catalog| {
                    for item in openleague_core::shop::catalog() {
                        catalog
                            .spawn((
                                Button,
                                Node {
                                    width: Val::Percent(49.),
                                    padding: UiRect::all(Val::Px(4.)),
                                    column_gap: Val::Px(4.),
                                    ..default()
                                },
                                BackgroundColor(Color::srgb(0.1, 0.2, 0.3)),
                                ShopButton(Action::Buy { item: item.id }),
                            ))
                            .with_children(|p| {
                                p.spawn((
                                    ImageNode::new(
                                        assets.load(format!("ui/items/{}.png", item.id)),
                                    ),
                                    Node {
                                        width: Val::Px(24.),
                                        height: Val::Px(24.),
                                        ..default()
                                    },
                                ));
                                p.spawn((
                                    Text::new(format!("{}\n{:.0} or", item.name, item.price)),
                                    font.clone(),
                                    PriceLabel(item.id),
                                ));
                            });
                    }
                });
            parent.spawn((Text::new("Inventaire"), font.clone(), InventoryLabel));
            parent
                .spawn(Node {
                    flex_direction: FlexDirection::Row,
                    flex_wrap: FlexWrap::Wrap,
                    column_gap: Val::Px(4.),
                    row_gap: Val::Px(4.),
                    ..default()
                })
                .with_children(|p| {
                    for slot in 0..6 {
                        p.spawn((
                            Button,
                            Node {
                                width: Val::Percent(32.),
                                padding: UiRect::all(Val::Px(4.)),
                                ..default()
                            },
                            BackgroundColor(Color::srgb(0.25, 0.1, 0.1)),
                            ShopButton(Action::Sell { slot }),
                        ))
                        .with_children(|c| {
                            c.spawn((Text::new(format!("Vendre {}", slot + 1)), font.clone()));
                        });
                        p.spawn((Button,Node {width:Val::Percent(32.),padding:UiRect::all(Val::Px(4.)),..default()},BackgroundColor(Color::srgb(0.1,0.22,0.12)),ShopButton(Action::UseItem {slot}))).with_children(|c| {
                            c.spawn((Text::new(format!("Utiliser {}",slot+1)),font.clone()));
                        });
                    }
                });
        });
    commands.spawn((
        Text::new("Survolez un objet"),
        font,
        Node {
            position_type: PositionType::Absolute,
            left: Val::Px(420.),
            top: Val::Px(18.),
            width: Val::Px(320.),
            padding: UiRect::all(Val::Px(10.)),
            ..default()
        },
        BackgroundColor(Color::srgba(0.02, 0.03, 0.05, 0.95)),
        DetailLabel,
    ));
}
pub fn update(
    keys: Res<ButtonInput<KeyCode>>,
    mut events: MessageReader<KeyboardInput>,
    mut focus_lost: MessageReader<KeyboardFocusLost>,
    mut text_input: Local<text_input::Input>,
    windows: Query<(Entity, &Window), With<bevy::window::PrimaryWindow>>,
    state: Res<Match>,
    mut connection: ResMut<Connection>,
    mut f: ResMut<Filters>,
    mut panels: Query<
        (&mut Node, Option<&ShopPanel>, Option<&DetailLabel>),
        Or<(With<ShopPanel>, With<DetailLabel>)>,
    >,
    buttons: Query<(&Interaction, &ShopButton), Changed<Interaction>>,
    controls: Query<(&Interaction, &ShopControl), Changed<Interaction>>,
    mut rows: Query<
        (&ShopButton, &mut Node, &mut BackgroundColor),
        (With<ShopButton>, Without<ShopPanel>, Without<DetailLabel>),
    >,
    mut labels: Query<(
        &mut Text,
        Option<&InventoryLabel>,
        Option<&SearchLabel>,
        Option<&DetailLabel>,
        Option<&PriceLabel>,
    )>,
) {
    if state.snapshot.as_ref().is_some_and(|s|s.winner.is_some()) {
        f.open=false;f.focused=false;
        for (mut panel, _, _) in &mut panels {panel.display=Display::None;}
        events.clear();focus_lost.clear();text_input.reset();return;
    }
    if keys.just_pressed(KeyCode::Escape) {
        f.focused = false;
    }
    if keys.just_pressed(KeyCode::KeyP) && !f.focused {
        f.open = !f.open;
    }
    for (mut panel, _, _) in &mut panels {
        panel.display = if f.open { Display::Flex } else { Display::None };
    }
    for (interaction, control) in &controls {
        if *interaction == Interaction::Pressed {
            match control {
                ShopControl::Search => f.focused = true,
                ShopControl::Category(id) => {
                    f.category = *id;
                    f.focused = false;
                }
                ShopControl::Clear => {
                    f.query.clear();
                    f.category = 0;
                    f.focused = false;
                }
            }
        }
    }
    let lost=focus_lost.read().next().is_some();focus_lost.clear();
    let window=windows.single().ok().map(|(entity,window)|(entity,window.focused));
    let identity=connection.session.zip(connection.id);
    let mut focused=f.focused;
    let open=f.open;
    text_input.update(&mut f.query,&mut focused,open,window,identity,lost,events.read(),text_input::clipboard_text);
    // update may reject a complete frame, but the reader must not retain it.
    events.clear();f.focused=focused;
    for (interaction, button) in &buttons {
        if *interaction == Interaction::Hovered || *interaction == Interaction::Pressed {
            if let Action::Buy { item } = button.0 {
                f.inspected = Some(item);
            }
        }
        if *interaction == Interaction::Pressed && connection.ready() {
            f.focused = false;
            if let Err(error)=connection.send_action(button.0.clone()) {connection.report(&error);}
        }
    }
    let player = state
        .snapshot
        .as_ref()
        .and_then(|s| s.players.iter().find(|p| Some(p.id) == connection.id));
    for (button, mut node, mut color) in &mut rows {
        if let Action::Buy { item } = button.0 {
            if let Some(i) = openleague_core::shop::catalog()
                .iter()
                .find(|i| i.id == item)
            {
                node.display = if matches(i, &f) {
                    Display::Flex
                } else {
                    Display::None
                };
                let affordable = player.is_some_and(|p| {
                    openleague_core::shop::quote_with_counts(&p.inventory, &p.inventory_counts, item).is_ok_and(|q| q.cost <= p.gold)
                });
                color.0 = if affordable {
                    Color::srgb(0.1, 0.2, 0.3)
                } else {
                    Color::srgb(0.12, 0.12, 0.14)
                };
            }
        }
    }
    for (mut text, inventory, search, details, price) in &mut labels {
        if inventory.is_some() {
            if let Some(p) = player {
                **text = format!(
                    "Or {:.1}\n{}",
                    p.gold,
                    p.inventory
                        .iter()
                        .enumerate()
                        .map(|(i, id)| format!(
                            "{}: {} x{}",
                            i + 1,
                            id.map(item_name).unwrap_or("vide"),
                            openleague_core::shop::inventory_count(p, i)
                        ))
                        .collect::<Vec<_>>()
                        .join(" | ")
                );
            }
        } else if search.is_some() {
            **text = format!(
                "Recherche : {}{}{}",
                f.query,
                if f.focused { " |" } else { " (cliquer)" },
                text_input.error.map(|error|format!("\n{error}")).unwrap_or_default()
            );
        } else if details.is_some() {
            **text = if !f.open {
                String::new()
            } else if let Some(i) = f
                .inspected
                .and_then(|id| openleague_core::shop::catalog().iter().find(|i| i.id == id))
            {
                let calc = player
                    .and_then(|p| {
                        openleague_core::shop::regeneration_tooltip(&p.champion, p.level, i.id)
                    })
                    .unwrap_or(0.);
                let remaining = player
                    .and_then(|p| openleague_core::shop::quote_with_counts(&p.inventory, &p.inventory_counts, i.id).ok())
                    .map(|q| format!("Reste a payer : {:.0} or", q.cost))
                    .unwrap_or_else(|| "Inventaire plein".into());
                let recipe = i
                    .recipe
                    .iter()
                    .map(|id| item_name(*id))
                    .collect::<Vec<_>>()
                    .join(" + ");
                format!(
                    "{}\nPrix total : {:.0} or\n{}\n\n{}\n\n{}",
                    i.name,
                    i.price,
                    remaining,
                    i.description.replace("{regen_5s}", &format!("{:.0}", calc)),
                    if recipe.is_empty() {
                        "Composant de base".into()
                    } else {
                        format!("Recette : {}", recipe)
                    }
                )
            } else {
                "Survolez un objet pour voir ses effets".into()
            };
        } else if let Some(price) = price {
            if let Some(i) = openleague_core::shop::catalog()
                .iter()
                .find(|i| i.id == price.0)
            {
                let cost = player
                    .and_then(|p| openleague_core::shop::quote_with_counts(&p.inventory, &p.inventory_counts, i.id).ok())
                    .map(|q| q.cost)
                    .unwrap_or(i.price);
                **text = format!("{}\n{:.0} or", i.name, cost);
            }
        }
    }
}
#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn native_accented_names_match_unaccented_and_case_insensitive_search() {
        let f = Filters {
            query: "COLLIER rafraichissant".into(),
            category: 0,
            focused: false,
            open: true,
            inspected: None,
        };
        let item = openleague_core::shop::catalog()
            .iter()
            .find(|i| i.id == 1006)
            .unwrap();
        assert!(matches(item, &f));
    }
    #[test]
    fn filters_exclude_nonmatching_stats_and_require_every_search_word() {
        let mut f = Filters {
            query: String::new(),
            category: 1,
            focused: false,
            open: true,
            inspected: None,
        };
        let item = openleague_core::shop::catalog()
            .iter()
            .find(|i| i.id == 1006)
            .unwrap();
        assert!(!matches(item, &f));
        f.category = 2;
        assert!(matches(item, &f));
        f.query = "collier dague".into();
        assert!(!matches(item, &f));
    }
    #[test]
    fn magic_category_includes_native_power_and_cooldown_components() {
        let f=Filters {query:String::new(),category:4,focused:false,open:true,inspected:None};
        for id in [1026,1052,1058,3108,3114,3067,3101,3024] {
            let item=openleague_core::shop::catalog().iter().find(|i|i.id==id).unwrap();
            assert!(matches(item,&f),"missing magic/cooldown item {id}");
        }
        assert!(!matches(openleague_core::shop::catalog().iter().find(|i|i.id==1036).unwrap(),&f));
    }

    #[test]
    fn penetration_items_match_their_combat_or_magic_categories() {
        let mut f=Filters {query:String::new(),category:1,focused:false,open:true,inspected:None};
        for id in [3134,3035] {assert!(matches(openleague_core::shop::catalog().iter().find(|i|i.id==id).unwrap(),&f));}
        f.category=4;
        for id in [3135,3136,3020] {assert!(matches(openleague_core::shop::catalog().iter().find(|i|i.id==id).unwrap(),&f));}
    }


    #[test]
    fn utility_category_includes_supported_potions_without_passive_bonuses() {
        let mut filters=Filters {query:String::new(),category:3,focused:false,open:true,inspected:None};
        for id in [2003,2004] {
            let item=openleague_core::shop::catalog().iter().find(|item|item.id==id).unwrap();
            assert!(item.consumable.is_some());
            assert_eq!([item.bonuses.mana,item.bonuses.mana_regen_percent,item.bonuses.move_speed],[0.;3]);
            filters.category=3;assert!(matches(item,&filters),"consumable {id} must appear in Utilitaire");
            filters.category=0;assert!(matches(item,&filters));
            // Healing/mana restored over time is not a passive stat category.
            for category in [1,2,4] {filters.category=category;assert!(!matches(item,&filters));}
        }
    }

    #[test]
    fn utility_filter_preserves_existing_items_and_respects_potion_search() {
        let mut filters=Filters {query:String::new(),category:3,focused:false,open:true,inspected:None};
        let mut ids=openleague_core::shop::catalog().iter().filter(|item|matches(item,&filters)).map(|item|item.id).collect::<Vec<_>>();
        ids.sort_unstable();assert_eq!(ids,[1001,1004,1027,2003,2004,3020,3024,3114]);
        let health=openleague_core::shop::catalog().iter().find(|item|item.id==2003).unwrap();
        let mana=openleague_core::shop::catalog().iter().find(|item|item.id==2004).unwrap();
        filters.query="POTION soin".into();assert!(matches(health,&filters));assert!(!matches(mana,&filters));
        filters.query="potion mana".into();assert!(matches(mana,&filters));assert!(!matches(health,&filters));
        filters.query="potion impossible".into();assert!(!matches(health,&filters));assert!(!matches(mana,&filters));
    }
}
