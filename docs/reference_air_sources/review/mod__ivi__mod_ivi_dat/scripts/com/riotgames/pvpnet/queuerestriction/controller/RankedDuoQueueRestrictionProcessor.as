package com.riotgames.pvpnet.queuerestriction.controller
{
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.gameclient.chat.RosterUtility;
   import com.riotgames.platform.gameclient.chat.controllers.PresenceController;
   import com.riotgames.platform.gameclient.chat.domain.PresenceStatusData;
   import com.riotgames.platform.gameclient.domain.LeagueItemDTO;
   import com.riotgames.platform.gameclient.domain.game.QueueType;
   import com.riotgames.platform.gameclient.domain.queuerestriction.QueueRestrictionCacheItem;
   import com.riotgames.pvpnet.queuerestriction.configurations.QueueRestrictionConfiguration;
   import com.riotgames.pvpnet.system.leagues.LeagueCache;
   import com.riotgames.pvpnet.system.leagues.LeagueRank;
   import com.riotgames.pvpnet.system.leagues.LeagueTier;
   import org.igniterealtime.xiff.data.im.RosterItemVO;
   
   public class RankedDuoQueueRestrictionProcessor
   {
      
      private var _cacheItem:QueueRestrictionCacheItem;
      
      private var _rosterItem:RosterItemVO;
      
      public function RankedDuoQueueRestrictionProcessor(param1:RosterItemVO, param2:QueueRestrictionCacheItem)
      {
         super();
         this._rosterItem = param1;
         this._cacheItem = param2;
      }
      
      private function getMyLeagueStanding() : LeagueItemDTO
      {
         var _loc1_:LeagueItemDTO = null;
         for each(_loc1_ in ServiceProxy.instance.leagueService.cache.myLeagueStandings)
         {
            if(_loc1_.queueType == QueueType.RANKED_SOLO_5x5)
            {
               return _loc1_;
            }
         }
         return null;
      }
      
      private function cacheItemUpdateToDate(param1:QueueRestrictionCacheItem, param2:Number, param3:Number) : Boolean
      {
         if(param1)
         {
            if(QueueRestrictionConfiguration.getRankedDuoQueueRestrictionMode() == "TIER")
            {
               return param1.getLastCheckedTier() == param2;
            }
            return param1.getLastCheckedTier() == param2 && param1.getLastCheckedRank() == param3;
         }
         return false;
      }
      
      private function getAbsoluteRank(param1:Number, param2:Number) : Number
      {
         return param1 * LeagueCache.TOTAL_RANKS + (LeagueCache.TOTAL_RANKS - 1 - param2);
      }
      
      private function eligibleToQueue(param1:Number, param2:Number, param3:Number, param4:Number) : Boolean
      {
         var _loc5_:Number = Number(LeagueCache.tierToValue(LeagueTier.MASTER));
         var _loc6_:Number = Number(LeagueCache.tierToValue(LeagueTier.CHALLENGER));
         if(param1 == _loc6_)
         {
            param1 = _loc5_;
         }
         if(param3 == _loc6_)
         {
            param3 = _loc5_;
         }
         if(QueueRestrictionConfiguration.getRankedDuoQueueRestrictionMode() == "TIER")
         {
            return Math.abs(param1 - param3) <= QueueRestrictionConfiguration.getRankedDuoQueueRestrictionMaxDelta();
         }
         return Math.abs(this.getAbsoluteRank(param1,param2) - this.getAbsoluteRank(param3,param4)) <= QueueRestrictionConfiguration.getRankedDuoQueueRestrictionMaxDelta();
      }
      
      public function process() : QueueRestrictionCacheItem
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:LeagueItemDTO = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:QueueRestrictionCacheItem = null;
         var _loc1_:PresenceStatusData = PresenceController.getPresenceData(this._rosterItem.status);
         if(_loc1_.rankedLeagueQueueType == QueueType.RANKED_SOLO_5x5)
         {
            _loc2_ = Number(LeagueCache.tierToValue(LeagueTier.valueOf(_loc1_.rankedLeagueTier)));
            _loc3_ = Number(LeagueCache.rankToValue(LeagueRank.valueOf(_loc1_.rankedLeagueDivision)));
            if(this.cacheItemUpdateToDate(this._cacheItem,_loc2_,_loc3_))
            {
               this._cacheItem.setIsRankedRestricted(_loc1_.rankedSoloRestricted);
               return this._cacheItem;
            }
            _loc4_ = this.getMyLeagueStanding();
            if(_loc4_)
            {
               _loc5_ = Number(LeagueCache.tierToValue(LeagueTier.valueOf(_loc4_.tier)));
               _loc6_ = Number(LeagueCache.rankToValue(LeagueRank.valueOf(_loc4_.rank)));
               _loc7_ = Number(RosterUtility.summonerIdFromJID(this._rosterItem.jid));
               _loc8_ = new QueueRestrictionCacheItem(_loc7_);
               _loc8_.setLastCheckedRank(_loc3_);
               _loc8_.setLastCheckedTier(_loc2_);
               _loc8_.setRankedDuoQueueEligibility(this.eligibleToQueue(_loc5_,_loc6_,_loc2_,_loc3_));
               _loc8_.setIsRankedRestricted(_loc1_.rankedSoloRestricted);
               return _loc8_;
            }
         }
         return null;
      }
   }
}

