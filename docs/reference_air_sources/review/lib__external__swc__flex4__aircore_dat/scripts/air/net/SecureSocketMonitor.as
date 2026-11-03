package air.net
{
   import flash.net.SecureSocket;
   import flash.net.Socket;
   
   public class SecureSocketMonitor extends SocketMonitor
   {
      
      public function SecureSocketMonitor(host:String, port:int)
      {
         super(host,port);
      }
      
      override public function toString() : String
      {
         return "[SecureSocketMonitor host=\"" + host + "\" port=\"" + port + "\" available=\"" + available + "\"]";
      }
      
      override protected function createSocket() : Socket
      {
         if(!SecureSocket.isSupported)
         {
            return null;
         }
         return new SecureSocket();
      }
   }
}

