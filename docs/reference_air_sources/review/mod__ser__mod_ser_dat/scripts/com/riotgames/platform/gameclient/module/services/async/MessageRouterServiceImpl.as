package com.riotgames.platform.gameclient.module.services.async
{
   import com.riotgames.platform.common.AppConfig;
   import com.riotgames.platform.common.RiotServiceConfig;
   import com.riotgames.platform.common.services.MessageRouterService;
   import com.riotgames.platform.common.utils.ServiceLogger;
   import com.riotgames.platform.gameclient.domain.ServerSessionObject;
   import com.riotgames.platform.gameclient.module.services.RemoteObjectGenerator;
   import flash.utils.getQualifiedClassName;
   import mx.collections.ArrayCollection;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.messaging.Consumer;
   import mx.messaging.events.ChannelEvent;
   import mx.messaging.events.ChannelFaultEvent;
   import mx.messaging.events.MessageEvent;
   import mx.messaging.events.MessageFaultEvent;
   
   public class MessageRouterServiceImpl implements MessageRouterService
   {
      
      private var gameMessageListeners:ArrayCollection = new ArrayCollection();
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      public var clientIdBroadcast:String;
      
      public var remoteObjectGenerator:RemoteObjectGenerator;
      
      public var clientIdClient:String;
      
      public var config:RiotServiceConfig;
      
      private var gameMessageConsumer:Consumer;
      
      public var clientIdGame:String;
      
      private var broadcastMessageListeners:ArrayCollection = new ArrayCollection();
      
      private var clientNotificationMessageConsumer:Consumer;
      
      private var broadcastNotificationConsumer:Consumer;
      
      private var clientNotificationMessageListeners:ArrayCollection = new ArrayCollection();
      
      public function MessageRouterServiceImpl()
      {
         super();
      }
      
      public function removeClientNotificationMessageListener(param1:Function) : void
      {
         var _loc2_:int = int(this.clientNotificationMessageListeners.getItemIndex(param1));
         if(_loc2_ >= 0)
         {
            this.clientNotificationMessageListeners.removeItemAt(_loc2_);
         }
      }
      
      public function subscribePlatformGameConsumer() : void
      {
         this.subscribeGameConsumer(this.gameMessageConsumer,this.clientIdGame,this.clientIdGame);
      }
      
      private function onBroadcastMessageReceived(param1:MessageEvent) : void
      {
         ServiceLogger.asyncBroadcast("messageRouterService","onBroadcastMessageReceived",[param1]);
         this.fireBroadcastMessage(param1);
      }
      
      public function addClientNotificationMessageListener(param1:Function) : void
      {
         this.clientNotificationMessageListeners.addItem(param1);
      }
      
      public function unsubscribePlatformGameConsumer() : void
      {
         this.unsubscribeGameConsumer(this.gameMessageConsumer);
      }
      
      public function initialize(param1:ServerSessionObject) : void
      {
         var _loc2_:String = null;
         if(!this.config.useCache)
         {
            _loc2_ = param1.accountSummary.accountId.toString();
            this.clientIdGame = "gn-" + _loc2_;
            this.clientIdClient = "cn-" + _loc2_;
            this.clientIdBroadcast = "bc-" + _loc2_;
            this.gameMessageConsumer = new Consumer();
            this.gameMessageConsumer.destination = this.config.messaging_dest;
            this.gameMessageConsumer.channelSet = this.remoteObjectGenerator.defaultChannelSet;
            this.subscribeGameConsumer(this.gameMessageConsumer,this.clientIdGame,this.clientIdGame);
            this.clientNotificationMessageConsumer = new Consumer();
            this.clientNotificationMessageConsumer.destination = this.config.messaging_dest;
            this.clientNotificationMessageConsumer.channelSet = this.remoteObjectGenerator.defaultChannelSet;
            this.subscribeConsumer(this.clientNotificationMessageConsumer,this.clientIdClient,this.clientIdClient,this.onClientNotificationMessageReceived);
            this.broadcastNotificationConsumer = new Consumer();
            this.broadcastNotificationConsumer.destination = this.config.messaging_dest;
            this.broadcastNotificationConsumer.channelSet = this.remoteObjectGenerator.defaultChannelSet;
            this.subscribeConsumer(this.broadcastNotificationConsumer,this.clientIdBroadcast,"bc",this.onBroadcastMessageReceived);
         }
         ServiceLogger.request("messageRouterService","initialize",[param1]);
      }
      
      public function disconnect() : void
      {
         this.unsubscribePlatformGameConsumer();
         if(this.clientNotificationMessageConsumer != null && Boolean(this.clientNotificationMessageConsumer.connected))
         {
            this.clientNotificationMessageConsumer.unsubscribe(false);
         }
         if(this.broadcastNotificationConsumer != null && Boolean(this.broadcastNotificationConsumer.connected))
         {
            this.broadcastNotificationConsumer.unsubscribe(false);
         }
         ServiceLogger.request("messageRouterService","disconnect");
      }
      
      private function onChannelConnect(param1:ChannelEvent) : void
      {
      }
      
      public function addGameMessageListener(param1:Function) : void
      {
         var _loc2_:int = int(this.gameMessageListeners.getItemIndex(param1));
         if(_loc2_ == -1)
         {
            this.gameMessageListeners.addItem(param1);
         }
      }
      
      public function addBroadcastMessageListener(param1:Function) : void
      {
         this.broadcastMessageListeners.addItem(param1);
      }
      
      public function fireGameMessage(param1:MessageEvent) : void
      {
         var _loc3_:Function = null;
         this.remoteObjectGenerator.onAsynchronousMessageReceived(param1);
         var _loc2_:Array = new Array();
         for each(_loc3_ in this.gameMessageListeners)
         {
            _loc2_.push(_loc3_);
         }
         while(_loc2_.length > 0)
         {
            _loc3_ = _loc2_.shift();
            _loc3_.apply(this,[param1]);
         }
      }
      
      private function onClientNotificationMessageReceived(param1:MessageEvent) : void
      {
         ServiceLogger.asyncClient("messageRouterService","onClientNotificationMessageReceived",[param1]);
         this.fireClientNotificationMessage(param1);
      }
      
      public function fireClientNotificationMessage(param1:MessageEvent) : void
      {
         var _loc2_:Function = null;
         this.remoteObjectGenerator.onAsynchronousMessageReceived(param1);
         for each(_loc2_ in this.clientNotificationMessageListeners)
         {
            _loc2_.apply(this,[param1]);
         }
      }
      
      public function invalidateConsumers() : void
      {
         this.broadcastNotificationConsumer = null;
         this.clientNotificationMessageConsumer = null;
         this.gameMessageConsumer = null;
      }
      
      private function onGameMessageReceived(param1:MessageEvent) : void
      {
         ServiceLogger.asyncGame("messageRouterService","onGameMessageReceived",[param1]);
         this.fireGameMessage(param1);
      }
      
      private function onMessageFault(param1:MessageFaultEvent) : void
      {
      }
      
      private function onChannelFault(param1:ChannelFaultEvent) : void
      {
         this.logger.warn("0002 MessageRouter ChannelFaultEvent.");
      }
      
      private function subscribeConsumer(param1:Consumer, param2:String, param3:String, param4:Function) : void
      {
         if(param1 != null)
         {
            param1.addEventListener(MessageEvent.MESSAGE,param4);
            param1.addEventListener(ChannelEvent.CONNECT,this.onChannelConnect);
            param1.addEventListener(ChannelEvent.DISCONNECT,this.onChannelDisconnect);
            param1.addEventListener(ChannelFaultEvent.FAULT,this.onChannelFault);
            param1.addEventListener(MessageFaultEvent.FAULT,this.onMessageFault);
            param1.subtopic = param3;
            param1.resubscribeAttempts = 30;
            param1.resubscribeInterval = 10000;
            param1.subscribe(param2);
            ServiceLogger.request("messageRouterService","subscribeConsumer",[param1]);
         }
      }
      
      public function removeGameMessageListener(param1:Function) : void
      {
         var _loc2_:int = int(this.gameMessageListeners.getItemIndex(param1));
         if(_loc2_ >= 0)
         {
            this.gameMessageListeners.removeItemAt(_loc2_);
         }
      }
      
      private function fireBroadcastMessage(param1:MessageEvent) : void
      {
         var _loc2_:Function = null;
         this.remoteObjectGenerator.onAsynchronousMessageReceived(param1);
         for each(_loc2_ in this.broadcastMessageListeners)
         {
            _loc2_.apply(this,[param1]);
         }
      }
      
      private function onChannelDisconnect(param1:ChannelEvent) : void
      {
         if(!AppConfig.instance.loggingOut)
         {
            this.logger.warn("0001 MessageRouter Channel Disconnected.");
         }
      }
      
      public function subscribeGameConsumer(param1:Consumer, param2:String, param3:String) : void
      {
         this.subscribeConsumer(param1,param2,param3,this.onGameMessageReceived);
      }
      
      private function unsubscribeConsumer(param1:Consumer, param2:Function) : void
      {
         if(param1 != null && Boolean(param1.connected))
         {
            param1.unsubscribe(true);
            param1.removeEventListener(MessageEvent.MESSAGE,param2);
            param1.removeEventListener(ChannelEvent.CONNECT,this.onChannelConnect);
            param1.removeEventListener(ChannelEvent.DISCONNECT,this.onChannelDisconnect);
            param1.removeEventListener(ChannelFaultEvent.FAULT,this.onChannelFault);
            param1.removeEventListener(MessageFaultEvent.FAULT,this.onMessageFault);
            ServiceLogger.request("messageRouterService","unsubscribeConsumer",[param1]);
         }
      }
      
      public function unsubscribeGameConsumer(param1:Consumer) : void
      {
         this.unsubscribeConsumer(param1,this.onGameMessageReceived);
      }
      
      public function removeBroadcastMessageListener(param1:Function) : void
      {
         var _loc2_:int = int(this.broadcastMessageListeners.getItemIndex(param1));
         if(_loc2_ >= 0)
         {
            this.broadcastMessageListeners.removeItemAt(_loc2_);
         }
      }
   }
}

