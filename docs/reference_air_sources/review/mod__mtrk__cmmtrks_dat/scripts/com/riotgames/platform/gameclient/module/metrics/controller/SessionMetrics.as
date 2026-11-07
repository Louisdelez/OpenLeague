package com.riotgames.platform.gameclient.module.metrics.controller
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.event.ShellEvent;
   import com.riotgames.platform.common.provider.SessionMetricsConstants;
   import com.riotgames.pvpnet.system.messaging.ShellDispatcher;
   import com.riotgames.pvpnet.tracker.Tracker;
   import com.riotgames.pvpnet.tracking.trackers.session.ISessionMetricsProvider;
   import flash.events.Event;
   
   public class SessionMetrics extends Tracker implements ISessionMetricsProvider
   {
      
      public static const SESSION_METRICS:String = "session_metrics";
      
      public static const ACTIVE_SESSION_METRICS:String = "active_session_metrics";
      
      public static const TUTORIAL_GAME:String = "TUTORIAL_GAME";
      
      public static const JOIN_GAME:String = "JOIN_GAME";
      
      public static const CAP_STATE:String = "CAP_STATE";
      
      public static const TEAM_SELECTION:String = "TEAM_SELECT";
      
      public static const CHAMPION_SELECTION:String = "CHAMP_SELECT";
      
      public static const START_REQUESTED:String = "START_REQUESTED";
      
      public static const CREATE_GAME:String = "CREATE_GAME";
      
      public static const IN_PROGRESS:String = "IN_PROGRESS";
      
      public static const PLAYING_GAME:String = "PLAYING_GAME";
      
      public static const GAME_OVER:String = "GAME_OVER";
      
      public static const NO_GAME:String = "NO_GAME";
      
      public static const JOIN_QUEUE:String = "NORMAL_JOIN_QUEUE";
      
      public static const WAIT_FOR_GAME:String = "NORMAL_WAIT_FOR_GAME";
      
      public static const WAIT_FOR_GAME_AFTER_MATCH:String = "NORMAL_WAIT_FOR_GAME_AFTER_MATCH";
      
      public static const WAIT_FOR_JOINING_GAME:String = "WAIT_FOR_JOINING_GAME";
      
      private var _specialSessionCreated:Signal = new Signal();
      
      private var _sessionCreated:Signal = new Signal();
      
      private var _sessionClosed:Signal = new Signal();
      
      private var _allSessionClosed:Signal = new Signal();
      
      private var _sessionForceClosed:Signal = new Signal();
      
      public function SessionMetrics()
      {
         super(SESSION_METRICS);
         add(ACTIVE_SESSION_METRICS,true);
      }
      
      public function setGameStateTo_CapState() : void
      {
         addAndStartNewSegmentAndStopLast(CAP_STATE);
      }
      
      public function getAllSessionClosedSignal() : ISignal
      {
         return this._allSessionClosed;
      }
      
      public function setGameStateTo_StartRequested() : void
      {
         addAndStartNewSegmentAndStopLast(START_REQUESTED);
      }
      
      public function getSessionElapsedTimeInMS() : Number
      {
         return getElapsedTimeInMS();
      }
      
      public function vietnamAntiAddictionLawSessionForceClosed() : void
      {
         this._sessionForceClosed.dispatch(SessionMetricsConstants.VIETNAM_ANTI_ADDICTION_LAW);
      }
      
      public function setGameStateTo_TutorialGame() : void
      {
         this.clientInactive();
         addAndStartNewSegmentAndStopLast(TUTORIAL_GAME);
      }
      
      public function setGameStateTo_GameOver() : void
      {
         this.clientActivated();
         addAndStartNewSegmentAndStopLast(GAME_OVER);
      }
      
      public function setGameStateTo_WaitForGame() : void
      {
         addAndStartNewSegmentAndStopLast(WAIT_FOR_GAME);
      }
      
      public function getSessionElapsedTimeInMinutes() : Number
      {
         return getElapsedTimeInMinutes();
      }
      
      public function getActiveSessionElapsedTimeInMinutes() : Number
      {
         return get(ACTIVE_SESSION_METRICS).getElapsedTimeInMinutes();
      }
      
      public function getSessionCreatedSignal() : ISignal
      {
         return this._sessionCreated;
      }
      
      public function sessionClosed() : void
      {
         stop();
         get(ACTIVE_SESSION_METRICS).stop();
         this._sessionClosed.dispatch();
         this._allSessionClosed.dispatch();
      }
      
      public function getSessionClosedSignal() : ISignal
      {
         return this._sessionClosed;
      }
      
      public function koreanShutdownLawSessionForceClosed() : void
      {
         this._sessionForceClosed.dispatch(SessionMetricsConstants.KOREAN_SHUTDOWN_LAW);
      }
      
      public function setGameStateTo_PlayingGame() : void
      {
         this.clientInactive();
         addAndStartNewSegmentAndStopLast(PLAYING_GAME);
      }
      
      public function setGameStateTo_WaitForJoiningGame() : void
      {
         addAndStartNewSegmentAndStopLast(WAIT_FOR_JOINING_GAME);
      }
      
      public function getSessionElapsedTimeInHours() : Number
      {
         return getElapsedTimeInHours();
      }
      
      public function passwordResetSessionHasBeenCreated() : void
      {
         this._specialSessionCreated.dispatch(SessionMetricsConstants.PASSWORD_RESET_SPECIAL_SESSION);
      }
      
      public function getActiveSessionElapsedTimeInMS() : Number
      {
         return get(ACTIVE_SESSION_METRICS).getElapsedTimeInMS();
      }
      
      public function isSessionActive() : Boolean
      {
         return (get(ACTIVE_SESSION_METRICS) as Tracker).isRunning;
      }
      
      public function clientActivated(param1:Event = null) : void
      {
         get(ACTIVE_SESSION_METRICS).start();
      }
      
      public function getSessionForceClosedSignal() : ISignal
      {
         return this._sessionForceClosed;
      }
      
      public function setGameStateTo_JoinQueue() : void
      {
         addAndStartNewSegmentAndStopLast(JOIN_QUEUE);
      }
      
      public function chineseAntiIndulgenceLawSessionForceClosed() : void
      {
         this._sessionForceClosed.dispatch(SessionMetricsConstants.CHINESE_ANTI_INDULGENCE_LAW);
      }
      
      public function setGameStateTo_NoGame() : void
      {
         addAndStartNewSegmentAndStopLast(NO_GAME);
      }
      
      public function setGameStateTo_WaitForGameAfterMatch() : void
      {
         addAndStartNewSegmentAndStopLast(WAIT_FOR_GAME_AFTER_MATCH);
      }
      
      public function setGameStateTo_InProgress() : void
      {
         addAndStartNewSegmentAndStopLast(IN_PROGRESS);
      }
      
      public function getActiveSessionElapsedTimeInHours() : Number
      {
         return get(ACTIVE_SESSION_METRICS).getElapsedTimeInHours();
      }
      
      public function setGameStateTo_ChampionSelection() : void
      {
         addAndStartNewSegmentAndStopLast(CHAMPION_SELECTION);
      }
      
      public function sessionHasBeenCreated() : void
      {
         start();
         get(ACTIVE_SESSION_METRICS).start();
         ShellDispatcher.instance.addEventListener(ShellEvent.ACTIVATE,this.clientActivated);
         ShellDispatcher.instance.addEventListener(ShellEvent.DEACTIVATE,this.clientInactive);
         this._sessionCreated.dispatch();
      }
      
      public function setGameStateTo_JoinGame() : void
      {
         addAndStartNewSegmentAndStopLast(JOIN_GAME);
      }
      
      public function getSpecialSessionCreatedSignal() : ISignal
      {
         return this._specialSessionCreated;
      }
      
      public function clientInactive(param1:Event = null) : void
      {
         get(ACTIVE_SESSION_METRICS).stop();
      }
      
      public function setGameStateTo_TeamSelection() : void
      {
         addAndStartNewSegmentAndStopLast(TEAM_SELECTION);
      }
      
      public function setGameStateTo_CreateGame() : void
      {
         addAndStartNewSegmentAndStopLast(CREATE_GAME);
      }
   }
}

