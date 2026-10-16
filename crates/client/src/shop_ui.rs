//! Source-backed Foundry4.20 shop presentation, scoped to the31 admitted Map10 items.
//! Own renderer/input behavior; full native shop/280-item gameplay and exact pixels remain open.
use super::*;
use bevy::input::keyboard::{KeyboardInput, KeyboardFocusLost};
#[path = "shop_text_input.rs"]
mod text_input;
#[path = "shop_native_foundry.rs"]
mod foundry;
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
#[derive(Component, Clone, Copy)]
pub(super) enum ShopControl {
    Search, Category(u8), Clear, SelectItem(u32), SelectInventory(u8),
    BuySelected, SellSelected, Close, Grid, List, AllItems, Recommended, Undo,
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
fn map10_purchase_available(id: u32) -> bool {
    openleague_core::shop::map10_available(id) == Some(true)
}
fn map10_purchase_catalog() -> impl Iterator<Item = &'static openleague_core::shop::Item> {
    openleague_core::shop::catalog()
        .iter()
        .filter(|item| map10_purchase_available(item.id))
}
fn map10_action_available(action: &Action) -> bool {
    match action {
        Action::Buy { item } => map10_purchase_available(*item),
        _ => true,
    }
}
fn map10_purchase_notice(id: u32) -> Option<&'static str> {
    match openleague_core::shop::map10_available(id) {
        Some(true) => None,
        Some(false) => Some("Indisponible sur cette carte"),
        None => Some("Disponibilité sur cette carte inconnue"),
    }
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
    if !map10_purchase_available(i.id) {
        return false;
    }
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
// Source positions below are the fresh, unresized Foundry root346 placements.
// The application keeps its six authoritative slots and implemented item catalog.
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
enum SelectedIntent { Buy, Sell }
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
struct SelectedInventory { slot: u8, item: u32 }
#[derive(Default)]
pub(super) struct Presentation {
    identity: Option<(u64, u32)>,
    inventory: Option<SelectedInventory>,
    grid: bool,
}
#[derive(Component)] struct CatalogRow(u32);
#[derive(Component)] struct CatalogIcon;
#[derive(Component)] struct CatalogText;
#[derive(Component)] struct InventoryIcon(u8);
#[derive(Component)] struct DetailIcon;
#[derive(Component)] struct CatalogPane;
#[derive(Component, Clone, Copy)]
enum NativeText { Search, Gold, Detail, SelectedName, SelectedPrice, Recipe, SellPrice, Count(u8), Price(u32), Notice }
#[derive(Component)]
struct ButtonSkin {
    button: Entity,
    part: foundry::Part,
    layer: usize,
    origin: [f32; 2],
    scale: [f32; 2],
}
const PANEL_WIDTH: f32 = 1170.;
const PANEL_HEIGHT: f32 = 920.;

fn native_font(assets: &AssetServer, size: f32) -> TextFont {
    TextFont { font: FontSource::Handle(assets.load(foundry::FONT_PATH)), font_size: FontSize::Px(size), ..default() }
}
fn artwork(parent: &mut ChildSpawnerCommands, images: &foundry::SourceImages,
    part: foundry::Part, x: f32, y: f32, sx: f32, sy: f32) {
    for region in foundry::layers(part, foundry::State::Up) {
        let [rx,ry,w,h]=region.bounds;
        parent.spawn((foundry::image(images,region),foundry::px_node([x+rx*sx,y+ry*sy,w*sx,h*sy])));
    }
}
fn native_text(parent: &mut ChildSpawnerCommands, font: &TextFont, text: impl Into<String>,
    rect: [f32;4], role: Option<NativeText>) {
    let mut entity=parent.spawn((Text::new(text),font.clone(),TextColor(Color::srgb_u8(228,224,206)),foundry::px_node(rect)));
    if let Some(role)=role {entity.insert(role);}
}
fn native_button(parent: &mut ChildSpawnerCommands, images: &foundry::SourceImages,
    font: &TextFont, part: foundry::Part, control: ShopControl, anchor: [f32;2],
    scale: [f32;2], label: Option<(&str,[f32;4])>) {
    let region=foundry::region(part,foundry::State::Up)
        .or_else(||foundry::region(part,foundry::State::Over)).expect("qualified native button shape");
    let [rx,ry,w,h]=region.bounds;
    let mut entity=parent.spawn((Button,control,foundry::px_node([anchor[0]+rx*scale[0],anchor[1]+ry*scale[1],w*scale[0],h*scale[1]])));
    let button=entity.id();
    entity.with_children(|children| {
        // Reserve all source layers, including the second inventory highlight.
        // Missing up/disabled labels remain transparent, never fabricated images.
        let count=[foundry::State::Up,foundry::State::Over,foundry::State::Down,foundry::State::Selected,foundry::State::Disabled]
            .into_iter().map(|state|foundry::layers(part,state).len()).max().unwrap_or(0);
        for layer in 0..count {
            let skin=ButtonSkin {button,part,layer,origin:[rx,ry],scale};
            if let Some(region)=foundry::layers(part,foundry::State::Up).get(layer).copied() {
                let [x,y,w,h]=region.bounds;
                children.spawn((skin,foundry::image(images,region),foundry::px_node([(x-rx)*scale[0],(y-ry)*scale[1],w*scale[0],h*scale[1]])));
            } else {children.spawn((skin,ImageNode::default(),Node {display:Display::None,..default()}));}
        }
        if let Some((text,rect))=label {native_text(children,font,text,rect,None);}
        if let ShopControl::SelectInventory(slot)=control {
            // Keep image and count inside the clickable slot hierarchy. A root
            // sibling image would cover its button in Bevy UI hit testing.
            children.spawn((InventoryIcon(slot),ImageNode::default(),foundry::px_node([3.5,3.5,44.,44.])));
            native_text(children,font,"",[27.,32.,22.,22.],Some(NativeText::Count(slot)));
        }
    });
}

pub fn setup(mut commands: Commands, assets: Res<AssetServer>, filters: Res<Filters>) {
    let images=foundry::load(&assets);
    commands.insert_resource(images.clone());
    let font=native_font(&assets,16.);
    commands.spawn((ShopPanel,UiTransform::IDENTITY,GlobalZIndex(200),Node {
        position_type:PositionType::Absolute,width:Val::Px(PANEL_WIDTH),height:Val::Px(PANEL_HEIGHT),
        display:if filters.open {Display::Flex}else{Display::None},..default()
    })).with_children(|root| {
        artwork(root,&images,foundry::Part::Background,0.,69.5,1.1436767578125,1.66015625);
        artwork(root,&images,foundry::Part::Header,0.,0.,1.,1.);
        artwork(root,&images,foundry::Part::GoldPlate,501.,12.,1.,1.);
        artwork(root,&images,foundry::Part::FilterPanel,18.85,189.,4.73333740234375,10.48333740234375);
        artwork(root,&images,foundry::Part::FilterPanel,316.85,189.,4.73333740234375,10.4166259765625);
        artwork(root,&images,foundry::Part::Details,627.,538.,8.433334350585938,5.5333251953125);
        native_button(root,&images,&font,foundry::Part::TabAll,ShopControl::AllItems,[307.5,72.5],[1.,1.],Some(("Tous les objets",[11.5,15.5,208.,26.])));
        native_button(root,&images,&font,foundry::Part::TabRecommended,ShopControl::Recommended,[27.,72.5],[1.2363739013671875,1.],Some(("Recommandés",[13.,15.5,231.,26.])));
        // Original recommendation payload is not admitted; its tab is visible disabled.
        native_button(root,&images,&font,foundry::Part::GridButton,ShopControl::Grid,[547.5,96.25],[1.,1.],None);
        native_button(root,&images,&font,foundry::Part::ListButton,ShopControl::List,[587.,96.5],[1.,1.],None);
        native_button(root,&images,&font,foundry::Part::Close,ShopControl::Close,[1068.5,14.75],[0.9997406005859375,0.9997406005859375],None);
        artwork(root,&images,foundry::Part::Search,19.5,131.,1.,1.);
        root.spawn((Button,ShopControl::Search,foundry::px_node([59.5,145.,461.5,34.]))).with_children(|input| {
            native_text(input,&font,"Rechercher un objet...",[0.,0.,457.,30.],Some(NativeText::Search));
        });
        // Keep the existing clear operation, using the native close/clear motif.
        native_button(root,&images,&font,foundry::Part::Close,ShopControl::Clear,[483.,141.],[0.5,0.5],None);
        for (category,label,y) in [(0,"Tous les objets",191.),(1,"Attaque",250.),(2,"Défense",303.),(4,"Magie",356.),(3,"Autres",409.)] {
            native_button(root,&images,&font,foundry::Part::Filter,ShopControl::Category(category),[18.85,y],[1.,1.],Some((label,[14.,9.,251.,26.])));
        }
        // Clipping and mouse-wheel scrolling are own-client UI behavior. The
        // native category payload and complete resize controller remain pending.
        root.spawn((CatalogPane,ScrollPosition::default(),Node {
            overflow:Overflow::scroll_y(),..foundry::px_node([321.85,194.,258.,615.])
        })).with_children(|catalog| {
            for (index,item) in map10_purchase_catalog().enumerate() {
                let row=foundry::region(foundry::Part::CatalogRow,foundry::State::Up).unwrap();
                catalog.spawn((Button,ShopControl::SelectItem(item.id),CatalogRow(item.id),
                    foundry::image(&images,row),foundry::px_node([3.,2.+index as f32*70.,240.,65.])))
                    .with_children(|children| {
                        children.spawn((CatalogIcon,ImageNode::new(assets.load(format!("ui/items/{}.png",item.id))),foundry::px_node([10.5,9.5,44.,44.])));
                        children.spawn((CatalogText,NativeText::Price(item.id),Text::new(format!("{}\n{:.0} PO",item.name,item.price)),font.clone(),TextColor(Color::srgb_u8(228,224,206)),foundry::px_node([63.,8.,169.,48.])));
                    });
            }
        });
        native_text(root,&font,"Débloque :",[647.,90.,463.,32.],None);
        native_text(root,&font,"Composants",[647.,270.,463.,32.],None);
        native_text(root,&font,"",[647.,313.,455.,190.],Some(NativeText::Recipe));
        root.spawn((DetailIcon,ImageNode::default(),foundry::px_node([649.4,561.,55.,55.])));
        native_text(root,&font,"Sélectionnez un objet",[704.,546.,228.,32.],Some(NativeText::SelectedName));
        native_text(root,&font,"",[744.5,589.,200.,30.],Some(NativeText::SelectedPrice));
        native_text(root,&font,"",[645.5,622.,449.,230.],Some(NativeText::Detail));
        // Buy sprite176 is at Details177(627,536)+local(339.5,-.5).
        native_button(root,&images,&font,foundry::Part::Buy,ShopControl::BuySelected,
            [966.5,535.4999],[1.,1.000152587890625],Some(("ACHETER",[45.5,15.5,137.,32.])));
        // Six server-owned inventory slots; native seventh/trinket applicability remains open.
        for slot in 0..6u8 {
            let x=27.+55.*slot as f32*0.999847412109375;
            native_button(root,&images,&font,foundry::Part::InventorySlot,ShopControl::SelectInventory(slot),[x,835.],[0.999847412109375,1.],None);
        }
        native_button(root,&images,&font,foundry::Part::Sell,ShopControl::SellSelected,
            [413.94098,854.],[0.999847412109375,1.0233154296875],Some(("VENDRE",[7.,10.,125.,27.])));
        native_button(root,&images,&font,foundry::Part::Undo,ShopControl::Undo,
            [491.92908,849.],[0.999847412109375,1.],None);
        native_text(root,&font,"",[27.,899.,570.,22.],Some(NativeText::Notice));
        native_text(root,&font,"",[490.,830.,180.,25.],Some(NativeText::Gold));
        native_text(root,&font,"",[589.,14.5,181.,32.],Some(NativeText::Gold));
        native_text(root,&font,"",[414.,900.,166.,22.],Some(NativeText::SellPrice));
    });
}

fn selected_action(intent: SelectedIntent, selected: Option<u32>, inventory: Option<SelectedInventory>,
    player: Option<&openleague_core::Champion>, ready: bool, open: bool) -> Option<Action> {
    if !ready || !open {return None;}
    let player=player?;
    match intent {
        SelectedIntent::Buy => {
            let item=selected?;
            if !map10_purchase_available(item) {return None;}
            let quote=openleague_core::shop::quote_with_counts(&player.inventory,&player.inventory_counts,item).ok()?;
            (quote.cost<=player.gold).then_some(Action::Buy {item})
        }
        SelectedIntent::Sell => {
            let chosen=inventory?;
            if player.inventory.get(chosen.slot as usize).copied().flatten()!=Some(chosen.item) {return None;}
            openleague_core::shop::catalog().iter().find(|i|i.id==chosen.item)?.sell_price?;
            Some(Action::Sell {slot:chosen.slot})
        }
    }
}

#[derive(bevy::ecs::system::SystemParam)]
pub struct PresentationUi<'w,'s> {
    roots: Query<'w,'s,(&'static mut Node,&'static mut UiTransform),With<ShopPanel>>,
    changed: Query<'w,'s,(&'static Interaction,&'static ShopControl),Changed<Interaction>>,
    controls: Query<'w,'s,(&'static Interaction,&'static ShopControl)>,
    skins: Query<'w,'s,(&'static ButtonSkin,&'static mut Node,&'static mut ImageNode),(Without<ShopPanel>,Without<CatalogRow>)>,
    rows: Query<'w,'s,(&'static CatalogRow,&'static Interaction,&'static mut Node,&'static mut ImageNode),(Without<ShopPanel>,Without<ButtonSkin>)>,
    row_children: Query<'w,'s,(&'static ChildOf,Option<&'static CatalogIcon>,&'static mut Node),(Without<ShopPanel>,Without<ButtonSkin>,Without<CatalogRow>)>,
    texts: Query<'w,'s,(&'static NativeText,&'static mut Text)>,
    inventory_icons: Query<'w,'s,(&'static InventoryIcon,&'static mut ImageNode),(Without<ButtonSkin>,Without<CatalogRow>,Without<DetailIcon>)>,
    detail_icons: Query<'w,'s,&'static mut ImageNode,(With<DetailIcon>,Without<InventoryIcon>,Without<ButtonSkin>,Without<CatalogRow>)>,
    scroll: Query<'w,'s,&'static mut ScrollPosition,With<CatalogPane>>,
}

pub fn update(
    keys:Res<ButtonInput<KeyCode>>,mut events:MessageReader<KeyboardInput>,mut focus_lost:MessageReader<KeyboardFocusLost>,
    mut wheel:MessageReader<bevy::input::mouse::MouseWheel>,mut text_input:Local<text_input::Input>,mut presentation:Local<Presentation>,
    windows:Query<(Entity,&Window),With<bevy::window::PrimaryWindow>>,state:Res<Match>,mut connection:ResMut<Connection>,
    mut f:ResMut<Filters>,assets:Res<AssetServer>,images:Res<foundry::SourceImages>,mut ui:PresentationUi,
) {
    let identity=connection.session.zip(connection.id);
    if presentation.identity!=identity {presentation.identity=identity;presentation.inventory=None;}
    if state.snapshot.as_ref().is_some_and(|s|s.winner.is_some()) {
        f.open=false;f.focused=false;presentation.inventory=None;
        for (mut node,_) in &mut ui.roots {node.display=Display::None;}
        events.clear();focus_lost.clear();wheel.clear();text_input.reset();return;
    }
    if keys.just_pressed(KeyCode::Escape) {f.focused=false;}
    if keys.just_pressed(KeyCode::KeyP)&&!f.focused {f.open=!f.open;}
    let window=windows.single().ok();
    let (width,height)=window.map(|(_,w)|(w.width(),w.height())).unwrap_or((1280.,800.));
    // Fresh base, no persisted resize. Native SetViewport padding/max/ceil rule.
    let scale=if height/(PANEL_HEIGHT+100.)<0.95||width/(PANEL_WIDTH+100.)<0.95 {
        ((height/(PANEL_HEIGHT+100.)).min(width/(PANEL_WIDTH+100.))*100.).ceil()/100.
    } else {0.95};
    let scale=scale.max(0.01);
    let x=(width/2.).floor()-(PANEL_WIDTH*scale/2.).floor();
    let y=(height/2.).floor()-(PANEL_HEIGHT*scale/2.).floor();
    for (mut node,mut transform) in &mut ui.roots {
        node.display=if f.open {Display::Flex}else{Display::None};
        // UiTransform scales around the node center; compensate to retain native top-left coordinates.
        node.left=Val::Px(x-PANEL_WIDTH*(1.-scale)/2.);node.top=Val::Px(y-PANEL_HEIGHT*(1.-scale)/2.);
        transform.scale=Vec2::splat(scale);
    }
    let player=state.snapshot.as_ref().and_then(|s|s.players.iter().find(|p|Some(p.id)==connection.id&&Some(s.session)==connection.session));
    if presentation.inventory.is_some_and(|chosen|player.and_then(|p|p.inventory.get(chosen.slot as usize).copied().flatten())!=Some(chosen.item)) {presentation.inventory=None;}
    for (interaction,control) in &ui.changed {
        if *interaction!=Interaction::Pressed||!f.open {continue;}
        match *control {
            ShopControl::Search=>f.focused=true,
            ShopControl::Category(category)=>{f.category=category;f.focused=false;for mut scroll in &mut ui.scroll {scroll.0.y=0.;}},
            ShopControl::Clear=>{f.query.clear();f.category=0;f.focused=false;},
            ShopControl::SelectItem(item)=>{if map10_purchase_available(item) {f.inspected=Some(item);presentation.inventory=None;f.focused=false;}},
            ShopControl::SelectInventory(slot)=>{
                if let Some(item)=player.and_then(|p|p.inventory.get(slot as usize).copied().flatten()) {
                    presentation.inventory=Some(SelectedInventory {slot,item});f.inspected=Some(item);f.focused=false;
                }
            },
            ShopControl::BuySelected|ShopControl::SellSelected=>{
                let intent=if matches!(control,ShopControl::BuySelected){SelectedIntent::Buy}else{SelectedIntent::Sell};
                if let Some(action)=selected_action(intent,f.inspected,presentation.inventory,player,connection.ready(),f.open) {
                    f.focused=false;if let Err(error)=connection.send_action(action) {connection.report(&error);}
                }
            },
            ShopControl::Close=>{f.open=false;f.focused=false;},
            ShopControl::Grid=>{presentation.grid=true;for mut scroll in &mut ui.scroll {scroll.0.y=0.;}},
            ShopControl::List=>{presentation.grid=false;for mut scroll in &mut ui.scroll {scroll.0.y=0.;}},
            ShopControl::AllItems=>{},
            ShopControl::Recommended|ShopControl::Undo=>{},
        }
    }
    let lost=focus_lost.read().next().is_some();focus_lost.clear();
    let mut focused=f.focused;let open=f.open;
    text_input.update(&mut f.query,&mut focused,open,window.map(|(e,w)|(e,w.focused)),identity,lost,events.read(),text_input::clipboard_text);
    events.clear();f.focused=focused;
    let visible=map10_purchase_catalog().filter(|item|matches(item,&f)).map(|i|i.id).collect::<Vec<_>>();
    let pane_hovered=ui.controls.iter().any(|(interaction,control)|*interaction!=Interaction::None&&matches!(control,ShopControl::SelectItem(_)));
    for event in wheel.read() {
        if f.open&&!f.focused&&pane_hovered&&window.is_some_and(|(e,w)|e==event.window&&w.focused) {
            let amount=match event.unit {bevy::input::mouse::MouseScrollUnit::Line=>event.y*55.,bevy::input::mouse::MouseScrollUnit::Pixel=>event.y};
            let content_height=if presentation.grid {visible.len().div_ceil(4) as f32*84.}else{visible.len() as f32*70.};
            for mut scroll in &mut ui.scroll {scroll.0.y=(scroll.0.y-amount).clamp(0.,(content_height-615.).max(0.));}
        }
    }
    let selected=f.inspected.and_then(|id|openleague_core::shop::catalog().iter().find(|i|i.id==id));
    for (row,interaction,mut node,mut image) in &mut ui.rows {
        let Some(index)=visible.iter().position(|id|*id==row.0) else {node.display=Display::None;continue;};
        node.display=Display::Flex;
        let part=if presentation.grid {foundry::Part::CatalogGridBackground}else{foundry::Part::CatalogRow};
        let state=if *interaction==Interaction::Pressed {foundry::State::Down}
            else if f.inspected==Some(row.0) {foundry::State::Selected}
            else if *interaction==Interaction::Hovered {foundry::State::Over}else{foundry::State::Up};
        if let Some(region)=foundry::region(part,state) {*image=foundry::image(&images,region);}
        let affordable=selected_action(SelectedIntent::Buy,Some(row.0),None,player,connection.ready(),f.open).is_some();
        if !affordable {image.color=Color::srgba(0.55,0.55,0.55,1.);}
        if presentation.grid {node.left=Val::Px((index%4) as f32*64.);node.top=Val::Px((index/4) as f32*84.);node.width=Val::Px(60.);node.height=Val::Px(78.);}
        else {node.left=Val::Px(3.);node.top=Val::Px(2.+index as f32*70.);node.width=Val::Px(240.);node.height=Val::Px(65.);}
    }
    for (parent,icon,mut node) in &mut ui.row_children {
        if ui.rows.get(parent.parent()).is_err() {continue;}
        if icon.is_some() {node.left=Val::Px(if presentation.grid {8.}else{10.5});node.top=Val::Px(if presentation.grid {8.}else{9.5});}
        else {node.display=if presentation.grid {Display::None}else{Display::Flex};}
    }
    for (skin,mut node,mut image) in &mut ui.skins {
        let Ok((interaction,control))=ui.controls.get(skin.button) else {node.display=Display::None;continue;};
        let disabled=match control {
            ShopControl::BuySelected=>selected_action(SelectedIntent::Buy,f.inspected,presentation.inventory,player,connection.ready(),f.open).is_none(),
            ShopControl::SellSelected=>selected_action(SelectedIntent::Sell,f.inspected,presentation.inventory,player,connection.ready(),f.open).is_none(),
            ShopControl::Recommended|ShopControl::Undo=>true,_=>false,
        };
        let selected=match control {ShopControl::Category(c)=>f.category==*c,ShopControl::AllItems=>true,
            ShopControl::SelectInventory(s)=>presentation.inventory.is_some_and(|i|i.slot==*s),
            ShopControl::Grid=>presentation.grid,ShopControl::List=>!presentation.grid,_=>false};
        let state=if disabled {foundry::State::Disabled}else if *interaction==Interaction::Pressed {foundry::State::Down}
            else if selected {foundry::State::Selected}else if *interaction==Interaction::Hovered {foundry::State::Over}else{foundry::State::Up};
        let layers=foundry::layers(skin.part,state);
        let local_disabled_tint=layers.is_empty()&&disabled;
        // Tabs have no authored disabled label: preserve their Up artwork with local disabled tint.
        let layers=if layers.is_empty()&&disabled {foundry::layers(skin.part,foundry::State::Up)}else{layers};
        if let Some(region)=layers.get(skin.layer).copied() {
            let [rx,ry,w,h]=region.bounds;node.display=Display::Flex;
            node.left=Val::Px((rx-skin.origin[0])*skin.scale[0]);node.top=Val::Px((ry-skin.origin[1])*skin.scale[1]);
            node.width=Val::Px(w*skin.scale[0]);node.height=Val::Px(h*skin.scale[1]);
            *image=foundry::image(&images,region);if local_disabled_tint {image.color=Color::srgba(0.6,0.6,0.6,1.);}
        } else {node.display=Display::None;}
    }
    for (slot,mut image) in &mut ui.inventory_icons {
        if let Some(item)=player.and_then(|p|p.inventory.get(slot.0 as usize).copied().flatten()) {
            image.image=assets.load(format!("ui/items/{item}.png"));image.color=Color::WHITE;
        } else {image.color=Color::NONE;}
    }
    for mut image in &mut ui.detail_icons {
        if let Some(item)=selected {image.image=assets.load(format!("ui/items/{}.png",item.id));image.color=Color::WHITE;}
        else {image.color=Color::NONE;}
    }
    for (role,mut text) in &mut ui.texts {
        **text=match *role {
            NativeText::Search=>if f.query.is_empty()&&!f.focused {"Rechercher un objet...".into()}else{format!("{}{}",f.query,if f.focused {" |"}else{""})},
            NativeText::Gold=>player.map(|p|p.gold.to_string()).unwrap_or_default(),
            NativeText::SelectedName=>selected.map(|i|i.name.clone()).unwrap_or_else(||"Sélectionnez un objet".into()),
            NativeText::SelectedPrice=>selected.map(|i|format!("{:.0} PO",player.and_then(|p|openleague_core::shop::quote_with_counts(&p.inventory,&p.inventory_counts,i.id).ok()).map(|q|q.cost).unwrap_or(i.price))).unwrap_or_default(),
            NativeText::Detail=>selected.map(|i|{
                let calc=player.and_then(|p|openleague_core::shop::regeneration_tooltip(&p.champion,p.level,i.id)).unwrap_or(0.);
                format!("{}\n\n{}",i.description.replace("{regen_5s}",&format!("{:.0}",calc)),map10_purchase_notice(i.id).unwrap_or(""))
            }).unwrap_or_default(),
            NativeText::Recipe=>selected.map(|i| {
                let from=i.recipe.iter().map(|id|item_name(*id)).collect::<Vec<_>>().join(" + ");
                let into=map10_purchase_catalog().filter(|candidate|candidate.recipe.contains(&i.id)).map(|candidate|candidate.name.as_str()).collect::<Vec<_>>().join(", ");
                format!("{}\n\n{}",if from.is_empty(){"Composant de base"}else{from.as_str()},into)
            }).unwrap_or_default(),
            NativeText::SellPrice=>presentation.inventory.and_then(|chosen|openleague_core::shop::catalog().iter().find(|i|i.id==chosen.item)?.sell_price).map(|price|format!("+{price:.0} PO")).unwrap_or_default(),
            NativeText::Count(slot)=>player.map(|p|openleague_core::shop::inventory_count(p,slot as usize)).filter(|count|*count>1).map(|count|count.to_string()).unwrap_or_default(),
            NativeText::Price(id)=>openleague_core::shop::catalog().iter().find(|i|i.id==id).map(|i|format!("{}\n{:.0} PO",i.name,player.and_then(|p|openleague_core::shop::quote_with_counts(&p.inventory,&p.inventory_counts,id).ok()).map(|q|q.cost).unwrap_or(i.price))).unwrap_or_default(),
            NativeText::Notice=>text_input.error.map(str::to_owned).unwrap_or_else(||connection.rejection.clone()),
        };
    }
    // Close may be pressed after the first layout pass; hide in the same frame.
    if !f.open {for (mut node,_) in &mut ui.roots {node.display=Display::None;}}
}

#[cfg(test)]
mod native_foundry_selection_tests {
    use super::*;
    fn game() -> openleague_core::Simulation {
        let nav=openleague_core::Navigation::load(include_str!("../../../assets/maps/tt_navigation_grid.json"),include_bytes!("../../../assets/maps/tt_navigation_grid.cells.bin")).unwrap();
        let mut game=openleague_core::Simulation::new(nav).unwrap();game.join("garen").unwrap();game
    }
    #[test]
    fn received_inventory_and_quote_control_selected_buy_and_sell() {
        let mut game=game();let id=*game.players.keys().next().unwrap();
        assert!(matches!(selected_action(SelectedIntent::Buy,Some(1055),None,Some(&game.players[&id]),true,true),Some(Action::Buy {item:1055})));
        for item in [1038,1058,999_999] {assert!(selected_action(SelectedIntent::Buy,Some(item),None,Some(&game.players[&id]),true,true).is_none());}
        game.buy_item(id,1055).unwrap();
        let chosen=SelectedInventory {slot:0,item:1055};
        assert!(matches!(selected_action(SelectedIntent::Sell,None,Some(chosen),Some(&game.players[&id]),true,true),Some(Action::Sell {slot:0})));
        game.sell_item(id,0).unwrap();
        assert!(selected_action(SelectedIntent::Sell,None,Some(chosen),Some(&game.players[&id]),true,true).is_none());
        game.buy_item(id,1029).unwrap();
        assert_eq!(game.players[&id].inventory[0],Some(1029));
        assert!(selected_action(SelectedIntent::Sell,None,Some(chosen),Some(&game.players[&id]),true,true).is_none());
    }
    #[test]
    fn closed_or_unready_owner_and_insufficient_quote_never_emit_selected_actions() {
        let mut game=game();let id=*game.players.keys().next().unwrap();
        for (ready,open) in [(false,true),(true,false),(false,false)] {
            assert!(selected_action(SelectedIntent::Buy,Some(1055),None,Some(&game.players[&id]),ready,open).is_none());
        }
        assert!(selected_action(SelectedIntent::Buy,Some(1055),None,None,true,true).is_none());
        game.buy_item(id,1055).unwrap();
        assert!(game.players[&id].gold<440.);
        assert!(selected_action(SelectedIntent::Buy,Some(1055),None,Some(&game.players[&id]),true,true).is_none());
        assert!(selected_action(SelectedIntent::Sell,None,Some(SelectedInventory {slot:6,item:1055}),Some(&game.players[&id]),true,true).is_none());
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
        for id in [1026,1052,3108,3114,3067,3101,3024] {
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

    #[test]
    fn map10_purchase_catalog_preserves_global_items_and_filters_only_acquisition() {
        let global = openleague_core::shop::catalog();
        assert_eq!(global.len(), 33);
        let purchasable = map10_purchase_catalog().collect::<Vec<_>>();
        assert_eq!(purchasable.len(), 31);
        assert!(purchasable.iter().any(|item| item.id == 1055));
        let mut excluded = global.iter()
            .filter(|item| !purchasable.iter().any(|shown| shown.id == item.id))
            .map(|item| item.id).collect::<Vec<_>>();
        excluded.sort_unstable();
        assert_eq!(excluded, [1038, 1058]);
        for id in excluded {
            let item = global.iter().find(|item| item.id == id).unwrap();
            assert_eq!(item_name(id), item.name.as_str());
            assert!(!item.description.is_empty());
            assert!(item.sell_price.is_some());
        }
    }

    #[test]
    fn map10_excluded_items_never_match_categories_or_search() {
        let global = openleague_core::shop::catalog();
        let mut filters = Filters {
            query: String::new(), category: 0, focused: false, open: true, inspected: None,
        };
        for id in [1038, 1058] {
            let item = global.iter().find(|item| item.id == id).unwrap();
            for query in ["", item.name.as_str()] {
                filters.query = query.into();
                for category in 0..=4 {
                    filters.category = category;
                    assert!(!matches(item, &filters), "excluded item {id} in category {category}");
                }
            }
        }
    }

    #[test]
    fn map10_action_gate_rejects_unavailable_or_unknown_buys_and_preserves_inventory_actions() {
        for id in [1038, 1058, 999_999] {
            assert!(!map10_action_available(&Action::Buy { item: id }));
        }
        assert!(map10_action_available(&Action::Buy { item: 1055 }));
        assert_eq!(map10_purchase_notice(1055), None);
        assert_eq!(map10_purchase_notice(1038), Some("Indisponible sur cette carte"));
        assert_eq!(map10_purchase_notice(999_999), Some("Disponibilité sur cette carte inconnue"));
        for slot in 0..6 {
            assert!(map10_action_available(&Action::Sell { slot }));
            assert!(map10_action_available(&Action::UseItem { slot }));
        }
    }
}
