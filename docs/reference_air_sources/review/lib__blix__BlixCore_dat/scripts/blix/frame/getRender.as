package blix.frame
{
   import blix.signals.ISignal;
   import blix.signals.NativeSignal;
   import flash.events.Event;
   
   public function getRender() : ISignal
   {
      if(render == null)
      {
         render = new NativeSignal(Event.RENDER,getFrameDispatcher());
      }
      return render;
   }
}

