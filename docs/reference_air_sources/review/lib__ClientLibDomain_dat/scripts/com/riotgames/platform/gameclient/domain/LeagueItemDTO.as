package com.riotgames.platform.gameclient.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.leagues.pojo.LeagueItemDTO")]
   public class LeagueItemDTO implements IEventDispatcher
   {
      
      private var _24665195inactive:Boolean;
      
      private var _1540458778leaguePointsDelta:Number;
      
      private var _1739445269queueType:String;
      
      private var _353046207veteran:Boolean;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _1238215500playerOrTeamName:String;
      
      private var _481870177timeLastDecayMessageShown:Number;
      
      private var _1096968431losses:int;
      
      private var _800282260freshBlood:Boolean;
      
      private var _397643523previousDayLeaguePosition:int;
      
      private var _1266140260displayDecayWarning:Boolean;
      
      private var _3649559wins:int;
      
      private var _471399410leaguePoints:int;
      
      private var _3559906tier:String;
      
      private var _1450351653demotionWarning:int;
      
      private var _4886874leagueName:String;
      
      private var _755195349hotStreak:Boolean;
      
      private var _1142083154miniSeries:MiniSeriesDTO;
      
      private var _2087393879timeUntilDecay:Number;
      
      private var _3492908rank:String;
      
      private var _1845973257lastPlayed:Number;
      
      private var _1413577244playerOrTeamId:String;
      
      public function LeagueItemDTO()
      {
         super();
      }
      
      public function set previousDayLeaguePosition(param1:int) : void
      {
         var _loc2_:Object = this._397643523previousDayLeaguePosition;
         if(_loc2_ !== param1)
         {
            this._397643523previousDayLeaguePosition = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"previousDayLeaguePosition",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get timeLastDecayMessageShown() : Number
      {
         return this._481870177timeLastDecayMessageShown;
      }
      
      [Bindable(event="propertyChange")]
      public function get lastPlayed() : Number
      {
         return this._1845973257lastPlayed;
      }
      
      [Bindable(event="propertyChange")]
      public function get losses() : int
      {
         return this._1096968431losses;
      }
      
      [Bindable(event="propertyChange")]
      public function get previousDayLeaguePosition() : int
      {
         return this._397643523previousDayLeaguePosition;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get wins() : int
      {
         return this._3649559wins;
      }
      
      public function set playerOrTeamName(param1:String) : void
      {
         var _loc2_:Object = this._1238215500playerOrTeamName;
         if(_loc2_ !== param1)
         {
            this._1238215500playerOrTeamName = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"playerOrTeamName",_loc2_,param1));
         }
      }
      
      public function set lastPlayed(param1:Number) : void
      {
         var _loc2_:Object = this._1845973257lastPlayed;
         if(_loc2_ !== param1)
         {
            this._1845973257lastPlayed = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lastPlayed",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get playerOrTeamId() : String
      {
         return this._1413577244playerOrTeamId;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function set losses(param1:int) : void
      {
         var _loc2_:Object = this._1096968431losses;
         if(_loc2_ !== param1)
         {
            this._1096968431losses = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"losses",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get inactive() : Boolean
      {
         return this._24665195inactive;
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get timeUntilDecay() : Number
      {
         return this._2087393879timeUntilDecay;
      }
      
      [Bindable(event="propertyChange")]
      public function get hotStreak() : Boolean
      {
         return this._755195349hotStreak;
      }
      
      public function set wins(param1:int) : void
      {
         var _loc2_:Object = this._3649559wins;
         if(_loc2_ !== param1)
         {
            this._3649559wins = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"wins",_loc2_,param1));
         }
      }
      
      public function set miniSeries(param1:MiniSeriesDTO) : void
      {
         var _loc2_:Object = this._1142083154miniSeries;
         if(_loc2_ !== param1)
         {
            this._1142083154miniSeries = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"miniSeries",_loc2_,param1));
         }
      }
      
      public function set leagueName(param1:String) : void
      {
         var _loc2_:Object = this._4886874leagueName;
         if(_loc2_ !== param1)
         {
            this._4886874leagueName = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"leagueName",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get miniSeries() : MiniSeriesDTO
      {
         return this._1142083154miniSeries;
      }
      
      [Bindable(event="propertyChange")]
      public function get rank() : String
      {
         return this._3492908rank;
      }
      
      [Bindable(event="propertyChange")]
      public function get demotionWarning() : int
      {
         return this._1450351653demotionWarning;
      }
      
      public function set playerOrTeamId(param1:String) : void
      {
         var _loc2_:Object = this._1413577244playerOrTeamId;
         if(_loc2_ !== param1)
         {
            this._1413577244playerOrTeamId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"playerOrTeamId",_loc2_,param1));
         }
      }
      
      public function set tier(param1:String) : void
      {
         var _loc2_:Object = this._3559906tier;
         if(_loc2_ !== param1)
         {
            this._3559906tier = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"tier",_loc2_,param1));
         }
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function set displayDecayWarning(param1:Boolean) : void
      {
         var _loc2_:Object = this._1266140260displayDecayWarning;
         if(_loc2_ !== param1)
         {
            this._1266140260displayDecayWarning = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"displayDecayWarning",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get playerOrTeamName() : String
      {
         return this._1238215500playerOrTeamName;
      }
      
      [Bindable(event="propertyChange")]
      public function get veteran() : Boolean
      {
         return this._353046207veteran;
      }
      
      public function set timeUntilDecay(param1:Number) : void
      {
         var _loc2_:Object = this._2087393879timeUntilDecay;
         if(_loc2_ !== param1)
         {
            this._2087393879timeUntilDecay = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"timeUntilDecay",_loc2_,param1));
         }
      }
      
      public function set leaguePointsDelta(param1:Number) : void
      {
         var _loc2_:Object = this._1540458778leaguePointsDelta;
         if(_loc2_ !== param1)
         {
            this._1540458778leaguePointsDelta = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"leaguePointsDelta",_loc2_,param1));
         }
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
      
      public function set rank(param1:String) : void
      {
         var _loc2_:Object = this._3492908rank;
         if(_loc2_ !== param1)
         {
            this._3492908rank = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rank",_loc2_,param1));
         }
      }
      
      public function set demotionWarning(param1:int) : void
      {
         var _loc2_:Object = this._1450351653demotionWarning;
         if(_loc2_ !== param1)
         {
            this._1450351653demotionWarning = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"demotionWarning",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get leagueName() : String
      {
         return this._4886874leagueName;
      }
      
      public function set hotStreak(param1:Boolean) : void
      {
         var _loc2_:Object = this._755195349hotStreak;
         if(_loc2_ !== param1)
         {
            this._755195349hotStreak = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"hotStreak",_loc2_,param1));
         }
      }
      
      public function set freshBlood(param1:Boolean) : void
      {
         var _loc2_:Object = this._800282260freshBlood;
         if(_loc2_ !== param1)
         {
            this._800282260freshBlood = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"freshBlood",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get tier() : String
      {
         return this._3559906tier;
      }
      
      public function set inactive(param1:Boolean) : void
      {
         var _loc2_:Object = this._24665195inactive;
         if(_loc2_ !== param1)
         {
            this._24665195inactive = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"inactive",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get leaguePointsDelta() : Number
      {
         return this._1540458778leaguePointsDelta;
      }
      
      [Bindable(event="propertyChange")]
      public function get queueType() : String
      {
         return this._1739445269queueType;
      }
      
      [Bindable(event="propertyChange")]
      public function get freshBlood() : Boolean
      {
         return this._800282260freshBlood;
      }
      
      public function set leaguePoints(param1:int) : void
      {
         var _loc2_:Object = this._471399410leaguePoints;
         if(_loc2_ !== param1)
         {
            this._471399410leaguePoints = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"leaguePoints",_loc2_,param1));
         }
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      [Bindable(event="propertyChange")]
      public function get leaguePoints() : int
      {
         return this._471399410leaguePoints;
      }
      
      public function set timeLastDecayMessageShown(param1:Number) : void
      {
         var _loc2_:Object = this._481870177timeLastDecayMessageShown;
         if(_loc2_ !== param1)
         {
            this._481870177timeLastDecayMessageShown = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"timeLastDecayMessageShown",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get displayDecayWarning() : Boolean
      {
         return this._1266140260displayDecayWarning;
      }
      
      public function set veteran(param1:Boolean) : void
      {
         var _loc2_:Object = this._353046207veteran;
         if(_loc2_ !== param1)
         {
            this._353046207veteran = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"veteran",_loc2_,param1));
         }
      }
   }
}

