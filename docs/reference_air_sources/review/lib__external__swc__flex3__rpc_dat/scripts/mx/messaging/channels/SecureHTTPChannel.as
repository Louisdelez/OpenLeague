package mx.messaging.channels
{
   public class SecureHTTPChannel extends HTTPChannel
   {
      
      public function SecureHTTPChannel(id:String = null, uri:String = null)
      {
         super(id,uri);
      }
      
      override public function get protocol() : String
      {
         return "https";
      }
   }
}

