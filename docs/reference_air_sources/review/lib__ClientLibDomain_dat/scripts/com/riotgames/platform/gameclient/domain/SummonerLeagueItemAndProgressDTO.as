package com.riotgames.platform.gameclient.domain
{
   import com.riotgames.platform.gameclient.domain.game.QueueType;
   import com.riotgames.platform.gameclient.domain.systemstates.TeamRewardQaulificationVO;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.leagues.client.dto.SummonerLeagueItemAndProgressDTO")]
   public class SummonerLeagueItemAndProgressDTO implements IEventDispatcher
   {
      
      private var _1496064502summonerRewards:SummonerLeagueRewardsDTO;
      
      private var _806526808highestTierParticipantId:String;
      
      private var _109060581highestTierQueueType:String;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _445873910summonerLeagues:ArrayCollection;
      
      public function SummonerLeagueItemAndProgressDTO()
      {
         super();
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function set summonerRewards(param1:SummonerLeagueRewardsDTO) : void
      {
         var _loc2_:Object = this._1496064502summonerRewards;
         if(_loc2_ !== param1)
         {
            this._1496064502summonerRewards = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerRewards",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get summonerRewards() : SummonerLeagueRewardsDTO
      {
         return this._1496064502summonerRewards;
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function set highestTierQueueType(param1:String) : void
      {
         var _loc2_:Object = this._109060581highestTierQueueType;
         if(_loc2_ !== param1)
         {
            this._109060581highestTierQueueType = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"highestTierQueueType",_loc2_,param1));
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function set highestTierParticipantId(param1:String) : void
      {
         var _loc2_:Object = this._806526808highestTierParticipantId;
         if(_loc2_ !== param1)
         {
            this._806526808highestTierParticipantId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"highestTierParticipantId",_loc2_,param1));
         }
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      [Bindable(event="propertyChange")]
      public function get highestTierQueueType() : String
      {
         return this._109060581highestTierQueueType;
      }
      
      public function getIfQualifiedForTeamRewards() : Object
      {
         var _loc2_:SummonerLeagueItemDTO = null;
         var _loc3_:TeamRewardQaulificationVO = null;
         var _loc1_:Object = {};
         for each(_loc2_ in this.summonerLeagues)
         {
            if(_loc2_.queueType == QueueType.RANKED_TEAM_5x5 || _loc2_.queueType == QueueType.RANKED_TEAM_3x3)
            {
               _loc3_ = new TeamRewardQaulificationVO();
               _loc3_.qualifiedTierReward = _loc2_.qualifiedTierReward;
               _loc3_.gameWinForReward = _loc2_.gameWinForReward;
               _loc1_[_loc2_.queueType + _loc2_.playerOrTeamId] = _loc3_;
            }
         }
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get highestTierParticipantId() : String
      {
         return this._806526808highestTierParticipantId;
      }
      
      public function set summonerLeagues(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._445873910summonerLeagues;
         if(_loc2_ !== param1)
         {
            this._445873910summonerLeagues = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerLeagues",_loc2_,param1));
         }
      }
      
      public function getHighestTier() : String
      {
         var _loc2_:SummonerLeagueItemDTO = null;
         var _loc1_:String = Summoner.TIER_UNRANKED;
         for each(_loc2_ in this.summonerLeagues)
         {
            if(_loc2_.playerOrTeamId == this.highestTierParticipantId && _loc2_.queueType == this.highestTierQueueType && _loc2_.qualifiedTierReward == true)
            {
               _loc1_ = _loc2_.tier;
            }
         }
         return _loc1_;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get summonerLeagues() : ArrayCollection
      {
         return this._445873910summonerLeagues;
      }
      
      public function getDemotionWarningLevels() : Object
      {
         var _loc2_:SummonerLeagueItemDTO = null;
         var _loc1_:Object = {};
         for each(_loc2_ in this.summonerLeagues)
         {
            _loc1_[_loc2_.queueType + _loc2_.playerOrTeamId] = _loc2_.demotionWarning;
         }
         return _loc1_;
      }
   }
}

