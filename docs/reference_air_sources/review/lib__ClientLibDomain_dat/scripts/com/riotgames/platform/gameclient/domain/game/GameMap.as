package com.riotgames.platform.gameclient.domain.game
{
   import com.riotgames.platform.gameclient.domain.AbstractDomainObject;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.game.map.GameMap")]
   public class GameMap extends AbstractDomainObject implements IEventDispatcher
   {
      
      public static const SUMMONERS_RIFT_ID:int = 1;
      
      public static const SUMMONERS_RIFT_AUTUMN_ID:int = 2;
      
      public static const PROVING_GROUNDS_ID:int = 3;
      
      public static const TWISTED_TREELINE_OLD_ID:int = 4;
      
      public static const SUMMONERS_RIFT_WINTER_ID:int = 6;
      
      public static const PROVING_GROUNDS_ARAM_ID:int = 7;
      
      public static const CRYSTAL_SCAR_ID:int = 8;
      
      public static const TWISTED_TREELINE_ID:int = 10;
      
      public static const SUMMONERS_RIFT_UPDATE_SHIPPING:int = 11;
      
      public static const HOWLING_ABYSS:int = 12;
      
      public static const SUMMONERS_RIFT_UPDATE_WIP:int = 13;
      
      public static const PRE_SEASON_SANDBOX:int = 90;
      
      private var _103663511mapId:int;
      
      private var _1714148973displayName:String;
      
      private var _3373707name:String;
      
      private var _1724546052description:String;
      
      private var _61475278totalPlayers:int;
      
      private var _1111432143minCustomPlayers:int;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function GameMap()
      {
         super();
      }
      
      public function canAddBotsToMap() : Boolean
      {
         return this.mapId == SUMMONERS_RIFT_ID || this.mapId == SUMMONERS_RIFT_AUTUMN_ID || this.mapId == SUMMONERS_RIFT_WINTER_ID || this.mapId == TWISTED_TREELINE_ID || this.mapId == CRYSTAL_SCAR_ID || this.mapId == SUMMONERS_RIFT_UPDATE_SHIPPING || this.mapId == SUMMONERS_RIFT_UPDATE_WIP || this.mapId == SUMMONERS_RIFT_UPDATE_WIP;
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get name() : String
      {
         return this._3373707name;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      [Bindable(event="propertyChange")]
      public function get totalPlayers() : int
      {
         return this._61475278totalPlayers;
      }
      
      [Bindable(event="propertyChange")]
      public function get minCustomPlayers() : int
      {
         return this._1111432143minCustomPlayers;
      }
      
      public function initialize(param1:int, param2:String, param3:String, param4:int) : void
      {
         this.mapId = param1;
         this.displayName = param2;
         this.description = param3;
         this.totalPlayers = param4;
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      [Bindable(event="propertyChange")]
      public function get mapId() : int
      {
         return this._103663511mapId;
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function set displayName(param1:String) : void
      {
         var _loc2_:Object = this._1714148973displayName;
         if(_loc2_ !== param1)
         {
            this._1714148973displayName = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"displayName",_loc2_,param1));
         }
      }
      
      public function set totalPlayers(param1:int) : void
      {
         var _loc2_:Object = this._61475278totalPlayers;
         if(_loc2_ !== param1)
         {
            this._61475278totalPlayers = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"totalPlayers",_loc2_,param1));
         }
      }
      
      public function set name(param1:String) : void
      {
         var _loc2_:Object = this._3373707name;
         if(_loc2_ !== param1)
         {
            this._3373707name = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"name",_loc2_,param1));
         }
      }
      
      public function set minCustomPlayers(param1:int) : void
      {
         var _loc2_:Object = this._1111432143minCustomPlayers;
         if(_loc2_ !== param1)
         {
            this._1111432143minCustomPlayers = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"minCustomPlayers",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get displayName() : String
      {
         return this._1714148973displayName;
      }
      
      public function set mapId(param1:int) : void
      {
         var _loc2_:Object = this._103663511mapId;
         if(_loc2_ !== param1)
         {
            this._103663511mapId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mapId",_loc2_,param1));
         }
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function set description(param1:String) : void
      {
         var _loc2_:Object = this._1724546052description;
         if(_loc2_ !== param1)
         {
            this._1724546052description = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"description",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get description() : String
      {
         return this._1724546052description;
      }
   }
}

