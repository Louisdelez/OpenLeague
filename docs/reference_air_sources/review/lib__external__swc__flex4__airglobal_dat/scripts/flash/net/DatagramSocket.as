package flash.net
{
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   
   [native(cls="DatagramSocketClass",instance="DatagramSocketObject",methods="auto")]
   [Version("air2.0")]
   [Event(name="ioError",type="flash.events.IOErrorEvent")]
   [Event(name="data",type="flash.events.DatagramSocketDataEvent")]
   [Event(name="close",type="flash.events.Event")]
   public class DatagramSocket extends EventDispatcher
   {
      
      public function DatagramSocket()
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
      
      public function connect(remoteAddress:String, remotePort:int) : void
      {
         this.internalConnect(remoteAddress,remotePort);
      }
      
      private native function internalConnect(param1:String, param2:int) : void;
      
      public function receive() : void
      {
         this.internalReceive();
      }
      
      private native function internalReceive() : void;
      
      public function close() : void
      {
         this.internalClose();
      }
      
      private native function internalClose() : void;
      
      public function send(bytes:ByteArray, offset:uint = 0, length:uint = 0, address:String = null, port:int = 0) : void
      {
         this.internalSend(bytes,offset,length,address,port);
      }
      
      private native function internalSend(param1:ByteArray, param2:uint, param3:uint, param4:String, param5:int) : void;
      
      public function get connected() : Boolean
      {
         return this.internalGetConnected();
      }
      
      private native function internalGetConnected() : Boolean;
      
      public function get bound() : Boolean
      {
         return this.internalGetBound();
      }
      
      private native function internalGetBound() : Boolean;
      
      public function get localAddress() : String
      {
         return this.internalGetLocalAddress();
      }
      
      private native function internalGetLocalAddress() : String;
      
      public function get localPort() : int
      {
         return this.internalGetLocalPort();
      }
      
      private native function internalGetLocalPort() : int;
      
      public function get remoteAddress() : String
      {
         return this.internalGetRemoteAddress();
      }
      
      private native function internalGetRemoteAddress() : String;
      
      public function get remotePort() : int
      {
         return this.internalGetRemotePort();
      }
      
      private native function internalGetRemotePort() : int;
   }
}

