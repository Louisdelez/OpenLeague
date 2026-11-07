package mx.logging.targets
{
   import flash.events.SecurityErrorEvent;
   import flash.events.StatusEvent;
   import flash.net.LocalConnection;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class MiniDebugTarget extends LineFormattedTarget
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var _method:String;
      
      private var _lc:LocalConnection;
      
      private var _connection:String;
      
      public function MiniDebugTarget(connection:String = "_mdbtrace", method:String = "trace")
      {
         super();
         _lc = new LocalConnection();
         _lc.addEventListener(StatusEvent.STATUS,onStatus);
         _lc.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onSecurityError);
         _connection = connection;
         _method = method;
      }
      
      private function onStatus(e:StatusEvent) : void
      {
         if(e.level == "error")
         {
            trace("Warning: MiniDebugTarget send failed: " + e.code);
         }
      }
      
      private function onSecurityError(e:SecurityErrorEvent) : void
      {
         trace("Error: security error on MiniDebugTarget\'s local connction");
      }
      
      override mx_internal function internalLog(message:String) : void
      {
         _lc.send(_connection,_method,message);
      }
   }
}

