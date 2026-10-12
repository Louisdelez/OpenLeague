from pathlib import Path
import shutil
r=Path('E:/OpenLeague');stage=Path(__file__).parent
shutil.copy2(stage/'native_user_settings.rs',r/'crates/client/src/native_user_settings.rs')
p=r/'crates/client/src/main.rs';text=p.read_text(encoding='utf-8')
if 'mod native_user_settings;' not in text:text='mod native_user_settings;\n'+text
anchor='    let socket = UdpSocket::bind("127.0.0.1:0").unwrap();'
extra='''    let settings=native_user_settings::load(&root).expect("load native Game.cfg configuration");
    let mut quality=native_environment_draw::Quality::default();
    quality.apply(settings.options.read(native_graphics_options::ENVIRONMENT_ID).value);
    eprintln!("Game.cfg defaults={} user={} loaded={} parser_warnings={} environment_quality={}",settings.default_path.display(),settings.user_path.display(),settings.user_loaded,settings.parse_warnings,quality.value);
'''
assert anchor in text
if 'let settings=native_user_settings::load(&root)' not in text:text=text.replace(anchor,extra+anchor,1)
text=text.replace('.init_resource::<native_environment_draw::Quality>()','.insert_resource(quality).insert_resource(settings)')
p.write_text(text,encoding='utf-8')
for source,target in [(Path(__file__),r/'tools'/Path(__file__).name),(stage/'native_user_settings.rs',r/'tools/native_user_settings.rs')]:
 if source.resolve()!=target.resolve():shutil.copy2(source,target)
print('Native default-language settings paths and real file loading integrated in client startup.')
