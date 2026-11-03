package blix.frame
{
   import blix.signals.ISignal;
   import blix.signals.NativeSignal;
   import flash.events.Event;
   
   public function getEnterFrame() : ISignal
   {
      if(enterFrame == null)
      {
         enterFrame = new NativeSignal(Event.ENTER_FRAME,getFrameDispatcher());
      }
      return enterFrame;
   }
}

