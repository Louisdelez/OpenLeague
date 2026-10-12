from pathlib import Path
import json,shutil
r=Path('E:/OpenLeague');stage=Path('E:/mapslol3v3')
p=json.loads((r/'data/4.20/native_hud_group_bounds_contract.json').read_text(encoding='utf-8'));assert p['passed'] and p['case_count']==1152
shutil.copy2(stage/'native_hud_group_bounds.rs',r/'crates/client/src/native_hud_group_bounds.rs')
file=r/'crates/client/src/main.rs';s=file.read_text(encoding='utf-8')
if 'mod native_hud_group_bounds;' not in s:s='mod native_hud_group_bounds;\n'+s
file.write_text(s,encoding='utf-8')
file=r/'crates/client/src/native_hud_groups.rs';s=file.read_text(encoding='utf-8').replace('#[derive(Default)]\n','');s=s.replace('pub members:Vec<u32>,','pub members:Vec<u32>,pub bounds:[u32;4],')
if 'impl Default for Group' not in s:
 pos=s.index('pub struct Registry');s=s[:pos]+'''impl Default for Group {
    fn default()->Self {Self {name_storage:[0;32],layer:0,alpha_flags:0,enabled_marker:0,flags:0,clock_enabled:false,last_frame:0,members:Vec::new(),bounds:crate::native_hud_group_bounds::EMPTY}}
}
'''+s[pos:]
needle='    pub fn lookup('
if 'pub fn refresh_bounds' not in s:
 pos=s.index(needle);s=s[:pos]+'''    pub fn refresh_bounds<'a,F>(&mut self,width:u32,height:u32,scalar:f32,resolve:F)->Result<usize,&'static str>
    where F:Fn(u32)->Option<&'a crate::native_hud_element_storage::ElementStorage> {
        let mut refreshed=0;
        for group in self.groups.values_mut() {
            let members=group.members.iter().map(|id|resolve(*id).ok_or("HUD bounds member missing"));
            if crate::native_hud_group_bounds::refresh(&mut group.bounds,&mut group.flags,width,height,scalar,members)? {refreshed+=1;}
        }
        Ok(refreshed)
    }
'''+s[pos:]
file.write_text(s,encoding='utf-8')
file=r/'crates/client/src/native_zip_provider.rs';s=file.read_text(encoding='utf-8');needle='impl Provider {'
if 'impl StartupHud {' not in s:
 pos=s.index(needle);s=s[:pos]+'''impl StartupHud {
    // Caller must supply qualified viewport and HUD owner scalar; no settings default is invented.
    pub fn refresh_bounds(&mut self,width:u32,height:u32,scalar:f32)->io::Result<usize> {
        let elements=self.shadow_isles_layouts.iter().flat_map(|l|&l.structure.accepted).enumerate().map(|(i,r)|((i+1) as u32,&r.element.storage)).collect::<std::collections::BTreeMap<_,_>>();
        self.shadow_isles_groups.refresh_bounds(width,height,scalar,|id|elements.get(&id).copied()).map_err(io::Error::other)
    }
}
'''+s[pos:]
s=s.replace('let hud=provider.startup_hud(&root).unwrap();assert_eq!(hud.fast_hud.len(),1607);','let mut hud=provider.startup_hud(&root).unwrap();assert_eq!(hud.fast_hud.len(),1607);')
needle='        assert_eq!(hud.shadow_isles_groups.groups.values().map(|g|g.members.len()).sum::<usize>(),697);'
extra='''
        assert_eq!(hud.refresh_bounds(1280,800,1.0).unwrap(),41);
        assert_eq!(hud.refresh_bounds(1280,800,1.0).unwrap(),0);
        let bounds:serde_json::Value=serde_json::from_str(include_str!("../../../data/4.20/native_hud_group_bounds_contract.json")).unwrap();
        for case in bounds["cases"].as_array().unwrap().iter().filter(|c|c["width"]==1280 && c["height"]==800 && c["owner_scalar_bits"]==1f32.to_bits() && c["dirty"]==true && c["initial_bits"][0]==0x7f7fffffu32) {
            let id=hud.shadow_isles_groups.lookup(case["group"].as_str().unwrap().as_bytes()).unwrap().unwrap();let group=&hud.shadow_isles_groups.groups[&id];
            assert_eq!(group.bounds.to_vec(),case["output_bits"].as_array().unwrap().iter().map(|v|v.as_u64().unwrap() as u32).collect::<Vec<_>>());
            assert_eq!(group.flags&2,0);
        }'''
if 'hud.refresh_bounds(1280,800,1.0)' not in s:s=s.replace(needle,needle+extra)
file.write_text(s,encoding='utf-8');shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name);print(json.dumps(dict(ported=True,native_cases=1152,provider_api_integrated=True,owner_scalar_producer=False,runtime_refresh=False,drawing=False)))
