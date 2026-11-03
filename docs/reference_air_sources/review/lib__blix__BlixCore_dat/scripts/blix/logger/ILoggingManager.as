package blix.logger
{
   import blix.signals.ISignal;
   
   public interface ILoggingManager
   {
      
      function getMessageLogged() : ISignal;
      
      function log(param1:String, param2:String, param3:uint = 4) : void;
   }
}

