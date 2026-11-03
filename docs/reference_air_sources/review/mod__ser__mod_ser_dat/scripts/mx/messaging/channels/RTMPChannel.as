package mx.messaging.channels
{
   import flash.events.IOErrorEvent;
   import flash.events.NetStatusEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.TimerEvent;
   import flash.net.NetConnection;
   import flash.net.ObjectEncoding;
   import flash.utils.Timer;
   import mx.core.mx_internal;
   import mx.logging.Log;
   import mx.messaging.FlexClient;
   import mx.messaging.config.ServerConfig;
   import mx.messaging.events.ChannelFaultEvent;
   import mx.messaging.messages.AbstractMessage;
   import mx.messaging.messages.CommandMessage;
   import mx.utils.ArrayUtil;
   import mx.utils.ObjectUtil;
   import mx.utils.URLUtil;
   
   use namespace mx_internal;
   
   public class RTMPChannel extends NetConnectionChannel
   {
      
      protected var _tempNCs:Array = [];
      
      protected var _concurrentConnectTimer:Timer = new Timer(2000,1);
      
      public function RTMPChannel(param1:String = null, param2:String = null)
      {
         super(param1,param2);
         _concurrentConnectTimer.addEventListener(TimerEvent.TIMER,concurrentConnectHandler);
      }
      
      override public function enablePolling() : void
      {
      }
      
      override protected function timerRequired() : Boolean
      {
         return false;
      }
      
      override public function poll() : void
      {
      }
      
      override public function get connected() : Boolean
      {
         return netConnection.connected;
      }
      
      protected function isLastTempNC() : Boolean
      {
         return _tempNCs.length == 0 && !_concurrentConnectTimer.running ? true : false;
      }
      
      protected function tempStatusHandler(param1:NetStatusEvent) : void
      {
         var info:Object;
         var channelFault:ChannelFaultEvent = null;
         var level:String = null;
         var code:String = null;
         var serverVersion:Number = NaN;
         var event:NetStatusEvent = param1;
         var nc:NetConnection = event.target as NetConnection;
         if(!shouldHandleEvent(nc))
         {
            return;
         }
         if(Log.isDebug())
         {
            _log.debug("\'{0}\' channel got connect attempt status. {1}",id,ObjectUtil.toString(event.info));
         }
         info = event.info;
         try
         {
            level = info.level;
            code = info.code;
         }
         catch(error:Error)
         {
            return;
         }
         if(code.indexOf("Connect.Success") > -1)
         {
            ServerConfig.mx_internal::updateServerConfigData(info.serverConfig,endpoint);
            if(FlexClient.getInstance().id == null)
            {
               FlexClient.getInstance().id = info.id;
            }
            if(info[CommandMessage.MESSAGING_VERSION] != null)
            {
               serverVersion = info[CommandMessage.MESSAGING_VERSION] as Number;
               handleServerMessagingVersion(serverVersion);
            }
            setUpMainNC(nc);
            return;
         }
         if(code.indexOf("Connect.Failed") > -1)
         {
            channelFault = ChannelFaultEvent.createEvent(this,false,"Channel.Connect.Failed",info.level,info.description + " url:\'" + endpoint + "\'");
            channelFault.rootCause = info;
         }
         else
         {
            if(code.indexOf("Connect.Rejected") > -1)
            {
               shutdownTempNCs();
               channelFault = ChannelFaultEvent.createEvent(this,false,"Channel.Connect.Failed","Connection rejected: \'" + endpoint + "\'",info.description + " url:\'" + endpoint + "\'",true);
               channelFault.rootCause = info;
               connectFailed(channelFault);
               return;
            }
            if(code.indexOf("SSLNotAvailable") > -1 || code.indexOf("SSLHandshakeFailed") > -1 || code.indexOf("CertificateExpired") > -1 || code.indexOf("CertificatePrincipalMismatch") > -1 || code.indexOf("CertificateUntrustedSigner") > -1 || code.indexOf("CertificateRevoked") > -1 || code.indexOf("CertificateInvalid") > -1 || code.indexOf("ClientCertificateInvalid") > -1 || code.indexOf("SSLCipherFailure") > -1 || code.indexOf("CertificateAPIError") > -1)
            {
               _concurrentConnectTimer.stop();
               return;
            }
            channelFault = ChannelFaultEvent.createEvent(this,false,"Channel.Connect.Failed","error","Failed on url: \'" + endpoint + "\'");
            channelFault.rootCause = info;
         }
         shutdownTempNC(nc);
         if(isLastTempNC())
         {
            connectFailed(channelFault);
         }
      }
      
      protected function shutdownTempNCs(param1:NetConnection = null) : void
      {
         var _loc2_:NetConnection = null;
         if(_concurrentConnectTimer.running)
         {
            _concurrentConnectTimer.stop();
         }
         while(_tempNCs.length)
         {
            _loc2_ = _tempNCs.pop() as NetConnection;
            if(_loc2_ != param1)
            {
               shutdownTempNC(_loc2_);
            }
         }
      }
      
      protected function concurrentConnectHandler(param1:TimerEvent) : void
      {
         _concurrentConnectTimer.stop();
         var _loc2_:NetConnection = buildTempNC();
         _loc2_.proxyType = "http";
         _tempNCs.push(_loc2_);
         var _loc3_:String = endpoint.replace("rtmp:","rtmpt:");
         var _loc4_:String = FlexClient.getInstance().id;
         if(_loc4_ == null)
         {
            _loc4_ = FlexClient.mx_internal::NULL_FLEXCLIENT_ID;
         }
         if(credentials != null)
         {
            _loc2_.connect(_loc3_,ServerConfig.mx_internal::needsConfig(this),_loc4_,credentials,buildHandshakeMessage());
         }
         else
         {
            _loc2_.connect(_loc3_,ServerConfig.mx_internal::needsConfig(this),_loc4_,"",buildHandshakeMessage());
         }
      }
      
      override public function get protocol() : String
      {
         var _loc1_:String = URLUtil.getProtocol(uri);
         if(_loc1_ == "rtmpt")
         {
            return "rtmpt";
         }
         return "rtmp";
      }
      
      protected function buildTempNC() : NetConnection
      {
         var _loc1_:NetConnection = new NetConnection();
         _loc1_.objectEncoding = netConnection != null ? uint(netConnection.objectEncoding) : ObjectEncoding.AMF3;
         _loc1_.client = this;
         _loc1_.proxyType = "best";
         _loc1_.addEventListener(NetStatusEvent.NET_STATUS,tempStatusHandler);
         _loc1_.addEventListener(SecurityErrorEvent.SECURITY_ERROR,tempSecurityErrorHandler);
         _loc1_.addEventListener(IOErrorEvent.IO_ERROR,tempIOErrorHandler);
         return _loc1_;
      }
      
      protected function shouldHandleEvent(param1:NetConnection) : Boolean
      {
         return ArrayUtil.getItemIndex(param1,_tempNCs) != -1 ? true : false;
      }
      
      protected function buildHandshakeMessage() : CommandMessage
      {
         var _loc1_:CommandMessage = new CommandMessage();
         _loc1_.headers[CommandMessage.MESSAGING_VERSION] = messagingVersion;
         if(ServerConfig.mx_internal::needsConfig(this))
         {
            _loc1_.headers[CommandMessage.NEEDS_CONFIG_HEADER] = true;
         }
         _loc1_.headers[AbstractMessage.FLEX_CLIENT_ID_HEADER] = id;
         if(credentials != null)
         {
            _loc1_.operation = CommandMessage.LOGIN_OPERATION;
            _loc1_.body = credentials;
         }
         else
         {
            _loc1_.operation = CommandMessage.CLIENT_PING_OPERATION;
         }
         return _loc1_;
      }
      
      protected function attemptConcurrentConnect() : void
      {
         var _loc1_:String = URLUtil.getProtocol(uri);
         if(_loc1_ == "rtmpt")
         {
            return;
         }
         _concurrentConnectTimer.start();
      }
      
      protected function setUpMainNC(param1:NetConnection) : void
      {
         shutdownTempNCs(param1);
         param1.removeEventListener(NetStatusEvent.NET_STATUS,tempStatusHandler);
         param1.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,tempSecurityErrorHandler);
         param1.removeEventListener(IOErrorEvent.IO_ERROR,tempIOErrorHandler);
         param1.addEventListener(NetStatusEvent.NET_STATUS,statusHandler);
         param1.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler);
         param1.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
         _nc = param1;
         connectSuccess();
         mx_internal::setAuthenticated(credentials != null);
      }
      
      override protected function internalConnect() : void
      {
         var _loc1_:NetConnection = buildTempNC();
         _tempNCs.push(_loc1_);
         var _loc2_:String = FlexClient.getInstance().id;
         if(_loc2_ == null)
         {
            _loc2_ = FlexClient.mx_internal::NULL_FLEXCLIENT_ID;
         }
         attemptConcurrentConnect();
         if(credentials != null)
         {
            _loc1_.connect(endpoint,ServerConfig.mx_internal::needsConfig(this),_loc2_,credentials,buildHandshakeMessage());
         }
         else
         {
            _loc1_.connect(endpoint,ServerConfig.mx_internal::needsConfig(this),_loc2_,"",buildHandshakeMessage());
         }
      }
      
      override mx_internal function get realtime() : Boolean
      {
         return true;
      }
      
      protected function tempSecurityErrorHandler(param1:SecurityErrorEvent) : void
      {
         var _loc2_:NetConnection = param1.target as NetConnection;
         if(!shouldHandleEvent(_loc2_))
         {
            return;
         }
         if(Log.isDebug())
         {
            _log.debug("\'{0}\' channel got SecurityError from temporary NetConnection connect attempt. {1}",id,ObjectUtil.toString(param1));
         }
         shutdownTempNC(_loc2_);
         if(isLastTempNC())
         {
            securityErrorHandler(param1);
         }
      }
      
      override protected function statusHandler(param1:NetStatusEvent) : void
      {
         var info:Object;
         var channelFault:ChannelFaultEvent = null;
         var level:String = null;
         var code:String = null;
         var event:NetStatusEvent = param1;
         if(Log.isDebug())
         {
            _log.debug("\'{0}\' channel got runtime status. {1}",id,ObjectUtil.toString(event.info));
         }
         info = event.info;
         try
         {
            level = info.level;
            code = info.code;
         }
         catch(error:Error)
         {
            return;
         }
         if(code.indexOf("Connect.Closed") > -1)
         {
            if(info.description != null && (info.description.indexOf("Timed Out") != -1 || info.description.indexOf("Force Close") != -1))
            {
               internalDisconnect(true);
            }
            else
            {
               internalDisconnect();
            }
            return;
         }
         if(Log.isWarn())
         {
            _log.warn("\'{0}\' channel connection failed. {1}",id,ObjectUtil.toString(event.info));
         }
         channelFault = ChannelFaultEvent.createEvent(this,false,"Channel.Connect.Failed",info.level,info.description + " url:\'" + endpoint + "\'");
         channelFault.rootCause = info;
         shutdownNetConnection();
         connectFailed(channelFault);
      }
      
      override protected function internalDisconnect(param1:Boolean = false) : void
      {
         shutdownTempNCs();
         super.internalDisconnect(param1);
      }
      
      override protected function connectTimeoutHandler(param1:TimerEvent) : void
      {
         shutdownTempNCs();
         shutdownNetConnection();
         super.connectTimeoutHandler(param1);
      }
      
      override public function disablePolling() : void
      {
      }
      
      protected function tempIOErrorHandler(param1:IOErrorEvent) : void
      {
         var _loc2_:NetConnection = param1.target as NetConnection;
         if(!shouldHandleEvent(_loc2_))
         {
            return;
         }
         if(Log.isDebug())
         {
            _log.debug("\'{0}\' channel got IOError from temporary NetConnection connect attempt. {1}",id,ObjectUtil.toString(param1));
         }
         shutdownTempNC(_loc2_);
         if(isLastTempNC())
         {
            ioErrorHandler(param1);
         }
      }
      
      protected function shutdownTempNC(param1:NetConnection) : void
      {
         param1.close();
         var _loc2_:int = int(ArrayUtil.getItemIndex(param1,_tempNCs));
         if(_loc2_ != -1)
         {
            _tempNCs.splice(_loc2_,1);
         }
      }
   }
}

