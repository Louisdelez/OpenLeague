package mx.messaging.channels
{
   public class SecureStreamingHTTPChannel extends StreamingHTTPChannel
   {
      
      public function SecureStreamingHTTPChannel(id:String = null, uri:String = null)
      {
         super(id,uri);
      }
      
      override public function get protocol() : String
      {
         return "https";
      }
   }
}

