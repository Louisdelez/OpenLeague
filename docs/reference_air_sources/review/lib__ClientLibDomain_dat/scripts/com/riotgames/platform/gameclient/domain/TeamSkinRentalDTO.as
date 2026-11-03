package com.riotgames.platform.gameclient.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.skin.rental.service.pojo.TeamSkinRentalDTO")]
   public class TeamSkinRentalDTO implements IEventDispatcher
   {
      
      private var _504377593summonerName:String;
      
      private var _210949405unlocked:Boolean;
      
      private var _1372163894ipReward:int;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function TeamSkinRentalDTO()
      {
         super();
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get unlocked() : Boolean
      {
         return this._210949405unlocked;
      }
      
      public function set unlocked(param1:Boolean) : void
      {
         var _loc2_:Object = this._210949405unlocked;
         if(_loc2_ !== param1)
         {
            this._210949405unlocked = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"unlocked",_loc2_,param1));
         }
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function set ipReward(param1:int) : void
      {
         var _loc2_:Object = this._1372163894ipReward;
         if(_loc2_ !== param1)
         {
            this._1372163894ipReward = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ipReward",_loc2_,param1));
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function set summonerName(param1:String) : void
      {
         var _loc2_:Object = this._504377593summonerName;
         if(_loc2_ !== param1)
         {
            this._504377593summonerName = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerName",_loc2_,param1));
         }
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get ipReward() : int
      {
         return this._1372163894ipReward;
      }
      
      [Bindable(event="propertyChange")]
      public function get summonerName() : String
      {
         return this._504377593summonerName;
      }
   }
}

