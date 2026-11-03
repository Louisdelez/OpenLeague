package com.riotgames.platform.gameclient.shutdown
{
   import com.riotgames.platform.common.AppConfig;
   import com.riotgames.platform.common.IAppController;
   import com.riotgames.platform.common.IAppControllerConstants;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.domain.game.GameViewState;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.game.controllers.MasterGameController;
   import com.riotgames.pvpnet.game.controllers.shutdown.ShutdownTimingTables;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.pvpnet.tracking.trackers.session.ISessionMetricsProvider;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.getQualifiedClassName;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class KoreanShutdownLaw extends EventDispatcher
   {
      
      internal static const TICK_WARNING_WINDOW:String = "KOREAN_SHUTDOWN_LAW_WARNING_WINDOW";
      
      internal static const TICK_QUEUES_DISABLED:String = "KOREAN_SHUTDOWN_LAW_QUEUES_DISABLED";
      
      internal static const TICK_SHUTDOWN:String = "KOREAN_SHUTDOWN_LAW_SHUTDOWN";
      
      private var applicationController:IAppController;
      
      private var shutdownTimer:Timer;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var _sessionMetrics:ISessionMetricsProvider;
      
      private var masterGameController:MasterGameController;
      
      private var shutdownNoGamesTimer:Timer;
      
      private var shutdownWarningTimer:Timer;
      
      public function KoreanShutdownLaw(param1:IAppController, param2:MasterGameController)
      {
         super();
         this.applicationController = param1;
         this.masterGameController = param2;
      }
      
      private function onShutdownNoGamesTimer(param1:TimerEvent) : void
      {
         var timeUntilNextThreshold:Number = NaN;
         var e:TimerEvent = param1;
         timeUntilNextThreshold = Number(ShutdownTimingTables.getTimeUntilShutdown());
         var alertAction:AlertAction = new AlertAction(RiotResourceLoader.getString("shutdown_law_alert_title","Shutdown law alert"),RiotResourceLoader.getString("shutdown_law_final_window","Shutdown time is approaching. You are no longer able to join any games and will disconnect soon."));
         alertAction.add();
         if(AppConfig.instance.currentAppState == IAppControllerConstants.CHOOSE_GAME_FLOW)
         {
            AppConfig.instance.currentAppState = IAppControllerConstants.LOBBY;
         }
         if(this.masterGameController.currentState == GameViewState.CREATE_GAME || this.masterGameController.currentState == GameViewState.JOIN_GAME || this.masterGameController.currentState == GameViewState.TEAM_SELECTION)
         {
            this.masterGameController.cancelGameFlow();
         }
         AppConfig.instance.shutdownDisablePlayButton = true;
         this.applicationController.shutdownLawActive = true;
         try
         {
            this.shutdownTimer = this.createTimer(timeUntilNextThreshold);
            this.shutdownTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onShutdownTimer);
            this.shutdownTimer.start();
         }
         catch(e:Error)
         {
            logger.warn("Shutdown law: onShutdownNoGamesTimer: Encountered an error when setting a shutdown timer for value: " + timeUntilNextThreshold + ". We may have transitioned in to the next stage. Moving on.");
            if(timeUntilNextThreshold <= 0)
            {
               applicationController.handleExit();
            }
         }
         dispatchEvent(new Event(TICK_QUEUES_DISABLED));
      }
      
      internal function cleanup() : void
      {
         if(this.shutdownTimer != null)
         {
            this.shutdownTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onShutdownTimer);
            this.shutdownTimer.stop();
            this.shutdownTimer = null;
         }
         if(this.shutdownWarningTimer != null)
         {
            this.shutdownWarningTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onShutdownWarningTimer);
            this.shutdownWarningTimer.stop();
            this.shutdownWarningTimer = null;
         }
         if(this.shutdownNoGamesTimer != null)
         {
            this.shutdownNoGamesTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onShutdownNoGamesTimer);
            this.shutdownNoGamesTimer.stop();
            this.shutdownNoGamesTimer = null;
         }
      }
      
      private function onShutdownTimer(param1:TimerEvent) : void
      {
         this._sessionMetrics.koreanShutdownLawSessionForceClosed();
         this.applicationController.handleExit();
         dispatchEvent(new Event(TICK_SHUTDOWN));
      }
      
      private function createTimer(param1:Number) : Timer
      {
         if(param1 < 0)
         {
            param1 = 0;
         }
         return new Timer(param1 / 10,10);
      }
      
      private function onShutdownWarningTimer(param1:TimerEvent) : void
      {
         var timeUntilNextThreshold:Number = NaN;
         var e:TimerEvent = param1;
         timeUntilNextThreshold = Number(ShutdownTimingTables.getTimeUntilNoQueuesAvailable());
         var alertAction:AlertAction = new AlertAction(RiotResourceLoader.getString("shutdown_law_alert_title","Shutdown law alert"),RiotResourceLoader.getString("shutdown_law_warning_window","Shutdown time is coming soon. Your game options will start being limited"));
         alertAction.add();
         try
         {
            this.shutdownNoGamesTimer = this.createTimer(timeUntilNextThreshold);
            this.shutdownNoGamesTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onShutdownNoGamesTimer);
            this.shutdownNoGamesTimer.start();
         }
         catch(e:Error)
         {
            logger.warn("Shutdown law: onShutdownWarningTimer: Encountered an error when setting a shutdown timer for value: " + timeUntilNextThreshold + ". We may have transitioned in to the next stage. Moving on.");
            onShutdownNoGamesTimer(null);
         }
         dispatchEvent(new Event(TICK_WARNING_WINDOW));
      }
      
      public function apply(param1:Boolean, param2:Boolean, param3:Number) : Boolean
      {
         var minor:Boolean = param1;
         var minorShutdownEnforced:Boolean = param2;
         var minutesUntilMidnight:Number = param3;
         ShutdownTimingTables.SELECTIVE_SHUTDOWN_MODE = false;
         if(this._sessionMetrics == null)
         {
            ProviderLookup.getProvider(ISessionMetricsProvider,this.onSessionMetricsProvided);
         }
         if(minor && minorShutdownEnforced)
         {
            if(!isNaN(minutesUntilMidnight) && minutesUntilMidnight >= 0)
            {
               ShutdownTimingTables.setCutoffTime(int(minutesUntilMidnight * 60 * 1000));
               if(ShutdownTimingTables.isInShutdownWindow())
               {
                  this.applicationController.handleExit();
                  return true;
               }
               if(ShutdownTimingTables.noQueuesAvailable())
               {
                  this.onShutdownNoGamesTimer(null);
               }
               else if(ShutdownTimingTables.isInWarningWindow())
               {
                  this.onShutdownWarningTimer(null);
               }
               else
               {
                  try
                  {
                     this.shutdownWarningTimer = this.createTimer(ShutdownTimingTables.getTimeUntilShutdownWarning());
                     this.shutdownWarningTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onShutdownWarningTimer,false,0,true);
                     this.shutdownWarningTimer.start();
                  }
                  catch(e:Error)
                  {
                     logger.warn("Shutdown law: onShutdownWarningTimer: Encountered an error when setting a shutdown timer for value: " + ShutdownTimingTables.getTimeUntilShutdownWarning() + ". We may have transitioned in to the next stage. Moving on.");
                     onShutdownWarningTimer(null);
                  }
               }
            }
            return true;
         }
         return false;
      }
      
      public function onSessionMetricsProvided(param1:ISessionMetricsProvider) : void
      {
         this._sessionMetrics = param1;
      }
   }
}

