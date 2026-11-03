package com.riotgames.platform.gameclient.controllers.notification
{
   import com.riotgames.platform.common.AppConfig;
   import com.riotgames.platform.common.IAppController;
   import com.riotgames.platform.common.event.RemoteServiceErrorEvent;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.domain.broadcast.BroadcastMessage;
   import com.riotgames.pvpnet.system.notification.IServerStatusProvider;
   import com.riotgames.pvpnet.system.notification.ServerStatusProviderProxy;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.messaging.events.ChannelEvent;
   import mx.messaging.events.ChannelFaultEvent;
   import org.swizframework.core.IDispatcherAware;
   
   public class LocalStatusController extends EventDispatcher implements IDispatcherAware
   {
      
      public var serverStatusController:IServerStatusProvider = ServerStatusProviderProxy.instance;
      
      [Inject]
      public var applicationController:IAppController;
      
      private var applicationEventDispatcher:IEventDispatcher;
      
      private var _isLCDSInError:Boolean = false;
      
      public var serviceProxy:ServiceProxy = ServiceProxy.instance;
      
      [Inject]
      public var chatController:ChatController;
      
      public function LocalStatusController()
      {
         super();
      }
      
      private function onLCDSDisconnect(param1:Event) : void
      {
         if(Boolean(this.applicationController) && Boolean(!AppConfig.instance.loggingOut) && !this.applicationController.hasLogoutCompleted)
         {
            this.isLCDSInError = true;
         }
      }
      
      private function onLCDSConnect(param1:Event) : void
      {
         this.isLCDSInError = false;
      }
      
      private function set isLCDSInError(param1:Boolean) : void
      {
         if(param1 != this._isLCDSInError)
         {
            this._isLCDSInError = param1;
            this.updateMessages();
         }
      }
      
      public function set dispatcher(param1:IEventDispatcher) : void
      {
         this.applicationEventDispatcher = param1;
         this.applicationEventDispatcher.addEventListener(RemoteServiceErrorEvent.CLIENT_ERROR,this.onLCDSDisconnect);
         this.applicationEventDispatcher.addEventListener("lcdsServiceResponse",this.onLCDSConnect);
      }
      
      [PostConstruct]
      public function onInjectComplete() : void
      {
         this.serviceProxy.remoteObjectGeneratorService.addChannelSetListener(ChannelEvent.DISCONNECT,this.onLCDSDisconnect);
         this.serviceProxy.remoteObjectGeneratorService.addChannelSetListener(ChannelEvent.CONNECT,this.onLCDSConnect);
         this.serviceProxy.remoteObjectGeneratorService.addChannelSetListener(ChannelFaultEvent.FAULT,this.onLCDSDisconnect);
      }
      
      private function updateMessages() : void
      {
         var _loc2_:BroadcastMessage = null;
         var _loc3_:BroadcastMessage = null;
         if(!this.serverStatusController)
         {
            return;
         }
         this.serverStatusController.clearLocalMessages();
         var _loc1_:Array = [];
         if(this._isLCDSInError)
         {
            _loc2_ = new BroadcastMessage();
            if(!this.chatController || this.chatController.currentState != ChatController.ONLINE)
            {
               _loc2_.severity = "ERROR";
               _loc2_.messageKey = "totally_disconnected";
            }
            else
            {
               _loc2_.severity = "ERROR";
               _loc2_.messageKey = "lcds_disconnected";
            }
            _loc1_.push(_loc2_);
         }
         if(_loc1_.length > 0)
         {
            for each(_loc3_ in _loc1_)
            {
               this.serverStatusController.addLocalMessage(_loc3_);
            }
         }
      }
   }
}

