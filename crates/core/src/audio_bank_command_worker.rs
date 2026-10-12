//! AF8C80 bank worker: physical wait, owned queue-pop and concrete command0 caller.
//! Remaining selectors/whole shutdown/OS threads are explicit qualification work.
use crate::{audio_bus_bank::Error,audio_bank_memory_reader::{Manager,Services as BankServices,UnknownChunks},audio_bank_command_queue::{Queue,Services as QueueServices},audio_bank_notification::WaitServices,audio_effect_bank_loader::UnknownHirc,audio_effect_resource_registry::Registry,audio_meter_lifecycle::Runtime,audio_plugin_factory::Registry as Plugins};
fn word(raw:&[u8],o:usize)->u32{u32::from_le_bytes(raw[o..o+4].try_into().unwrap())}
pub trait Services:BankServices+QueueServices{
    /// Physical event wait. External shutdown owner may publish stop flag.
    fn wait_worker(&mut self,event:u32,stop_flag:&mut u8)->Result<(),Error>;
}
#[derive(Default)]pub struct Worker{pub thread:u32}
impl Worker{
    pub fn run(&mut self,manager:&mut Manager,queue:&mut Queue,resources:&mut Registry,runtime:&mut Runtime,plugins:&Plugins,hirc:UnknownHirc,chunks:UnknownChunks,backing:&mut impl FnMut(u32,u32)->Result<Vec<u8>,Error>,services:&mut impl Services)->Result<u32,Error>{

        self.run_dispatch(manager,queue,services,|request,m,s|match request[0]{
            0=>{m.load_request_deferred(request,||backing(request[6],request[7]),resources,runtime,plugins,hirc,chunks,s)?;Ok(())},
            _=>Err(Error::Backend("bank worker command selector not qualified")),
        })
    }
    pub fn run_with_common<S:Services+crate::audio_common_queue::RetryServices>(&mut self,manager:&mut Manager,queue:&mut Queue,common:&mut crate::audio_common_queue::Context,processed:&mut u32,resources:&mut Registry,runtime:&mut Runtime,plugins:&Plugins,hirc:UnknownHirc,chunks:UnknownChunks,backing:&mut impl FnMut(u32,u32)->Result<Vec<u8>,Error>,services:&mut S)->Result<u32,Error>{
        self.run_dispatch(manager,queue,services,|request,m,s|match request[0]{
            0=>{m.load_request_deferred(request,||backing(request[6],request[7]),resources,runtime,plugins,hirc,chunks,s)?;Ok(())},
            1=>{m.unload_request(request,common,processed,resources,runtime,s)?;Ok(())},
            _=>Err(Error::Backend("bank worker command selector not qualified")),
        })
    }
    fn run_dispatch<S:Services>(&mut self,manager:&mut Manager,queue:&mut Queue,services:&mut S,mut dispatch:impl FnMut([u32;9],&mut Manager,&mut S)->Result<(),Error>)->Result<u32,Error>{
        self.thread=WaitServices::current_thread_id(services)?;
        loop{
            let event=word(&manager.raw,0x28);services.wait_worker(event,&mut manager.raw[0x2c])?;
            if manager.raw[0x2c]!=0{return Ok(0);}
            QueueServices::lock_queue(services)?;
            loop{
                let request=queue.pop(&mut manager.raw,services);QueueServices::unlock_queue(services)?;
                let Some(request)=request?else{break;};
                dispatch(request,manager,services)?;
                QueueServices::lock_queue(services)?;
            }
        }
    }
}
