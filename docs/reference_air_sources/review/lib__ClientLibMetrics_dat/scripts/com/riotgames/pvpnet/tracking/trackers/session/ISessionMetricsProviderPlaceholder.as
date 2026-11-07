package com.riotgames.pvpnet.tracking.trackers.session
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   
   public class ISessionMetricsProviderPlaceholder implements ISessionMetricsProvider
   {
      
      public function ISessionMetricsProviderPlaceholder()
      {
         super();
      }
      
      public function getSessionCreatedSignal() : ISignal
      {
         return new Signal();
      }
      
      public function sessionHasBeenCreated() : void
      {
      }
      
      public function getSpecialSessionCreatedSignal() : ISignal
      {
         return new Signal();
      }
      
      public function passwordResetSessionHasBeenCreated() : void
      {
      }
      
      public function getSessionForceClosedSignal() : ISignal
      {
         return new Signal();
      }
      
      public function koreanShutdownLawSessionForceClosed() : void
      {
      }
      
      public function vietnamAntiAddictionLawSessionForceClosed() : void
      {
      }
      
      public function chineseAntiIndulgenceLawSessionForceClosed() : void
      {
      }
      
      public function getSessionClosedSignal() : ISignal
      {
         return new Signal();
      }
      
      public function sessionClosed() : void
      {
      }
      
      public function getSessionElapsedTimeInMS() : Number
      {
         return 0;
      }
      
      public function getSessionElapsedTimeInHours() : Number
      {
         return 0;
      }
      
      public function getSessionElapsedTimeInMinutes() : Number
      {
         return 0;
      }
      
      public function getActiveSessionElapsedTimeInMS() : Number
      {
         return 0;
      }
      
      public function getActiveSessionElapsedTimeInHours() : Number
      {
         return 0;
      }
      
      public function getActiveSessionElapsedTimeInMinutes() : Number
      {
         return 0;
      }
      
      public function setGameStateTo_TutorialGame() : void
      {
      }
      
      public function setGameStateTo_JoinGame() : void
      {
      }
      
      public function setGameStateTo_CapState() : void
      {
      }
      
      public function setGameStateTo_TeamSelection() : void
      {
      }
      
      public function setGameStateTo_ChampionSelection() : void
      {
      }
      
      public function setGameStateTo_StartRequested() : void
      {
      }
      
      public function setGameStateTo_CreateGame() : void
      {
      }
      
      public function setGameStateTo_InProgress() : void
      {
      }
      
      public function setGameStateTo_PlayingGame() : void
      {
      }
      
      public function setGameStateTo_GameOver() : void
      {
      }
      
      public function setGameStateTo_NoGame() : void
      {
      }
      
      public function setGameStateTo_JoinQueue() : void
      {
      }
      
      public function setGameStateTo_WaitForGame() : void
      {
      }
      
      public function setGameStateTo_WaitForGameAfterMatch() : void
      {
      }
      
      public function setGameStateTo_WaitForJoiningGame() : void
      {
      }
      
      public function getAllSessionClosedSignal() : ISignal
      {
         return new Signal();
      }
      
      public function isSessionActive() : Boolean
      {
         return false;
      }
   }
}

