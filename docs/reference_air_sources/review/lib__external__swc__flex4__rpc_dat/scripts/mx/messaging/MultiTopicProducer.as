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
      
      [Bindable(event="propertyChange")]
      public function get subtopics() : ArrayCollection
      {
         return this._subtopics;
      }
      
      public function set subtopics(value:ArrayCollection) : void
      {
         var event:PropertyChangeEvent = null;
         if(this._subtopics != value)
         {
            if(value == null)
            {
               value = new ArrayCollection();
            }
            event = PropertyChangeEvent.createUpdateEvent(this,"subtopics",this._subtopics,value);
            this._subtopics = value;
            dispatchEvent(event);
         }
      }
      
      public function addSubtopic(subtopic:String) : void
      {
         this.subtopics.addItem(subtopic);
      }
      
      public function removeSubtopic(subtopic:String) : void
      {
         var ix:int = int(this.subtopics.getItemIndex(subtopic));
         if(ix == -1)
         {
            throw new MessagingError("Attempt to remove a subtopic from MultiTopicProducer: " + subtopic + " which does not exist");
         }
         this.subtopics.removeItemAt(ix);
      }
      
      override protected function internalSend(message:IMessage, waitForClientId:Boolean = true) : void
      {
         if(this.subtopics.length > 0)
         {
            message.headers[AsyncMessage.SUBTOPIC_HEADER] = this.subtopics;
         }
         super.internalSend(message,waitForClientId);
      }
   }
}

