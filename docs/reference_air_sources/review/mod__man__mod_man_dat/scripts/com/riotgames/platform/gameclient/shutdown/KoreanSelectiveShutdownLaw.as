package com.riotgames.platform.gameclient.shutdown
{
   import com.riotgames.platform.common.AppConfig;
   import com.riotgames.platform.common.IAppController;
   import com.riotgames.platform.common.IAppControllerConstants;
   import com.riotgames.platform.common.domain.XMPPMessageSubjectTypes;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.domain.broadcast.BroadcastMessage;
   import com.riotgames.platform.gameclient.domain.game.GameViewState;
   import com.riotgames.platform.gameclient.domain.partner.AntiIndulgenceMessage;
   import com.riotgames.pvpnet.game.controllers.MasterGameController;
   import com.riotgames.pvpnet.game.controllers.shutdown.ShutdownTimingTables;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.notification.ServerStatusProviderProxy;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.getQualifiedClassName;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class KoreanSelectiveShutdownLaw extends EventDispatcher
   {
      
      internal static const TICK_PLAYTIME_REMINDER:String = "KOREAN_SELECTIVE_SHUTDOWN_LAW_PLAYTIME_REMINDER";
      
      internal static const TICK_WARNING_WINDOW:String = "KOREAN_SELECTIVE_SHUTDOWN_LAW_WARNING_WINDOW";
      
      internal static const TICK_QUEUES_DISABLED:String = "KOREAN_SELECTIVE_SHUTDOWN_LAW_QUEUES_DISABLED";
      
      internal static const TICK_SHUTDOWN:String = "KOREAN_SELECTIVE_SHUTDOWN_LAW_SHUTDOWN";
      
      internal static var PLAYTIME_REMINDER_MINUTES:Number = 60;
      
      private var hoursPlayed:int = 0;
      
      private var applicationController:IAppController;
      
      private var shutdownTimer:Timer;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var chatController:ChatController;
      
      private var shutdownNoGamesTimer:Timer;
      
      private var masterGameController:MasterGameController;
      
      private var reminderTimer:Timer;
      
      private var shutdownWarningTimer:Timer;
      
      public function KoreanSelectiveShutdownLaw(param1:IAppController, param2:MasterGameController, param3:ChatController, param4:String)
      {
         super();
         this.applicationController = param1;
         this.masterGameController = param2;
         this.chatController = param3;
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
      
      private function onPlaytimeReminderTimer(param1:TimerEvent) : void
      {
         ++this.hoursPlayed;
         this.sendReminder();
         dispatchEvent(new Event(TICK_PLAYTIME_REMINDER));
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
      
      private function sendReminder() : void
      {
         var _loc1_:String = this.hoursPlayed == 1 ? "shutdown_law_playtime_reminder" : "shutdown_law_playtime_reminder_plural";
         var _loc2_:AntiIndulgenceMessage = new AntiIndulgenceMessage(XMPPMessageSubjectTypes.AAS_NOTIFICATION,_loc1_,new String(this.hoursPlayed));
         this.chatController.sendGameAntiIndulgenceMessage(_loc2_);
         var _loc3_:BroadcastMessage = new BroadcastMessage();
         _loc3_.severity = "ERROR";
         _loc3_.messageKey = "selective_shutdown_playtime_reminder";
         _loc3_.expiryTime = 30000;
         _loc3_.content = RiotResourceLoader.getString(_loc1_,null,[this.hoursPlayed]);
         ServerStatusProviderProxy.instance.addLocalMessage(_loc3_);
      }
      
      internal function cleanup() : void
      {
         if(this.reminderTimer != null)
         {
            this.reminderTimer.removeEventListener(TimerEvent.TIMER,this.onPlaytimeReminderTimer);
            this.reminderTimer.stop();
            this.reminderTimer = null;
         }
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
      
      private function createTimer(param1:Number) : Timer
      {
         if(param1 < 0)
         {
            param1 = 0;
         }
         return new Timer(param1 / 10,10);
      }
      
      public function apply(param1:Boolean, param2:Number) : Boolean
      {
         var minutesUntilShutdownEnabled:Boolean = param1;
         var minutesUntilShutdown:Number = param2;
         ShutdownTimingTables.SELECTIVE_SHUTDOWN_MODE = true;
         if(minutesUntilShutdownEnabled)
         {
            if(!isNaN(minutesUntilShutdown) && minutesUntilShutdown >= 0)
            {
               ShutdownTimingTables.setCutoffTime(int(minutesUntilShutdown * 60 * 1000));
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
      
      public function playReminderMessages() : void
      {
         if(ClientConfig.instance.enablePlaytimeReminderOverride)
         {
            PLAYTIME_REMINDER_MINUTES = 1;
         }
         this.reminderTimer = new Timer(PLAYTIME_REMINDER_MINUTES * 60 * 1000,0);
         this.reminderTimer.addEventListener(TimerEvent.TIMER,this.onPlaytimeReminderTimer,false,0,true);
         this.reminderTimer.start();
      }
      
      private function onShutdownTimer(param1:TimerEvent) : void
      {
         this.applicationController.handleExit();
         dispatchEvent(new Event(TICK_SHUTDOWN));
      }
   }
}

