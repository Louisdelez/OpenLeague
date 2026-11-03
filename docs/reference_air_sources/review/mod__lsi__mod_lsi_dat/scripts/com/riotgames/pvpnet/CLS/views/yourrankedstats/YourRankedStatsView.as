package com.riotgames.pvpnet.CLS.views.yourrankedstats
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import com.riotgames.platform.gameclient.domain.AggregatedStat;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.rankedTeams.Team;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamId;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamMemberInfo;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.CLS.commands.SummonerIconBulkRetrievalCommand;
   import com.riotgames.pvpnet.CLS.localeHelper.ILocaleHelper;
   import com.riotgames.pvpnet.CLS.managers.ILeagueSystemModuleNavigation;
   import com.riotgames.pvpnet.CLS.models.ListItemObjectModel;
   import com.riotgames.pvpnet.CLS.models.RankListViewModel;
   import com.riotgames.pvpnet.CLS.models.SummonerLeagueObjectModel;
   import com.riotgames.pvpnet.CLS.views.enums.QueueTypesEnum;
   import com.riotgames.pvpnet.CLS.views.helpers.ISummonerHelper;
   import com.riotgames.pvpnet.rankedteams.RankedTeamsProviderProxy;
   import com.riotgames.pvpnet.rankedteams.stats.TeamQueuePlayerStats;
   import com.riotgames.pvpnet.rankedteams.stats.TeamQueueStats;
   import com.riotgames.pvpnet.summonerprofile.ISummonerProfileProvider;
   import com.riotgames.pvpnet.system.leagues.LeagueRank;
   import com.riotgames.rust.components.text.AutoSizeTextFieldProxy;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import mx.collections.ArrayCollection;
   import mx.utils.ObjectUtil;
   
   public class YourRankedStatsView extends StatefulView
   {
      
      private static const NORMAL_LEAGUE_STATE:String = "default";
      
      private static const LOADING_STATE:String = "loading";
      
      private static const SERVICE_BUSY_STATE:String = "busy";
      
      private static const NB_TOP_PLAYERS:uint = 5;
      
      private var _title:TextFieldProxy;
      
      private var _errorText:TextFieldProxy;
      
      private var _rankedStatsButton:ButtonX;
      
      private var _retryLoadStatisticsButton:ButtonX;
      
      private var _teams:Array = [];
      
      private var _topPlayedItemRenderers:Vector.<TopPlayedItemRenderer>;
      
      private var _topFivePlayers:Vector.<ListItemObjectModel>;
      
      private var _leagueSystemModuleNavigation:ILeagueSystemModuleNavigation;
      
      private var _currentSummonerOrTeamName:String;
      
      private var _currentSummonerOrTeamId:String;
      
      private var _previousSummonerName:String;
      
      private var _previousSummonerOrTeamId:String;
      
      private var _currentQueueType:String;
      
      private var _currentTeam:Team;
      
      private var _currentTeamStats:Dictionary;
      
      private var _localeHelper:ILocaleHelper;
      
      private var _summonerHelper:ISummonerHelper;
      
      private var _viewingExternalPage:Boolean = false;
      
      public function YourRankedStatsView(param1:IContext, param2:MovieClip = null)
      {
         super(param1,param2);
      }
      
      override protected function initializeDependencies() : void
      {
         super.initializeDependencies();
         this._localeHelper = getDependency(ILocaleHelper);
         this._summonerHelper = getDependency(ISummonerHelper);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         ProviderLookup.getProvider(ISummonerProfileProvider,this.onSummonerProfileController);
         this._leagueSystemModuleNavigation = getDependency(ILeagueSystemModuleNavigation);
         this.registerSignals();
         var _loc1_:SpriteProxy = new SpriteProxy(this);
         setTimelineChildByName("headerBoard",_loc1_);
         this._title = new AutoSizeTextFieldProxy(this);
         _loc1_.setTimelineChildByName("headerTitle",this._title);
         this._errorText = new TextFieldProxy(this);
         setTimelineChildByName("errorText",this._errorText);
         this._rankedStatsButton = new ButtonX(this);
         setTimelineChildByName("statsButton",this._rankedStatsButton);
         var _loc2_:TextFieldProxy = new TextFieldProxy(this);
         this._rankedStatsButton.setTimelineChildByName("buttonText",_loc2_);
         this._rankedStatsButton.addEventListener(MouseEvent.CLICK,this.onRankedStatsClick);
         this._retryLoadStatisticsButton = new ButtonX(this);
         setTimelineChildByName("retryLink",this._retryLoadStatisticsButton);
         this._retryLoadStatisticsButton.addEventListener(MouseEvent.CLICK,this.onRetryLoadStatisticsClick);
         var _loc3_:TextFieldProxy = new TextFieldProxy(this);
         this._retryLoadStatisticsButton.setTimelineChildByName("linkText",_loc3_);
         _loc3_.setHtmlText(this._localeHelper.localeLookup("ERROR_top5_retry"));
         var _loc4_:SummonerChampsStats = new SummonerChampsStats(this,this._localeHelper.localeLookup("rswBestChampion"));
         setTimelineChildByName("bestChampionContainer",_loc4_);
         var _loc5_:SummonerChampsStats = new SummonerChampsStats(this,this._localeHelper.localeLookup("rswMostPlayed"));
         setTimelineChildByName("mostPlayedContainer",_loc5_);
         this._topPlayedItemRenderers = new Vector.<TopPlayedItemRenderer>();
         var _loc6_:uint = 0;
         while(_loc6_ < NB_TOP_PLAYERS)
         {
            this._topPlayedItemRenderers[_loc6_] = new TopPlayedItemRenderer(this);
            setTimelineChildByName("champ" + _loc6_,this._topPlayedItemRenderers[_loc6_]);
            _loc6_++;
         }
         this._rankedStatsButton.setEnabled(false);
         setCurrentState(NORMAL_LEAGUE_STATE);
      }
      
      private function onSummonerProfileController(param1:ISummonerProfileProvider) : void
      {
         this._summonerHelper.summonerProfileController = param1;
         this._summonerHelper.summonerProfileController.championStatsChanged.add(this.updateTopPlayedChampions);
         this._summonerHelper.summonerProfileController.serviceBusySignal.add(this.onServiceBusy);
      }
      
      public function setSeeMoreRankedStatsEnabled(param1:Boolean) : void
      {
         this._rankedStatsButton.setEnabled(param1);
      }
      
      private function onChallengerTierChange(param1:Vector.<ListItemObjectModel>) : void
      {
         this.resetView();
         if(param1 != null && param1.length > 0)
         {
            this.onRankRowSelected(param1[0],param1[0].isSelf,true);
         }
         else
         {
            this.setSeeMoreRankedStatsEnabled(false);
         }
      }
      
      private function _onLeagueChange(param1:SummonerLeagueObjectModel) : void
      {
         if(param1 != null)
         {
            this.resetView();
            this.onRankRowSelected(param1.elements.myRank,true,true);
         }
         else
         {
            this.setSeeMoreRankedStatsEnabled(false);
         }
      }
      
      private function registerSignals() : void
      {
         this._leagueSystemModuleNavigation.getOnLeagueSelectionUpdateSignal().add(this._onLeagueChange);
         this._leagueSystemModuleNavigation.getOnRankRowSelectedUpdateSignal().add(this.onRankRowSelected);
         this._leagueSystemModuleNavigation.getOnRankSelectionUpdateSignal().add(this.onRankButtonPressedSignal);
         this._leagueSystemModuleNavigation.getOnChallengerTierSelectionUpdateSignal().add(this.onChallengerTierChange);
         this._leagueSystemModuleNavigation.getOnViewProfilePressed().add(this.disableViewStatsButton);
      }
      
      private function disableViewStatsButton(param1:String, param2:String, param3:Boolean) : void
      {
         this.setSeeMoreRankedStatsEnabled(false);
         this._viewingExternalPage = true;
      }
      
      private function onRetryLoadStatisticsClick(param1:MouseEvent) : void
      {
         this.updateStatisticsPanel();
      }
      
      private function onRankRowSelected(param1:ListItemObjectModel, param2:Boolean = false, param3:Boolean = false) : void
      {
         setCurrentState(NORMAL_LEAGUE_STATE);
         this._previousSummonerName = this._currentSummonerOrTeamName;
         this._previousSummonerOrTeamId = this._currentSummonerOrTeamId;
         this._currentSummonerOrTeamName = param1.summonerName;
         this._currentSummonerOrTeamId = param1.playerOrTeamId;
         this._currentQueueType = QueueTypesEnum.INT_TO_QUEUES[param1.queueType];
         this.updateStatisticsPanel(param3);
      }
      
      private function updateStatisticsPanel(param1:Boolean = false) : void
      {
         var _loc2_:TeamId = null;
         this._viewingExternalPage = false;
         if(this._currentQueueType == QueueTypesEnum.INT_TO_QUEUES[QueueTypesEnum.QUEUE_TYPE_5V5] || this._currentQueueType == QueueTypesEnum.INT_TO_QUEUES[QueueTypesEnum.QUEUE_TYPE_3V3])
         {
            this._title.setText(this._localeHelper.localeLookup("rswTopFivePlayers"));
            this.setTopFiveChampionsVisibility(true);
            if(this._currentSummonerOrTeamId != this._previousSummonerOrTeamId || param1)
            {
               setCurrentState(LOADING_STATE);
               this.setSeeMoreRankedStatsEnabled(false);
               this.clearTopChampions();
               _loc2_ = new TeamId();
               _loc2_.fullId = this._currentSummonerOrTeamId;
               RankedTeamsProviderProxy.instance.updateTeamStatsView(_loc2_,this.onTeamDataRetrieved,this.onTeamStatsRetrieved);
            }
         }
         else
         {
            this._title.setText(this._localeHelper.localeLookup("rswTopFive"));
            this.setTopFiveChampionsVisibility(true);
            if(this._currentSummonerOrTeamName != this._previousSummonerName || param1)
            {
               setCurrentState(LOADING_STATE);
               this.setSeeMoreRankedStatsEnabled(false);
               this.clearTopChampions();
               this._retrieveSummonerStats();
            }
         }
      }
      
      private function onServiceBusy() : void
      {
         this.setCurrentState(SERVICE_BUSY_STATE);
      }
      
      private function onTeamDataRetrieved(param1:Team) : void
      {
         if(!param1)
         {
            return;
         }
         if(this._currentSummonerOrTeamId != param1.teamId.fullId)
         {
            return;
         }
         this._currentTeam = param1;
         this._teams.push(param1);
      }
      
      private function onTeamStatsRetrieved(param1:Dictionary) : void
      {
         var _loc4_:ListItemObjectModel = null;
         var _loc5_:TeamQueuePlayerStats = null;
         if(!param1)
         {
            return;
         }
         var _loc2_:TeamQueueStats = param1[this._currentQueueType];
         if(Boolean(!_loc2_) || Boolean(_loc2_ && _loc2_.teamName != this._currentSummonerOrTeamName) || this._viewingExternalPage)
         {
            this.setSeeMoreRankedStatsEnabled(false);
            return;
         }
         var _loc3_:SummonerIconBulkRetrievalCommand = new SummonerIconBulkRetrievalCommand();
         this._currentTeamStats = param1;
         this._topFivePlayers = new Vector.<ListItemObjectModel>();
         for each(_loc5_ in _loc2_.players)
         {
            _loc4_ = new ListItemObjectModel();
            _loc4_.id = _loc5_.playerId;
            _loc4_.playerOrTeamId = _loc5_.playerId.toString();
            _loc4_.summonerName = this.getPlayerName(_loc5_.playerId);
            _loc4_.wins = (_loc5_.getStat("TOTAL_SESSIONS_WON") as AggregatedStat).count;
            _loc4_.losses = (_loc5_.getStat("TOTAL_SESSIONS_LOST") as AggregatedStat).count;
            _loc3_.addLeagueListItemModelToLookup(_loc4_);
            if(_loc4_.summonerName)
            {
               this._topFivePlayers.push(_loc4_);
            }
         }
         this._topFivePlayers.sort(this.sortTopFivePlayers);
         _loc3_.executeAndCallback(this.updateTopFivePlayers);
      }
      
      private function updateTopFivePlayers() : void
      {
         var _loc2_:ListItemObjectModel = null;
         var _loc1_:int = this._topFivePlayers.length > NB_TOP_PLAYERS ? int(NB_TOP_PLAYERS) : int(this._topFivePlayers.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_)
         {
            _loc2_ = this._topFivePlayers[_loc3_];
            this._topPlayedItemRenderers[_loc3_].setPlayerFromId(_loc2_,_loc3_ * 150);
            _loc3_++;
         }
         setCurrentState(NORMAL_LEAGUE_STATE);
         this.setSeeMoreRankedStatsEnabled(true);
      }
      
      private function _retrieveSummonerStats() : void
      {
         this._summonerHelper.summonerProfileController.updateStatsBySummonerName(this._currentSummonerOrTeamName);
      }
      
      private function updateTopPlayedChampions() : void
      {
         var _loc4_:Champion = null;
         if(this._summonerHelper.summonerProfileController.statsSummoner.summonerId.toString() != this._currentSummonerOrTeamId)
         {
            return;
         }
         var _loc1_:ArrayCollection = this._summonerHelper.summonerProfileController.customSortedChampionList;
         var _loc2_:int = _loc1_.length > NB_TOP_PLAYERS ? int(NB_TOP_PLAYERS) : int(_loc1_.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = _loc1_[_loc3_];
            this._topPlayedItemRenderers[_loc3_].setChampionFromId(_loc4_.championId,_loc3_ * 150);
            _loc3_++;
         }
         setCurrentState(NORMAL_LEAGUE_STATE);
         this.setSeeMoreRankedStatsEnabled(true);
      }
      
      private function setTopFiveChampionsVisibility(param1:Boolean) : void
      {
         this._title.setVisible(param1);
         var _loc2_:uint = 0;
         while(_loc2_ < NB_TOP_PLAYERS)
         {
            this._topPlayedItemRenderers[_loc2_].setVisible(param1);
            _loc2_++;
         }
      }
      
      private function resetView() : void
      {
         setVisible(true);
         setCurrentState(NORMAL_LEAGUE_STATE);
         this.clearTopChampions();
      }
      
      private function clearTopChampions() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < NB_TOP_PLAYERS)
         {
            this._topPlayedItemRenderers[_loc1_].clearData();
            _loc1_++;
         }
      }
      
      private function onRankButtonPressedSignal(param1:RankListViewModel, param2:LeagueRank) : void
      {
         this.onRankRowSelected(param1.myRank,true);
      }
      
      private function onRankedStatsClick(param1:MouseEvent) : void
      {
         this._leagueSystemModuleNavigation.dispatchOnSeeMoreStatsPressed(this._currentSummonerOrTeamName,this._currentSummonerOrTeamId,this._currentQueueType);
      }
      
      private function sortTopFivePlayers(param1:ListItemObjectModel, param2:ListItemObjectModel) : int
      {
         if(param1.gamesPlayed < param2.gamesPlayed)
         {
            return 1;
         }
         if(param1.gamesPlayed > param2.gamesPlayed)
         {
            return -1;
         }
         if(param1.gamesPlayed == param2.gamesPlayed)
         {
            return ObjectUtil.stringCompare(param1.summonerName,param2.summonerName,true);
         }
         return 0;
      }
      
      private function getPlayerName(param1:int) : String
      {
         var _loc2_:Team = null;
         var _loc3_:TeamMemberInfo = null;
         loop0:
         for each(_loc2_ in this._teams)
         {
            var _loc6_:int = 0;
            var _loc7_:* = _loc2_.roster.memberList;
            do
            {
               for each(_loc3_ in _loc7_)
               {
               }
               continue loop0;
            }
            while(param1 != _loc3_.playerId);
            return _loc3_.playerName;
         }
         return null;
      }
   }
}

