package blix.logger
{
   import blix.IDestructible;
   import blix.util.string.StringFilter;
   
   [Abstract]
   public class LogTarget extends StringFilter implements IDestructible
   {
      
      protected var loggingManager:ILoggingManager;
      
      public function LogTarget(param1:ILoggingManager)
      {
         super();
         this.loggingManager = param1;
         param1.getMessageLogged().add(this.messageLoggedHandler);
      }
      
      private function messageLoggedHandler(param1:String, param2:String, param3:uint) : void
      {
         if(!filter(param2))
         {
            return;
         }
         this.logMessage(param1,param3);
      }
      
      [Abstract]
      protected function logMessage(param1:String, param2:uint) : void
      {
      }
      
      public function destroy() : void
      {
         this.loggingManager.getMessageLogged().remove(this.messageLoggedHandler);
      }
   }
}

