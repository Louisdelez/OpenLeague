package com.riotgames.platform.gameclient.domain
{
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.game.PlayerParticipant")]
   public class PlayerParticipant extends GameParticipant
   {
      
      private var _1359356291profileIconId:int = -1;
      
      private var _summonerLevel:Number;
      
      private var _1827029976accountId:Number;
      
      private var _1946516291clientInSynch:Boolean;
      
      private var _80971529summonerId:Number;
      
      private var _lifetimeStatistics:ArrayCollection;
      
      public function PlayerParticipant()
      {
         super();
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
      
      [Bindable(event="propertyChange")]
      public function get summonerId() : Number
      {
         return this._80971529summonerId;
      }
      
      private function set _5437135aggregatedLifetimeStatistics(param1:ArrayCollection) : void
      {
         this._lifetimeStatistics = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function get clientInSynch() : Boolean
      {
         return this._1946516291clientInSynch;
      }
      
      public function set accountId(param1:Number) : void
      {
         var _loc2_:Object = this._1827029976accountId;
         if(_loc2_ !== param1)
         {
            this._1827029976accountId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"accountId",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      override public function set isMe(param1:Boolean) : void
      {
         var _loc2_:Object = this.isMe;
         if(_loc2_ !== param1)
         {
            this._3241058isMe = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isMe",_loc2_,param1));
         }
      }
      
      public function getAggregatedStatistic(param1:String, param2:Number = 0) : AggregatedStat
      {
         var _loc4_:AggregatedStat = null;
         var _loc3_:AggregatedStat = null;
         for each(_loc4_ in this.aggregatedLifetimeStatistics)
         {
            if(_loc4_.statType == param1 && _loc4_.championId == param2)
            {
               _loc3_ = _loc4_;
               break;
            }
         }
         return _loc3_;
      }
      
      public function set summonerId(param1:Number) : void
      {
         var _loc2_:Object = this._80971529summonerId;
         if(_loc2_ !== param1)
         {
            this._80971529summonerId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerId",_loc2_,param1));
         }
      }
      
      public function get summonerLevel() : Number
      {
         return isNaN(this._summonerLevel) ? 0 : this._summonerLevel;
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
      
      private function set _1545882922summonerLevel(param1:Number) : void
      {
         this._summonerLevel = isNaN(param1) ? 0 : param1;
      }
      
      public function set _2130075689isGameOwner(param1:Boolean) : void
      {
         this._isGameOwner = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function get accountId() : Number
      {
         return this._1827029976accountId;
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
      
      public function get aggregatedLifetimeStatistics() : ArrayCollection
      {
         return this._lifetimeStatistics;
      }
      
      public function set _3241058isMe(param1:Boolean) : void
      {
         this._isMe = param1;
      }
      
      [Bindable(event="propertyChange")]
      override public function set isGameOwner(param1:Boolean) : void
      {
         var _loc2_:Object = this.isGameOwner;
         if(_loc2_ !== param1)
         {
            this._2130075689isGameOwner = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isGameOwner",_loc2_,param1));
         }
      }
      
      public function set profileIconId(param1:int) : void
      {
         var _loc2_:Object = this._1359356291profileIconId;
         if(_loc2_ !== param1)
         {
            this._1359356291profileIconId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"profileIconId",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get profileIconId() : int
      {
         return this._1359356291profileIconId;
      }
      
      public function equals(param1:PlayerParticipant) : Boolean
      {
         return param1 == this || param1 != null && param1.accountId == this.accountId && param1.summonerName == this.summonerName && param1.pickMode == this.pickMode && param1.pickTurn == this.pickTurn && param1.clientInSynch == this.clientInSynch;
      }
   }
}

