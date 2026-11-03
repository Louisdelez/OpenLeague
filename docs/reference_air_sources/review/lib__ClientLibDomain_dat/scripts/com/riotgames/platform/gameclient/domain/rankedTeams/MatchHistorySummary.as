package com.riotgames.platform.gameclient.domain.rankedTeams
{
   import com.riotgames.platform.gameclient.domain.AbstractDomainObject;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.team.stats.MatchHistorySummary")]
   public class MatchHistorySummary extends AbstractDomainObject implements IEventDispatcher
   {
      
      private var _1769361227gameMode:String;
      
      private var _1959784951invalid:Boolean;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _103663511mapId:int;
      
      private var _3076014date:Number;
      
      private var _1253236563gameId:Number;
      
      private var _539669975opposingTeamName:String;
      
      private var _117724win:Boolean;
      
      private var _102052053kills:int;
      
      private var _1335772033deaths:int;
      
      private var _452632823opposingTeamKills:int;
      
      private var _704656598assists:int;
      
      public function MatchHistorySummary()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get opposingTeamKills() : int
      {
         return this._452632823opposingTeamKills;
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function set opposingTeamKills(param1:int) : void
      {
         var _loc2_:Object = this._452632823opposingTeamKills;
         if(_loc2_ !== param1)
         {
            this._452632823opposingTeamKills = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"opposingTeamKills",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get mapId() : int
      {
         return this._103663511mapId;
      }
      
      [Bindable(event="propertyChange")]
      public function get assists() : int
      {
         return this._704656598assists;
      }
      
      [Bindable(event="propertyChange")]
      public function get gameId() : Number
      {
         return this._1253236563gameId;
      }
      
      [Bindable(event="propertyChange")]
      public function get date() : Number
      {
         return this._3076014date;
      }
      
      public function set opposingTeamName(param1:String) : void
      {
         var _loc2_:Object = this._539669975opposingTeamName;
         if(_loc2_ !== param1)
         {
            this._539669975opposingTeamName = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"opposingTeamName",_loc2_,param1));
         }
      }
      
      public function set win(param1:Boolean) : void
      {
         var _loc2_:Object = this._117724win;
         if(_loc2_ !== param1)
         {
            this._117724win = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"win",_loc2_,param1));
         }
      }
      
      public function set kills(param1:int) : void
      {
         var _loc2_:Object = this._102052053kills;
         if(_loc2_ !== param1)
         {
            this._102052053kills = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"kills",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get gameMode() : String
      {
         return this._1769361227gameMode;
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
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
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
      public function get kills() : int
      {
         return this._102052053kills;
      }
      
      [Bindable(event="propertyChange")]
      public function get opposingTeamName() : String
      {
         return this._539669975opposingTeamName;
      }
      
      public function set gameId(param1:Number) : void
      {
         var _loc2_:Object = this._1253236563gameId;
         if(_loc2_ !== param1)
         {
            this._1253236563gameId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameId",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get win() : Boolean
      {
         return this._117724win;
      }
      
      public function set assists(param1:int) : void
      {
         var _loc2_:Object = this._704656598assists;
         if(_loc2_ !== param1)
         {
            this._704656598assists = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"assists",_loc2_,param1));
         }
      }
      
      public function set gameMode(param1:String) : void
      {
         var _loc2_:Object = this._1769361227gameMode;
         if(_loc2_ !== param1)
         {
            this._1769361227gameMode = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameMode",_loc2_,param1));
         }
      }
      
      public function set date(param1:Number) : void
      {
         var _loc2_:Object = this._3076014date;
         if(_loc2_ !== param1)
         {
            this._3076014date = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"date",_loc2_,param1));
         }
      }
      
      public function set invalid(param1:Boolean) : void
      {
         var _loc2_:Object = this._1959784951invalid;
         if(_loc2_ !== param1)
         {
            this._1959784951invalid = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"invalid",_loc2_,param1));
         }
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get invalid() : Boolean
      {
         return this._1959784951invalid;
      }
      
      public function set deaths(param1:int) : void
      {
         var _loc2_:Object = this._1335772033deaths;
         if(_loc2_ !== param1)
         {
            this._1335772033deaths = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"deaths",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get deaths() : int
      {
         return this._1335772033deaths;
      }
   }
}

