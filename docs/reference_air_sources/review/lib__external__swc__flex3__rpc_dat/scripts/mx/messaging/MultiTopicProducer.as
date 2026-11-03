package mx.messaging
{
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   import mx.logging.Log;
   import mx.messaging.errors.MessagingError;
   import mx.messaging.messages.AsyncMessage;
   import mx.messaging.messages.IMessage;
   
   public class MultiTopicProducer extends AbstractProducer
   {
      
      private var _subtopics:ArrayCollection = new ArrayCollection();
      
      public function MultiTopicProducer()
      {
         super();
         _log = Log.getLogger("mx.messaging.MultiTopicProducer");
         _agentType = "MultiTopicProducer";
      }
      
      public function addSubtopic(subtopic:String) : void
      {
         subtopics.addItem(subtopic);
      }
      
      public function removeSubtopic(subtopic:String) : void
      {
         var ix:int = int(subtopics.getItemIndex(subtopic));
         if(ix == -1)
         {
            throw new MessagingError("Attempt to remove a subtopic from MultiTopicProducer: " + subtopic + " which does not exist");
         }
         subtopics.removeItemAt(ix);
      }
      
      [Bindable(event="propertyChange")]
      public function get subtopics() : ArrayCollection
      {
         return _subtopics;
      }
      
      public function set subtopics(value:ArrayCollection) : void
      {
         var event:PropertyChangeEvent = null;
         if(_subtopics != value)
         {
            if(value == null)
            {
               value = new ArrayCollection();
            }
            event = PropertyChangeEvent.createUpdateEvent(this,"subtopics",_subtopics,value);
            _subtopics = value;
            dispatchEvent(event);
         }
      }
      
      override protected function internalSend(message:IMessage, waitForClientId:Boolean = true) : void
      {
         if(subtopics.length > 0)
         {
            message.headers[AsyncMessage.SUBTOPIC_HEADER] = subtopics;
         }
         super.internalSend(message,waitForClientId);
      }
   }
}

