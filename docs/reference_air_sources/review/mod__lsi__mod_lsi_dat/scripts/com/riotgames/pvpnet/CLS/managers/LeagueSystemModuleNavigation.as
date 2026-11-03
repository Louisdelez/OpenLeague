package com.riotgames.pvpnet.CLS.managers
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.pvpnet.CLS.models.ListItemObjectModel;
   import com.riotgames.pvpnet.CLS.models.RankListViewModel;
   import com.riotgames.pvpnet.CLS.models.SummonerLeagueObjectModel;
   import com.riotgames.pvpnet.system.leagues.LeagueRank;
   import com.riotgames.pvpnet.system.leagues.LeagueTier;
   
   public class LeagueSystemModuleNavigation implements ILeagueSystemModuleNavigation
   {
      
      private var _seeMoreStatsSignal:Signal = new Signal();
      
      private var _addFriendSignal:Signal = new Signal();
      
      private var _viewProfileSignal:Signal = new Signal();
      
      private var _viewLeaguesSignal:Signal = new Signal();
      
      private var _noLeaguesScreenSignal:Signal = new Signal();
      
      private var _onPopUpMenuViewSignal:Signal = new Signal();
      
      private var _onRankRowSelected:Signal = new Signal();
      
      private var _onRankRowSelectedUpdate:Signal = new Signal();
      
      private var _onResetRankRowSelection:Signal = new Signal();
      
      private var _onRankRowClear:Signal = new Signal();
      
      private var _onLeagueSelection:Signal = new Signal();
      
      private var _onLeagueSelectionUpdate:Signal = new Signal();
      
      private var _onReceiveLeagueItems:Signal = new Signal();
      
      private var _onAskLeagueItems:Signal = new Signal();
      
      private var _onAskRankInfo:Signal = new Signal();
      
      private var _onReceiveRankInfo:Signal = new Signal();
      
      private var _onRankDragSelection:Signal = new Signal();
      
      private var _onRankSelection:Signal = new Signal();
      
      private var _onRankSelectionUpdate:Signal = new Signal();
      
      private var _onChallengerTierSelection:Signal = new Signal();
      
      private var _onChallengerTierSelectionUpdate:Signal = new Signal();
      
      private var _onThirdPersonLeagueSelected:Signal = new Signal();
      
      private var _onThirdPersonLeagueSelectedUpdate:Signal = new Signal();
      
      private var _askCurrentSelectedRowIdSignal:Signal = new Signal();
      
      private var _currentSelectedRowIdUpdateSignal:Signal = new Signal();
      
      private var _onFAQQuestionSelectedSignal:Signal = new Signal();
      
      private var _leagueOverview:Boolean;
      
      private var _onLeagueNavigationHome:Signal = new Signal();
      
      public function LeagueSystemModuleNavigation()
      {
         super();
      }
      
      public function getAskCurrentSelectedRowId() : ISignal
      {
         return this._askCurrentSelectedRowIdSignal;
      }
      
      public function dispatchAskCurrentSelectedRowId() : void
      {
         this._askCurrentSelectedRowIdSignal.dispatch();
      }
      
      public function getCurrentSelectedRowIdUpdate() : ISignal
      {
         return this._currentSelectedRowIdUpdateSignal;
      }
      
      public function dispatchCurrentSelectedRowIdUpdate(param1:uint) : void
      {
         this._currentSelectedRowIdUpdateSignal.dispatch(param1);
      }
      
      public function getOnThirdPersonLeagueSelectedUpdate() : ISignal
      {
         return this._onThirdPersonLeagueSelected;
      }
      
      public function dispatchThirdPersonLeagueSelectedUpdate() : void
      {
         this._onThirdPersonLeagueSelectedUpdate.dispatch();
      }
      
      public function getOnThirdPersonLeagueSelected() : ISignal
      {
         return this._onThirdPersonLeagueSelected;
      }
      
      public function dispatchThirdPersonLeagueSelected(param1:Number) : void
      {
         this._onThirdPersonLeagueSelected.dispatch(param1);
      }
      
      public function getOnRankRowClear() : ISignal
      {
         return this._onRankRowClear;
      }
      
      public function dispatchOnRankRowClear() : void
      {
         this._onRankRowClear.dispatch();
      }
      
      public function getOnAddFriendPressed() : ISignal
      {
         return this._addFriendSignal;
      }
      
      public function dispatchOnAddFriendPressed(param1:String) : void
      {
         this._addFriendSignal.dispatch(param1);
      }
      
      public function getOnViewProfilePressed() : ISignal
      {
         return this._viewProfileSignal;
      }
      
      public function dispatchOnViewProfilePressed(param1:String, param2:String, param3:Boolean) : void
      {
         this._viewProfileSignal.dispatch(param1,param2,param3);
      }
      
      public function getOnViewLeaguesPressed() : ISignal
      {
         return this._viewLeaguesSignal;
      }
      
      public function dispatchOnViewLeaguesPressed(param1:String) : void
      {
         this._viewLeaguesSignal.dispatch(param1);
      }
      
      public function getOnSeeMoreStatsPressed() : ISignal
      {
         return this._seeMoreStatsSignal;
      }
      
      public function dispatchOnSeeMoreStatsPressed(param1:String, param2:String, param3:String) : void
      {
         this._seeMoreStatsSignal.dispatch(param1,param2,param3);
      }
      
      public function getOnNoLeagueScreen() : ISignal
      {
         return this._noLeaguesScreenSignal;
      }
      
      public function dispatchOnNoLeagueScreen(param1:Boolean) : void
      {
         this._noLeaguesScreenSignal.dispatch(param1);
      }
      
      public function getOnPopUpMenuView() : ISignal
      {
         return this._onPopUpMenuViewSignal;
      }
      
      public function dispatchOnPopUpMenuView(param1:Number, param2:Number, param3:String, param4:String, param5:Boolean, param6:Boolean, param7:LeagueTier) : void
      {
         this._onPopUpMenuViewSignal.dispatch(param1,param2,param3,param4,param5,param6,param7);
      }
      
      public function getOnRankRowSelectedUpdateSignal() : ISignal
      {
         return this._onRankRowSelectedUpdate;
      }
      
      public function dispatchOnRankRowSelectedUpdate(param1:ListItemObjectModel, param2:Boolean) : void
      {
         this._onRankRowSelectedUpdate.dispatch(param1,param2);
      }
      
      public function getOnRankRowSelectedSignal() : ISignal
      {
         return this._onRankRowSelected;
      }
      
      public function dispatchOnRankRowSelected(param1:uint, param2:ListItemObjectModel) : void
      {
         this._onRankRowSelected.dispatch(param1,param2);
      }
      
      public function getOnResetRankRowSelection() : ISignal
      {
         return this._onResetRankRowSelection;
      }
      
      public function dispatchOnResetRankRowSelection() : void
      {
         this._onResetRankRowSelection.dispatch();
      }
      
      public function getOnLeagueSelectionSignal() : ISignal
      {
         return this._onLeagueSelection;
      }
      
      public function dispatchOnLeagueSelectionSignal(param1:uint) : void
      {
         this._onLeagueSelection.dispatch(param1);
      }
      
      public function getOnLeagueSelectionUpdateSignal() : ISignal
      {
         return this._onLeagueSelectionUpdate;
      }
      
      public function dispatchOnLeagueSelectionUpdateSignal(param1:SummonerLeagueObjectModel) : void
      {
         this._onLeagueSelectionUpdate.dispatch(param1);
      }
      
      public function getOnReceiveLeagueItemsSignal() : ISignal
      {
         return this._onReceiveLeagueItems;
      }
      
      public function dispatchOnReceiveLeagueItemsSignal(param1:Vector.<SummonerLeagueObjectModel>) : void
      {
         this._onReceiveLeagueItems.dispatch(param1);
      }
      
      public function getOnAskLeagueItemsSignal() : ISignal
      {
         return this._onAskLeagueItems;
      }
      
      public function dispatchOnAskLeagueItemsSignal() : void
      {
         this._onAskLeagueItems.dispatch();
      }
      
      public function getOnAskRankInfoSignal() : ISignal
      {
         return this._onAskRankInfo;
      }
      
      public function dispatchOnAskRankInfoSignal() : void
      {
         this._onAskRankInfo.dispatch();
      }
      
      public function getOnReceiveRankInfoSignal() : ISignal
      {
         return this._onReceiveRankInfo;
      }
      
      public function dispatchOnReceiveRankInfoSignal(param1:ListItemObjectModel) : void
      {
         this._onReceiveRankInfo.dispatch(param1);
      }
      
      public function dispatchOnRankDragSelectionSignal(param1:LeagueRank) : void
      {
         this._onRankDragSelection.dispatch(param1);
      }
      
      public function getOnRankDragSelectionUpdateSignal() : ISignal
      {
         return this._onRankDragSelection;
      }
      
      public function getOnRankSelectionSignal() : ISignal
      {
         return this._onRankSelection;
      }
      
      public function dispatchOnRankSelectionSignal(param1:LeagueRank) : void
      {
         this._onRankSelection.dispatch(param1);
      }
      
      public function getOnRankSelectionUpdateSignal() : ISignal
      {
         return this._onRankSelectionUpdate;
      }
      
      public function dispatchOnRankSelectionUpdateSignal(param1:RankListViewModel, param2:LeagueRank) : void
      {
         this._onRankSelectionUpdate.dispatch(param1,param2);
      }
      
      public function getOnChallengerTierSelectionSignal() : ISignal
      {
         return this._onChallengerTierSelection;
      }
      
      public function dispatchOnChallengerTierSelectionSignal(param1:uint) : void
      {
         this._onChallengerTierSelection.dispatch(param1);
      }
      
      public function getOnChallengerTierSelectionUpdateSignal() : ISignal
      {
         return this._onChallengerTierSelectionUpdate;
      }
      
      public function dispatchOnChallengerTierSelectionUpdateSignal(param1:Vector.<ListItemObjectModel>) : void
      {
         this._onChallengerTierSelectionUpdate.dispatch(param1);
      }
      
      public function getLeagueOverviewEnabled() : Boolean
      {
         return this._leagueOverview;
      }
      
      public function setLeagueOverviewEnabled(param1:Boolean) : void
      {
         this._leagueOverview = param1;
      }
      
      public function getOnLeagueNavigateHome() : ISignal
      {
         return this._onLeagueNavigationHome;
      }
      
      public function dispatchOnLeagueNavigateHome() : void
      {
         this._onLeagueNavigationHome.dispatch();
      }
   }
}

