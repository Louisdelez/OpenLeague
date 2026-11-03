package com.riotgames.pvpnet.tracking.trackers.session
{
   import blix.signals.ISignal;
   import com.riotgames.platform.provider.IProvider;
   
   public interface ISessionMetricsProvider extends IProvider
   {
      
      function getSessionCreatedSignal() : ISignal;
      
      function sessionHasBeenCreated() : void;
      
      function getSpecialSessionCreatedSignal() : ISignal;
      
      function passwordResetSessionHasBeenCreated() : void;
      
      function getSessionForceClosedSignal() : ISignal;
      
      function koreanShutdownLawSessionForceClosed() : void;
      
      function vietnamAntiAddictionLawSessionForceClosed() : void;
      
      function chineseAntiIndulgenceLawSessionForceClosed() : void;
      
      function getSessionClosedSignal() : ISignal;
      
      function getAllSessionClosedSignal() : ISignal;
      
      function sessionClosed() : void;
      
      function getSessionElapsedTimeInMS() : Number;
      
      function getSessionElapsedTimeInHours() : Number;
      
      function getSessionElapsedTimeInMinutes() : Number;
      
      function getActiveSessionElapsedTimeInMS() : Number;
      
      function getActiveSessionElapsedTimeInHours() : Number;
      
      function getActiveSessionElapsedTimeInMinutes() : Number;
      
      function setGameStateTo_TutorialGame() : void;
      
      function setGameStateTo_JoinGame() : void;
      
      function setGameStateTo_CapState() : void;
      
      function setGameStateTo_TeamSelection() : void;
      
      function setGameStateTo_ChampionSelection() : void;
      
      function setGameStateTo_StartRequested() : void;
      
      function setGameStateTo_CreateGame() : void;
      
      function setGameStateTo_InProgress() : void;
      
      function setGameStateTo_PlayingGame() : void;
      
      function setGameStateTo_GameOver() : void;
      
      function setGameStateTo_NoGame() : void;
      
      function setGameStateTo_JoinQueue() : void;
      
      function setGameStateTo_WaitForGame() : void;
      
      function setGameStateTo_WaitForGameAfterMatch() : void;
      
      function setGameStateTo_WaitForJoiningGame() : void;
      
      function isSessionActive() : Boolean;
   }
}

