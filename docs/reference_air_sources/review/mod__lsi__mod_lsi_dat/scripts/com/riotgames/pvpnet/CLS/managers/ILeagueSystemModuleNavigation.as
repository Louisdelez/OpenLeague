package com.riotgames.pvpnet.CLS.managers
{
   import blix.signals.ISignal;
   import com.riotgames.pvpnet.CLS.models.ListItemObjectModel;
   import com.riotgames.pvpnet.CLS.models.RankListViewModel;
   import com.riotgames.pvpnet.CLS.models.SummonerLeagueObjectModel;
   import com.riotgames.pvpnet.system.leagues.LeagueRank;
   import com.riotgames.pvpnet.system.leagues.LeagueTier;
   
   public interface ILeagueSystemModuleNavigation
   {
      
      function getOnLeagueNavigateHome() : ISignal;
      
      function dispatchOnLeagueNavigateHome() : void;
      
      function getAskCurrentSelectedRowId() : ISignal;
      
      function dispatchAskCurrentSelectedRowId() : void;
      
      function getCurrentSelectedRowIdUpdate() : ISignal;
      
      function dispatchCurrentSelectedRowIdUpdate(param1:uint) : void;
      
      function getOnThirdPersonLeagueSelected() : ISignal;
      
      function dispatchThirdPersonLeagueSelected(param1:Number) : void;
      
      function getOnThirdPersonLeagueSelectedUpdate() : ISignal;
      
      function dispatchThirdPersonLeagueSelectedUpdate() : void;
      
      function getOnRankRowClear() : ISignal;
      
      function dispatchOnRankRowClear() : void;
      
      function getOnAddFriendPressed() : ISignal;
      
      function dispatchOnAddFriendPressed(param1:String) : void;
      
      function getOnViewProfilePressed() : ISignal;
      
      function dispatchOnViewProfilePressed(param1:String, param2:String, param3:Boolean) : void;
      
      function getOnViewLeaguesPressed() : ISignal;
      
      function dispatchOnViewLeaguesPressed(param1:String) : void;
      
      function getOnSeeMoreStatsPressed() : ISignal;
      
      function dispatchOnSeeMoreStatsPressed(param1:String, param2:String, param3:String) : void;
      
      function getOnNoLeagueScreen() : ISignal;
      
      function dispatchOnNoLeagueScreen(param1:Boolean) : void;
      
      function getOnResetRankRowSelection() : ISignal;
      
      function dispatchOnResetRankRowSelection() : void;
      
      function getOnPopUpMenuView() : ISignal;
      
      function dispatchOnPopUpMenuView(param1:Number, param2:Number, param3:String, param4:String, param5:Boolean, param6:Boolean, param7:LeagueTier) : void;
      
      function getOnRankRowSelectedUpdateSignal() : ISignal;
      
      function dispatchOnRankRowSelectedUpdate(param1:ListItemObjectModel, param2:Boolean) : void;
      
      function getOnRankRowSelectedSignal() : ISignal;
      
      function dispatchOnRankRowSelected(param1:uint, param2:ListItemObjectModel) : void;
      
      function getOnLeagueSelectionSignal() : ISignal;
      
      function dispatchOnLeagueSelectionSignal(param1:uint) : void;
      
      function getOnLeagueSelectionUpdateSignal() : ISignal;
      
      function dispatchOnLeagueSelectionUpdateSignal(param1:SummonerLeagueObjectModel) : void;
      
      function getOnReceiveLeagueItemsSignal() : ISignal;
      
      function dispatchOnReceiveLeagueItemsSignal(param1:Vector.<SummonerLeagueObjectModel>) : void;
      
      function getOnAskLeagueItemsSignal() : ISignal;
      
      function dispatchOnAskLeagueItemsSignal() : void;
      
      function getOnAskRankInfoSignal() : ISignal;
      
      function dispatchOnAskRankInfoSignal() : void;
      
      function getOnReceiveRankInfoSignal() : ISignal;
      
      function dispatchOnReceiveRankInfoSignal(param1:ListItemObjectModel) : void;
      
      function getOnRankSelectionSignal() : ISignal;
      
      function dispatchOnRankSelectionSignal(param1:LeagueRank) : void;
      
      function getOnRankSelectionUpdateSignal() : ISignal;
      
      function dispatchOnRankDragSelectionSignal(param1:LeagueRank) : void;
      
      function getOnRankDragSelectionUpdateSignal() : ISignal;
      
      function dispatchOnRankSelectionUpdateSignal(param1:RankListViewModel, param2:LeagueRank) : void;
      
      function getOnChallengerTierSelectionSignal() : ISignal;
      
      function dispatchOnChallengerTierSelectionSignal(param1:uint) : void;
      
      function getOnChallengerTierSelectionUpdateSignal() : ISignal;
      
      function dispatchOnChallengerTierSelectionUpdateSignal(param1:Vector.<ListItemObjectModel>) : void;
      
      function getLeagueOverviewEnabled() : Boolean;
      
      function setLeagueOverviewEnabled(param1:Boolean) : void;
   }
}

