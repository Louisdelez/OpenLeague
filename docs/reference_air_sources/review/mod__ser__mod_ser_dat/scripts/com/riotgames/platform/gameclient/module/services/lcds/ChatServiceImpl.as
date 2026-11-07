package com.riotgames.platform.gameclient.module.services.lcds
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.domain.XMPPMessageSubjectTypes;
   import com.riotgames.platform.common.event.LoginEvent2;
   import com.riotgames.platform.common.services.ChatService;
   import com.riotgames.platform.common.services.ChatServiceState;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.common.utils.MultiValueProperty;
   import com.riotgames.platform.common.utils.ServiceLogger;
   import com.riotgames.platform.common.xmpp.data.commands.CmdExtAnnounce;
   import com.riotgames.platform.common.xmpp.data.privatedata.RiotPrivateDataExtension;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.clearTimeout;
   import flash.utils.getQualifiedClassName;
   import flash.utils.setTimeout;
   import flash.xml.XMLNode;
   import flash.xml.XMLNodeType;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import org.igniterealtime.xiff.conference.InviteListener;
   import org.igniterealtime.xiff.core.EscapedJID;
   import org.igniterealtime.xiff.core.UnescapedJID;
   import org.igniterealtime.xiff.core.XMPPSocketConnection;
   import org.igniterealtime.xiff.data.IQ;
   import org.igniterealtime.xiff.data.Message;
   import org.igniterealtime.xiff.data.Presence;
   import org.igniterealtime.xiff.data.XMPPStanza;
   import org.igniterealtime.xiff.data.im.RosterItemVO;
   import org.igniterealtime.xiff.data.privatedata.PrivateDataExtension;
   import org.igniterealtime.xiff.events.ConnectionSuccessEvent;
   import org.igniterealtime.xiff.events.DisconnectionEvent;
   import org.igniterealtime.xiff.events.IncomingDataEvent;
   import org.igniterealtime.xiff.events.LoginEvent;
   import org.igniterealtime.xiff.events.OutgoingDataEvent;
   import org.igniterealtime.xiff.events.XIFFErrorEvent;
   import org.igniterealtime.xiff.privatedata.IPrivatePayload;
   import org.igniterealtime.xiff.privatedata.PrivateDataManager;
   import org.igniterealtime.xiff.util.Callback;
   
   public class ChatServiceImpl extends EventDispatcher implements ChatService
   {
      
      public static const XMPP_CODE_SERVICE_UNAVAILABLE:int = 503;
      
      public static const XMPP_RECONNECTION_INTERVAL:int = 60000;
      
      public static const XMPP_RECONNECTION_DISABLED:int = -1;
      
      public static const XMPP_RECONNECTION_IMMEDIATE_INTERVAL:int = 20000;
      
      public static const XMPP_RECONNECTION_RETRY_LIMIT:int = 2;
      
      public static const XMPP_KEEP_ALIVE_INTERVAL:int = 60000;
      
      public static const XMPP_PRIVATE_DATA_REQUEST_TIMEOUT:int = 2000;
      
      private var reconnectionTimeoutId:uint = 0;
      
      private var _reconnectionInterval:int = -1;
      
      private var privateDataManager:PrivateDataManager;
      
      private var _reconnectionRetryLimit:int = 2;
      
      private var _loginSuccessfulSignal:Signal = new Signal();
      
      private var reconnectionTimer:Timer;
      
      private var _currentState:String;
      
      private var _privateDataRequestTimeout:int = 2000;
      
      private var connType:String;
      
      private var privateDataWithPayloadRequestMap:Object = {};
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var host:MultiValueProperty;
      
      private var _keepAliveInterval:int = 60000;
      
      private var reconnectionAttempts:int = 0;
      
      private var keepAliveTimer:Timer;
      
      private var shouldAttemptReconnectImmediately:Boolean = true;
      
      public var connection:XMPPSocketConnection;
      
      private var privateDataRequestMap:Object = null;
      
      private var connectionUserName:String;
      
      private var _inviteListener:InviteListener;
      
      public function ChatServiceImpl()
      {
         super();
         RiotPrivateDataExtension.enable();
         this.connection = new XMPPSocketConnection();
      }
      
      private function onPrivateDataWithPayloadResponse(param1:IQ) : void
      {
         var callback:Function = null;
         var id:String = null;
         var timer:Timer = null;
         var privateDataExt:PrivateDataExtension = null;
         var privatePayload:IPrivatePayload = null;
         var iq:IQ = param1;
         callback = null;
         try
         {
            id = iq.id;
            callback = this.privateDataWithPayloadRequestMap[id][1];
            timer = this.privateDataWithPayloadRequestMap[id][0];
            timer.stop();
            timer.removeEventListener(TimerEvent.TIMER,this.onPrivateDataWithPayloadError);
            delete this.privateDataWithPayloadRequestMap[id][1];
            delete this.privateDataWithPayloadRequestMap[id][0];
            delete this.privateDataWithPayloadRequestMap[id];
            privateDataExt = new PrivateDataExtension();
            privateDataExt.deserialize(iq.getNode().firstChild);
            privatePayload = privateDataExt.payload;
            callback(privatePayload);
         }
         catch(error:Error)
         {
            logger.error("0013 onPrivateDataWithPayloadResponse: Failed to parse/deserialize Private Data IQ response");
            if(callback != null)
            {
               callback(null);
            }
         }
      }
      
      private function switchHost() : Boolean
      {
         var _loc1_:Boolean = false;
         if(this.host.hasMultipleValues())
         {
            if(this.host.nextValue())
            {
               _loc1_ = true;
            }
            this.connection.server = this.host.value;
         }
         return _loc1_;
      }
      
      private function reconnectionTimedOut() : void
      {
         this.cleanupReconnectionTimeout();
         if(this.currentState == ChatServiceState.STATE_RECONNECTING)
         {
            this.switchHost();
            this.attemptReconnection();
         }
      }
      
      public function sendBuddyMessage(param1:String, param2:String) : void
      {
         if(!this.connection)
         {
            return;
         }
         var _loc3_:EscapedJID = new EscapedJID(param1);
         var _loc4_:EscapedJID = this.connection.jid.escaped;
         var _loc5_:Message = new Message();
         _loc5_.from = _loc4_;
         _loc5_.to = _loc3_;
         _loc5_.body = param2;
         _loc5_.type = Message.CHAT_TYPE;
         this.connection.send(_loc5_);
      }
      
      private function handleConflictError() : void
      {
         this.logger.error("0016 ChatService.handleConflictError another user has logged onto this chat account");
         this.shouldAttemptReconnectImmediately = false;
      }
      
      public function setPrivateData(param1:IPrivatePayload) : void
      {
         if(!this.privateDataManager)
         {
            this.privateDataManager = new PrivateDataManager(this.connection);
         }
         this.privateDataManager.setPrivateData(param1.getElementName(),param1.getNS(),param1);
      }
      
      public function removeConnectionEventListener(param1:String, param2:Function) : void
      {
         if(this.connection)
         {
            this.connection.removeEventListener(param1,param2);
         }
      }
      
      private function setCurrentState(param1:String) : void
      {
         if(this._currentState == param1)
         {
            return;
         }
         this._currentState = param1;
         dispatchEvent(new Event("currentStateChanged"));
      }
      
      private function connection_onErrorHandler(param1:XIFFErrorEvent) : void
      {
         var _loc2_:String = null;
         this.connection.password = this.connection.password.replace(/\w/g,"*");
         if(param1.errorCode == XMPP_CODE_SERVICE_UNAVAILABLE)
         {
            if(this.currentState == ChatServiceState.STATE_LOGGING_IN)
            {
               if(this.switchHost())
               {
                  this.connection.username = this.connectionUserName;
                  this.connection.connect(this.connType);
                  return;
               }
               this.serviceUnavailableWhileConnecting(param1);
               return;
            }
            if(this.currentState == ChatServiceState.STATE_RECONNECTING)
            {
               if(this.switchHost())
               {
                  this.attemptReconnection();
                  return;
               }
               dispatchEvent(new DisconnectionEvent());
               this.serviceUnavailableWhileConnecting(param1);
               return;
            }
            _loc2_ = param1.userInfo ? param1.userInfo : "none";
            this.logger.warn("0020 503 - service unavailable with subject: " + _loc2_);
         }
         else if(param1.errorCode == XIFFErrorEvent.IO_ERROR_CODE)
         {
            if(DynamicClientConfigManager.getConfiguration("chat","reconnectOnIOError",false).getBoolean())
            {
               this.logger.warn("0022 connection_onErrorHandler IOError - allowing reconnect");
            }
            else
            {
               this.serviceUnavailableWhileConnecting(param1);
            }
         }
         else if(param1.errorCode == XIFFErrorEvent.XIFF_ERROR_AUTHENTICATION)
         {
            this.logger.error("0019 Chat is unavailable and we will not attempt to reconnect! " + param1.errorCode + " : " + param1.errorCondition + param1.errorMessage + param1.errorType + param1.errorExt + param1.errorFrom);
            this.setCurrentState(ChatServiceState.STATE_DISCONNECTED);
         }
         else
         {
            this.logger.warn("0021 connection_onErrorHandler: Received unhandled error code [" + param1.errorCode + "]");
         }
      }
      
      public function get reconnectionRetryLimit() : int
      {
         return this._reconnectionRetryLimit;
      }
      
      public function get keepAliveInterval() : int
      {
         return this._keepAliveInterval;
      }
      
      public function get reconnectionInterval() : int
      {
         return this._reconnectionInterval;
      }
      
      public function set reconnectionRetryLimit(param1:int) : void
      {
         this._reconnectionRetryLimit = param1;
      }
      
      private function checkForStreamErrors(param1:XMLNode) : void
      {
         var _loc2_:XMLNode = null;
         if(!param1)
         {
            return;
         }
         if(param1.nodeName == "stream:error")
         {
            _loc2_ = param1.firstChild;
            if(_loc2_)
            {
               switch(_loc2_.nodeName)
               {
                  case "conflict":
                     this.handleConflictError();
                     break;
                  default:
                     this.logger.warn("0011 ChatService.checkForStreamErrors: We do not recognize this type of error");
               }
            }
         }
      }
      
      public function addConnectionEventListener(param1:String, param2:Function) : void
      {
         this.connection.addEventListener(param1,param2);
      }
      
      private function connection_outgoingDataHandler(param1:OutgoingDataEvent) : void
      {
         ServiceLogger.XMPPOutgoing(param1.data);
         this.startKeepAliveTimer();
      }
      
      private function connection_incomingDataHandler(param1:IncomingDataEvent) : void
      {
         this.startKeepAliveTimer();
         ServiceLogger.XMPPIncoming(param1.data);
         if(param1.data)
         {
            this.checkForStreamErrors(param1.data.firstChild);
         }
      }
      
      public function set keepAliveInterval(param1:int) : void
      {
         if(this._keepAliveInterval == param1)
         {
            return;
         }
         this._keepAliveInterval = param1;
         this.startKeepAliveTimer();
      }
      
      public function reconnect() : void
      {
         this.reconnectionAttempts = 0;
         this.shouldAttemptReconnectImmediately = true;
         this.attemptReconnection();
      }
      
      public function sendMessage(param1:UnescapedJID, param2:String, param3:XMLNode = null) : void
      {
         var _loc4_:String = "";
         if(param3 != null)
         {
            _loc4_ = param3.toString();
         }
         var _loc5_:Message = new Message(param1.escaped,XMPPStanza.generateID("msg_"),_loc4_,null,Message.NORMAL_TYPE,param2);
         this.connection.send(_loc5_);
      }
      
      private function connection_loginHandler(param1:LoginEvent) : void
      {
         this.connection.password = this.connection.password.replace(/\w/g,"*");
         this.host.resetCounter();
         this.setCurrentState(ChatServiceState.STATE_CONNECTED);
         this.cleanupReconnectionTimeout();
         this.startKeepAliveTimer();
         this.reconnectionAttempts = 0;
         dispatchEvent(new LoginEvent2());
         this._loginSuccessfulSignal.dispatch();
      }
      
      private function keepAliveTimer_timerHandler(param1:TimerEvent) : void
      {
         if(!this.connection)
         {
            this.removeKeepAliveTimer();
            return;
         }
         if(this.connection.isActive())
         {
            this.connection.sendKeepAlive();
         }
      }
      
      public function createMessage(param1:UnescapedJID, param2:String, param3:XMLNode = null) : Message
      {
         var _loc4_:String = "";
         if(param3 != null)
         {
            _loc4_ = param3.toString();
         }
         return new Message(param1.escaped,XMPPStanza.generateID("msg_"),_loc4_,null,Message.NORMAL_TYPE,param2);
      }
      
      public function set reconnectionInterval(param1:int) : void
      {
         this._reconnectionInterval = param1;
      }
      
      private function removeKeepAliveTimer() : void
      {
         if(!this.keepAliveTimer)
         {
            return;
         }
         if(this.keepAliveTimer.running)
         {
            this.keepAliveTimer.stop();
         }
         this.keepAliveTimer.removeEventListener(TimerEvent.TIMER,this.keepAliveTimer_timerHandler);
         this.keepAliveTimer = null;
      }
      
      public function get loginSuccessfulSignal() : ISignal
      {
         return this._loginSuccessfulSignal;
      }
      
      private function scheduleReconnect() : void
      {
         this.cleanupReconnectionTimeout();
         if(this.reconnectionInterval == XMPP_RECONNECTION_DISABLED)
         {
            this.setCurrentState(ChatServiceState.STATE_DISCONNECTED);
            return;
         }
         this.setCurrentState(ChatServiceState.STATE_DELAYED_RECONNECT);
         this.reconnectionAttempts = 0;
         this.reconnectionTimer = new Timer(this.reconnectionInterval,1);
         this.reconnectionTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.reconnectionTimer_timerCompleteHandler);
         this.reconnectionTimer.start();
      }
      
      private function cleanupReconnectionTimeout() : void
      {
         if(this.reconnectionTimeoutId != 0)
         {
            clearTimeout(this.reconnectionTimeoutId);
            this.reconnectionTimeoutId = 0;
         }
      }
      
      private function onPrivateDataWithPayloadError(param1:TimerEvent) : void
      {
         var key:String = null;
         var callback:Function = null;
         var timer:Timer = null;
         var e:TimerEvent = param1;
         var timeoutTimer:Timer = e.target as Timer;
         if(timeoutTimer == null)
         {
            this.logger.error("0014 onPrivateDataWithPayloadError: Failed to extract Timer from TimerEvent");
            return;
         }
         for(key in this.privateDataWithPayloadRequestMap)
         {
            try
            {
               callback = this.privateDataWithPayloadRequestMap[key][1] as Function;
               timer = this.privateDataWithPayloadRequestMap[key][0] as Timer;
               if(timeoutTimer == timer)
               {
                  this.logger.error("0015 onPrivateDataWithPayloadError: Timed out waiting for Private Data response");
                  timer.removeEventListener(TimerEvent.TIMER,this.onPrivateDataWithPayloadError);
                  delete this.privateDataWithPayloadRequestMap[key][0];
                  delete this.privateDataWithPayloadRequestMap[key][1];
                  delete this.privateDataWithPayloadRequestMap[key];
                  callback(null);
                  return;
               }
            }
            catch(error:Error)
            {
            }
         }
      }
      
      public function getPrivateData(param1:String, param2:String, param3:Function) : void
      {
         if(!this.privateDataRequestMap)
         {
            this.privateDataRequestMap = {};
         }
         if(!this.privateDataManager)
         {
            this.privateDataManager = new PrivateDataManager(this.connection);
         }
         var _loc4_:String = param1 + "|" + param2;
         if(this.privateDataRequestMap[_loc4_])
         {
            (this.privateDataRequestMap[_loc4_] as Array).push(param3);
            this.logger.warn("0012 requesting private data twice. Strange.");
            return;
         }
         this.privateDataRequestMap[_loc4_] = [param3];
         this.privateDataManager.getPrivateData(param1,param2,new Callback(this,this.onPrivateDataResponse));
      }
      
      public function disconnect(param1:Boolean = false, param2:Boolean = true) : void
      {
         var shouldAttemptReconnect:Boolean = param1;
         var shouldAttemptReconnectImmediately:Boolean = param2;
         this.shouldAttemptReconnectImmediately = shouldAttemptReconnectImmediately;
         if(!shouldAttemptReconnect)
         {
            this.setCurrentState(ChatServiceState.STATE_LOGGING_OUT);
         }
         if(Boolean(this.connection.isActive()) || Boolean(this.connection.isLoggedIn()))
         {
            try
            {
               this.connection.disconnect();
            }
            catch(error:Error)
            {
            }
         }
      }
      
      [Bindable("currentStateChanged")]
      public function get currentState() : String
      {
         return this._currentState;
      }
      
      public function get connectionInfo() : String
      {
         return this.connection.username + "@" + this.connection.server + ":" + this.connection.port.toString() + "/" + this.connection.resource + " is " + this._currentState;
      }
      
      private function connection_connectSuccessHandler(param1:ConnectionSuccessEvent) : void
      {
      }
      
      public function sendAlert(param1:String) : void
      {
         var _loc2_:EscapedJID = new EscapedJID(this.connection.domain);
         var _loc3_:IQ = new IQ(_loc2_,IQ.SET_TYPE,XMPPStanza.generateID("alert_"));
         var _loc4_:CmdExtAnnounce = new CmdExtAnnounce();
         _loc4_.addFormField("hidden","FORM_TYPE","http://jabber.org/protocol/admin");
         _loc4_.addFormField("text-single","subject",XMPPMessageSubjectTypes.SYSTEM_ALERT);
         _loc4_.addFormField("text-single","body",param1);
         _loc3_.addExtension(_loc4_);
         this.connection.send(_loc3_);
      }
      
      private function attemptReconnection() : void
      {
         if(this.reconnectionAttempts > Math.max(this.reconnectionRetryLimit,this.host.numberOfValues()))
         {
            this.scheduleReconnect();
            return;
         }
         this.cleanupReconnectionTimeout();
         this.setCurrentState(ChatServiceState.STATE_RECONNECTING);
         ++this.reconnectionAttempts;
         this.connection.username = this.connectionUserName;
         this.reconnectionTimeoutId = setTimeout(this.reconnectionTimedOut,XMPP_RECONNECTION_IMMEDIATE_INTERVAL);
         this.connection.password = Session.instance.getChatPassword();
         this.connection.connect(this.connType);
      }
      
      private function reconnectionTimer_timerCompleteHandler(param1:TimerEvent) : void
      {
         if(!this.reconnectionTimer)
         {
            return;
         }
         this.reconnectionTimer.stop();
         this.reconnectionTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.reconnectionTimer_timerCompleteHandler);
         this.reconnectionTimer = null;
         this.attemptReconnection();
      }
      
      public function changePresence(param1:String, param2:XMLNode) : void
      {
         var _loc3_:Presence = new Presence(null,null,null,param1,param2.toString());
         this.connection.send(_loc3_);
      }
      
      public function updateRosterNote(param1:RosterItemVO, param2:String, param3:String) : void
      {
         var _loc4_:IQ = new IQ(null,IQ.SET_TYPE,XMPPStanza.generateID("note_"));
         var _loc5_:XMLNode = new XMLNode(XMLNodeType.ELEMENT_NODE,"query");
         _loc5_.attributes = {"xmlns":"jabber:iq:roster"};
         var _loc6_:XMLNode = new XMLNode(XMLNodeType.ELEMENT_NODE,"item");
         _loc6_.attributes = {
            "name":param1.displayName,
            "jid":param1.jid.bareJID
         };
         _loc5_.appendChild(_loc6_);
         var _loc7_:XMLNode = new XMLNode(XMLNodeType.ELEMENT_NODE,"note");
         _loc6_.appendChild(_loc7_);
         var _loc8_:XMLNode = new XMLNode(XMLNodeType.TEXT_NODE,param3);
         _loc7_.appendChild(_loc8_);
         var _loc9_:XMLNode = new XMLNode(XMLNodeType.ELEMENT_NODE,"group");
         _loc6_.appendChild(_loc9_);
         var _loc10_:XMLNode = new XMLNode(XMLNodeType.CDATA_NODE,param2);
         _loc9_.appendChild(_loc10_);
         var _loc11_:XMLNode = _loc4_.getNode();
         trace(_loc4_.getNode());
         _loc11_.appendChild(_loc5_);
         trace(_loc4_.getNode());
         this.connection.send(_loc4_);
      }
      
      private function onPrivateDataResponse(param1:XMPPStanza) : void
      {
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:Function = null;
         var _loc2_:PrivateDataExtension = param1.getAllExtensionsByNS("jabber:iq:private")[0];
         var _loc3_:IPrivatePayload = _loc2_.payload;
         if(_loc3_)
         {
            _loc4_ = _loc3_.getElementName() + "|" + _loc3_.getNS();
            _loc5_ = this.privateDataRequestMap[_loc4_];
            for each(_loc6_ in _loc5_)
            {
               _loc6_(_loc3_);
            }
            delete this.privateDataRequestMap[_loc4_];
         }
      }
      
      public function getPrivateDataWithPayload(param1:IPrivatePayload, param2:Function) : void
      {
         var _loc3_:Timer = new Timer(this._privateDataRequestTimeout,1);
         _loc3_.addEventListener(TimerEvent.TIMER,this.onPrivateDataWithPayloadError);
         var _loc4_:EscapedJID = new EscapedJID(this.connection.domain);
         var _loc5_:String = XMPPStanza.generateID("private_data_");
         var _loc6_:IQ = new IQ(_loc4_,IQ.GET_TYPE,_loc5_,null,null,this.onPrivateDataWithPayloadResponse);
         _loc6_.addExtension(new PrivateDataExtension(param1.getElementName(),param1.getNS(),param1));
         this.privateDataWithPayloadRequestMap[_loc5_] = new Array(_loc3_,param2);
         _loc3_.start();
         this.connection.send(_loc6_);
      }
      
      public function getConnection() : XMPPSocketConnection
      {
         return this.connection;
      }
      
      public function removeChatServiceEventListener(param1:String, param2:Function) : void
      {
         this.removeEventListener(param1,param2);
      }
      
      private function startKeepAliveTimer() : void
      {
         if(!this.connection || !this.connection.isActive())
         {
            this.logger.warn("0010 startKeepAliveTimer: no connection");
            return;
         }
         if(!this.keepAliveTimer)
         {
            this.keepAliveTimer = new Timer(this.keepAliveInterval);
         }
         if(this.keepAliveTimer.running)
         {
            this.keepAliveTimer.reset();
         }
         if(!this.keepAliveTimer.hasEventListener(TimerEvent.TIMER))
         {
            this.keepAliveTimer.addEventListener(TimerEvent.TIMER,this.keepAliveTimer_timerHandler);
         }
         this.keepAliveTimer.start();
      }
      
      private function setupConnectionEventListeners() : void
      {
         if(!this.connection)
         {
            return;
         }
         this.connection.addEventListener(ConnectionSuccessEvent.CONNECT_SUCCESS,this.connection_connectSuccessHandler);
         this.connection.addEventListener(DisconnectionEvent.DISCONNECT,this.connection_disconnectHandler);
         this.connection.addEventListener(OutgoingDataEvent.OUTGOING_DATA,this.connection_outgoingDataHandler);
         this.connection.addEventListener(IncomingDataEvent.INCOMING_DATA,this.connection_incomingDataHandler);
         this.connection.addEventListener(LoginEvent.LOGIN,this.connection_loginHandler);
         this.connection.addEventListener(XIFFErrorEvent.XIFF_ERROR,this.connection_onErrorHandler);
      }
      
      private function removeConnectionEventListeners() : void
      {
         if(!this.connection)
         {
            return;
         }
         this.cleanupReconnectionTimeout();
         this.connection.removeEventListener(ConnectionSuccessEvent.CONNECT_SUCCESS,this.connection_connectSuccessHandler);
         this.connection.removeEventListener(DisconnectionEvent.DISCONNECT,this.connection_disconnectHandler);
         this.connection.removeEventListener(OutgoingDataEvent.OUTGOING_DATA,this.connection_outgoingDataHandler);
         this.connection.removeEventListener(IncomingDataEvent.INCOMING_DATA,this.connection_incomingDataHandler);
      }
      
      public function addInviteListener(param1:String, param2:Function) : void
      {
         this._inviteListener = new InviteListener();
         this._inviteListener.setConnection(this.connection);
         this._inviteListener.addEventListener(param1,param2);
      }
      
      public function connect(param1:String, param2:String, param3:String, param4:MultiValueProperty, param5:int, param6:String = "standard", param7:Boolean = false, param8:Boolean = false) : void
      {
         var username:String = param1;
         var password:String = param2;
         var resource:String = param3;
         var host:MultiValueProperty = param4;
         var port:int = param5;
         var connType:String = param6;
         var useSSL:Boolean = param7;
         var acceptSelfSignedCert:Boolean = param8;
         this.setupConnectionEventListeners();
         this.setCurrentState(ChatServiceState.STATE_LOGGING_IN);
         this.connectionUserName = username;
         this.connType = connType;
         this.host = host;
         this.connection.username = username;
         this.connection.password = password;
         this.connection.resource = resource;
         this.connection.server = host.value;
         this.connection.acceptSelfSignedCert = acceptSelfSignedCert;
         this.connection.useSSL = useSSL;
         this.connection.domain = "pvp.net";
         if(port > 0)
         {
            this.connection.port = port;
         }
         else if(useSSL)
         {
            this.connection.port = 5223;
         }
         else
         {
            this.connection.port = 5222;
         }
         trace("Connecting xmpp: " + this.connectionInfo);
         try
         {
            this.connection.connect(this.connType);
         }
         catch(e:Error)
         {
            logger.error("0001 IO error while connecting to chat:" + e.message);
            setCurrentState(ChatServiceState.STATE_DISCONNECTED);
         }
      }
      
      private function connection_disconnectHandler(param1:DisconnectionEvent) : void
      {
         this.connection.password = this.connection.password.replace(/\w/g,"*");
         switch(this.currentState)
         {
            case ChatServiceState.STATE_LOGGING_OUT:
               this.setCurrentState(ChatServiceState.STATE_DISCONNECTED);
               this.removeConnectionEventListeners();
               this.removeKeepAliveTimer();
               break;
            case ChatServiceState.STATE_CONNECTED:
               if(this.shouldAttemptReconnectImmediately)
               {
                  if(this.switchHost())
                  {
                     this.attemptReconnection();
                  }
                  else
                  {
                     this.attemptReconnection();
                     dispatchEvent(new DisconnectionEvent());
                  }
               }
               else
               {
                  this.setCurrentState(ChatServiceState.STATE_DISCONNECTED);
                  dispatchEvent(new DisconnectionEvent());
               }
               break;
            default:
               dispatchEvent(new DisconnectionEvent());
         }
      }
      
      private function serviceUnavailableWhileConnecting(param1:XIFFErrorEvent) : void
      {
         this.logger.error("0018 Chat is unavailable and we will not attempt to reconnect! " + param1.errorCode + " : " + param1.errorCondition + param1.errorMessage + param1.errorType + param1.errorExt + param1.errorFrom);
         this.setCurrentState(ChatServiceState.STATE_DISCONNECTED);
      }
      
      public function addChatServiceEventListener(param1:String, param2:Function) : void
      {
         this.addEventListener(param1,param2);
      }
      
      public function set privateDataRequestTimeout(param1:int) : void
      {
         this._privateDataRequestTimeout = param1;
      }
      
      public function get privateDataRequestTimeout() : int
      {
         return this._privateDataRequestTimeout;
      }
   }
}

