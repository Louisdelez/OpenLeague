package com.riotgames.platform.gameclient.domain.game.matched
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.matchmaking.SearchingForMatchNotification")]
   public class MatchSearchNotification implements IEventDispatcher
   {
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _662641908playerJoinFailures:ArrayCollection;
      
      private var _589438421joinedQueues:ArrayCollection;
      
      private var _158620356ghostGameSummoners:ArrayCollection;
      
      public function MatchSearchNotification()
      {
         super();
      }
      
      private static function classReferences() : void
      {
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get playerJoinFailures() : ArrayCollection
      {
         return this._662641908playerJoinFailures;
      }
      
      public function getJoinedQueueById(param1:int) : QueueInfo
      {
         var _loc2_:QueueInfo = null;
         for each(_loc2_ in this.joinedQueues)
         {
            if(_loc2_.queueId == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function set ghostGameSummoners(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._158620356ghostGameSummoners;
         if(_loc2_ !== param1)
         {
            this._158620356ghostGameSummoners = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ghostGameSummoners",_loc2_,param1));
         }
      }
      
      public function getJoinedQueueByIndex(param1:int) : QueueInfo
      {
         return this.joinedQueues.getItemAt(param1) as QueueInfo;
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      [Bindable(event="propertyChange")]
      public function get ghostGameSummoners() : ArrayCollection
      {
         return this._158620356ghostGameSummoners;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function set joinedQueues(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._589438421joinedQueues;
         if(_loc2_ !== param1)
         {
            this._589438421joinedQueues = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"joinedQueues",_loc2_,param1));
         }
      }
      
      public function set playerJoinFailures(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._662641908playerJoinFailures;
         if(_loc2_ !== param1)
         {
            this._662641908playerJoinFailures = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"playerJoinFailures",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get joinedQueues() : ArrayCollection
      {
         return this._589438421joinedQueues;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function addQueueInfo(param1:QueueInfo) : void
      {
         if(this.joinedQueues == null)
         {
            this.joinedQueues = new ArrayCollection();
         }
         this.joinedQueues.addItem(param1);
      }
   }
}

