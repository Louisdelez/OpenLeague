package com.riotgames.platform.gameclient.shutdown
{
   import com.riotgames.platform.common.AppConfig;
   import com.riotgames.platform.common.IAppController;
   import com.riotgames.platform.common.IAppControllerConstants;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.chat.gamechat.GameChatXML;
   import com.riotgames.platform.gameclient.domain.binge.BingePreventionNotification;
   import com.riotgames.platform.gameclient.domain.game.GameViewState;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.game.controllers.MasterGameController;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.pvpnet.system.maestro.MaestroProviderProxy;
   import com.riotgames.pvpnet.system.notification.ClientNotificationEvent;
   import com.riotgames.pvpnet.tracking.trackers.session.ISessionMetricsProvider;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.getQualifiedClassName;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class VietnamAntiAddictionLaw extends EventDispatcher
   {
      
      private var _sessionMetrics:ISessionMetricsProvider;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var applicationController:IAppController;
      
      private var masterGameController:MasterGameController;
      
      private var cooldownTimer:Timer;
      
      private var isBingeSystemEnabledForClient:Boolean = false;
      
      public function VietnamAntiAddictionLaw(param1:IAppController, param2:MasterGameController, param3:Boolean)
      {
         super();
         this.applicationController = param1;
         this.masterGameController = param2;
         this.isBingeSystemEnabledForClient = param3;
      }
      
      private function killPlayOptions() : void
      {
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
         if(this._sessionMetrics == null)
         {
            ProviderLookup.getProvider(ISessionMetricsProvider,this.onSessionMetricsProvided);
         }
      }
      
      internal function cleanup() : void
      {
         if(this.cooldownTimer != null)
         {
            this.cooldownTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onBingeWindowCooldownTimer);
            this.cooldownTimer.stop();
            this.cooldownTimer = null;
         }
      }
      
      public function onBingePreventionNotificationReceived(param1:ClientNotificationEvent) : void
      {
         var _loc2_:BingePreventionNotification = param1.notification as BingePreventionNotification;
         if(this.isBingeSystemEnabledForClient)
         {
            this.apply(_loc2_.blockPlayerInXMinutes <= 0,_loc2_.preventPlayForXMinutes,_loc2_.blockPlayerInXMinutes);
         }
      }
      
      public function displayInBingeNotificationAlert(param1:Number) : void
      {
         this.killPlayOptions();
         var _loc2_:String = "";
         _loc2_ = RiotResourceLoader.getString("bingePreventionMessage","Been playing too long now!",[param1]);
         var _loc3_:AlertAction = new AlertAction(RiotResourceLoader.getString("bingePreventionApproachingTitle","Been playing too long soon!"),_loc2_);
         _loc3_.add();
         if(this.cooldownTimer)
         {
            this.cooldownTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onBingeWindowCooldownTimer);
            this.cooldownTimer.stop();
            this.cooldownTimer = null;
         }
         this.cooldownTimer = this.createTimer(param1 * 60000);
         this.cooldownTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onBingeWindowCooldownTimer,false,0,true);
         this.cooldownTimer.start();
         this.sendMessageToGame(_loc2_);
      }
      
      public function apply(param1:Boolean, param2:Number, param3:Number = 0) : Boolean
      {
         if(this.isBingeSystemEnabledForClient)
         {
            if(param1)
            {
               this.displayInBingeNotificationAlert(param2);
               return true;
            }
            if(param3 > 0)
            {
               this.displayBingeApproachingNotificationAlert(param2);
            }
            return true;
         }
         return false;
      }
      
      public function onSessionMetricsProvided(param1:ISessionMetricsProvider) : void
      {
         this._sessionMetrics = param1;
         this._sessionMetrics.vietnamAntiAddictionLawSessionForceClosed();
      }
      
      public function displayBingeApproachingNotificationAlert(param1:Number) : void
      {
         var _loc2_:String = "";
         _loc2_ = RiotResourceLoader.getString("bingePreventionApproachingMessage","Been playing too long soon!",[param1]);
         var _loc3_:AlertAction = new AlertAction(RiotResourceLoader.getString("bingePreventionApproachingTitle","Been playing too long soon!"),_loc2_);
         _loc3_.add();
         this.sendMessageToGame(_loc2_);
      }
      
      private function createTimer(param1:Number) : Timer
      {
         if(param1 < 0)
         {
            param1 = 0;
         }
         return new Timer(param1 / 10,10);
      }
      
      private function sendMessageToGame(param1:String) : void
      {
         var _loc2_:GameChatXML = new GameChatXML();
         _loc2_.setStringValue(GameChatXML.ENTRY_NODE_TYPE,GameChatXML.CHAT_TYPE_AAS_NOTIFICATION);
         _loc2_.setStringValue(GameChatXML.ENTRY_NODE_AAS_MESSAGE,param1);
         MaestroProviderProxy.instance.sendChatMessage(_loc2_.getNode().toString());
      }
      
      private function onBingeWindowCooldownTimer(param1:TimerEvent) : void
      {
         AppConfig.instance.shutdownDisablePlayButton = false;
         this.applicationController.shutdownLawActive = false;
         this.cleanup();
      }
   }
}

