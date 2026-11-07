package com.riotgames.platform.gameclient.shell.platformshutdown
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.common.utils.app.ApplicationUtil;
   import com.riotgames.platform.gameclient.domain.broadcast.BroadcastMessage;
   import com.riotgames.pvpnet.system.config.cdc.ConfigurationModel;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
   import com.riotgames.pvpnet.system.notification.IServerStatusProvider;
   import flash.display.DisplayObject;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import mx.managers.PopUpManager;
   
   public class PlatformShutdownDisplay
   {
      
      private static const DEFAULT_MAX_SECONDS:int = 300;
      
      private static const ONE_SECOND:int = 1000;
      
      private static const ONE_MINUTE:int = 60;
      
      private static const SECONDS_COUNTDOWN:int = 30;
      
      private static const PLATFORM_SHUTDOWN_NAMESPACE:String = "PlatformShutdown";
      
      private static const PLATFORM_SHUTDOWN_ENABLED:String = "Enabled";
      
      private static const PLATFORM_SHUTDOWN_DURATION:String = "Duration";
      
      private var parentComponent:DisplayObject;
      
      private var timer:Timer;
      
      private var statusPane:PlatformShutdownStatusPane;
      
      private var forcedShutdown:Signal = new Signal();
      
      public var serverStatusController:IServerStatusProvider;
      
      private var previousMinutesLeft:int;
      
      private var maxSeconds:int;
      
      private var finalPane:PlatformShutdownFinalPane;
      
      public function PlatformShutdownDisplay(param1:IServerStatusProvider)
      {
         super();
         this.serverStatusController = param1;
         this.parentComponent = DisplayObject(ApplicationUtil.application);
      }
      
      private static function getDisplayTime(param1:int) : String
      {
         if(param1 < 60)
         {
            return param1 + " " + RiotResourceLoader.getString("common_time_seconds_long");
         }
         var _loc2_:int = Math.round(param1 / ONE_MINUTE);
         param1 -= _loc2_ * ONE_MINUTE;
         return _loc2_ + " " + RiotResourceLoader.getString("common_time_minutes_short");
      }
      
      public function shutdownClient() : void
      {
         this.forcedShutdown.dispatch();
      }
      
      private function updateTicker(param1:String) : void
      {
         var _loc2_:BroadcastMessage = new BroadcastMessage();
         _loc2_.severity = "WARN";
         _loc2_.messageKey = "platform_shutdown";
         _loc2_.content = param1;
         this.serverStatusController.clearLocalMessages();
         this.serverStatusController.addLocalMessage(_loc2_);
      }
      
      public function getForcedShutdown() : ISignal
      {
         return this.forcedShutdown;
      }
      
      public function init() : void
      {
         var _loc1_:ConfigurationModel = DynamicClientConfigManager.getConfiguration(PLATFORM_SHUTDOWN_NAMESPACE,PLATFORM_SHUTDOWN_ENABLED,false,this.onPlatformShutdownChanged);
         if(_loc1_.getBoolean() == true)
         {
            this.finalizeShutdown();
         }
      }
      
      private function finalizeShutdown() : void
      {
         if(this.finalPane == null)
         {
            if(this.statusPane != null && Boolean(this.statusPane.visible))
            {
               PopUpManager.removePopUp(this.statusPane);
            }
            this.finalPane = new PlatformShutdownFinalPane();
            this.finalPane.controller = this;
            PopUpManager.addPopUp(this.finalPane,this.parentComponent,true);
            PopUpManager.centerPopUp(this.finalPane);
            this.finalPane.x -= 60;
            if(this.finalPane.x <= 0 || this.finalPane.y <= 0)
            {
               this.finalPane.x = 100;
               this.finalPane.y = 100;
            }
         }
      }
      
      private function initiateShutdown(param1:int = 300) : void
      {
         var _loc2_:String = null;
         if(this.timer == null && this.finalPane == null)
         {
            this.serverStatusController.clearAllMessages();
            this.maxSeconds = param1;
            this.previousMinutesLeft = param1 / ONE_MINUTE;
            this.statusPane = new PlatformShutdownStatusPane();
            PopUpManager.addPopUp(this.statusPane,this.parentComponent,false);
            PopUpManager.centerPopUp(this.statusPane);
            this.statusPane.x -= 60;
            if(this.statusPane.x <= 0 || this.statusPane.y <= 0)
            {
               this.statusPane.x = 100;
               this.statusPane.y = 100;
            }
            _loc2_ = getDisplayTime(this.maxSeconds);
            this.statusPane.timeLeft = RiotResourceLoader.getString("platform_shutdown_dialog_message",null,[_loc2_]);
            this.updateTicker(_loc2_);
            this.timer = new Timer(ONE_SECOND,this.maxSeconds);
            this.timer.addEventListener(TimerEvent.TIMER,this.handleTimerTick,false,0,true);
            this.timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.handleTimerComplete,false,0,true);
            this.timer.start();
         }
      }
      
      private function handleTimerComplete(param1:TimerEvent) : void
      {
         this.finalizeShutdown();
      }
      
      public function onPlatformShutdownChanged(param1:Boolean) : void
      {
         var _loc3_:ConfigurationModel = null;
         var _loc2_:ConfigurationModel = DynamicClientConfigManager.getConfiguration(PLATFORM_SHUTDOWN_NAMESPACE,PLATFORM_SHUTDOWN_ENABLED,false);
         if(_loc2_.getBoolean() == true)
         {
            if(param1)
            {
               this.finalizeShutdown();
            }
            else
            {
               _loc3_ = DynamicClientConfigManager.getConfiguration(PLATFORM_SHUTDOWN_NAMESPACE,PLATFORM_SHUTDOWN_DURATION,DEFAULT_MAX_SECONDS);
               this.initiateShutdown(_loc3_.getInt());
            }
         }
      }
      
      private function handleTimerTick(param1:TimerEvent) : void
      {
         var _loc4_:String = null;
         var _loc2_:int = this.maxSeconds - this.timer.currentCount;
         var _loc3_:int = Math.round(_loc2_ / ONE_MINUTE);
         if(this.statusPane != null)
         {
            this.statusPane.nextUpdateProgress = this.timer.currentCount / this.maxSeconds;
         }
         if(_loc2_ < 60 || this.previousMinutesLeft != _loc3_)
         {
            _loc4_ = getDisplayTime(_loc2_);
            if(_loc2_ >= 60 || _loc2_ <= SECONDS_COUNTDOWN)
            {
               this.updateTicker(_loc4_);
            }
            if(this.statusPane != null)
            {
               this.statusPane.messageText.htmlText = RiotResourceLoader.getString("platform_shutdown_dialog_message",null,[_loc4_]);
            }
         }
         this.previousMinutesLeft = _loc3_;
      }
   }
}

