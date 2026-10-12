from pathlib import Path
import shutil
r=Path('E:/OpenLeague');stage=Path(__file__).parent
shutil.copy2(stage/'native_filesystem_provider.rs',r/'crates/client/src/native_filesystem_provider.rs')
p=r/'crates/client/src/main.rs';text=p.read_text(encoding='utf-8')
if 'mod native_filesystem_provider;' not in text:text='mod native_filesystem_provider;\n'+text
p.write_text(text,encoding='utf-8')
p=r/'crates/client/src/native_user_settings.rs';text=p.read_text(encoding='utf-8');old=" match std::fs::read(path) {Ok(bytes)=>Ok(Some(bytes)),Err(e) if e.kind()==std::io::ErrorKind::NotFound=>Ok(None),Err(e)=>Err(e)}";assert old in text;text=text.replace(old,' crate::native_filesystem_provider::read(path)');p.write_text(text,encoding='utf-8')
for name in ['native_filesystem_provider.rs','port_native_filesystem_provider.py','prepare_native_filesystem_text_flow.py']:shutil.copy2(stage/name,r/'tools'/name)
print('Native simple provider/read flow connected to actual configuration loading via host Windows CRT; archives/error paths remain open.')
