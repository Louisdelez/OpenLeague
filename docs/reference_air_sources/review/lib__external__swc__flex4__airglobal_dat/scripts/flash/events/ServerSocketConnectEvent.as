package flash.events
{
   import flash.net.Socket;
   
   [Version("air2.0")]
   public class ServerSocketConnectEvent extends Event
   {
      
      public static const CONNECT:String = "connect";
      
      private var _socket:Socket = null;
      
      public function ServerSocketConnectEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, socket:Socket = null)
      {
         super(type,bubbles,cancelable);
         this.socket = socket;
      }
      
      override public function clone() : Event
      {
         return new ServerSocketConnectEvent(type,bubbles,cancelable,this.socket);
      }
      
      override public function toString() : String
      {
         return formatToString("ServerSocketConnectEvent","type","bubbles","cancelable","socket");
      }
      
      public function get socket() : Socket
      {
         return this._socket;
      }
      
      public function set socket(value:Socket) : void
      {
         this._socket = value;
      }
   }
}

