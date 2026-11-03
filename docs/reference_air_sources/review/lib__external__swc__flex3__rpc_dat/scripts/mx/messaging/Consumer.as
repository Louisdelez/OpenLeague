package mx.messaging
{
   import mx.events.PropertyChangeEvent;
   import mx.messaging.messages.AsyncMessage;
   import mx.messaging.messages.CommandMessage;
   import mx.messaging.messages.IMessage;
   
   [Event(name="message",type="mx.messaging.events.MessageEvent")]
   public class Consumer extends AbstractConsumer
   {
      
      private var _selector:String = "";
      
      private var _subtopic:String = "";
      
      public function Consumer(messageType:String = "flex.messaging.messages.AsyncMessage")
      {
         super();
      }
      
      public function set subtopic(value:String) : void
      {
         var resetSubscription:Boolean = false;
         if(subtopic != value)
         {
            resetSubscription = false;
            if(subscribed)
            {
               unsubscribe();
               resetSubscription = true;
            }
            _subtopic = value;
            if(resetSubscription)
            {
               subscribe();
            }
         }
      }
      
      override protected function internalSend(message:IMessage, waitForClientId:Boolean = true) : void
      {
         if(subtopic.length > 0)
         {
            message.headers[AsyncMessage.SUBTOPIC_HEADER] = subtopic;
         }
         if(_selector.length > 0)
         {
            message.headers[CommandMessage.SELECTOR_HEADER] = _selector;
         }
         super.internalSend(message,waitForClientId);
      }
      
      public function set selector(value:String) : void
      {
         var event:PropertyChangeEvent = null;
         var resetSubscription:Boolean = false;
         if(_selector !== value)
         {
            event = PropertyChangeEvent.createUpdateEvent(this,"selector",_selector,value);
            resetSubscription = false;
            if(subscribed)
            {
               unsubscribe();
               resetSubscription = true;
            }
            _selector = value;
            if(resetSubscription)
            {
               subscribe(clientId);
            }
            dispatchEvent(event);
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get subtopic() : String
      {
         return _subtopic;
      }
      
      [Inspectable(category="General",verbose="1")]
      [Bindable(event="propertyChange")]
      public function get selector() : String
      {
         return _selector;
      }
   }
}

