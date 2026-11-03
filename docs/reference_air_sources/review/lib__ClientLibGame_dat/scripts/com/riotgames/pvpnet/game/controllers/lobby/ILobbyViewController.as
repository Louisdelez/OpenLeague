package com.riotgames.pvpnet.game.controllers.lobby
{
   import blix.signals.ISignal;
   import com.riotgames.platform.gameclient.controllers.IViewController;
   import com.riotgames.platform.gameclient.domain.BaseSummoner;
   
   public interface ILobbyViewController extends IViewController
   {
      
      function searchForSummoner(param1:String, param2:Function, param3:Boolean = false) : void;
      
      function showWatchTab() : void;
      
      function navigateToGameFlow(param1:Array = null) : void;
      
      function navigateToQueue(param1:int, param2:Boolean, param3:String, param4:String) : void;
      
      function navigateToHome() : void;
      
      function issueGameFlowCommand(param1:String) : void;
      
      function selectQueue(param1:int, param2:Boolean) : void;
      
      function cancelJoinQueue() : void;
      
      function showLobbyLanding() : void;
      
      function showStoreView(param1:String, param2:String) : void;
      
      function closeStoreSession() : void;
      
      function showStoryView() : Boolean;
      
      function showProfileView() : void;
      
      function refreshStoreView(param1:String = "champion") : void;
      
      function openHelpDialog() : void;
      
      function reviewSummonerProfile(param1:BaseSummoner, param2:String = null) : Boolean;
      
      function requestLobbyState(param1:String) : void;
      
      function cancelMatchmaking() : void;
      
      function quitSpectating() : void;
      
      function requirePromptOnNavigate(param1:Function) : void;
      
      function clearNavigationPrompt() : void;
      
      function set currentLobbyState(param1:String) : void;
      
      function get lobbyStateChanged() : ISignal;
      
      function set matchmakingState(param1:String) : void;
      
      function get matchmakingState() : String;
      
      function get matchmakingStateChanged() : ISignal;
      
      function get practiceGameTimerString() : String;
      
      function get spectatorDelayTimerString() : String;
      
      function get storeNavigated() : ISignal;
      
      function get storeRefreshed() : ISignal;
   }
}

