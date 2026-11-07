package mx.messaging.messages
{
   [RemoteClass(alias="flex.messaging.messages.RemotingMessage")]
   public class RemotingMessage extends AbstractMessage
   {
      
      public var source:String;
      
      public var operation:String;
      
      public function RemotingMessage()
      {
         super();
         operation = "";
      }
   }
}

