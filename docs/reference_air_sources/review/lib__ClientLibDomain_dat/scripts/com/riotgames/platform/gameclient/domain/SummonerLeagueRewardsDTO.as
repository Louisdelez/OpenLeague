package com.riotgames.platform.gameclient.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.leagues.client.dto.SummonerLeagueRewardsDTO")]
   public class SummonerLeagueRewardsDTO implements IEventDispatcher
   {
      
      private var _982754077points:int;
      
      private var _880574869rewardLevel:int;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function SummonerLeagueRewardsDTO()
      {
         super();
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get points() : int
      {
         return this._982754077points;
      }
      
      public function set points(param1:int) : void
      {
         var _loc2_:Object = this._982754077points;
         if(_loc2_ !== param1)
         {
            this._982754077points = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"points",_loc2_,param1));
         }
      }
      
      public function set rewardLevel(param1:int) : void
      {
         var _loc2_:Object = this._880574869rewardLevel;
         if(_loc2_ !== param1)
         {
            this._880574869rewardLevel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rewardLevel",_loc2_,param1));
         }
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      [Bindable(event="propertyChange")]
      public function get rewardLevel() : int
      {
         return this._880574869rewardLevel;
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
   }
}

