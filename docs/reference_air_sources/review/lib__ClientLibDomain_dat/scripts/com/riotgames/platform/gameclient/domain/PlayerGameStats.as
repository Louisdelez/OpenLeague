package com.riotgames.platform.gameclient.domain
{
   import com.riotgames.platform.gameclient.domain.game.QueueType;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   import mx.utils.RPCObjectUtil;
   
   [RemoteClass(alias="com.riotgames.platform.statistics.PlayerGameStats")]
   public class PlayerGameStats extends AbstractDomainObject implements IEventDispatcher
   {
      
      public static const VERIFICATION_EXCEPTION:String = "com.riotgames.platform.ValidationException";
      
      private var _1739445269queueType:String;
      
      private var _1020872611gameMutators:ArrayCollection;
      
      private var _1769361227gameMode:String;
      
      private var _1368729290createDate:Date;
      
      private var _996153982ipEarned:Number;
      
      private var _983970501gameMapId:Number;
      
      private var _877713320teamId:Number;
      
      private var _1959784951invalid:Boolean;
      
      private var _rawStats:ArrayCollection;
      
      private var _896064502spell2:Number;
      
      private var _1655724770leveledUp:Boolean;
      
      private var _statistics:Object;
      
      private var _1769142708gameType:String;
      
      private var _1537709924championId:Number;
      
      private var _1253236563gameId:Number;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _1106736997leaver:Boolean;
      
      private var _597616769experienceEarned:Number;
      
      private var _896064503spell1:Number;
      
      private var _938279477ranked:Boolean;
      
      private var _836030906userId:Number;
      
      private var _907587829fellowPlayers:ArrayCollection;
      
      public function PlayerGameStats()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get experienceEarned() : Number
      {
         return this._597616769experienceEarned;
      }
      
      [Bindable(event="propertyChange")]
      public function get ipEarned() : Number
      {
         return this._996153982ipEarned;
      }
      
      [Bindable(event="propertyChange")]
      public function get spell1() : Number
      {
         return this._896064503spell1;
      }
      
      public function set gameMapId(param1:Number) : void
      {
         var _loc2_:Object = this._983970501gameMapId;
         if(_loc2_ !== param1)
         {
            this._983970501gameMapId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameMapId",_loc2_,param1));
         }
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get spell2() : Number
      {
         return this._896064502spell2;
      }
      
      public function set spell1(param1:Number) : void
      {
         var _loc2_:Object = this._896064503spell1;
         if(_loc2_ !== param1)
         {
            this._896064503spell1 = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"spell1",_loc2_,param1));
         }
      }
      
      public function set createDate(param1:Date) : void
      {
         var _loc2_:Object = this._1368729290createDate;
         if(_loc2_ !== param1)
         {
            this._1368729290createDate = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"createDate",_loc2_,param1));
         }
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
      
      public function set experienceEarned(param1:Number) : void
      {
         var _loc2_:Object = this._597616769experienceEarned;
         if(_loc2_ !== param1)
         {
            this._597616769experienceEarned = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"experienceEarned",_loc2_,param1));
         }
      }
      
      public function set fellowPlayers(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._907587829fellowPlayers;
         if(_loc2_ !== param1)
         {
            this._907587829fellowPlayers = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"fellowPlayers",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get leveledUp() : Boolean
      {
         return this._1655724770leveledUp;
      }
      
      [Bindable(event="propertyChange")]
      public function get leaver() : Boolean
      {
         return this._1106736997leaver;
      }
      
      public function get statistics() : Object
      {
         return this._statistics;
      }
      
      public function set userId(param1:Number) : void
      {
         var _loc2_:Object = this._836030906userId;
         if(_loc2_ !== param1)
         {
            this._836030906userId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"userId",_loc2_,param1));
         }
      }
      
      public function set gameType(param1:String) : void
      {
         var _loc2_:Object = this._1769142708gameType;
         if(_loc2_ !== param1)
         {
            this._1769142708gameType = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameType",_loc2_,param1));
         }
      }
      
      public function set spell2(param1:Number) : void
      {
         var _loc2_:Object = this._896064502spell2;
         if(_loc2_ !== param1)
         {
            this._896064502spell2 = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"spell2",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get gameId() : Number
      {
         return this._1253236563gameId;
      }
      
      [Bindable(event="propertyChange")]
      public function set rawStats(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this.rawStats;
         if(_loc2_ !== param1)
         {
            this._492500311rawStats = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rawStats",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get gameMode() : String
      {
         return this._1769361227gameMode;
      }
      
      public function set teamId(param1:Number) : void
      {
         var _loc2_:Object = this._877713320teamId;
         if(_loc2_ !== param1)
         {
            this._877713320teamId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"teamId",_loc2_,param1));
         }
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
      
      public function set leveledUp(param1:Boolean) : void
      {
         var _loc2_:Object = this._1655724770leveledUp;
         if(_loc2_ !== param1)
         {
            this._1655724770leveledUp = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"leveledUp",_loc2_,param1));
         }
      }
      
      public function set leaver(param1:Boolean) : void
      {
         var _loc2_:Object = this._1106736997leaver;
         if(_loc2_ !== param1)
         {
            this._1106736997leaver = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"leaver",_loc2_,param1));
         }
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get gameMapId() : Number
      {
         return this._983970501gameMapId;
      }
      
      [Bindable(event="propertyChange")]
      public function get createDate() : Date
      {
         return this._1368729290createDate;
      }
      
      private function set _94588637statistics(param1:Object) : void
      {
         var _loc2_:RawStat = null;
         this._statistics = param1;
         this._rawStats = new ArrayCollection();
         for each(_loc2_ in this._statistics)
         {
            this._rawStats.addItem(_loc2_);
         }
         this.rawStats = null;
      }
      
      [Bindable(event="propertyChange")]
      public function get gameType() : String
      {
         return this._1769142708gameType;
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
      
      [Bindable(event="propertyChange")]
      public function get gameMutators() : ArrayCollection
      {
         return this._1020872611gameMutators;
      }
      
      [Bindable(event="propertyChange")]
      public function get fellowPlayers() : ArrayCollection
      {
         return this._907587829fellowPlayers;
      }
      
      [Bindable(event="propertyChange")]
      public function get userId() : Number
      {
         return this._836030906userId;
      }
      
      public function set queueType(param1:String) : void
      {
         var _loc2_:Object = this._1739445269queueType;
         if(_loc2_ !== param1)
         {
            this._1739445269queueType = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"queueType",_loc2_,param1));
         }
      }
      
      public function get rawStats() : ArrayCollection
      {
         return this._rawStats;
      }
      
      [Bindable(event="propertyChange")]
      public function get teamId() : Number
      {
         return this._877713320teamId;
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
      public function set statistics(param1:Object) : void
      {
         var _loc2_:Object = this.statistics;
         if(_loc2_ !== param1)
         {
            this._94588637statistics = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"statistics",_loc2_,param1));
         }
      }
      
      private function set _492500311rawStats(param1:ArrayCollection) : void
      {
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      [Bindable(event="propertyChange")]
      public function get championId() : Number
      {
         return this._1537709924championId;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      [Bindable(event="propertyChange")]
      public function get queueType() : String
      {
         return this._1739445269queueType;
      }
      
      public function toString() : String
      {
         return RPCObjectUtil.toString(this);
      }
      
      [Bindable(event="propertyChange")]
      public function get ranked() : Boolean
      {
         return this._938279477ranked;
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
      
      public function set gameMode(param1:String) : void
      {
         var _loc2_:Object = this._1769361227gameMode;
         if(_loc2_ !== param1)
         {
            this._1769361227gameMode = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameMode",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get invalid() : Boolean
      {
         return this._1959784951invalid;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function set ipEarned(param1:Number) : void
      {
         var _loc2_:Object = this._996153982ipEarned;
         if(_loc2_ !== param1)
         {
            this._996153982ipEarned = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ipEarned",_loc2_,param1));
         }
      }
      
      public function get gameTypeString() : String
      {
         if(QueueType.isCoopVsAI(this.queueType))
         {
            return "COOP_VS_AI";
         }
         return this.ranked ? "RANKED_GAME" : this.gameType;
      }
   }
}

