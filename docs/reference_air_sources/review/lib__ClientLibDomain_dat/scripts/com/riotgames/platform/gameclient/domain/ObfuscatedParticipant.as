package com.riotgames.platform.gameclient.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.game.ObfuscatedParticipant")]
   public class ObfuscatedParticipant implements IParticipant, IEventDispatcher
   {
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _1396647632badges:int;
      
      private var _139230498gameUniqueId:int;
      
      private var _1946516291clientInSynch:Boolean;
      
      private var _739625628pickMode:int;
      
      public function ObfuscatedParticipant()
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
      
      public function getSummonerInternalName() : String
      {
         return "";
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function set pickMode(param1:int) : void
      {
         var _loc2_:Object = this._739625628pickMode;
         if(_loc2_ !== param1)
         {
            this._739625628pickMode = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"pickMode",_loc2_,param1));
         }
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      [Bindable(event="propertyChange")]
      public function get gameUniqueId() : int
      {
         return this._139230498gameUniqueId;
      }
      
      public function set badges(param1:int) : void
      {
         var _loc2_:Object = this._1396647632badges;
         if(_loc2_ !== param1)
         {
            this._1396647632badges = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"badges",_loc2_,param1));
         }
      }
      
      public function getPickMode() : int
      {
         return this.pickMode;
      }
      
      public function getBadges() : int
      {
         return this.badges;
      }
      
      [Bindable(event="propertyChange")]
      public function get pickMode() : int
      {
         return this._739625628pickMode;
      }
      
      public function getSummonerName() : String
      {
         return "";
      }
      
      [Bindable(event="propertyChange")]
      public function get badges() : int
      {
         return this._1396647632badges;
      }
      
      public function getPickTurn() : int
      {
         return 0;
      }
      
      public function set clientInSynch(param1:Boolean) : void
      {
         var _loc2_:Object = this._1946516291clientInSynch;
         if(_loc2_ !== param1)
         {
            this._1946516291clientInSynch = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"clientInSynch",_loc2_,param1));
         }
      }
      
      public function set gameUniqueId(param1:int) : void
      {
         var _loc2_:Object = this._139230498gameUniqueId;
         if(_loc2_ !== param1)
         {
            this._139230498gameUniqueId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameUniqueId",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get clientInSynch() : Boolean
      {
         return this._1946516291clientInSynch;
      }
   }
}

