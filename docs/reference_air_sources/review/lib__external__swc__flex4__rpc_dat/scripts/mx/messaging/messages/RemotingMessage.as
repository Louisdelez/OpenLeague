package mx.messaging.messages
{
   [RemoteClass(alias="flex.messaging.messages.RemotingMessage")]
   public class RemotingMessage extends AbstractMessage
   {
      
      public var operation:String;
      
      public var source:String;
      
      public function RemotingMessage()
      {
         super();
         this.operation = "";
      }
   }
}

