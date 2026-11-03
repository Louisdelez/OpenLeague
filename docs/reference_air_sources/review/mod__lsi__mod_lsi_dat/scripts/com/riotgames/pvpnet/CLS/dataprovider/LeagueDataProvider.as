package com.riotgames.pvpnet.CLS.dataprovider
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.provider.ILeagueDataProvider;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.domain.LeagueItemDTO;
   import com.riotgames.platform.gameclient.domain.LeagueListDTO;
   import com.riotgames.platform.gameclient.domain.SummonerLeagueItemAndProgressDTO;
   import com.riotgames.platform.gameclient.domain.SummonerLeagueRewardsDTO;
   import com.riotgames.platform.gameclient.domain.SummonerLeaguesDTO;
   import com.riotgames.platform.gameclient.services.CLSServicePlatform;
   import com.riotgames.pvpnet.CLS.commands.SummonerIconBulkRetrievalCommand;
   import com.riotgames.pvpnet.CLS.models.LeagueSortUtils;
   import com.riotgames.pvpnet.CLS.models.ListItemObjectModel;
   import com.riotgames.pvpnet.CLS.models.RankListViewModel;
   import com.riotgames.pvpnet.CLS.models.SummonerLeagueObjectModel;
   import com.riotgames.pvpnet.CLS.models.SummonerObjectModel;
   import com.riotgames.pvpnet.CLS.views.enums.EmblemsStates;
   import com.riotgames.pvpnet.CLS.views.enums.QueueTypesEnum;
   import com.riotgames.pvpnet.CLS.views.enums.SummonerRelationshipEnum;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.leagues.LeagueCache;
   import com.riotgames.pvpnet.system.leagues.LeagueRank;
   import com.riotgames.pvpnet.system.leagues.LeagueSortOrder;
   import com.riotgames.pvpnet.system.leagues.LeagueTier;
   import mx.collections.ArrayCollection;
   import mx.rpc.events.ResultEvent;
   
   public class LeagueDataProvider implements ILeagueDataProvider, ILeagueDataProviderLocal
   {
      
      private var _rankListViewModel:RankListViewModel;
      
      private var _summoner:SummonerObjectModel;
      
      private var _leagueService:CLSServicePlatform;
      
      private var _externalCall:Boolean;
      
      private var _chatController:ChatController;
      
      private var _challengerTierProvider:ChallengerTierProvider;
      
      private var _leaguesUpdateComplete:Signal;
      
      private var _seasonRewardsUpdateComplete:Signal;
      
      private var _seasonRewardsEnabled:Boolean;
      
      private var _teamReward:int = 0;
      
      private var _teamRewardLevel:int = 0;
      
      private var _tierReward:String = "UNRANKED";
      
      private var _self:Boolean = false;
      
      private var _selfRewardIcon:int = -1;
      
      public function LeagueDataProvider()
      {
         super();
         this._leagueService = ServiceProxy.instance.leagueService;
         this._leaguesUpdateComplete = new Signal();
         this._seasonRewardsUpdateComplete = new Signal();
         this._externalCall = false;
         this._challengerTierProvider = new ChallengerTierProvider(this._leagueService);
         this._selfRewardIcon = this.determineSelfRewardIcon();
      }
      
      private static function fillEmblems(param1:LeagueItemDTO) : Vector.<String>
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
      
      public function getLeaguesFromSummoner(param1:Number, param2:Boolean) : void
      {
         this._externalCall = true;
         this._challengerTierProvider.updateChallengerLeagues();
         this._self = param2;
         if(this._self)
         {
            this._leagueService.getAllMyLeagues(this.createDataProviders);
         }
         else
         {
            this._leagueService.cache.setTeamQualifications(null);
            this._leagueService.getAllLeaguesForPlayer(param1,this.createDataProviders);
         }
      }
      
      public function setSeasonRewardsEarned(param1:SummonerLeagueItemAndProgressDTO) : void
      {
         if(param1.summonerRewards == null)
         {
            param1.summonerRewards = new SummonerLeagueRewardsDTO();
         }
         this._teamRewardLevel = param1.summonerRewards.rewardLevel;
         this._teamReward = param1.summonerRewards.points;
         this._tierReward = param1.getHighestTier();
         this._leagueService.cache.setTeamQualifications(param1.getIfQualifiedForTeamRewards());
         this._leagueService.cache.setDemotionWarningsMap(param1.getDemotionWarningLevels());
         this._selfRewardIcon = this.determineSelfRewardIcon();
         this._seasonRewardsUpdateComplete.dispatch();
      }
      
      public function getSeasonRewardsUpdateComplete() : ISignal
      {
         return this._seasonRewardsUpdateComplete;
      }
      
      public function getApexCountdownUpdated() : ISignal
      {
         return this._challengerTierProvider.getApexCountdownUpdated();
      }
      
      public function getUpdateApexCountdownMs() : Number
      {
         return this._challengerTierProvider.getUpdateApexCountdownMs();
      }
      
      private function determineSelfRewardIcon() : int
      {
         if(Session.instance.summoner)
         {
            return LeagueCache.getIconRewardForTier(LeagueTier.valueOf(Session.instance.summoner.previousSeasonHighestTier));
         }
         return -1;
      }
      
      private function createDataProviders(param1:ResultEvent) : void
      {
         var _loc4_:RankListViewModel = null;
         var _loc5_:ArrayCollection = null;
         var _loc7_:LeagueListDTO = null;
         var _loc9_:SummonerLeagueObjectModel = null;
         var _loc10_:String = null;
         var _loc11_:uint = 0;
         var _loc12_:String = null;
         var _loc13_:uint = 0;
         var _loc14_:Boolean = false;
         var _loc15_:Boolean = false;
         var _loc16_:Boolean = false;
         var _loc17_:LeagueItemDTO = null;
         var _loc18_:uint = 0;
         var _loc19_:ListItemObjectModel = null;
         var _loc20_:LeagueRank = null;
         var _loc21_:Vector.<ListItemObjectModel> = null;
         var _loc22_:int = 0;
         var _loc23_:int = 0;
         var _loc2_:Vector.<SummonerLeagueObjectModel> = new Vector.<SummonerLeagueObjectModel>();
         var _loc3_:SummonerLeaguesDTO = param1.result as SummonerLeaguesDTO;
         var _loc6_:SummonerIconBulkRetrievalCommand = new SummonerIconBulkRetrievalCommand();
         this._leagueService.cache.clearData();
         if(this._self && this._seasonRewardsEnabled)
         {
            this._leagueService.getMyLeaguePositionsAndProgress(this.onGetMyHighestLeaguePosition);
         }
         if(_loc3_ == null || _loc3_.summonerLeagues == null)
         {
            return;
         }
         var _loc8_:uint = 0;
         while(_loc8_ < _loc3_.summonerLeagues.length)
         {
            _loc7_ = _loc3_.summonerLeagues[_loc8_];
            _loc4_ = new RankListViewModel();
            _loc5_ = _loc7_.entries;
            _loc10_ = _loc7_.requestorsName;
            _loc11_ = 0;
            _loc12_ = _loc7_.requestorsName;
            _loc13_ = 0;
            _loc14_ = !ClientConfig.instance.teamServiceEnabled;
            _loc15_ = _loc7_.queue == "RANKED_TEAM_5x5" || _loc7_.queue == "RANKED_TEAM_3x3";
            _loc16_ = _loc14_ && !_loc15_ || !_loc14_;
            if(_loc16_)
            {
               _loc18_ = 0;
               for(; _loc18_ < _loc5_.length; _loc18_++)
               {
                  _loc19_ = new ListItemObjectModel();
                  _loc17_ = _loc5_[_loc18_];
                  _loc19_.emblems = Vector.<String>([]);
                  _loc19_.id = uint(_loc17_.playerOrTeamId);
                  _loc19_.summonerName = _loc17_.playerOrTeamName;
                  _loc19_.playerOrTeamId = _loc17_.playerOrTeamId;
                  if(this._chatController)
                  {
                     _loc19_.isFriend = this._chatController.isSummonerBuddy(_loc19_.summonerName);
                  }
                  _loc19_.tier = LeagueTier.valueOf(_loc17_.tier);
                  _loc19_.rank = LeagueRank.valueOf(_loc17_.rank);
                  _loc19_.points = _loc17_.leaguePoints >= 0 || _loc19_.summonerName == Session.instance.summoner.name ? int(_loc17_.leaguePoints) : 0;
                  _loc19_.wins = _loc17_.wins;
                  _loc19_.losses = _loc17_.losses;
                  _loc19_.previousPosition = _loc17_.previousDayLeaguePosition;
                  _loc19_.isInactive = _loc17_.inactive;
                  if(_loc17_.playerOrTeamName == _loc10_)
                  {
                     _loc11_ = _loc13_;
                  }
                  else if(Boolean(_loc17_.inactive) && !_loc19_.tier.isApex())
                  {
                     continue;
                  }
                  _loc19_.emblems = fillEmblems(_loc17_);
                  _loc19_.miniSeriesResults = LeagueDataProviderUtils.fillMiniSeriesGames(_loc17_,LeagueRank.valueOf(_loc7_.requestorsRank));
                  if(_loc17_.miniSeries)
                  {
                     _loc19_.miniSeriesWins = _loc17_.miniSeries.wins;
                     _loc19_.miniSeriesLosses = _loc17_.miniSeries.losses;
                  }
                  _loc19_.teamName = _loc19_.summonerName;
                  _loc19_.queueType = QueueTypesEnum.QUEUES[_loc7_.queue];
                  _loc19_.queueLabel = QueueTypesEnum.QUEUES_LABEL[_loc7_.queue];
                  if(_loc17_.playerOrTeamName == Session.instance.summoner.name)
                  {
                     _loc19_.relationship = SummonerRelationshipEnum.SELF_RELATIONSHIP;
                  }
                  else
                  {
                     _loc19_.relationship = SummonerRelationshipEnum.DEFAULT_RELATIONSHIP;
                  }
                  _loc4_.allRankListElements.push(_loc19_);
                  if(!_loc19_.isTeam)
                  {
                     _loc6_.addLeagueListItemModelToLookup(_loc19_);
                  }
                  _loc13_++;
               }
               if(_loc4_.allRankListElements.length > _loc11_)
               {
                  _loc4_.myRank = _loc4_.allRankListElements[_loc11_];
               }
               else
               {
                  _loc4_.myRank = new ListItemObjectModel();
               }
               _loc4_.leagueName = _loc7_.name;
               _loc2_.push(new SummonerLeagueObjectModel(_loc4_.leagueName,LeagueTier.valueOf(_loc7_.tier),LeagueRank.valueOf(_loc7_.requestorsRank),_loc4_));
               this._leagueService.cache.addLeague(_loc7_);
            }
            _loc8_++;
         }
         _loc6_.execute();
         this.loadChallengerTierSummonerIcons();
         this.sortLeagueElements(_loc2_);
         if(_loc2_.length > 0)
         {
            this._rankListViewModel = _loc2_[0].elements;
         }
         for each(_loc9_ in _loc2_)
         {
            if(_loc9_.elements)
            {
               if(_loc9_.tier != LeagueTier.CHALLENGER)
               {
                  for each(_loc20_ in LeagueRank.valuesFor(_loc9_.tier,LeagueSortOrder.DESCENDING))
                  {
                     _loc21_ = _loc9_.elements.getListFromRank(_loc20_);
                     if(_loc21_ != null)
                     {
                        _loc21_.sort(LeagueSortUtils.sortLeagueItemsHighestToLowest);
                        _loc22_ = 0;
                        _loc23_ = 0;
                        while(_loc23_ < _loc21_.length)
                        {
                           if(!_loc21_[_loc23_].isInactive || Boolean(_loc21_[_loc23_].tier.isApex()))
                           {
                              _loc22_++;
                           }
                           _loc21_[_loc23_].position = _loc22_;
                           _loc23_++;
                        }
                     }
                  }
               }
            }
         }
         _loc2_ = _loc2_.sort(this.sortLeaguesByQueueType);
         this.resetLeagueIds(_loc2_);
         for each(_loc9_ in _loc2_)
         {
            if(_loc9_.tier == LeagueTier.MASTER)
            {
               this._challengerTierProvider.updateMasterSpecificData(_loc9_.elements.allRankListElements,_loc9_.queueType);
            }
         }
         this._summoner = new SummonerObjectModel(_loc12_,_loc2_);
         if(this._externalCall)
         {
            this._externalCall = false;
            this._leaguesUpdateComplete.dispatch();
         }
      }
      
      private function onGetMyHighestLeaguePosition(param1:ResultEvent) : void
      {
         var _loc2_:SummonerLeagueItemAndProgressDTO = null;
         if(param1.result is SummonerLeagueItemAndProgressDTO)
         {
            _loc2_ = param1.result as SummonerLeagueItemAndProgressDTO;
            this.setSeasonRewardsEarned(_loc2_);
         }
      }
      
      private function loadChallengerTierSummonerIcons() : void
      {
         var _loc2_:Vector.<ListItemObjectModel> = null;
         var _loc3_:ListItemObjectModel = null;
         var _loc1_:SummonerIconBulkRetrievalCommand = new SummonerIconBulkRetrievalCommand();
         for each(_loc2_ in this._challengerTierProvider.challengerTier)
         {
            for each(_loc3_ in _loc2_)
            {
               _loc1_.addLeagueListItemModelToLookup(_loc3_);
            }
         }
         _loc1_.execute();
      }
      
      private function resetLeagueIds(param1:Vector.<SummonerLeagueObjectModel>) : void
      {
         var _loc2_:uint = 0;
         while(_loc2_ < param1.length)
         {
            param1[_loc2_].id = _loc2_;
            _loc2_++;
         }
      }
      
      private function sortLeaguesByQueueType(param1:SummonerLeagueObjectModel, param2:SummonerLeagueObjectModel) : int
      {
         if(param1.queueType > param2.queueType)
         {
            return -1;
         }
         if(param1.queueType < param2.queueType)
         {
            return 1;
         }
         if(param1.tier.isBelow(param2.tier))
         {
            return -1;
         }
         if(param2.tier.isBelow(param1.tier))
         {
            return 1;
         }
         if(param1.teamName < param2.teamName)
         {
            return -1;
         }
         if(param1.teamName > param2.teamName)
         {
            return 1;
         }
         return param2.id - param1.id;
      }
      
      private function sortLeagueElements(param1:Vector.<SummonerLeagueObjectModel>) : void
      {
         var _loc2_:SummonerLeagueObjectModel = null;
         for each(_loc2_ in param1)
         {
            if(_loc2_.elements)
            {
               _loc2_.elements.allRankListElements = _loc2_.elements.allRankListElements.sort(LeagueSortUtils.sortLeagueItemsHighestToLowest);
               _loc2_.elements.organizeListElements();
            }
         }
      }
      
      public function get summoner() : SummonerObjectModel
      {
         return this._summoner;
      }
      
      public function get rankListViewModel() : RankListViewModel
      {
         return this._rankListViewModel;
      }
      
      public function get topMasters() : Vector.<Vector.<ListItemObjectModel>>
      {
         if(this._challengerTierProvider)
         {
            return this._challengerTierProvider.topMasters;
         }
         return null;
      }
      
      public function get challengerTier() : Vector.<Vector.<ListItemObjectModel>>
      {
         if(this._challengerTierProvider)
         {
            return this._challengerTierProvider.challengerTier;
         }
         return null;
      }
      
      public function updateApexPromotionDemotionStatuses() : void
      {
         if(this._challengerTierProvider)
         {
            this._challengerTierProvider.updatePromotionDemotionStatuses();
         }
      }
      
      public function challengerTierMaxSize(param1:uint) : Number
      {
         if(this._challengerTierProvider)
         {
            return this._challengerTierProvider.challengerTierMaxSize(param1);
         }
         return NaN;
      }
      
      public function get leagueService() : CLSServicePlatform
      {
         return this._leagueService;
      }
      
      public function get leaguesUpdateComplete() : Signal
      {
         return this._leaguesUpdateComplete;
      }
      
      public function set chatController(param1:ChatController) : void
      {
         this._chatController = param1;
      }
      
      public function get chatController() : ChatController
      {
         return this._chatController;
      }
      
      public function get teamReward() : int
      {
         return this._teamReward;
      }
      
      public function get tierReward() : String
      {
         return this._tierReward;
      }
      
      public function get teamRewardLevel() : int
      {
         return this._teamRewardLevel;
      }
      
      public function get self() : Boolean
      {
         return this._self;
      }
      
      public function get selfRewardIcon() : int
      {
         return this._selfRewardIcon;
      }
      
      public function get seasonRewardsEnabled() : Boolean
      {
         return this._seasonRewardsEnabled;
      }
      
      public function set seasonRewardsEnabled(param1:Boolean) : void
      {
         this._seasonRewardsEnabled = param1;
      }
   }
}

