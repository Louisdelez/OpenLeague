package mx.messaging
{
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import mx.collections.ArrayCollection;
   import mx.events.CollectionEvent;
   import mx.events.PropertyChangeEvent;
   import mx.messaging.errors.MessagingError;
   import mx.messaging.messages.CommandMessage;
   import mx.messaging.messages.IMessage;
   
   [Event(name="message",type="mx.messaging.events.MessageEvent")]
   public class MultiTopicConsumer extends AbstractConsumer
   {
      
      private var _subscriptions:ArrayCollection = new ArrayCollection();
      
      private var _currentSubscriptions:Object = {};
      
      private var _subchangeTimer:Timer = null;
      
      public function MultiTopicConsumer()
      {
         super();
         this._subscriptions.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.subscriptionsChangeHandler);
      }
      
      [Inspectable(category="General",verbose="1")]
      [Bindable(event="propertyChange")]
      public function get subscriptions() : ArrayCollection
      {
         return this._subscriptions;
      }
      
      public function set subscriptions(value:ArrayCollection) : void
      {
         var event:PropertyChangeEvent = null;
         if(this._subscriptions !== value)
         {
            event = PropertyChangeEvent.createUpdateEvent(this,"subscriptions",this._subscriptions,value);
            if(subscribed)
            {
               unsubscribe();
               _shouldBeSubscribed = true;
            }
            if(this._subscriptions != null)
            {
               this._subscriptions.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.subscriptionsChangeHandler);
            }
            this._subscriptions = value;
            if(this._subscriptions != null)
            {
               this._subscriptions.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.subscriptionsChangeHandler);
            }
            if(_shouldBeSubscribed)
            {
               subscribe(clientId);
            }
            dispatchEvent(event);
         }
      }
      
      public function addSubscription(subtopic:String = null, selector:String = null, maxFrequency:uint = 0) : void
      {
         this.subscriptions.addItem(new SubscriptionInfo(subtopic,selector,maxFrequency));
      }
      
      public function removeSubscription(subtopic:String = null, selector:String = null) : void
      {
         var si:SubscriptionInfo = null;
         var n:int = int(this.subscriptions.length);
         for(var i:int = 0; i < n; i++)
         {
            si = SubscriptionInfo(this.subscriptions.getItemAt(i));
            if(si.subtopic == subtopic && si.selector == selector)
            {
               this.subscriptions.removeItemAt(i);
               break;
            }
         }
         if(n == this.subscriptions.length)
         {
            throw new MessagingError("Attempt to remove a subscription with subtopic: " + subtopic + " and selector: " + selector + " that this consumer does not have");
         }
      }
      
      override protected function buildSubscribeMessage() : CommandMessage
      {
         var s:String = null;
         var msg:CommandMessage = super.buildSubscribeMessage();
         msg.operation = CommandMessage.MULTI_SUBSCRIBE_OPERATION;
         var subs:Object = this.getCurrentSubscriptions();
         var toAdd:Array = [];
         var toRemove:Array = [];
         for(s in subs)
         {
            if(this._currentSubscriptions[s] == null)
            {
               toAdd.push(s);
            }
         }
         for(s in this._currentSubscriptions)
         {
            if(subs[s] == null)
            {
               toRemove.push(s);
            }
         }
         if(toAdd.length > 0)
         {
            msg.headers[CommandMessage.ADD_SUBSCRIPTIONS] = toAdd;
         }
         if(toRemove.length > 0)
         {
            msg.headers[CommandMessage.REMOVE_SUBSCRIPTIONS] = toRemove;
         }
         this._currentSubscriptions = subs;
         if(this._currentSubscriptions.length == 0)
         {
            msg.headers.DSlastUnsub = true;
         }
         return msg;
      }
      
      override protected function buildUnsubscribeMessage(preserveDurable:Boolean) : CommandMessage
      {
         var s:String = null;
         var msg:CommandMessage = super.buildUnsubscribeMessage(preserveDurable);
         msg.operation = CommandMessage.MULTI_SUBSCRIBE_OPERATION;
         var toRemove:Array = [];
         for(s in this._currentSubscriptions)
         {
            toRemove.push(s);
         }
         this._currentSubscriptions = {};
         if(toRemove.length > 0)
         {
            msg.headers[CommandMessage.REMOVE_SUBSCRIPTIONS] = toRemove;
         }
         msg.headers.DSlastUnsub = true;
         return msg;
      }
      
      override protected function internalSend(message:IMessage, waitForClientId:Boolean = true) : void
      {
         if(message.headers[CommandMessage.ADD_SUBSCRIPTIONS] != null || message.headers[CommandMessage.REMOVE_SUBSCRIPTIONS] != null)
         {
            super.internalSend(message,waitForClientId);
         }
         else
         {
            if(channelSet == null)
            {
               initChannelSet(message);
            }
            if(channelSet != null && !channelSet.connected && message is CommandMessage && CommandMessage(message).operation == CommandMessage.MULTI_SUBSCRIBE_OPERATION)
            {
               super.internalSend(message,waitForClientId);
            }
            if(message.headers.DSlastUnsub != null)
            {
               this.setSubscribed(false);
            }
            else if(channelSet != null && channelSet.connected)
            {
               this.setSubscribed(true);
            }
         }
      }
      
      override protected function setSubscribed(value:Boolean) : void
      {
         if(!value)
         {
            this._currentSubscriptions = {};
         }
         super.setSubscribed(value);
      }
      
      private function getCurrentSubscriptions() : Object
      {
         var si:SubscriptionInfo = null;
         var temp:String = null;
         var subs:Object = {};
         for(var i:int = 0; i < this.subscriptions.length; i++)
         {
            si = SubscriptionInfo(this.subscriptions.getItemAt(i));
            temp = (si.subtopic == null ? "" : si.subtopic) + CommandMessage.SUBTOPIC_SEPARATOR + (si.selector == null ? "" : si.selector);
            if(si.maxFrequency > 0)
            {
               temp += CommandMessage.SUBTOPIC_SEPARATOR + si.maxFrequency;
            }
            subs[temp] = true;
         }
         return subs;
      }
      
      private function subscriptionsChangeHandler(event:CollectionEvent) : void
      {
         if((_shouldBeSubscribed || subscribed) && this._subchangeTimer == null)
         {
            this._subchangeTimer = new Timer(0,1);
            this._subchangeTimer.addEventListener(TimerEvent.TIMER,this.doResubscribe);
            this._subchangeTimer.start();
         }
      }
      
      private function doResubscribe(event:TimerEvent) : void
      {
         this._subchangeTimer.removeEventListener(TimerEvent.TIMER,this.doResubscribe);
         this._subchangeTimer = null;
         this.internalSend(this.buildSubscribeMessage());
      }
   }
}

