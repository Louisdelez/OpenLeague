package mx.messaging
{
   import mx.events.PropertyChangeEvent;
   import mx.logging.Log;
   import mx.messaging.messages.AbstractMessage;
   import mx.messaging.messages.AsyncMessage;
   import mx.messaging.messages.IMessage;
   
   public class Producer extends AbstractProducer
   {
      
      public static const DEFAULT_PRIORITY:int = 4;
      
      private var _subtopic:String = "";
      
      public function Producer()
      {
         super();
         _log = Log.getLogger("mx.messaging.Producer");
         _agentType = "producer";
      }
      
      override protected function internalSend(message:IMessage, waitForClientId:Boolean = true) : void
      {
         if(subtopic.length > 0)
         {
            message.headers[AsyncMessage.SUBTOPIC_HEADER] = subtopic;
         }
         handlePriority(message);
         super.internalSend(message,waitForClientId);
      }
      
      private function handlePriority(message:IMessage) : void
      {
         var messagePriority:int = 0;
         if(message.headers[AbstractMessage.PRIORITY_HEADER] != null)
         {
            messagePriority = int(message.headers[AbstractMessage.PRIORITY_HEADER]);
            if(messagePriority < 0)
            {
               message.headers[AbstractMessage.PRIORITY_HEADER] = 0;
            }
            else if(messagePriority > 9)
            {
               message.headers[AbstractMessage.PRIORITY_HEADER] = 9;
            }
         }
         else if(priority > -1)
         {
            message.headers[AbstractMessage.PRIORITY_HEADER] = priority;
         }
      }
      
      public function set subtopic(value:String) : void
      {
         var event:PropertyChangeEvent = null;
         if(_subtopic != value)
         {
            if(value == null)
            {
               value = "";
            }
            event = PropertyChangeEvent.createUpdateEvent(this,"subtopic",_subtopic,value);
            _subtopic = value;
            dispatchEvent(event);
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get subtopic() : String
      {
         return _subtopic;
      }
   }
}

