package com.riotgames.platform.gameclient.init
{
   import com.riotgames.platform.common.AppConfig;
   import com.riotgames.platform.common.RiotServiceConfig;
   import com.riotgames.platform.common.event.BroadcastMessageEvent;
   import com.riotgames.platform.common.event.RemoteServiceErrorEvent;
   import com.riotgames.platform.common.event.ShellEvent;
   import com.riotgames.platform.common.exception.InvalidSessionException;
   import com.riotgames.platform.common.exception.PlatformException;
   import com.riotgames.platform.common.resource.RiotResourceManager;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.common.utils.ClientErrorCodes;
   import com.riotgames.platform.common.utils.MessageDictionary;
   import com.riotgames.platform.gameclient.domain.broadcast.BroadcastMessage;
   import com.riotgames.platform.gameclient.domain.broadcast.BroadcastNotification;
   import com.riotgames.platform.gameclient.domain.broadcast.alert.BroadcastAlert;
   import com.riotgames.platform.gameclient.notification.ClientNotificationType;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.pvpnet.system.alerter.AlertErrorAction;
   import com.riotgames.pvpnet.system.alerter.AlertWaitAction;
   import com.riotgames.pvpnet.system.config.cdc.ConfigurationModel;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
   import com.riotgames.pvpnet.system.maestro.IMaestroProvider;
   import com.riotgames.pvpnet.system.maestro.MaestroController;
   import com.riotgames.pvpnet.system.messaging.BroadcastMessageControllerProxy;
   import com.riotgames.pvpnet.system.messaging.ShellDispatcher;
   import com.riotgames.pvpnet.system.notification.IServerStatusProvider;
   import com.riotgames.util.logging.ErrorUtil;
   import flash.events.Event;
   import flash.utils.getQualifiedClassName;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.managers.CursorManager;
   import mx.resources.ResourceManager;
   import mx.rpc.events.FaultEvent;
   
   public class AsyncAlertHandler
   {
      
      private var loggingOutWait:AlertWaitAction;
      
      private var rrM:RiotResourceManager;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var session:Session;
      
      private var serverStatusProvider:IServerStatusProvider;
      
      private var shellDispatcher:ShellDispatcher;
      
      private var serviceProxy:ServiceProxy;
      
      private var didClientError:Boolean = false;
      
      public function AsyncAlertHandler(param1:Session, param2:ShellDispatcher, param3:IServerStatusProvider, param4:IMaestroProvider, param5:ServiceProxy)
      {
         super();
         this.session = param1;
         this.shellDispatcher = param2;
         this.serverStatusProvider = param3;
         this.serviceProxy = param5;
         BroadcastMessageControllerProxy.instance.addMessageListener(ClientNotificationType.TICKER,this.onBroadcastMessageReceived);
         BroadcastMessageControllerProxy.instance.addMessageListener(ClientNotificationType.ALERT,this.onBroadcastAlertReceived);
         param2.addEventListener(RemoteServiceErrorEvent.AUTHENTICATION_CREDENTIALS_ERROR,this.onAuthenticationCredentialsError);
         param2.addEventListener(RemoteServiceErrorEvent.SESSION_TIMEOUT,this.onSessionExpired);
         param2.addEventListener(RemoteServiceErrorEvent.UNHANDLED_REMOTE_SERVICE_ERROR,this.handleUnhandledRemoteError);
         param2.addEventListener(RemoteServiceErrorEvent.CLIENT_ERROR,this.handleClientError);
         param2.addEventListener(RemoteServiceErrorEvent.UNKNOWN_ERROR,this.handleUnknownRemoteError);
         if(param4.getMaestroHeartbeatErrored().getHasDispatched())
         {
            this.onMaestroHeartbeatError();
         }
         else
         {
            param2.addEventListener(MaestroController.MAESTRO_HEARTBEAT_ERROR,this.onMaestroHeartbeatError);
         }
         if(param4.getMaestroConnectionErrored().getHasDispatched())
         {
            this.onMaestroConnectionError();
         }
         else
         {
            param2.addEventListener(MaestroController.MAESTRO_CONNECTION_ERROR,this.onMaestroConnectionError);
         }
         AppConfig.instance.loggingOutChanged.add(this.onLoggingOutChanged);
         this.rrM = RiotResourceManager.getInstance();
      }
      
      private function handleUnknownRemoteError(param1:RemoteServiceErrorEvent = null) : void
      {
         CursorManager.getInstance().removeAllCursors();
         var _loc2_:String = param1.faultEvent.message != null ? param1.faultEvent.message.toString() : null;
         this.logger.error("0003 handleUnknownRemoteError: message: {0}",_loc2_);
         var _loc3_:AlertErrorAction = new AlertErrorAction(this.rrM.getResourcesString(MessageDictionary.UNKNOWN_ERROR_TITLE),this.rrM.getResourcesString(MessageDictionary.UNKNOWN_ERROR),_loc2_);
         _loc3_.add();
      }
      
      private function onAuthenticationCredentialsError(param1:RemoteServiceErrorEvent = null) : void
      {
         this.cleanAuthenticationState();
         var _loc2_:AlertAction = new AlertAction(this.rrM.getResourcesString("session_authenticationCredentialsErrorTitle"),this.rrM.getResourcesString("session_authenticationCredentialsErrorMessage"));
         _loc2_.getCompleted().addOnce(this.handleExit);
         _loc2_.add();
      }
      
      private function onBroadcastMessageReceived(param1:BroadcastMessageEvent) : void
      {
         var _loc4_:BroadcastMessage = null;
         var _loc2_:ConfigurationModel = DynamicClientConfigManager.getConfiguration(RiotServiceConfig.SERVICE_STATUS_API_NAMESPACE,RiotServiceConfig.SERVICE_STATUS_API_ENABLED,false);
         if(_loc2_.getBoolean())
         {
            return;
         }
         var _loc3_:BroadcastNotification = param1.notification as BroadcastNotification;
         this.serverStatusProvider.clearPlatformMessages();
         if(_loc3_.broadcastMessages != null && _loc3_.broadcastMessages.length > 0)
         {
            for each(_loc4_ in _loc3_.broadcastMessages)
            {
               this.serverStatusProvider.addPlatformMessage(_loc4_);
            }
         }
      }
      
      private function handleExit() : void
      {
         this.shellDispatcher.dispatchEvent(new ShellEvent(ShellEvent.EXIT));
      }
      
      private function onBroadcastAlertReceived(param1:BroadcastMessageEvent) : void
      {
         var _loc2_:BroadcastAlert = param1.notification as BroadcastAlert;
         var _loc3_:String = ResourceManager.getInstance().getString("resources","alert_title");
         var _loc4_:AlertAction = new AlertAction(_loc3_,_loc2_.alertMessage);
         _loc4_.add();
      }
      
      private function onMaestroHeartbeatError(param1:Event = null) : void
      {
         var _loc2_:AlertAction = new AlertAction(this.rrM.getResourcesString("maestro_maestroConnectionErrorTitle"),this.rrM.getResourcesString("maestro_maestroHeartbeatErrorMessage"));
         _loc2_.getCompleted().addOnce(this.handleExit);
         _loc2_.add();
      }
      
      private function handleClientConnectionErrorDialog() : void
      {
         this.didClientError = false;
         if(!this.session.isLoggedIn)
         {
            this.handleExit();
         }
      }
      
      private function onMaestroConnectionError(param1:Event = null) : void
      {
         var _loc2_:AlertAction = new AlertAction(this.rrM.getResourcesString("maestro_maestroConnectionErrorTitle"),this.rrM.getResourcesString("maestro_maestroConnectionErrorMessage"));
         _loc2_.getCompleted().addOnce(this.handleExit);
         _loc2_.add();
      }
      
      private function handleUnhandledRemoteError(param1:RemoteServiceErrorEvent = null) : void
      {
         var _loc5_:AlertAction = null;
         var _loc6_:String = null;
         CursorManager.getInstance().removeAllCursors();
         var _loc2_:String = param1.faultEvent.message != null ? param1.faultEvent.message.toString() : "";
         var _loc3_:FaultEvent = param1.faultEvent;
         var _loc4_:Object = _loc3_.fault != null ? _loc3_.fault.rootCause : null;
         if(Boolean(_loc3_) && Boolean(_loc3_.fault))
         {
            this.logger.error(ErrorUtil.makeErrorMessage(_loc3_.fault,_loc2_));
         }
         else
         {
            this.logger.error("0002 handleUnhandledRemoteError: message: {0}",_loc2_);
         }
         if(_loc4_ is InvalidSessionException && Boolean(InvalidSessionException(_loc4_).errorCode))
         {
            this.onSessionExpired(param1);
         }
         else if(_loc4_ is PlatformException && Boolean(PlatformException(_loc4_).errorCode))
         {
            if(_loc4_.errorCode == "UNEXPECTED_ERROR")
            {
               _loc6_ = this.rrM.getResourcesString("GEN-00010");
            }
            else
            {
               _loc6_ = this.rrM.getResourcesString(_loc4_.errorCode);
            }
            _loc5_ = new AlertAction(this.rrM.getResourcesString("general_generalAlertErrorTitle"),_loc6_);
            _loc5_.add();
         }
         else
         {
            _loc5_ = new AlertErrorAction(this.rrM.getResourcesString(MessageDictionary.UNHANDLED_ERROR_TITLE),this.rrM.getResourcesString(MessageDictionary.UNHANDLED_ERROR),_loc2_);
            _loc5_.add();
         }
      }
      
      private function onLoggingOutChanged(param1:Boolean) : void
      {
         if(param1)
         {
            CursorManager.getInstance().setBusyCursor();
            if(this.loggingOutWait == null)
            {
               this.loggingOutWait = new AlertWaitAction(this.rrM.getResourcesString("serverWait_retrievingDataMessage"),this.rrM.getResourcesString("serverWait_loadingMessage"));
            }
            this.loggingOutWait.add();
         }
         else
         {
            if(this.loggingOutWait)
            {
               this.loggingOutWait.complete();
            }
            CursorManager.getInstance().removeBusyCursor();
         }
      }
      
      private function cleanAuthenticationState() : void
      {
         this.serviceProxy.remoteObjectGeneratorService.expireAuthenticationChannel();
         this.session.token = null;
         this.session.summoner = null;
      }
      
      private function handleClientError(param1:RemoteServiceErrorEvent = null) : void
      {
         var _loc2_:String = null;
         var _loc3_:AlertAction = null;
         CursorManager.getInstance().removeAllCursors();
         if(!this.didClientError)
         {
            this.didClientError = true;
            _loc2_ = param1.faultEvent.fault.faultCode == ClientErrorCodes.MESSAGE_SEND ? MessageDictionary.CONNECTION_TO_HOST_FAILED : MessageDictionary.REMOTE_SERVICE_REQUEST_TIMED_OUT;
            _loc3_ = new AlertAction(this.rrM.getResourcesString(MessageDictionary.CONNECTION_FAILED_TITLE),this.rrM.getResourcesString(_loc2_));
            _loc3_.getCompleted().addOnce(this.handleClientConnectionErrorDialog);
            _loc3_.add();
         }
      }
      
      private function onSessionExpired(param1:RemoteServiceErrorEvent = null) : void
      {
         this.cleanAuthenticationState();
         var _loc2_:AlertAction = new AlertAction(this.rrM.getResourcesString("session_sessionExpiredErrorTitle"),this.rrM.getResourcesString("session_sessionExpiredErrorMessage"));
         _loc2_.getCompleted().addOnce(this.handleExit);
         _loc2_.add();
      }
   }
}

