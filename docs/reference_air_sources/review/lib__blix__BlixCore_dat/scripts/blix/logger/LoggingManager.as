package blix.logger
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   
   public class LoggingManager implements ILoggingManager
   {
      
      private var _messageLogged:Signal = new Signal();
      
      public function LoggingManager()
      {
         super();
      }
      
      public function getMessageLogged() : ISignal
      {
         return this._messageLogged;
      }
      
      public function log(param1:String, param2:String, param3:uint = 4) : void
      {
         this._messageLogged.dispatch(param1,param2,param3);
      }
   }
}

