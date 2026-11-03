package com.riotgames.platform.gameclient.domain.game
{
   import com.riotgames.platform.gameclient.domain.AbstractDomainObject;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.matchmaking.GameQueueConfig")]
   public class GameQueueConfig extends AbstractDomainObject implements IEventDispatcher
   {
      
      public static const CHAMPS_NEEDED_FOR_DRAFT:int = 16;
      
      public static const CAP_QUEUE_5V5:int = 12;
      
      public static const CAP_QUEUE_1V1:int = 60;
      
      private var _2105559965disallowFreeChampions:Boolean = false;
      
      private var _1769361227gameMode:String;
      
      private var _76493322supportedMapIds:ArrayCollection;
      
      private var _1020872611gameMutators:ArrayCollection;
      
      private var _1147999186maximumParticipantListSize:int;
      
      private var _1312539397maxSummonerLevelForFirstWinOfTheDay:int;
      
      private var _3575610type:String;
      
      private var _1914706140minimumParticipantListSize:int;
      
      private var _968761961gameTypeConfigId:int;
      
      private var _832155602numPlayersPerTeam:Number;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _3355id:Number;
      
      private var _1386076078minLevel:int;
      
      private var _390120576maxLevel:int;
      
      private var _1668718679teamOnly:Boolean;
      
      private var _938279477ranked:Boolean;
      
      public function GameQueueConfig()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get maxLevel() : int
      {
         return this._390120576maxLevel;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get maxSummonerLevelForFirstWinOfTheDay() : int
      {
         return this._1312539397maxSummonerLevelForFirstWinOfTheDay;
      }
      
      public function get name() : String
      {
         return this.numPlayersPerTeam + "x" + this.numPlayersPerTeam;
      }
      
      public function set maxLevel(param1:int) : void
      {
         var _loc2_:Object = this._390120576maxLevel;
         if(_loc2_ !== param1)
         {
            this._390120576maxLevel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"maxLevel",_loc2_,param1));
         }
      }
      
      public function set maxSummonerLevelForFirstWinOfTheDay(param1:int) : void
      {
         var _loc2_:Object = this._1312539397maxSummonerLevelForFirstWinOfTheDay;
         if(_loc2_ !== param1)
         {
            this._1312539397maxSummonerLevelForFirstWinOfTheDay = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"maxSummonerLevelForFirstWinOfTheDay",_loc2_,param1));
         }
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function set ranked(param1:Boolean) : void
      {
         var _loc2_:Object = this._938279477ranked;
         if(_loc2_ !== param1)
         {
            this._938279477ranked = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ranked",_loc2_,param1));
         }
      }
      
      public function initialize(param1:Number, param2:String, param3:Number) : GameQueueConfig
      {
         this.id = param1;
         this.type = param2;
         this.numPlayersPerTeam = param3;
         return this;
      }
      
      public function set teamOnly(param1:Boolean) : void
      {
         var _loc2_:Object = this._1668718679teamOnly;
         if(_loc2_ !== param1)
         {
            this._1668718679teamOnly = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"teamOnly",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get supportedMapIds() : ArrayCollection
      {
         return this._76493322supportedMapIds;
      }
      
      [Bindable(event="propertyChange")]
      public function get id() : Number
      {
         return this._3355id;
      }
      
      public function set supportedMapIds(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._76493322supportedMapIds;
         if(_loc2_ !== param1)
         {
            this._76493322supportedMapIds = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"supportedMapIds",_loc2_,param1));
         }
      }
      
      public function set maximumParticipantListSize(param1:int) : void
      {
         var _loc2_:Object = this._1147999186maximumParticipantListSize;
         if(_loc2_ !== param1)
         {
            this._1147999186maximumParticipantListSize = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"maximumParticipantListSize",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get teamOnly() : Boolean
      {
         return this._1668718679teamOnly;
      }
      
      [Bindable(event="propertyChange")]
      public function get gameMutators() : ArrayCollection
      {
         return this._1020872611gameMutators;
      }
      
      public function set minLevel(param1:int) : void
      {
         var _loc2_:Object = this._1386076078minLevel;
         if(_loc2_ !== param1)
         {
            this._1386076078minLevel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"minLevel",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get numPlayersPerTeam() : Number
      {
         return this._832155602numPlayersPerTeam;
      }
      
      public function set id(param1:Number) : void
      {
         var _loc2_:Object = this._3355id;
         if(_loc2_ !== param1)
         {
            this._3355id = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"id",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get type() : String
      {
         return this._3575610type;
      }
      
      [Bindable(event="propertyChange")]
      public function get minimumParticipantListSize() : int
      {
         return this._1914706140minimumParticipantListSize;
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get gameMode() : String
      {
         return this._1769361227gameMode;
      }
      
      public function set disallowFreeChampions(param1:Boolean) : void
      {
         var _loc2_:Object = this._2105559965disallowFreeChampions;
         if(_loc2_ !== param1)
         {
            this._2105559965disallowFreeChampions = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"disallowFreeChampions",_loc2_,param1));
         }
      }
      
      public function isCap() : Boolean
      {
         return this.gameTypeConfigId == CAP_QUEUE_5V5 || this.gameTypeConfigId == CAP_QUEUE_1V1;
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      [Bindable(event="propertyChange")]
      public function get ranked() : Boolean
      {
         return this._938279477ranked;
      }
      
      public function set gameMutators(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1020872611gameMutators;
         if(_loc2_ !== param1)
         {
            this._1020872611gameMutators = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameMutators",_loc2_,param1));
         }
      }
      
      public function set minimumParticipantListSize(param1:int) : void
      {
         var _loc2_:Object = this._1914706140minimumParticipantListSize;
         if(_loc2_ !== param1)
         {
            this._1914706140minimumParticipantListSize = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"minimumParticipantListSize",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get maximumParticipantListSize() : int
      {
         return this._1147999186maximumParticipantListSize;
      }
      
      public function set numPlayersPerTeam(param1:Number) : void
      {
         var _loc2_:Object = this._832155602numPlayersPerTeam;
         if(_loc2_ !== param1)
         {
            this._832155602numPlayersPerTeam = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"numPlayersPerTeam",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get minLevel() : int
      {
         return this._1386076078minLevel;
      }
      
      [Bindable(event="propertyChange")]
      public function get disallowFreeChampions() : Boolean
      {
         return this._2105559965disallowFreeChampions;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_ += "id=" + this.id;
         _loc1_ += ":type=" + this.type;
         _loc1_ += ":numPlayersPerTeam=" + this.numPlayersPerTeam;
         _loc1_ += ":name=" + this.name;
         _loc1_ += ":ranked=" + this.ranked;
         _loc1_ += ":minLevel=" + this.minLevel;
         _loc1_ += ":gameMode=" + this.gameMode;
         _loc1_ += ":minParticipatnList=" + this.minimumParticipantListSize;
         _loc1_ += ":maxParticipantList=" + this.maximumParticipantListSize;
         return _loc1_ + (":gameTypeConfigId=" + this.gameTypeConfigId);
      }
      
      [Bindable(event="propertyChange")]
      public function get gameTypeConfigId() : int
      {
         return this._968761961gameTypeConfigId;
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
      
      public function set type(param1:String) : void
      {
         var _loc2_:Object = this._3575610type;
         if(_loc2_ !== param1)
         {
            this._3575610type = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"type",_loc2_,param1));
         }
      }
      
      public function set gameTypeConfigId(param1:int) : void
      {
         var _loc2_:Object = this._968761961gameTypeConfigId;
         if(_loc2_ !== param1)
         {
            this._968761961gameTypeConfigId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameTypeConfigId",_loc2_,param1));
         }
      }
   }
}

