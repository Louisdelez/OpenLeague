from pathlib import Path
import shutil
r=Path('E:/OpenLeague');s=Path(__file__).parent;shutil.copy2(s/'native_hud_normal_font.rs',r/'crates/client/src/native_hud_normal_font.rs')
p=r/'crates/client/src/native_zip_provider.rs';t=p.read_text(encoding='utf-8');t=t.replace('self.font_requests(Some(crate::native_hud_normal_font::manager_default(entries,previous)))','self.font_requests(Some(crate::native_hud_normal_font::manager_default(entries,previous).map_err(io::Error::other)?))');p.write_text(t,encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name);print('Native font alias ASCII case comparison corrected; duplicate/non-ASCII alias states explicit errors pending qualification')
