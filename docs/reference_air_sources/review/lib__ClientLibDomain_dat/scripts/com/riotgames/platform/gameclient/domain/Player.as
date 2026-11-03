package com.riotgames.platform.gameclient.domain
{
   import flash.events.EventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   
   public class Player extends EventDispatcher
   {
      
      public static const STAT_TYPE_LOSSES:Number = 2;
      
      public static const STAT_TYPE_WINS:Number = 3;
      
      public static const STAT_TYPE_TOTAL_CHAMPION_KILLS:Number = 4;
      
      public static const STAT_TYPE_LEAVES:Number = 52;
      
      private var _accountSummary:PlayerParticipant;
      
      private var _100484757isYou:Boolean;
      
      private var _601231222currentTeam:uint;
      
      private var _baseSummoner:BaseSummoner;
      
      private var _1431766121champion:Champion;
      
      public function Player(param1:GameParticipant)
      {
         super();
         this._accountSummary = param1 as PlayerParticipant;
      }
      
      public function get accountSummary() : PlayerParticipant
      {
         return this._accountSummary;
      }
      
      private function set _5437135aggregatedLifetimeStatistics(param1:ArrayCollection) : void
      {
         if(this._accountSummary is PlayerParticipant)
         {
            PlayerParticipant(this._accountSummary).aggregatedLifetimeStatistics = param1;
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set summonerLevel(param1:Number) : void
      {
         var _loc2_:Object = this.summonerLevel;
         if(_loc2_ !== param1)
         {
            this._1545882922summonerLevel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerLevel",_loc2_,param1));
         }
      }
      
      public function set champion(param1:Champion) : void
      {
         var _loc2_:Object = this._1431766121champion;
         if(_loc2_ !== param1)
         {
            this._1431766121champion = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"champion",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get isYou() : Boolean
      {
         return this._100484757isYou;
      }
      
      public function get summonerLevel() : Number
      {
         return this._accountSummary is PlayerParticipant ? PlayerParticipant(this._accountSummary).summonerLevel : 0;
      }
      
      private function set _1545882922summonerLevel(param1:Number) : void
      {
         if(this._accountSummary is PlayerParticipant)
         {
            PlayerParticipant(this._accountSummary).summonerLevel = param1;
         }
      }
      
      private function set _873833279baseSummoner(param1:BaseSummoner) : void
      {
         this._baseSummoner = param1;
      }
      
      public function getAggregatedStatistic(param1:String, param2:Number = 0) : AggregatedStat
      {
         return this._accountSummary is PlayerParticipant ? PlayerParticipant(this._accountSummary).getAggregatedStatistic(param1,param2) : null;
      }
      
      public function get accountId() : Number
      {
         return this.accountSummary.accountId;
      }
      
      [Bindable(event="propertyChange")]
      public function get champion() : Champion
      {
         return this._1431766121champion;
      }
      
      public function set isYou(param1:Boolean) : void
      {
         var _loc2_:Object = this._100484757isYou;
         if(_loc2_ !== param1)
         {
            this._100484757isYou = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isYou",_loc2_,param1));
         }
      }
      
      override public function toString() : String
      {
         return this.accountId.toString();
      }
      
      public function get aggregatedLifetimeStatistics() : ArrayCollection
      {
         return this._accountSummary is PlayerParticipant ? PlayerParticipant(this._accountSummary).aggregatedLifetimeStatistics : new ArrayCollection();
      }
      
      [Bindable(event="propertyChange")]
      public function get currentTeam() : uint
      {
         return this._601231222currentTeam;
      }
      
      public function get summonerName() : String
      {
         return this.accountSummary.summonerName;
      }
      
      [Bindable(event="propertyChange")]
      public function set aggregatedLifetimeStatistics(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this.aggregatedLifetimeStatistics;
         if(_loc2_ !== param1)
         {
            this._5437135aggregatedLifetimeStatistics = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"aggregatedLifetimeStatistics",_loc2_,param1));
         }
      }
      
      public function set currentTeam(param1:uint) : void
      {
         var _loc2_:Object = this._601231222currentTeam;
         if(_loc2_ !== param1)
         {
            this._601231222currentTeam = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"currentTeam",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set baseSummoner(param1:BaseSummoner) : void
      {
         var _loc2_:Object = this.baseSummoner;
         if(_loc2_ !== param1)
         {
            this._873833279baseSummoner = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"baseSummoner",_loc2_,param1));
         }
      }
      
      public function get baseSummoner() : BaseSummoner
      {
         return this._baseSummoner;
      }
   }
}

