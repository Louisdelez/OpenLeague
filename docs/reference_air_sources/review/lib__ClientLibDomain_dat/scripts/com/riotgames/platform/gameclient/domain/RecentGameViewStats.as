package com.riotgames.platform.gameclient.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class RecentGameViewStats implements IEventDispatcher
   {
      
      private var _109757599stats:PlayerGameStats;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _1330532588thumbnail:String;
      
      public function RecentGameViewStats()
      {
         super();
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
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
      public function get thumbnail() : String
      {
         return this._1330532588thumbnail;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function set thumbnail(param1:String) : void
      {
         var _loc2_:Object = this._1330532588thumbnail;
         if(_loc2_ !== param1)
         {
            this._1330532588thumbnail = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"thumbnail",_loc2_,param1));
         }
      }
      
      public function set stats(param1:PlayerGameStats) : void
      {
         var _loc2_:Object = this._109757599stats;
         if(_loc2_ !== param1)
         {
            this._109757599stats = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"stats",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get stats() : PlayerGameStats
      {
         return this._109757599stats;
      }
   }
}

