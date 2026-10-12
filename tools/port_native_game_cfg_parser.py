from pathlib import Path
import shutil
r=Path('E:/OpenLeague');s=Path(__file__).parent
shutil.copy2(s/'native_game_cfg_text.rs',r/'crates/client/src/native_game_cfg_text.rs')
p=r/'crates/client/src/main.rs';text=p.read_text(encoding='utf-8')
if 'mod native_game_cfg_text;' not in text:text='mod native_game_cfg_text;\n'+text
p.write_text(text,encoding='utf-8')
p=r/'crates/client/src/native_graphics_options.rs';text=p.read_text(encoding='utf-8')
text=text.replace('//! Original INI parser, option UI and complete settings initialization remain open.','//! Native text parser is separately qualified; cache, user file, UI and complete initialization remain open.')
old='impl Default for IntegerOptions {fn default()->Self {Self::from_environment_configuration(ConfigurationPair::default(),ConfigurationPair::default())}}'
new='''impl Default for IntegerOptions {fn default()->Self {
 let parsed=crate::native_game_cfg_text::parse(include_bytes!("../../../data/4.20/configuration/defaults/Game.cfg"),0);
 assert!(parsed.error.is_none(),"native default Game.cfg parsing failed");
 let value=parsed.value(ENVIRONMENT_SECTION.as_bytes(),ENVIRONMENT_KEY.as_bytes()).map(|text|read_integer_value(Self::environment_default(),ValueSources {binary_enabled:false,typed_enabled:false,text_enabled:true,typed:None,text:Some(text)},|_|{}).value);
 Self::from_environment_configuration(ConfigurationPair {primary:value,overlay:None},ConfigurationPair::default())
}}'''
assert old in text or new in text
text=text.replace(old,new);p.write_text(text,encoding='utf-8')
shutil.copy2(s/'port_native_game_cfg_parser.py',r/'tools/port_native_game_cfg_parser.py')
print('Native parser ported; startup now parses embedded original defaults. User/cache/menu still open.')
