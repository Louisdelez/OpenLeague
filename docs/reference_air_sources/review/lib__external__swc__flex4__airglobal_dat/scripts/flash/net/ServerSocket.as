package flash.net
{
   import flash.events.EventDispatcher;
   
   [native(cls="ServerSocketClass",instance="ServerSocketObject",methods="auto")]
   [Version("air2.0")]
   [Event(name="connect",type="flash.events.ServerSocketConnectEvent")]
   [Event(name="close",type="flash.events.Event")]
   public class ServerSocket extends EventDispatcher
   {
      
      public function ServerSocket()
      {
         super();
      }
      
      public static function get isSupported() : Boolean
      {
         return true;
      }
      
      public function bind(localPort:int = 0, localAddress:String = "0.0.0.0") : void
      {
         this.internalBind(localPort,localAddress);
      }
      
      private native function internalBind(param1:int, param2:String) : void;
      
      public function close() : void
      {
         this.internalClose();
      }
      
      private native function internalClose() : void;
      
      public function listen(backlog:int = 0) : void
      {
         this.internalListen(backlog);
      }
      
      private native function internalListen(param1:int) : void;
      
      public native function get localAddress() : String;
      
      public native function get localPort() : int;
      
      public function get listening() : Boolean
      {
         return this.internalListening();
      }
      
      private native function internalListening() : Boolean;
      
      public function get bound() : Boolean
      {
         return this.internalBound();
      }
      
      private native function internalBound() : Boolean;
   }
}

