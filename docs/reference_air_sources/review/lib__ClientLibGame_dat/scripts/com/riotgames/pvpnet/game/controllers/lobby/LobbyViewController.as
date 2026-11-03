package com.riotgames.pvpnet.game.controllers.lobby
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.gameclient.domain.BaseSummoner;
   
   public class LobbyViewController implements ILobbyViewController
   {
      
      private var _matchmakingStateChanged:Signal = new Signal();
      
      private var _lobbyStateChanged:Signal = new Signal();
      
      private var _storeNavigated:Signal = new Signal();
      
      private var _storeRefreshed:Signal = new Signal();
      
      public function LobbyViewController()
      {
         super();
      }
      
      public function searchForSummoner(param1:String, param2:Function, param3:Boolean = false) : void
      {
      }
      
      public function showWatchTab() : void
      {
      }
      
      public function navigateToHome() : void
      {
      }
      
      public function navigateToGameFlow(param1:Array = null) : void
      {
      }
      
      public function navigateToQueue(param1:int, param2:Boolean, param3:String, param4:String) : void
      {
      }
      
      public function cancelJoinQueue() : void
      {
      }
      
      public function issueGameFlowCommand(param1:String) : void
      {
      }
      
      public function selectQueue(param1:int, param2:Boolean) : void
      {
      }
      
      public function showLobbyLanding() : void
      {
      }
      
      public function showStoreView(param1:String, param2:String) : void
      {
      }
      
      public function closeStoreSession() : void
      {
      }
      
      public function showStoryView() : Boolean
      {
         return false;
      }
      
      public function showProfileView() : void
      {
      }
      
      public function refreshStoreView(param1:String = "champion") : void
      {
      }
      
      public function reviewSummonerProfile(param1:BaseSummoner, param2:String = null) : Boolean
      {
         return false;
      }
      
      public function requestLobbyState(param1:String) : void
      {
      }
      
      public function cancelMatchmaking() : void
      {
      }
      
      public function requirePromptOnNavigate(param1:Function) : void
      {
      }
      
      public function clearNavigationPrompt() : void
      {
      }
      
      public function set currentLobbyState(param1:String) : void
      {
      }
      
      public function get matchmakingState() : String
      {
         return null;
      }
      
      public function set matchmakingState(param1:String) : void
      {
      }
      
      public function get matchmakingStateChanged() : ISignal
      {
         return this._matchmakingStateChanged;
      }
      
      public function get lobbyStateChanged() : ISignal
      {
         return this._lobbyStateChanged;
      }
      
      public function get storeNavigated() : ISignal
      {
         return this._storeNavigated;
      }
      
      public function get storeRefreshed() : ISignal
      {
         return this._storeRefreshed;
      }
      
      public function initialize() : void
      {
      }
      
      public function cleanup() : void
      {
      }
      
      public function activate() : void
      {
      }
      
      public function deactivate() : void
      {
      }
      
      public function openHelpDialog() : void
      {
      }
      
      public function get practiceGameTimerString() : String
      {
         return "";
      }
      
      public function get spectatorDelayTimerString() : String
      {
         return "";
      }
      
      public function quitSpectating() : void
      {
      }
   }
}

