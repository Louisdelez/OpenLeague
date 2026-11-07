package com.riotgames.platform.gameclient.domain.queuerestriction
{
   public class QueueRestrictionCacheItem
   {
      
      private var _lastCheckedRank:Number = -1;
      
      private var _summonerId:Number;
      
      private var _isRankedRestricted:Boolean = false;
      
      private var _lastCheckedTier:Number = -1;
      
      private var _rankedDuoQueueEligibility:Boolean = true;
      
      public function QueueRestrictionCacheItem(param1:Number)
      {
         super();
         this._summonerId = param1;
      }
      
      public function getIsRankedRestricted() : Boolean
      {
         return this._isRankedRestricted;
      }
      
      public function getLastCheckedRank() : Number
      {
         return this._lastCheckedRank;
      }
      
      public function setRankedDuoQueueEligibility(param1:Boolean) : void
      {
         this._rankedDuoQueueEligibility = param1;
      }
      
      public function setLastCheckedTier(param1:Number) : void
      {
         this._lastCheckedTier = param1;
      }
      
      public function setIsRankedRestricted(param1:Boolean) : *
      {
         this._isRankedRestricted = param1;
      }
      
      public function getRankedDuoQueueEligibility() : Boolean
      {
         return this._rankedDuoQueueEligibility;
      }
      
      public function setLastCheckedRank(param1:Number) : void
      {
         this._lastCheckedRank = param1;
      }
      
      public function getLastCheckedTier() : Number
      {
         return this._lastCheckedTier;
      }
      
      public function getSummonerId() : Number
      {
         return this._summonerId;
      }
   }
}

