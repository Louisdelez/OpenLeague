package com.riotgames.platform.gameclient.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.statistics.ChampionStatInfo")]
   public class ChampionStatInfo implements IEventDispatcher
   {
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _1537709924championId:Number;
      
      private var _1839054608totalGamesPlayed:Number;
      
      private var _109757599stats:ArrayCollection;
      
      public function ChampionStatInfo()
      {
         super();
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function set championId(param1:Number) : void
      {
         var _loc2_:Object = this._1537709924championId;
         if(_loc2_ !== param1)
         {
            this._1537709924championId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"championId",_loc2_,param1));
         }
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      [Bindable(event="propertyChange")]
      public function get totalGamesPlayed() : Number
      {
         return this._1839054608totalGamesPlayed;
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get stats() : ArrayCollection
      {
         return this._109757599stats;
      }
      
      public function set totalGamesPlayed(param1:Number) : void
      {
         var _loc2_:Object = this._1839054608totalGamesPlayed;
         if(_loc2_ !== param1)
         {
            this._1839054608totalGamesPlayed = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"totalGamesPlayed",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get championId() : Number
      {
         return this._1537709924championId;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function set stats(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._109757599stats;
         if(_loc2_ !== param1)
         {
            this._109757599stats = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"stats",_loc2_,param1));
         }
      }
   }
}

