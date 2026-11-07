package com.riotgames.platform.gameclient.domain.game
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class QueueMap implements IEventDispatcher
   {
      
      private var _1275011871qualifiedToEnter:Boolean;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _195623926gameMap:GameMap;
      
      private var _107944209queue:GameQueueConfig;
      
      public function QueueMap()
      {
         super();
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function set qualifiedToEnter(param1:Boolean) : void
      {
         var _loc2_:Object = this._1275011871qualifiedToEnter;
         if(_loc2_ !== param1)
         {
            this._1275011871qualifiedToEnter = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"qualifiedToEnter",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get gameMap() : GameMap
      {
         return this._195623926gameMap;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function set gameMap(param1:GameMap) : void
      {
         var _loc2_:Object = this._195623926gameMap;
         if(_loc2_ !== param1)
         {
            this._195623926gameMap = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameMap",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get queue() : GameQueueConfig
      {
         return this._107944209queue;
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      [Bindable(event="propertyChange")]
      public function get qualifiedToEnter() : Boolean
      {
         return this._1275011871qualifiedToEnter;
      }
      
      public function set queue(param1:GameQueueConfig) : void
      {
         var _loc2_:Object = this._107944209queue;
         if(_loc2_ !== param1)
         {
            this._107944209queue = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"queue",_loc2_,param1));
         }
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
   }
}

