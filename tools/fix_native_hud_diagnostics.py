from pathlib import Path
r=Path('E:/OpenLeague');p=r/'crates/client/src/main.rs';s=p.read_text(encoding='utf-8')
needle='            max_width: Val::Percent(95.),';assert s.count(needle)==1;s=s.replace(needle,'            display: Display::None,\n'+needle)
needle='    mut labels: Query<(&mut Text,&mut Node), With<PlayerLabel>>,\n';assert s.count(needle)==1;s=s.replace(needle,needle+'    keys: Res<ButtonInput<KeyCode>>,\n    mut debug_visible: Local<bool>,\n')
needle='    let _retained = &map.0;';assert s.count(needle)==1;s=s.replace(needle,'    if keys.just_pressed(KeyCode::F3) {*debug_visible=!*debug_visible;}\n'+needle)
s=s.replace('        node.display=Display::Flex;','        node.display=if *debug_visible {Display::Flex}else{Display::None};',1);p.write_text(s,encoding='utf-8')
p=r/'crates/client/src/native_hud_widgets.rs';s=p.read_text(encoding='utf-8');s=s.replace('"material_assets":live.materials.len(),','"material_assets":live.materials.len(),"total_font_material_assets":materials.len(),"window_scale_factor":window.scale_factor(),');p.write_text(s,encoding='utf-8')
p=Path('E:/mapslol3v3/run_native_hud_widgets.ps1');s=p.read_text(encoding='utf-8');s=s.replace("$captureTag = 'native-hud-widgets-' + $captureBackend","$captureTag = 'native-hud-widgets-' + $captureBackend + '-clean'");p.write_text(s,encoding='utf-8')
print('Diagnostics hidden by default, toggleF3; total material count/window scale factor traced; previous captures preserved')
