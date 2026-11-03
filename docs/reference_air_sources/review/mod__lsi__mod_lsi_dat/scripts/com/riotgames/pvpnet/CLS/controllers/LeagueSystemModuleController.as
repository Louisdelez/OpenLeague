package com.riotgames.pvpnet.CLS.controllers
{
   import blix.context.IContext;
   import blix.signals.Signal;
   import com.riotgames.platform.gameclient.chat.IChatProvider;
   import com.riotgames.pvpnet.CLS.dataprovider.LeagueDataProvider;
   import com.riotgames.pvpnet.CLS.managers.ILeagueSystemModuleNavigation;
   import com.riotgames.pvpnet.CLS.models.ListItemObjectModel;
   import com.riotgames.pvpnet.CLS.models.SummonerLeagueObjectModel;
   import com.riotgames.pvpnet.system.leagues.LeagueRank;
   import com.riotgames.pvpnet.system.leagues.LeagueTier;
   
   public class LeagueSystemModuleController
   {
      
      private var _leagueSystemModuleContext:IContext;
      
      private var _leagueSystemModuleNavigation:ILeagueSystemModuleNavigation;
      
      private var _dataProvider:LeagueDataProvider;
      
      private var _currentLeagueId:uint;
      
      private var _currentRank:LeagueRank;
      
      private var _currentChallengerTierId:uint;
      
      private var _onChallengerTierMode:Boolean;
      
      private var _chat:IChatProvider;
      
      private var _lobbySignal:Signal;
      
      private var _statsSignal:Signal;
      
      private var _lastSelectedRankRowItem:uint;
      
      public function LeagueSystemModuleController(param1:IContext, param2:LeagueDataProvider, param3:Signal, param4:Signal, param5:IChatProvider = null)
      {
         super();
         this._leagueSystemModuleContext = param1;
         this._dataProvider = param2;
         this.registerSignals();
         this._onChallengerTierMode = true;
         this._currentLeagueId = 0;
         this._currentRank = LeagueRank.I;
         this._currentChallengerTierId = 0;
         this._chat = param5;
         this._lobbySignal = param3;
         this._statsSignal = param4;
         this.resetLastSelectedToDefault();
      }
      
      private function resetLastSelectedToDefault() : void
      {
         this._lastSelectedRankRowItem = uint.MAX_VALUE;
      }
      
      private function registerSignals() : void
      {
         this._leagueSystemModuleNavigation = this._leagueSystemModuleContext.getDependency(ILeagueSystemModuleNavigation);
         this._leagueSystemModuleNavigation.getOnAskRankInfoSignal().add(this.onAskRankInfo);
         this._leagueSystemModuleNavigation.getOnAskLeagueItemsSignal().add(this.onAskLeagueItems);
         this._leagueSystemModuleNavigation.getOnLeagueSelectionSignal().add(this.onLeagueChange);
         this._leagueSystemModuleNavigation.getOnRankSelectionSignal().add(this.onRankChange);
         this._leagueSystemModuleNavigation.getOnChallengerTierSelectionSignal().add(this.onChallengeTierChange);
         this._leagueSystemModuleNavigation.getOnRankRowSelectedSignal().add(this.onRankRowSelected);
         this._leagueSystemModuleNavigation.getOnAddFriendPressed().add(this.addSummonerAsFriend);
         this._leagueSystemModuleNavigation.getOnViewProfilePressed().add(this.viewSummonerProfile);
         this._leagueSystemModuleNavigation.getOnSeeMoreStatsPressed().add(this.viewMoreStats);
         this._leagueSystemModuleNavigation.getOnThirdPersonLeagueSelected().add(this.viewThirdPersonLeague);
         this._leagueSystemModuleNavigation.getAskCurrentSelectedRowId().add(this.onAskCurrentSelectedRow);
         this._dataProvider.leaguesUpdateComplete.add(this.leaguesUpdateComplete);
      }
      
      private function onAskCurrentSelectedRow() : void
      {
         this._leagueSystemModuleNavigation.dispatchCurrentSelectedRowIdUpdate(this._lastSelectedRankRowItem);
      }
      
      private function leaguesUpdateComplete() : void
      {
         this._currentLeagueId = 0;
         if(Boolean(this._dataProvider.summoner) && Boolean(this._dataProvider.summoner.leagues))
         {
            if(this._dataProvider.summoner.leagues.length > 0)
            {
               this._leagueSystemModuleNavigation.dispatchOnNoLeagueScreen(false);
               this._leagueSystemModuleNavigation.dispatchOnReceiveLeagueItemsSignal(this._dataProvider.summoner.leagues);
               this.sendNewLeagueSelection(0);
            }
            else
            {
               this._leagueSystemModuleNavigation.dispatchOnReceiveLeagueItemsSignal(null);
               this._leagueSystemModuleNavigation.dispatchOnLeagueSelectionUpdateSignal(null);
               this._leagueSystemModuleNavigation.dispatchOnNoLeagueScreen(true);
            }
         }
         else
         {
            this._leagueSystemModuleNavigation.dispatchOnReceiveLeagueItemsSignal(null);
            this._leagueSystemModuleNavigation.dispatchOnLeagueSelectionUpdateSignal(null);
            this._leagueSystemModuleNavigation.dispatchOnNoLeagueScreen(true);
         }
      }
      
      private function viewThirdPersonLeague(param1:Number) : void
      {
         this._dataProvider.getLeaguesFromSummoner(param1,false);
      }
      
      private function viewMoreStats(param1:String, param2:String, param3:String) : void
      {
         this._statsSignal.dispatch(param1,param2,param3);
      }
      
      private function viewSummonerProfile(param1:String, param2:String, param3:Boolean) : void
      {
         this._lobbySignal.dispatch(param1,param2,param3);
      }
      
      private function addSummonerAsFriend(param1:String) : void
      {
         if(this._chat != null)
         {
            this._chat.addBuddy(param1);
         }
      }
      
      private function onAskRankInfo() : void
      {
         if(this._dataProvider.rankListViewModel)
         {
            this._leagueSystemModuleNavigation.dispatchOnReceiveRankInfoSignal(this._dataProvider.rankListViewModel.myRank);
         }
         else
         {
            this._leagueSystemModuleNavigation.dispatchOnReceiveRankInfoSignal(null);
         }
      }
      
      private function onLeagueChange(param1:uint) : void
      {
         if(param1 == uint.MAX_VALUE)
         {
            this._onChallengerTierMode = true;
            this._currentLeagueId = 0;
            this._currentRank = LeagueRank.I;
            this._currentChallengerTierId = 0;
            if(Boolean(this._dataProvider.challengerTier) && this._dataProvider.challengerTier.length > 0)
            {
               this._leagueSystemModuleNavigation.dispatchOnChallengerTierSelectionUpdateSignal(this._dataProvider.challengerTier[0]);
            }
            else
            {
               this._leagueSystemModuleNavigation.dispatchOnChallengerTierSelectionUpdateSignal(null);
            }
         }
         else if(this._dataProvider.summoner == null || this._dataProvider.summoner.leagues == null || this._dataProvider.summoner.leagues.length == 0)
         {
            this._onChallengerTierMode = true;
            this._currentChallengerTierId = 0;
            this._leagueSystemModuleNavigation.dispatchOnReceiveLeagueItemsSignal(null);
            this._leagueSystemModuleNavigation.dispatchOnLeagueSelectionUpdateSignal(null);
            this._leagueSystemModuleNavigation.dispatchOnNoLeagueScreen(true);
            if(Boolean(this._dataProvider.challengerTier) && this._dataProvider.challengerTier.length > 0)
            {
               this._leagueSystemModuleNavigation.dispatchOnChallengerTierSelectionUpdateSignal(this._dataProvider.challengerTier[0]);
            }
            else
            {
               this._leagueSystemModuleNavigation.dispatchOnChallengerTierSelectionUpdateSignal(null);
            }
         }
         else if(this._currentLeagueId != param1 || this._onChallengerTierMode)
         {
            this._onChallengerTierMode = false;
            this._currentLeagueId = param1;
            this._currentRank = this._dataProvider.summoner.leagues[param1].rank;
            this.sendNewLeagueSelection(param1);
         }
         this.resetLastSelectedToDefault();
      }
      
      private function sendNewLeagueSelection(param1:uint) : void
      {
         var _loc2_:SummonerLeagueObjectModel = this._dataProvider.summoner.leagues[param1];
         if(_loc2_.tier == LeagueTier.CHALLENGER)
         {
            this._leagueSystemModuleNavigation.dispatchOnChallengerTierSelectionSignal(_loc2_.queueType);
         }
         else
         {
            this._leagueSystemModuleNavigation.dispatchOnLeagueSelectionUpdateSignal(_loc2_);
         }
      }
      
      private function onAskLeagueItems() : void
      {
         if(this._dataProvider.summoner)
         {
            this._leagueSystemModuleNavigation.dispatchOnReceiveLeagueItemsSignal(this._dataProvider.summoner.leagues);
         }
         else
         {
            this._leagueSystemModuleNavigation.dispatchOnReceiveLeagueItemsSignal(null);
         }
      }
      
      private function onRankChange(param1:LeagueRank) : void
      {
         var _loc2_:SummonerLeagueObjectModel = null;
         if(this._onChallengerTierMode != false || this._currentRank != param1)
         {
            if(this._dataProvider.summoner.leagues.length < this._currentLeagueId)
            {
               return;
            }
            this._onChallengerTierMode = false;
            this._currentRank = param1;
            _loc2_ = this._dataProvider.summoner.leagues[this._currentLeagueId];
            this._leagueSystemModuleNavigation.dispatchOnRankSelectionUpdateSignal(_loc2_.elements,this._currentRank);
            this.resetLastSelectedToDefault();
         }
      }
      
      private function onChallengeTierChange(param1:uint) : void
      {
         this._dataProvider.updateApexPromotionDemotionStatuses();
         if(this._onChallengerTierMode != true || this._currentChallengerTierId != param1)
         {
            this._onChallengerTierMode = true;
            this._currentChallengerTierId = param1;
            if(Boolean(this._dataProvider.challengerTier) && Boolean(this._dataProvider.challengerTier[param1]))
            {
               this._leagueSystemModuleNavigation.dispatchOnChallengerTierSelectionUpdateSignal(this._dataProvider.challengerTier[param1]);
            }
            else
            {
               this._leagueSystemModuleNavigation.dispatchOnChallengerTierSelectionUpdateSignal(null);
            }
            this.resetLastSelectedToDefault();
         }
      }
      
      private function onRankRowSelected(param1:uint, param2:ListItemObjectModel) : void
      {
         this._lastSelectedRankRowItem = param1;
         this._leagueSystemModuleNavigation.dispatchOnRankRowSelectedUpdate(param2,param2.isSelf);
      }
   }
}

