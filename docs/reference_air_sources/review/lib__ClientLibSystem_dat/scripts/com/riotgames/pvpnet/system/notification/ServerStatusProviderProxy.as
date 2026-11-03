package com.riotgames.pvpnet.system.notification
{
   import blix.signals.ISignal;
   import com.riotgames.platform.gameclient.controllers.notification.TickerMessageListener;
   import com.riotgames.platform.gameclient.domain.broadcast.BroadcastMessage;
   import com.riotgames.platform.provider.proxy.ProviderProxyBase;
   import mx.collections.ArrayCollection;
   
   public class ServerStatusProviderProxy extends ProviderProxyBase implements IServerStatusProvider
   {
      
      private static var _instance:IServerStatusProvider;
      
      public function ServerStatusProviderProxy()
      {
         super(IServerStatusProvider);
      }
      
      public static function get instance() : IServerStatusProvider
      {
         if(_instance == null)
         {
            _instance = new ServerStatusProviderProxy();
         }
         return _instance;
      }
      
      §§namespace("http://www.riotgames.com/pvpnet/internal") static function setInstance(param1:IServerStatusProvider) : void
      {
         _instance = param1;
      }
      
      public function addLocalMessage(param1:BroadcastMessage) : void
      {
         _invoke("addLocalMessage",[param1]);
      }
      
      public function addMessageListener(param1:TickerMessageListener) : void
      {
         _invoke("addMessageListener",[param1]);
      }
      
      public function addPlatformMessage(param1:BroadcastMessage) : void
      {
         _invoke("addPlatformMessage",[param1]);
      }
      
      public function addRemoteMessage(param1:BroadcastMessage) : void
      {
         _invoke("addRemoteMessage",[param1]);
      }
      
      public function getAllMessagesChanged() : ISignal
      {
         return _getSignal("getAllMessagesChanged");
      }
      
      public function getAllMessages() : ArrayCollection
      {
         var _loc1_:ArrayCollection = _invoke("getAllMessages") as ArrayCollection;
         if(_loc1_ != null)
         {
            return _loc1_;
         }
         return new ArrayCollection();
      }
      
      public function clearAllMessages() : void
      {
         _invoke("clearAllMessages");
      }
      
      public function clearLocalMessages() : void
      {
         _invoke("clearLocalMessages");
      }
      
      public function clearPlatformMessages() : void
      {
         _invoke("clearPlatformMessages");
      }
      
      public function clearRemoteMessages() : void
      {
         _invoke("clearRemoteMessages");
      }
      
      public function initializePoller() : void
      {
         _invoke("initializePoller");
      }
      
      public function initiateServerStatusMonitoring(param1:String, param2:String) : void
      {
         _invoke("initiateServerStatusMonitoring",[param1,param2]);
      }
      
      public function removeMessageListener(param1:TickerMessageListener) : void
      {
         _invoke("removeMessageListener",[param1]);
      }
      
      public function stopPolling() : void
      {
         _invoke("stopPolling");
      }
      
      public function getStatusRefreshed() : ISignal
      {
         return _getSignal("getStatusRefreshed");
      }
   }
}

