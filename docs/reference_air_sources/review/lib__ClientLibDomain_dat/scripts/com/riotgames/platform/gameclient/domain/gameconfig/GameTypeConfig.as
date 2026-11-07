package com.riotgames.platform.gameclient.domain.gameconfig
{
   import com.riotgames.platform.gameclient.domain.AbstractDomainObject;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.game.GameTypeConfigDTO")]
   public class GameTypeConfig extends AbstractDomainObject implements IEventDispatcher
   {
      
      public static const PICK_MODE_SIMUL_PICK:String = "SimulPickStrategy";
      
      public static const PICK_MODE_DRAFT_MODE_SINGLE_PICK:String = "DraftModeSinglePickStrategy";
      
      public static const PICK_MODE_ALL_RANDOM:String = "AllRandomPickStrategy";
      
      public static const PICK_MODE_TOURNAMENT:String = "TournamentPickStrategy";
      
      public static const PICK_MODE_VOTE_PICK:String = "OneTeamVotePickStrategy";
      
      public static const PICK_MODE_ALL_VOTE_PICK:String = "AllTeamVotePickStrategy";
      
      public static const PICK_ID_BLIND_PICK:int = 1;
      
      public static const PICK_ID_RANDOM:int = 4;
      
      public static const PICK_ID_SIM_BAN:int = 7;
      
      public static const PICK_ID_ONE_TEAM_VOTE_DRAFT:int = 14;
      
      public static const PICK_ID_ALL_TEAM_VOTE_PICK:int = 15;
      
      public static const PICK_ID_SIM_BAN_SHORT_TIMER:int = 16;
      
      private static const FEATURED_PICK_IDS:ArrayCollection = new ArrayCollection([PICK_ID_SIM_BAN,PICK_ID_ONE_TEAM_VOTE_DRAFT,PICK_ID_ALL_TEAM_VOTE_PICK,PICK_ID_SIM_BAN_SHORT_TIMER]);
      
      private static const VOTE_PICK_IDS:ArrayCollection = new ArrayCollection([PICK_ID_ONE_TEAM_VOTE_DRAFT,PICK_ID_ALL_TEAM_VOTE_PICK]);
      
      public static const SERVER_TIMER_BUFFER:Number = 3;
      
      public static const ADVANCED_TUTORIAL_GAMETYPE_ID:uint = 11;
      
      private var _3373707name:String;
      
      private var _1723362145mainPickTimerDuration:Number;
      
      private var _1881080706crossTeamChampionPool:Boolean;
      
      private var _234835096postPickTimerDuration:Number;
      
      private var _940812330banTimerDuration:Number;
      
      private var _3355id:Number;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _429218014teamChampionPool:Boolean;
      
      private var _939685373maxAllowableBans:int;
      
      private var _739625628pickMode:String = "DraftModeSinglePickStrategy";
      
      private var _1196504031exclusivePick:Boolean;
      
      private var _1250769972duplicatePick:Boolean;
      
      private var _1039495224allowTrades:Boolean;
      
      public function GameTypeConfig()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get crossTeamChampionPool() : Boolean
      {
         return this._1881080706crossTeamChampionPool;
      }
      
      [Bindable(event="propertyChange")]
      public function get maxAllowableBans() : int
      {
         return this._939685373maxAllowableBans;
      }
      
      public function set crossTeamChampionPool(param1:Boolean) : void
      {
         var _loc2_:Object = this._1881080706crossTeamChampionPool;
         if(_loc2_ !== param1)
         {
            this._1881080706crossTeamChampionPool = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"crossTeamChampionPool",_loc2_,param1));
         }
      }
      
      public function set maxAllowableBans(param1:int) : void
      {
         var _loc2_:Object = this._939685373maxAllowableBans;
         if(_loc2_ !== param1)
         {
            this._939685373maxAllowableBans = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"maxAllowableBans",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get name() : String
      {
         return this._3373707name;
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get postPickTimerDuration() : Number
      {
         return this._234835096postPickTimerDuration;
      }
      
      [Bindable(event="propertyChange")]
      public function get id() : Number
      {
         return this._3355id;
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
      
      [Bindable(event="propertyChange")]
      public function get mainPickTimerDuration() : Number
      {
         return this._1723362145mainPickTimerDuration;
      }
      
      [Bindable(event="propertyChange")]
      public function get teamChampionPool() : Boolean
      {
         return this._429218014teamChampionPool;
      }
      
      public function set duplicatePick(param1:Boolean) : void
      {
         var _loc2_:Object = this._1250769972duplicatePick;
         if(_loc2_ !== param1)
         {
            this._1250769972duplicatePick = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"duplicatePick",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get banTimerDuration() : Number
      {
         return this._940812330banTimerDuration;
      }
      
      public function set postPickTimerDuration(param1:Number) : void
      {
         var _loc2_:Object = this._234835096postPickTimerDuration;
         if(_loc2_ !== param1)
         {
            this._234835096postPickTimerDuration = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"postPickTimerDuration",_loc2_,param1));
         }
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
      public function get allowTrades() : Boolean
      {
         return this._1039495224allowTrades;
      }
      
      public function get votePickGameTypeConfig() : Boolean
      {
         return VOTE_PICK_IDS.contains(this.id);
      }
      
      public function set exclusivePick(param1:Boolean) : void
      {
         var _loc2_:Object = this._1196504031exclusivePick;
         if(_loc2_ !== param1)
         {
            this._1196504031exclusivePick = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"exclusivePick",_loc2_,param1));
         }
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function set teamChampionPool(param1:Boolean) : void
      {
         var _loc2_:Object = this._429218014teamChampionPool;
         if(_loc2_ !== param1)
         {
            this._429218014teamChampionPool = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"teamChampionPool",_loc2_,param1));
         }
      }
      
      public function set pickMode(param1:String) : void
      {
         var _loc2_:Object = this._739625628pickMode;
         if(_loc2_ !== param1)
         {
            this._739625628pickMode = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"pickMode",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get duplicatePick() : Boolean
      {
         return this._1250769972duplicatePick;
      }
      
      public function set mainPickTimerDuration(param1:Number) : void
      {
         var _loc2_:Object = this._1723362145mainPickTimerDuration;
         if(_loc2_ !== param1)
         {
            this._1723362145mainPickTimerDuration = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mainPickTimerDuration",_loc2_,param1));
         }
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function set banTimerDuration(param1:Number) : void
      {
         var _loc2_:Object = this._940812330banTimerDuration;
         if(_loc2_ !== param1)
         {
            this._940812330banTimerDuration = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"banTimerDuration",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get pickMode() : String
      {
         return this._739625628pickMode;
      }
      
      [Bindable(event="propertyChange")]
      public function get exclusivePick() : Boolean
      {
         return this._1196504031exclusivePick;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function set allowTrades(param1:Boolean) : void
      {
         var _loc2_:Object = this._1039495224allowTrades;
         if(_loc2_ !== param1)
         {
            this._1039495224allowTrades = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"allowTrades",_loc2_,param1));
         }
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function get featuredGameTypeConfig() : Boolean
      {
         return FEATURED_PICK_IDS.contains(this.id);
      }
   }
}

