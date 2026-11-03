package com.riotgames.platform.gameclient.views
{
   import com.riotgames.platform.gameclient.domain.SummonerTalentsAndPoints;
   import flash.events.Event;
   
   public interface ViewMediator
   {
      
      function showExitAlert(param1:String, param2:String) : void;
      
      function handleAbortResetPassword() : void;
      
      function handleActivateBetaKey() : void;
      
      function maximizeClient() : void;
      
      function showCreateSummoner() : void;
      
      function shutdownClient(param1:Event) : void;
      
      function showSummonerWizardOrMainLobbyView() : void;
      
      function showTalentTreeView(param1:SummonerTalentsAndPoints) : void;
      
      function showPracticeGameView() : void;
      
      function minimizeClient() : void;
      
      function showLoginView() : void;
      
      function handleCreateSummoner() : void;
      
      function handleLogoutWithoutExit() : void;
      
      function showPartnerBetaBlockedMessage() : void;
      
      function handleClientConnectionError() : void;
      
      function showPlayTutorialGame() : void;
      
      function handleRenameSummoner() : void;
      
      function handleAbortBetaKeyActivation() : void;
      
      function handlePlayTutorialClose() : void;
      
      function continueCreateSummonerFlow(param1:String = null) : void;
   }
}

