from pathlib import Path
import shutil
r=Path('E:/OpenLeague');p=r/'crates/client/src/projected_live.rs';s=p.read_text(encoding='utf-8')
assert 'struct Lifetime {cycle:NativeProjectedCycle,system:SimpleSystemState}' in s
s=s.replace('struct Lifetime {cycle:NativeProjectedCycle,system:SimpleSystemState}', 'struct Lifetime {cycle:NativeProjectedCycle,system:SimpleSystemState,wrapper:openleague_core::native_projectile_stop_dispatch::Wrapper,requests:u32}')
s=s.replace('Ok(Self{cycle,system:SimpleSystemState{flags:1,start_time:start,stop_time:0.}})', 'Ok(Self{cycle,system:SimpleSystemState{flags:1,start_time:start,stop_time:0.},wrapper:openleague_core::native_projectile_stop_dispatch::Wrapper{ended:0,linked:true},requests:0})')
assert 'if ended {self.system.stop(clock)?;}' in s
s=s.replace('if ended {self.system.stop(clock)?;}', '''// Local network disappearance still supplies the controller-end trigger.
        // Apply the qualified native marker -> wrapper cleanup -> Troy request route.
        if ended {self.wrapper.projectile_end(true);}
        if !self.wrapper.update_can_continue(self.wrapper.linked,false) {
            // Local registry consumes the rejected wrapper in this frame. Original
            // registry scheduling and weak ownership remain explicit open contracts.
            self.wrapper.cleanup(true,&mut self.requests);
        }
        if self.requests&0x400!=0 {self.system.stop(clock)?;}''')
s=s.replace('missile pose/stop adapter reconstructed, identity orientation', 'native projectile marker/cleanup/stop request; network end trigger and registry scheduling reconstructed, identity orientation')
s=s.replace('"native_clock_binding":true', '"native_stop_dispatch_binding":true,"native_clock_binding":true')
s=s.replace('Shared current projectile anchor and disappearance flag are a reconstructed owner adapter; exact native missile interface is unqualified.', 'Projectile marker, wrapper cleanup and Troy stop request use the native dispatch port; disappearance trigger, weak ownership, registry scheduling and current projectile anchor remain reconstructed adapters.')
assert s!=p.read_text(encoding='utf-8');p.write_text(s,encoding='utf-8')
if Path(__file__).resolve()!=(r/'tools'/Path(__file__).name).resolve():shutil.copy2(Path(__file__),r/'tools'/Path(__file__).name)
