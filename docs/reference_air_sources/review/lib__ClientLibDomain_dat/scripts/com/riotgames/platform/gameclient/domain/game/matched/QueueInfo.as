package com.riotgames.platform.gameclient.domain.game.matched
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.matchmaking.QueueInfo")]
   public class QueueInfo implements IEventDispatcher
   {
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _655172108queueId:int;
      
      private var _1112182953queueLength:int;
      
      private var _1121694481waitTimeStr:String;
      
      private var _245339618waitTime:int;
      
      public function QueueInfo()
      {
         super();
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function set waitTime(param1:int) : void
      {
         var _loc2_:Object = this._245339618waitTime;
         if(_loc2_ !== param1)
         {
            this._245339618waitTime = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"waitTime",_loc2_,param1));
         }
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      [Bindable(event="propertyChange")]
      public function get queueId() : int
      {
         return this._655172108queueId;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function initialize(param1:int) : QueueInfo
      {
         this.queueId = param1;
         return this;
      }
      
      public function set queueId(param1:int) : void
      {
         var _loc2_:Object = this._655172108queueId;
         if(_loc2_ !== param1)
         {
            this._655172108queueId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"queueId",_loc2_,param1));
         }
      }
      
      public function set waitTimeStr(param1:String) : void
      {
         var _loc2_:Object = this._1121694481waitTimeStr;
         if(_loc2_ !== param1)
         {
            this._1121694481waitTimeStr = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"waitTimeStr",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get waitTime() : int
      {
         return this._245339618waitTime;
      }
      
      [Bindable(event="propertyChange")]
      public function get queueLength() : int
      {
         return this._1112182953queueLength;
      }
      
      public function set queueLength(param1:int) : void
      {
         var _loc2_:Object = this._1112182953queueLength;
         if(_loc2_ !== param1)
         {
            this._1112182953queueLength = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"queueLength",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get waitTimeStr() : String
      {
         return this._1121694481waitTimeStr;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
   }
}

