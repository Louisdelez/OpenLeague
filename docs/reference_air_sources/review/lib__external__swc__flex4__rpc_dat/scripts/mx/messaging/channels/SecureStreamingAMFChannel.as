package mx.messaging.channels
{
   public class SecureStreamingAMFChannel extends StreamingAMFChannel
   {
      
      public function SecureStreamingAMFChannel(id:String = null, uri:String = null)
      {
         super(id,uri);
      }
      
      override public function get protocol() : String
      {
         return "https";
      }
   }
}

