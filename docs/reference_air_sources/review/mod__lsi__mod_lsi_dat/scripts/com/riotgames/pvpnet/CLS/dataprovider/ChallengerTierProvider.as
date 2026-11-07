package com.riotgames.pvpnet.CLS.dataprovider
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.gameclient.domain.LeagueItemDTO;
   import com.riotgames.platform.gameclient.domain.LeagueListDTO;
   import com.riotgames.platform.gameclient.services.CLSServicePlatform;
   import com.riotgames.pvpnet.CLS.models.LeagueSortUtils;
   import com.riotgames.pvpnet.CLS.models.ListItemObjectModel;
   import com.riotgames.pvpnet.CLS.views.enums.EmblemsStates;
   import com.riotgames.pvpnet.CLS.views.enums.QueueTypesEnum;
   import com.riotgames.pvpnet.CLS.views.enums.SummonerRelationshipEnum;
   import com.riotgames.pvpnet.system.leagues.LeagueRank;
   import com.riotgames.pvpnet.system.leagues.LeagueTier;
   import mx.rpc.events.ResultEvent;
   
   public class ChallengerTierProvider
   {
      
      private static const NUM_TOP_MASTERS_TO_RETRIEVE:int = 200;
      
      private var _challengerTier:Vector.<Vector.<ListItemObjectModel>>;
      
      private var _topMasters:Vector.<Vector.<ListItemObjectModel>>;
      
      private var _leagueService:CLSServicePlatform;
      
      private var _challengerTierMaxSize:Vector.<Number>;
      
      private var _apexCountdownUpdated:Signal;
      
      private var _updateApexCountdownMs:Number;
      
      public function ChallengerTierProvider(param1:CLSServicePlatform)
      {
         super();
         this._apexCountdownUpdated = new Signal();
         this._leagueService = param1;
         this._challengerTier = new Vector.<Vector.<ListItemObjectModel>>();
         this._topMasters = new Vector.<Vector.<ListItemObjectModel>>();
         this._challengerTierMaxSize = new Vector.<Number>();
         var _loc2_:uint = 0;
         while(_loc2_ < QueueTypesEnum.QUEUE_TYPE_TOTAL)
         {
            this._challengerTier[_loc2_] = new Vector.<ListItemObjectModel>();
            this._topMasters[_loc2_] = new Vector.<ListItemObjectModel>();
            this._challengerTierMaxSize[_loc2_] = NaN;
            _loc2_++;
         }
      }
      
      public function updateChallengerLeagues() : void
      {
         this._leagueService.getChallengerLeague("RANKED_SOLO_5x5",this.onGetChallenger);
         this._leagueService.getChallengerLeague("RANKED_TEAM_5x5",this.onGetChallenger);
         this._leagueService.getChallengerLeague("RANKED_TEAM_3x3",this.onGetChallenger);
         this._leagueService.getMasterLeagueTopX("RANKED_SOLO_5x5",NUM_TOP_MASTERS_TO_RETRIEVE,this.onGetTopMaster);
         this._leagueService.getMasterLeagueTopX("RANKED_TEAM_5x5",NUM_TOP_MASTERS_TO_RETRIEVE,this.onGetTopMaster);
         this._leagueService.getMasterLeagueTopX("RANKED_TEAM_3x3",NUM_TOP_MASTERS_TO_RETRIEVE,this.onGetTopMaster);
      }
      
      private function onGetChallenger(param1:ResultEvent) : void
      {
         var _loc2_:LeagueListDTO = null;
         if(param1)
         {
            _loc2_ = param1.result as LeagueListDTO;
            if(_loc2_)
            {
               this.updateChallenger(_loc2_);
            }
         }
      }
      
      private function onGetTopMaster(param1:ResultEvent) : void
      {
         var _loc2_:LeagueListDTO = null;
         if(param1)
         {
            _loc2_ = param1.result as LeagueListDTO;
            if(_loc2_)
            {
               this.updateTopMaster(_loc2_);
            }
         }
      }
      
      private function updateChallenger(param1:LeagueListDTO) : void
      {
         var _loc4_:LeagueItemDTO = null;
         this.updateApexCountdown(param1);
         var _loc2_:uint = uint(QueueTypesEnum.QUEUES[param1.queue]);
         this._challengerTierMaxSize[_loc2_] = param1.maxLeagueSize;
         var _loc3_:Vector.<ListItemObjectModel> = new Vector.<ListItemObjectModel>();
         for each(_loc4_ in param1.entries)
         {
            _loc3_.push(this.getChallengerEntry(_loc2_,_loc4_));
         }
         _loc3_ = _loc3_.sort(LeagueSortUtils.sortLeagueItemsHighestToLowest);
         this._challengerTier[_loc2_] = _loc3_;
      }
      
      private function updateTopMaster(param1:LeagueListDTO) : void
      {
         var _loc4_:LeagueItemDTO = null;
         this.updateApexCountdown(param1);
         var _loc2_:uint = uint(QueueTypesEnum.QUEUES[param1.queue]);
         var _loc3_:Vector.<ListItemObjectModel> = new Vector.<ListItemObjectModel>();
         for each(_loc4_ in param1.entries)
         {
            _loc3_.push(this.getChallengerEntry(_loc2_,_loc4_));
         }
         _loc3_ = _loc3_.sort(LeagueSortUtils.sortLeagueItemsHighestToLowest);
         this._topMasters[_loc2_] = _loc3_;
      }
      
      public function updatePromotionDemotionStatuses() : void
      {
         this.updatePromotionDemotionStatusForQueue(QueueTypesEnum.QUEUES["RANKED_SOLO_5x5"]);
         this.updatePromotionDemotionStatusForQueue(QueueTypesEnum.QUEUES["RANKED_TEAM_5x5"]);
         this.updatePromotionDemotionStatusForQueue(QueueTypesEnum.QUEUES["RANKED_TEAM_3x3"]);
      }
      
      private function updatePromotionDemotionStatusForQueue(param1:uint) : void
      {
         var _loc2_:Vector.<ListItemObjectModel> = this.challengerTier[param1];
         var _loc3_:Vector.<ListItemObjectModel> = this.topMasters[param1];
         var _loc4_:Number = this._challengerTierMaxSize[param1];
         this.updatePromotionDemotionStatusInternal(_loc2_,_loc3_,_loc4_);
      }
      
      private function updatePromotionDemotionStatusInternal(param1:Vector.<ListItemObjectModel>, param2:Vector.<ListItemObjectModel>, param3:Number) : void
      {
         var _loc6_:ListItemObjectModel = null;
         if(!param3)
         {
            return;
         }
         if(!param1)
         {
            return;
         }
         if(!param2 || param2.length == 0)
         {
            return;
         }
         var _loc4_:Vector.<ListItemObjectModel> = param1.concat(param2).sort(LeagueSortUtils.sortLeagueItemsHighestToLowest);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_.length)
         {
            _loc6_ = _loc4_[_loc5_];
            if(_loc5_ < param3)
            {
               if(_loc6_.tier != LeagueTier.CHALLENGER)
               {
                  _loc6_.apexPendingPromotion = true;
                  _loc6_.apexPendingDemotion = false;
               }
               else
               {
                  _loc6_.apexPendingPromotion = false;
                  _loc6_.apexPendingDemotion = false;
               }
            }
            else if(_loc6_.tier == LeagueTier.CHALLENGER)
            {
               _loc6_.apexPendingPromotion = false;
               _loc6_.apexPendingDemotion = true;
            }
            else
            {
               _loc6_.apexPendingPromotion = false;
               _loc6_.apexPendingDemotion = false;
            }
            _loc5_++;
         }
      }
      
      private function getChallengerEntry(param1:uint, param2:LeagueItemDTO) : ListItemObjectModel
      {
         var _loc3_:ListItemObjectModel = new ListItemObjectModel();
         _loc3_.emblems = Vector.<String>([]);
         _loc3_.id = uint(param2.playerOrTeamId);
         _loc3_.summonerName = param2.playerOrTeamName;
         if(_loc3_.summonerName == Session.instance.summoner.name)
         {
            _loc3_.relationship = SummonerRelationshipEnum.SELF_RELATIONSHIP;
         }
         else
         {
            _loc3_.relationship = SummonerRelationshipEnum.DEFAULT_RELATIONSHIP;
         }
         _loc3_.tier = LeagueTier.valueOf(param2.tier);
         _loc3_.rank = LeagueRank.valueOf(param2.rank);
         _loc3_.points = param2.leaguePoints;
         _loc3_.wins = param2.wins;
         _loc3_.losses = param2.losses;
         _loc3_.previousPosition = param2.previousDayLeaguePosition;
         _loc3_.isInactive = param2.inactive;
         _loc3_.emblems = this.fillEmblems(param2);
         _loc3_.teamName = _loc3_.summonerName;
         _loc3_.queueType = param1;
         _loc3_.playerOrTeamId = param2.playerOrTeamId;
         return _loc3_;
      }
      
      private function fillEmblems(param1:LeagueItemDTO) : Vector.<String>
      {
         var _loc2_:Vector.<String> = Vector.<String>([]);
         if(param1.hotStreak)
         {
            _loc2_.push(EmblemsStates.HOTSTEAK_EMBLEM_STATE);
         }
         if(param1.veteran)
         {
            _loc2_.push(EmblemsStates.VETERAN_EMBLEM_STATE);
         }
         if(param1.freshBlood)
         {
            _loc2_.push(EmblemsStates.FRESHBLOOD_EMBLEM_STATE);
         }
         return _loc2_;
      }
      
      public function get challengerTier() : Vector.<Vector.<ListItemObjectModel>>
      {
         return this._challengerTier;
      }
      
      public function get topMasters() : Vector.<Vector.<ListItemObjectModel>>
      {
         return this._topMasters;
      }
      
      public function updateMasterSpecificData(param1:Vector.<ListItemObjectModel>, param2:uint) : void
      {
         var _loc3_:Vector.<ListItemObjectModel> = this.challengerTier[param2];
         var _loc4_:Number = this._challengerTierMaxSize[param2];
         this.updatePromotionDemotionStatusInternal(_loc3_,param1,_loc4_);
      }
      
      public function challengerTierMaxSize(param1:uint) : Number
      {
         return this._challengerTierMaxSize[param1];
      }
      
      public function getUpdateApexCountdownMs() : Number
      {
         return this._updateApexCountdownMs;
      }
      
      private function updateApexCountdown(param1:LeagueListDTO) : void
      {
         if(param1.nextApexUpdate)
         {
            this._updateApexCountdownMs = param1.nextApexUpdate;
            this._apexCountdownUpdated.dispatch(param1.nextApexUpdate);
         }
      }
      
      public function getApexCountdownUpdated() : ISignal
      {
         return this._apexCountdownUpdated;
      }
   }
}

