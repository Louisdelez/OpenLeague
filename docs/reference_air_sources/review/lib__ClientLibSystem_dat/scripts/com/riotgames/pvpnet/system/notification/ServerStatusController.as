package com.riotgames.pvpnet.system.notification
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.AppConfig;
   import com.riotgames.platform.common.RiotServiceConfig;
   import com.riotgames.platform.common.event.ServerStatusEvent;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.controllers.notification.TickerMessageListener;
   import com.riotgames.platform.gameclient.domain.broadcast.BroadcastMessage;
   import com.riotgames.platform.gameclient.domain.game.GameMap;
   import com.riotgames.pvpnet.system.config.PlatformConfig;
   import com.riotgames.pvpnet.system.config.PlatformConfigProviderProxy;
   import com.riotgames.pvpnet.system.config.cdc.ConfigurationModel;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   import mx.events.CollectionEvent;
   
   public class ServerStatusController implements IServerStatusProvider
   {
      
      private static const _POLL_TIME:int = 60 * 1000;
      
      public var serviceProxy:ServiceProxy = ServiceProxy.instance;
      
      private var _pollTimer:Timer;
      
      private var _platformMessages:Vector.<BroadcastMessage> = new Vector.<BroadcastMessage>();
      
      private var _remoteMessages:Vector.<BroadcastMessage> = new Vector.<BroadcastMessage>();
      
      private var _localMessages:Vector.<BroadcastMessage> = new Vector.<BroadcastMessage>();
      
      private var _allMessages:ArrayCollection = new ArrayCollection();
      
      private var _expiryTimers:Dictionary = new Dictionary();
      
      private var _remoteMessageListeners:IList;
      
      private var _allMessagesChanged:Signal = new Signal();
      
      public function ServerStatusController()
      {
         super();
         PlatformConfigProviderProxy.instance.getPlatformConfig().platformConfigChanged.add(this.onPlatformConfigChanged);
         AppConfig.instance.availableMapsChanged.add(this.onGameMapsChanged);
      }
      
      private function onPlatformConfigChanged(param1:PlatformConfig) : void
      {
         this.clearLocalMessages();
      }
      
      private function onGameMapsChanged(param1:ArrayCollection) : void
      {
         var _loc5_:BroadcastMessage = null;
         if(param1.length == 0)
         {
            return;
         }
         var _loc2_:Boolean = false;
         var _loc3_:GameMap = null;
         var _loc4_:GameMap = param1.getItemAt(0) as GameMap;
         for each(_loc3_ in param1)
         {
            if(_loc3_.minCustomPlayers != _loc4_.minCustomPlayers)
            {
               _loc2_ = true;
               break;
            }
         }
         _loc5_ = null;
         if(_loc2_)
         {
            for each(_loc3_ in param1)
            {
               if(_loc3_.minCustomPlayers > 1 && _loc3_.mapId != 2)
               {
                  _loc5_ = new BroadcastMessage();
                  _loc5_.content = RiotResourceLoader.getString("throttleMessages_PlayerLimitUponEnteringSingle","There\'s a limit for player count.",[_loc3_.displayName,_loc3_.minCustomPlayers]);
                  _loc5_.severity = "INFO";
                  this.addLocalMessage(_loc5_);
               }
            }
         }
         else if(Boolean(_loc3_) && _loc3_.minCustomPlayers > 1)
         {
            _loc5_ = new BroadcastMessage();
            _loc5_.content = RiotResourceLoader.getString("throttleMessages_PlayerLimitUponEnteringAll","There\'s a limit for player count.",[_loc3_.minCustomPlayers]);
            _loc5_.severity = "INFO";
            this.addLocalMessage(_loc5_);
         }
      }
      
      private function updateStatus(param1:ServerStatusEvent) : void
      {
         this._remoteMessages = param1.messages;
         this.combineArrays();
         this.startPolling();
         this.fireMessagesReceived(param1.messages);
      }
      
      private function updateStatusFailed(param1:ServerStatusEvent) : void
      {
         this.clearRemoteMessages();
         this.startPolling();
      }
      
      private function startPolling() : void
      {
         this._pollTimer.start();
      }
      
      public function initializePoller() : void
      {
         this._pollTimer = new Timer(_POLL_TIME);
         this._pollTimer.addEventListener(TimerEvent.TIMER,this.timerTick);
      }
      
      public function stopPolling() : void
      {
         if(this._pollTimer != null)
         {
            this._pollTimer.stop();
            this._pollTimer.reset();
         }
      }
      
      private function timerTick(param1:TimerEvent) : void
      {
         this.serviceProxy.serverStatusService.getServerStatus();
      }
      
      public function addRemoteMessage(param1:BroadcastMessage) : void
      {
         this.addMessage(this._remoteMessages,param1);
         this.combineArrays();
         this.fireMessageReceived(param1);
      }
      
      public function addLocalMessage(param1:BroadcastMessage) : void
      {
         this.addMessage(this._localMessages,param1);
         this.combineArrays();
         this.fireMessageReceived(param1);
      }
      
      public function addPlatformMessage(param1:BroadcastMessage) : void
      {
         this.addMessage(this._platformMessages,param1);
         this.combineArrays();
         this.fireMessageReceived(param1);
      }
      
      protected function allMessagesChangedHandler(param1:CollectionEvent = null) : void
      {
         this._allMessagesChanged.dispatch(this._allMessages);
      }
      
      private function addMessage(param1:Vector.<BroadcastMessage>, param2:BroadcastMessage) : void
      {
         var _loc3_:Timer = null;
         param1.push(param2);
         if(param2.expiryTime > 0)
         {
            _loc3_ = new Timer(param2.expiryTime,1);
            _loc3_.addEventListener(TimerEvent.TIMER_COMPLETE,this.handleExpiryTimer,false,0,true);
            _loc3_.start();
            this._expiryTimers[_loc3_] = param2;
         }
      }
      
      private function handleExpiryTimer(param1:TimerEvent) : void
      {
         var _loc2_:Timer = param1.target as Timer;
         var _loc3_:BroadcastMessage = this._expiryTimers[_loc2_] as BroadcastMessage;
         delete this._expiryTimers[_loc2_];
         if(_loc3_ != null)
         {
            this._remoteMessages = this.excludeMessage(this._remoteMessages,_loc3_);
            this._localMessages = this.excludeMessage(this._localMessages,_loc3_);
            this._platformMessages = this.excludeMessage(this._platformMessages,_loc3_);
            this.combineArrays();
         }
      }
      
      private function excludeMessage(param1:Vector.<BroadcastMessage>, param2:BroadcastMessage) : Vector.<BroadcastMessage>
      {
         var _loc4_:BroadcastMessage = null;
         var _loc3_:Vector.<BroadcastMessage> = new Vector.<BroadcastMessage>();
         for each(_loc4_ in param1)
         {
            if(_loc4_ != param2)
            {
               _loc3_.push(_loc4_);
            }
         }
         return _loc3_;
      }
      
      private function combineArrays() : void
      {
         var _loc2_:BroadcastMessage = null;
         var _loc1_:Vector.<BroadcastMessage> = this._localMessages.concat(this._platformMessages.concat(this._remoteMessages));
         this._allMessages.removeAll();
         for each(_loc2_ in _loc1_)
         {
            this._allMessages.addItem(_loc2_);
         }
         this._allMessagesChanged.dispatch(this._allMessages);
      }
      
      public function initiateServerStatusMonitoring(param1:String, param2:String) : void
      {
         this.serviceProxy.serverStatusService.addEventListener(ServerStatusEvent.STATUS_RECEIVED,this.updateStatus);
         this.serviceProxy.serverStatusService.addEventListener(ServerStatusEvent.STATUS_FAILED,this.updateStatusFailed);
         this.serviceProxy.serverStatusService.endpointString = param1;
         this.serviceProxy.serverStatusService.hostString = param2;
         this.initializePoller();
         this.updatePolling();
      }
      
      public function updatePolling() : void
      {
         var _loc1_:ConfigurationModel = DynamicClientConfigManager.getConfiguration(RiotServiceConfig.SERVICE_STATUS_API_NAMESPACE,RiotServiceConfig.SERVICE_STATUS_API_ENABLED,false,this.updatePolling);
         if(_loc1_.getBoolean())
         {
            this.clearPlatformMessages();
            this.serviceProxy.serverStatusService.getServerStatus();
            this.startPolling();
         }
         else
         {
            this.clearRemoteMessages();
            this.stopPolling();
         }
      }
      
      public function clearPlatformMessages() : void
      {
         this._platformMessages = new Vector.<BroadcastMessage>();
         this.combineArrays();
      }
      
      public function clearRemoteMessages() : void
      {
         this._remoteMessages = new Vector.<BroadcastMessage>();
         this.combineArrays();
      }
      
      public function clearLocalMessages() : void
      {
         this._localMessages = new Vector.<BroadcastMessage>();
         this.combineArrays();
      }
      
      public function clearAllMessages() : void
      {
         this.clearRemoteMessages();
         this.clearPlatformMessages();
         this.clearLocalMessages();
         this.combineArrays();
      }
      
      public function getAllMessagesChanged() : ISignal
      {
         return this._allMessagesChanged;
      }
      
      public function getAllMessages() : ArrayCollection
      {
         return this._allMessages;
      }
      
      public function addMessageListener(param1:TickerMessageListener) : void
      {
         if(this._remoteMessageListeners == null)
         {
            this._remoteMessageListeners = new ArrayCollection();
         }
         this._remoteMessageListeners.addItem(param1);
      }
      
      public function removeMessageListener(param1:TickerMessageListener) : void
      {
         var _loc2_:int = 0;
         if(this._remoteMessageListeners != null)
         {
            _loc2_ = int(this._remoteMessageListeners.getItemIndex(param1));
            if(_loc2_ >= 0)
            {
               this._remoteMessageListeners.removeItemAt(_loc2_);
            }
         }
      }
      
      public function getStatusRefreshed() : ISignal
      {
         return this.serviceProxy.serverStatusService.getStatusRefreshed();
      }
      
      private function fireMessageReceived(param1:BroadcastMessage) : void
      {
         var _loc2_:Vector.<BroadcastMessage> = new Vector.<BroadcastMessage>();
         _loc2_.push(param1);
         this.fireMessagesReceived(_loc2_);
      }
      
      private function fireMessagesReceived(param1:Vector.<BroadcastMessage>) : void
      {
         var _loc2_:TickerMessageListener = null;
         if(this._remoteMessageListeners != null)
         {
            for each(_loc2_ in this._remoteMessageListeners)
            {
               _loc2_.tickerMessagesReceived(param1);
            }
         }
      }
   }
}

