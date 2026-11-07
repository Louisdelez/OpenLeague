package mx.messaging
{
   import flash.utils.Dictionary;
   import mx.logging.Log;
   import mx.messaging.events.MessageEvent;
   
   public class ConsumerMessageDispatcher
   {
      
      private static var _instance:ConsumerMessageDispatcher;
      
      private const _consumerDuplicateMessageBarrier:Object = {};
      
      private const _channelSetRefCounts:Dictionary = new Dictionary();
      
      private const _consumers:Object = {};
      
      public function ConsumerMessageDispatcher()
      {
         super();
      }
      
      public static function getInstance() : ConsumerMessageDispatcher
      {
         if(!_instance)
         {
            _instance = new ConsumerMessageDispatcher();
         }
         return _instance;
      }
      
      public function registerSubscription(consumer:AbstractConsumer) : void
      {
         _consumers[consumer.clientId] = consumer;
         if(_channelSetRefCounts[consumer.channelSet] == null)
         {
            consumer.channelSet.addEventListener(MessageEvent.MESSAGE,messageHandler);
            _channelSetRefCounts[consumer.channelSet] = 1;
         }
         else
         {
            ++_channelSetRefCounts[consumer.channelSet];
         }
      }
      
      private function messageHandler(event:MessageEvent) : void
      {
         var count:int = 0;
         var cs:ChannelSet = null;
         var duplicateDispatchGuard:Array = null;
         var consumer:AbstractConsumer = _consumers[event.message.clientId];
         if(consumer == null)
         {
            if(Log.isDebug())
            {
               Log.getLogger("mx.messaging.Consumer").debug("\'{0}\' received pushed message for consumer but no longer subscribed: {1}",event.message.clientId,event.message);
            }
            return;
         }
         if(event.target.currentChannel.channelSets.length > 1)
         {
            count = 0;
            for each(cs in event.target.currentChannel.channelSets)
            {
               if(_channelSetRefCounts[cs] != null)
               {
                  count++;
               }
            }
            if(count > 1)
            {
               if(_consumerDuplicateMessageBarrier[consumer.id] == null)
               {
                  _consumerDuplicateMessageBarrier[consumer.id] = [event.messageId,count];
                  consumer.messageHandler(event);
               }
               duplicateDispatchGuard = _consumerDuplicateMessageBarrier[consumer.id];
               if(duplicateDispatchGuard[0] == event.messageId)
               {
                  if(--duplicateDispatchGuard[1] == 0)
                  {
                     delete _consumerDuplicateMessageBarrier[consumer.id];
                  }
               }
               return;
            }
         }
         consumer.messageHandler(event);
      }
      
      public function unregisterSubscription(consumer:AbstractConsumer) : void
      {
         delete _consumers[consumer.clientId];
         var refCount:int = int(_channelSetRefCounts[consumer.channelSet]);
         if(--refCount == 0)
         {
            consumer.channelSet.removeEventListener(MessageEvent.MESSAGE,messageHandler);
            delete _channelSetRefCounts[consumer.channelSet];
            if(_consumerDuplicateMessageBarrier[consumer.id] != null)
            {
               delete _consumerDuplicateMessageBarrier[consumer.id];
            }
         }
         else
         {
            _channelSetRefCounts[consumer.channelSet] = refCount;
         }
      }
      
      public function isChannelUsedForSubscriptions(channel:Channel) : Boolean
      {
         var memberOfChannelSets:Array = channel.channelSets;
         var cs:ChannelSet = null;
         var n:int = int(memberOfChannelSets.length);
         for(var i:int = 0; i < n; i++)
         {
            cs = memberOfChannelSets[i];
            if(_channelSetRefCounts[cs] != null && cs.currentChannel == channel)
            {
               return true;
            }
         }
         return false;
      }
   }
}

