package blix.frame
{
   import blix.signals.ISignal;
   import blix.signals.NativeSignal;
   import flash.events.Event;
   
   public function getExitFrame() : ISignal
   {
      if(exitFrame == null)
      {
         exitFrame = new NativeSignal(Event.EXIT_FRAME,getFrameDispatcher());
      }
      return exitFrame;
   }
}

