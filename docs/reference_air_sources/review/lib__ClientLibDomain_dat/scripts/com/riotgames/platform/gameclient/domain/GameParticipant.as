package com.riotgames.platform.gameclient.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.game.GameParticipant")]
   public class GameParticipant extends AbstractDomainObject implements IParticipant, IEventDispatcher
   {
      
      public static const PICK_MODE_NOT_PICKING:int = 0;
      
      public static const PICK_MODE_ACTIVE:int = 1;
      
      public static const PICK_MODE_DONE:int = 2;
      
      public static const FRIENDLY_TEAM:int = 1;
      
      public static const ENEMY_TEAM:int = 2;
      
      private var _1396647632badges:int;
      
      private var _504377593summonerName:String;
      
      protected var _isGameOwner:Boolean = false;
      
      private var _3555933team:int;
      
      protected var _isMe:Boolean;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _1668760952teamName:String;
      
      private var _739410882pickTurn:int;
      
      private var _739625628pickMode:int;
      
      private var _647530666summonerInternalName:String;
      
      public function GameParticipant()
      {
         super();
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get teamName() : String
      {
         return this._1668760952teamName;
      }
      
      public function set teamName(param1:String) : void
      {
         var _loc2_:Object = this._1668760952teamName;
         if(_loc2_ !== param1)
         {
            this._1668760952teamName = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"teamName",_loc2_,param1));
         }
      }
      
      public function canBeKickBanned() : Boolean
      {
         return !this.isMe && !this.isGameOwner;
      }
      
      public function getBadges() : int
      {
         return this.badges;
      }
      
      public function set summonerInternalName(param1:String) : void
      {
         var _loc2_:Object = this._647530666summonerInternalName;
         if(_loc2_ !== param1)
         {
            this._647530666summonerInternalName = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerInternalName",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set isGameOwner(param1:Boolean) : void
      {
         var _loc2_:Object = this.isGameOwner;
         if(_loc2_ !== param1)
         {
            this._2130075689isGameOwner = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isGameOwner",_loc2_,param1));
         }
      }
      
      public function getPickTurn() : int
      {
         return this.pickTurn;
      }
      
      [Bindable(event="propertyChange")]
      public function get badges() : int
      {
         return this._1396647632badges;
      }
      
      public function set team(param1:int) : void
      {
         var _loc2_:Object = this._3555933team;
         if(_loc2_ !== param1)
         {
            this._3555933team = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"team",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get pickTurn() : int
      {
         return this._739410882pickTurn;
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      private function set _3241058isMe(param1:Boolean) : void
      {
      }
      
      [Bindable(event="propertyChange")]
      public function set isMe(param1:Boolean) : void
      {
         var _loc2_:Object = this.isMe;
         if(_loc2_ !== param1)
         {
            this._3241058isMe = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isMe",_loc2_,param1));
         }
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
      
      public function getSummonerInternalName() : String
      {
         return this.summonerInternalName;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      [Bindable(event="propertyChange")]
      public function get summonerInternalName() : String
      {
         return this._647530666summonerInternalName;
      }
      
      public function get isGameOwner() : Boolean
      {
         return this._isGameOwner;
      }
      
      public function getPickMode() : int
      {
         return this.pickMode;
      }
      
      [Bindable(event="propertyChange")]
      public function get team() : int
      {
         return this._3555933team;
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
      
      public function get isMe() : Boolean
      {
         return this._isMe;
      }
      
      private function set _2130075689isGameOwner(param1:Boolean) : void
      {
      }
      
      [Bindable(event="propertyChange")]
      public function get pickMode() : int
      {
         return this._739625628pickMode;
      }
      
      public function getSummonerName() : String
      {
         return this.summonerName;
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
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get summonerName() : String
      {
         return this._504377593summonerName;
      }
      
      public function set pickTurn(param1:int) : void
      {
         var _loc2_:Object = this._739410882pickTurn;
         if(_loc2_ !== param1)
         {
            this._739410882pickTurn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"pickTurn",_loc2_,param1));
         }
      }
   }
}

