package org.igniterealtime.xiff.core
{
   import flash.events.DataEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.TimerEvent;
   import flash.net.XMLSocket;
   import flash.utils.Timer;
   import flash.xml.XMLDocument;
   import flash.xml.XMLNode;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import org.igniterealtime.xiff.auth.Anonymous;
   import org.igniterealtime.xiff.auth.External;
   import org.igniterealtime.xiff.auth.Plain;
   import org.igniterealtime.xiff.auth.SASLAuth;
   import org.igniterealtime.xiff.data.Extension;
   import org.igniterealtime.xiff.data.IExtension;
   import org.igniterealtime.xiff.data.IQ;
   import org.igniterealtime.xiff.data.Message;
   import org.igniterealtime.xiff.data.Presence;
   import org.igniterealtime.xiff.data.XMPPStanza;
   import org.igniterealtime.xiff.data.auth.AuthExtension;
   import org.igniterealtime.xiff.data.bind.BindExtension;
   import org.igniterealtime.xiff.data.forms.FormExtension;
   import org.igniterealtime.xiff.data.register.RegisterExtension;
   import org.igniterealtime.xiff.data.session.SessionExtension;
   import org.igniterealtime.xiff.events.*;
   import org.igniterealtime.xiff.exception.SerializationException;
   
   [Event(name="registrationSuccess",type="org.igniterealtime.xiff.events.RegistrationSuccessEvent")]
   [Event(name="presence",type="org.igniterealtime.xiff.events.PresenceEvent")]
   [Event(name="outgoingData",type="org.igniterealtime.xiff.events.OutgoingDataEvent")]
   [Event(name="message",type="org.igniterealtime.xiff.events.MessageEvent")]
   [Event(name="login",type="org.igniterealtime.xiff.events.LoginEvent")]
   [Event(name="incomingData",type="org.igniterealtime.xiff.events.IncomingDataEvent")]
   [Event(name="error",type="org.igniterealtime.xiff.events.XIFFErrorEvent")]
   [Event(name="disconnection",type="org.igniterealtime.xiff.events.DisconnectionEvent")]
   [Event(name="connection",type="org.igniterealtime.xiff.events.ConnectionSuccessEvent")]
   [Event(name="changePasswordSuccess",type="org.igniterealtime.xiff.events.ChangePasswordSuccessEvent")]
   public class XMPPConnection extends EventDispatcher
   {
      
      private static const logger:ILogger = Log.getLogger("org.igniterealtime.xiff.core.XMPPConnection");
      
      protected static var _openConnections:Array = [];
      
      protected static var saslMechanisms:Object = {
         "PLAIN":Plain,
         "ANONYMOUS":Anonymous,
         "EXTERNAL":External
      };
      
      protected var _useAnonymousLogin:Boolean;
      
      protected var _useSSL:Boolean;
      
      protected var _acceptSelfSignedCert:Boolean = false;
      
      protected var _socket:XMLSocket;
      
      protected var myServer:String;
      
      protected var myDomain:String;
      
      protected var myUsername:String;
      
      protected var myResource:String;
      
      protected var myPassword:String;
      
      protected var myPort:Number;
      
      protected var _active:Boolean;
      
      protected var loggedIn:Boolean;
      
      protected var ignoreWhitespace:Boolean;
      
      protected var openingStreamTag:String;
      
      protected var closingStreamTag:String;
      
      protected var sessionID:String;
      
      protected var pendingIQs:Object;
      
      protected var _expireTagSearch:Boolean;
      
      protected var auth:SASLAuth;
      
      private var presenceQueue:Array = [];
      
      private var presenceQueueTimer:Timer;
      
      public function XMPPConnection()
      {
         super();
         this.pendingIQs = new Object();
         this._useAnonymousLogin = false;
         this.active = false;
         this.loggedIn = false;
         this.ignoreWhitespace = true;
         this.resource = "xiff";
         this.port = 5222;
         AuthExtension.enable();
         BindExtension.enable();
         SessionExtension.enable();
         RegisterExtension.enable();
         FormExtension.enable();
      }
      
      public static function registerSASLMechanism(param1:String, param2:Class) : void
      {
         saslMechanisms[param1] = param2;
      }
      
      public static function disableSASLMechanism(param1:String) : void
      {
         saslMechanisms[param1] = null;
      }
      
      public static function get openConnections() : Array
      {
         return _openConnections;
      }
      
      public function connect(param1:String = "terminatedStandard") : Boolean
      {
         this._socket = this._createXmlSocket();
         this.active = false;
         this.loggedIn = false;
         switch(param1)
         {
            case "flash":
               this.openingStreamTag = new String("<?xml version=\"1.0\"?><flash:stream to=\"" + this.domain + "\" xmlns=\"jabber:client\" xmlns:flash=\"http://www.jabber.com/streams/flash\" version=\"1.0\">");
               this.closingStreamTag = new String("</flash:stream>");
               break;
            case "terminatedFlash":
               this.openingStreamTag = new String("<?xml version=\"1.0\"?><flash:stream to=\"" + this.domain + "\" xmlns=\"jabber:client\" xmlns:flash=\"http://www.jabber.com/streams/flash\" version=\"1.0\" />");
               this.closingStreamTag = new String("</flash:stream>");
               break;
            case "standard":
               this.openingStreamTag = new String("<?xml version=\"1.0\"?><stream:stream to=\"" + this.domain + "\" xmlns=\"jabber:client\" xmlns:stream=\"http://etherx.jabber.org/streams\" version=\"1.0\">");
               this.closingStreamTag = new String("</stream:stream>");
               break;
            case "terminatedStandard":
            default:
               this.openingStreamTag = new String("<?xml version=\"1.0\"?><stream:stream to=\"" + this.domain + "\" xmlns=\"jabber:client\" xmlns:stream=\"http://etherx.jabber.org/streams\" version=\"1.0\" />");
               this.closingStreamTag = new String("</stream:stream>");
         }
         this._socket.connect(this.server,this.port);
         return true;
      }
      
      public function disconnect() : void
      {
         var _loc1_:DisconnectionEvent = null;
         if(this.isActive())
         {
            this.sendXML(this.closingStreamTag);
            if(Boolean(this._socket))
            {
               this._socket.close();
            }
            this.active = false;
            this.loggedIn = false;
            _loc1_ = new DisconnectionEvent();
            dispatchEvent(_loc1_);
         }
      }
      
      public function send(param1:XMPPStanza) : void
      {
         var _loc2_:XMLNode = null;
         var _loc3_:IQ = null;
         if(this.isActive())
         {
            if(param1 is IQ)
            {
               _loc3_ = param1 as IQ;
               if(_loc3_.callbackName != null && _loc3_.callbackScope != null || _loc3_.callback != null)
               {
                  this.addIQCallbackToPending(_loc3_.id,_loc3_.callbackName,_loc3_.callbackScope,_loc3_.callback);
               }
            }
            _loc2_ = param1.getNode().parentNode;
            if(_loc2_ == null)
            {
               _loc2_ = new XMLDocument();
            }
            if(!param1.serialize(_loc2_))
            {
               throw new SerializationException();
            }
            this.sendXML(_loc2_.firstChild);
         }
      }
      
      public function sendKeepAlive() : void
      {
         if(this.isActive())
         {
            this.sendXML(" ");
         }
      }
      
      public function isActive() : Boolean
      {
         return this.active;
      }
      
      public function isLoggedIn() : Boolean
      {
         return this.loggedIn;
      }
      
      public function getRegistrationFields() : void
      {
         var _loc1_:IQ = new IQ(new EscapedJID(this.domain),IQ.GET_TYPE,XMPPStanza.generateID("reg_info_"),"getRegistrationFields_result",this,null);
         _loc1_.addExtension(new RegisterExtension(_loc1_.getNode()));
         this.send(_loc1_);
      }
      
      public function sendRegistrationFields(param1:Object, param2:String) : void
      {
         var _loc5_:String = null;
         var _loc3_:IQ = new IQ(new EscapedJID(this.domain),IQ.SET_TYPE,XMPPStanza.generateID("reg_attempt_"),"sendRegistrationFields_result",this,null);
         var _loc4_:RegisterExtension = new RegisterExtension(_loc3_.getNode());
         for(_loc5_ in param1)
         {
            _loc4_[_loc5_] = param1[_loc5_];
         }
         if(param2 != null)
         {
            _loc4_.key = param2;
         }
         _loc3_.addExtension(_loc4_);
         this.send(_loc3_);
      }
      
      public function changePassword(param1:String) : void
      {
         var _loc2_:IQ = new IQ(new EscapedJID(this.domain),IQ.SET_TYPE,XMPPStanza.generateID("pswd_change_"),"changePassword_result",this,null);
         var _loc3_:RegisterExtension = new RegisterExtension(_loc2_.getNode());
         _loc3_.username = this.jid.escaped.bareJID;
         _loc3_.password = param1;
         _loc2_.addExtension(_loc3_);
         this.send(_loc2_);
      }
      
      public function get jid() : UnescapedJID
      {
         return new UnescapedJID(this.myUsername + "@" + this.myDomain + "/" + this.myResource);
      }
      
      protected function changePassword_result(param1:IQ) : void
      {
         var _loc2_:ChangePasswordSuccessEvent = null;
         if(param1.type == IQ.RESULT_TYPE)
         {
            _loc2_ = new ChangePasswordSuccessEvent();
            dispatchEvent(_loc2_);
         }
         else
         {
            this.dispatchError("unexpected-request","Unexpected Request","wait",400);
         }
      }
      
      protected function getRegistrationFields_result(param1:IQ) : void
      {
         var ext:RegisterExtension = null;
         var fields:Array = null;
         var event:RegistrationFieldsEvent = null;
         var resultIQ:IQ = param1;
         try
         {
            ext = resultIQ.getAllExtensionsByNS(RegisterExtension.NS)[0];
            fields = ext.getRequiredFieldNames();
            event = new RegistrationFieldsEvent();
            event.fields = fields;
            event.data = ext;
         }
         catch(e:Error)
         {
         }
      }
      
      protected function sendRegistrationFields_result(param1:IQ) : void
      {
         var _loc2_:RegistrationSuccessEvent = null;
         if(param1.type == IQ.RESULT_TYPE)
         {
            _loc2_ = new RegistrationSuccessEvent();
            dispatchEvent(_loc2_);
         }
         else
         {
            this.dispatchError("unexpected-request","Unexpected Request","wait",400);
         }
      }
      
      protected function socketConnected(param1:Event) : void
      {
         this.active = true;
         this.sendXML(this.openingStreamTag);
         var _loc2_:ConnectionSuccessEvent = new ConnectionSuccessEvent();
         dispatchEvent(_loc2_);
      }
      
      protected function socketReceivedData(param1:DataEvent) : void
      {
         var _loc6_:RegExp = null;
         var _loc7_:Object = null;
         if(!this._expireTagSearch)
         {
            _loc6_ = /<flash:stream/;
            _loc7_ = _loc6_.exec(param1.data);
            if(_loc7_ != null)
            {
               param1.data = param1.data.concat("</flash:stream>");
               this._expireTagSearch = true;
            }
         }
         if(param1.data == "</flash:stream>")
         {
            this.socketClosed(null);
            return;
         }
         var _loc2_:XMLDocument = new XMLDocument();
         _loc2_.ignoreWhite = this.ignoreWhite;
         _loc2_.parseXML(param1.data);
         var _loc3_:IncomingDataEvent = new IncomingDataEvent();
         _loc3_.data = _loc2_;
         dispatchEvent(_loc3_);
         var _loc4_:XMLNode = _loc2_.firstChild;
         var _loc5_:String = _loc4_.nodeName.toLowerCase();
         switch(_loc5_)
         {
            case "stream:stream":
            case "flash:stream":
               this._expireTagSearch = false;
               this.handleStream(_loc4_);
               break;
            case "stream:error":
               this.handleStreamError(_loc4_);
               break;
            case "iq":
               this.handleIQ(_loc4_);
               break;
            case "message":
               this.handleMessage(_loc4_);
               break;
            case "presence":
               this.handlePresence(_loc4_);
               break;
            case "stream:features":
               this.handleStreamFeatures(_loc4_);
               break;
            case "success":
               this.handleAuthentication(_loc4_);
               break;
            case "failure":
               this.handleAuthentication(_loc4_);
               break;
            default:
               this.dispatchError("undefined-condition","Unknown Error","modify",500);
         }
      }
      
      protected function socketClosed(param1:Event) : void
      {
         var _loc2_:DisconnectionEvent = new DisconnectionEvent();
         dispatchEvent(_loc2_);
      }
      
      protected function handleStream(param1:XMLNode) : void
      {
         var _loc2_:XMLNode = null;
         this.sessionID = param1.attributes.id;
         this.domain = param1.attributes.from;
         for each(_loc2_ in param1.childNodes)
         {
            if(_loc2_.nodeName == "stream:features")
            {
               this.handleStreamFeatures(_loc2_);
            }
         }
      }
      
      protected function handleStreamFeatures(param1:XMLNode) : void
      {
         var _loc2_:XMLNode = null;
         if(!this.loggedIn)
         {
            for each(_loc2_ in param1.childNodes)
            {
               if(_loc2_.nodeName == "starttls")
               {
                  if(Boolean(_loc2_.firstChild) && _loc2_.firstChild.nodeName == "required")
                  {
                     this.dispatchError("TLS required","The server requires TLS, but this feature is not implemented.","cancel",501);
                     this.disconnect();
                     return;
                  }
               }
               else if(_loc2_.nodeName == "mechanisms")
               {
                  this.configureAuthMechanisms(_loc2_);
               }
            }
            if(this.useAnonymousLogin || this.username != null && this.username.length > 0)
            {
               this.beginAuthentication();
            }
            else
            {
               this.getRegistrationFields();
            }
         }
         else
         {
            this.bindConnection();
         }
      }
      
      protected function configureAuthMechanisms(param1:XMLNode) : void
      {
         var _loc2_:SASLAuth = null;
         var _loc3_:Class = null;
         var _loc4_:XMLNode = null;
         for each(_loc4_ in param1.childNodes)
         {
            _loc3_ = saslMechanisms[_loc4_.firstChild.nodeValue];
            if(this.useAnonymousLogin)
            {
               if(_loc3_ == Anonymous)
               {
                  break;
               }
            }
            else if(Boolean(_loc3_))
            {
               break;
            }
         }
         if(!_loc3_)
         {
            this.dispatchError("SASL missing","The server is not configured to support any available SASL mechanisms","SASL",-1);
            return;
         }
         this.auth = new _loc3_(this);
      }
      
      protected function handleStreamError(param1:XMLNode) : void
      {
         this.dispatchError("service-unavailable","Remote Server Error","cancel",502);
         try
         {
            this._socket.close();
         }
         catch(error:Error)
         {
         }
         this.active = false;
         this.loggedIn = false;
         var _loc2_:DisconnectionEvent = new DisconnectionEvent();
         dispatchEvent(_loc2_);
      }
      
      protected function set active(param1:Boolean) : void
      {
         if(param1)
         {
            _openConnections.push(this);
         }
         else
         {
            _openConnections.splice(_openConnections.indexOf(this),1);
         }
         this._active = param1;
      }
      
      protected function get active() : Boolean
      {
         return this._active;
      }
      
      protected function handleIQ(param1:XMLNode) : IQ
      {
         var _loc3_:* = undefined;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:IExtension = null;
         var _loc7_:IQEvent = null;
         var _loc2_:IQ = new IQ();
         if(!_loc2_.deserialize(param1))
         {
            throw new SerializationException();
         }
         if(_loc2_.type == IQ.ERROR_TYPE)
         {
            this.dispatchError(_loc2_.errorCondition,_loc2_.errorMessage,_loc2_.errorType,_loc2_.errorCode);
         }
         else if(this.pendingIQs[_loc2_.id] !== undefined)
         {
            _loc3_ = this.pendingIQs[_loc2_.id];
            if(Boolean(_loc3_.methodScope) && Boolean(_loc3_.methodName))
            {
               _loc3_.methodScope[_loc3_.methodName].apply(_loc3_.methodScope,[_loc2_]);
            }
            if(_loc3_.func != null)
            {
               _loc3_.func(_loc2_);
            }
            this.pendingIQs[_loc2_.id] = null;
            delete this.pendingIQs[_loc2_.id];
         }
         else
         {
            _loc4_ = _loc2_.getAllExtensions();
            for(_loc5_ in _loc4_)
            {
               _loc6_ = _loc4_[_loc5_] as IExtension;
               if(_loc6_ != null)
               {
                  _loc7_ = new IQEvent(_loc6_.getNS());
                  _loc7_.data = _loc6_;
                  _loc7_.iq = _loc2_;
                  dispatchEvent(_loc7_);
               }
            }
         }
         return _loc2_;
      }
      
      protected function handleMessage(param1:XMLNode) : Message
      {
         var _loc3_:Array = null;
         var _loc4_:MessageEvent = null;
         var _loc2_:Message = new Message();
         if(!_loc2_.deserialize(param1))
         {
            throw new SerializationException();
         }
         if(_loc2_.type == Message.ERROR_TYPE)
         {
            _loc3_ = _loc2_.getAllExtensions();
            this.dispatchError(_loc2_.errorCondition,_loc2_.errorMessage,_loc2_.errorType,_loc2_.errorCode,_loc3_.length > 0 ? _loc3_[0] : null,_loc2_.from,_loc2_.subject);
         }
         else
         {
            _loc4_ = new MessageEvent();
            _loc4_.data = _loc2_;
            dispatchEvent(_loc4_);
         }
         return _loc2_;
      }
      
      protected function handlePresence(param1:XMLNode) : Presence
      {
         if(!this.presenceQueueTimer)
         {
            this.presenceQueueTimer = new Timer(1,1);
            this.presenceQueueTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.flushPresenceQueue);
         }
         var _loc2_:Presence = new Presence();
         if(!_loc2_.deserialize(param1))
         {
            throw new SerializationException();
         }
         this.presenceQueue.push(_loc2_);
         this.presenceQueueTimer.reset();
         this.presenceQueueTimer.start();
         return _loc2_;
      }
      
      protected function flushPresenceQueue(param1:TimerEvent) : void
      {
         var _loc2_:PresenceEvent = new PresenceEvent();
         _loc2_.data = this.presenceQueue;
         dispatchEvent(_loc2_);
         this.presenceQueue = [];
      }
      
      protected function onIOError(param1:IOErrorEvent) : void
      {
         this.dispatchError("riot-io-error","riot-io-error","socket io error",XIFFErrorEvent.IO_ERROR_CODE,null,null,"XMPPConnection::onIOError");
      }
      
      protected function securityError(param1:SecurityErrorEvent) : void
      {
         this.dispatchError("not-authorized","Not Authorized","auth",XIFFErrorEvent.XIFF_ERROR_AUTHENTICATION);
      }
      
      protected function dispatchError(param1:String, param2:String, param3:String, param4:Number, param5:Extension = null, param6:EscapedJID = null, param7:String = null) : void
      {
         var _loc8_:XIFFErrorEvent = new XIFFErrorEvent();
         _loc8_.errorCondition = param1;
         _loc8_.errorMessage = param2;
         _loc8_.errorType = param3;
         _loc8_.errorCode = param4;
         _loc8_.errorExt = param5;
         _loc8_.errorFrom = param6;
         _loc8_.userInfo = param7;
         dispatchEvent(_loc8_);
      }
      
      protected function sendXML(param1:*) : void
      {
         this._socket.send(param1);
         var _loc2_:OutgoingDataEvent = new OutgoingDataEvent();
         _loc2_.data = param1;
         dispatchEvent(_loc2_);
      }
      
      protected function beginAuthentication() : void
      {
         this.sendXML(this.auth.request);
      }
      
      protected function handleAuthentication(param1:XMLNode) : void
      {
         var _loc2_:Object = this.auth.handleResponse(0,param1);
         if(Boolean(_loc2_.authComplete))
         {
            if(Boolean(_loc2_.authSuccess))
            {
               this.loggedIn = true;
               this.restartStream();
            }
            else
            {
               this.dispatchError("Authentication Error","","",XIFFErrorEvent.XIFF_ERROR_AUTHENTICATION);
               this.disconnect();
            }
         }
      }
      
      protected function restartStream() : void
      {
         this.sendXML(this.openingStreamTag);
      }
      
      protected function bindConnection() : void
      {
         var _loc1_:IQ = new IQ(null,"set");
         var _loc2_:BindExtension = new BindExtension();
         if(Boolean(this.resource))
         {
            _loc2_.resource = this.resource;
         }
         _loc1_.addExtension(_loc2_);
         _loc1_.callback = this.handleBindResponse;
         _loc1_.callbackScope = this;
         this.send(_loc1_);
      }
      
      protected function handleBindResponse(param1:IQ) : void
      {
         var _loc2_:BindExtension = param1.getExtension("bind") as BindExtension;
         var _loc3_:UnescapedJID = _loc2_.jid.unescaped;
         this.myResource = _loc3_.resource;
         this.myUsername = _loc3_.node;
         this.domain = _loc3_.domain;
         this.establishSession();
      }
      
      private function establishSession() : void
      {
         var _loc1_:IQ = new IQ(null,"set");
         _loc1_.addExtension(new SessionExtension());
         _loc1_.callback = this.handleSessionResponse;
         _loc1_.callbackScope = this;
         this.send(_loc1_);
      }
      
      private function handleSessionResponse(param1:IQ) : void
      {
         dispatchEvent(new LoginEvent());
      }
      
      protected function addIQCallbackToPending(param1:String, param2:String, param3:Object, param4:Function) : void
      {
         this.pendingIQs[param1] = {
            "methodName":param2,
            "methodScope":param3,
            "func":param4
         };
      }
      
      public function get server() : String
      {
         if(!this.myServer)
         {
            return this.myDomain;
         }
         return this.myServer;
      }
      
      public function set server(param1:String) : void
      {
         this.myServer = param1;
      }
      
      public function get domain() : String
      {
         if(!this.myDomain)
         {
            return this.myServer;
         }
         return this.myDomain;
      }
      
      public function set domain(param1:String) : void
      {
         this.myDomain = param1;
      }
      
      public function get username() : String
      {
         return this.myUsername;
      }
      
      public function set username(param1:String) : void
      {
         this.myUsername = param1;
      }
      
      public function get password() : String
      {
         return this.myPassword;
      }
      
      public function set password(param1:String) : void
      {
         this.myPassword = param1;
      }
      
      public function get resource() : String
      {
         return this.myResource;
      }
      
      public function set resource(param1:String) : void
      {
         if(param1.length > 0)
         {
            this.myResource = param1;
         }
      }
      
      public function get useAnonymousLogin() : Boolean
      {
         return this._useAnonymousLogin;
      }
      
      public function set useAnonymousLogin(param1:Boolean) : void
      {
         if(!this.isActive())
         {
            this._useAnonymousLogin = param1;
         }
      }
      
      public function get useSSL() : Boolean
      {
         return this._useSSL;
      }
      
      public function set useSSL(param1:Boolean) : void
      {
         this._useSSL = param1;
      }
      
      public function get acceptSelfSignedCert() : Boolean
      {
         return this._acceptSelfSignedCert;
      }
      
      public function set acceptSelfSignedCert(param1:Boolean) : void
      {
         this._acceptSelfSignedCert = param1;
      }
      
      public function get port() : Number
      {
         return this.myPort;
      }
      
      public function set port(param1:Number) : void
      {
         this.myPort = param1;
      }
      
      public function get ignoreWhite() : Boolean
      {
         return this.ignoreWhitespace;
      }
      
      public function set ignoreWhite(param1:Boolean) : void
      {
         this.ignoreWhitespace = param1;
      }
      
      private function _createXmlSocket() : XMLSocket
      {
         var _loc1_:XMLSocket = new XMLSocket(this.server,this.port);
         _loc1_.addEventListener(Event.CONNECT,this.socketConnected);
         _loc1_.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
         _loc1_.addEventListener(Event.CLOSE,this.socketClosed);
         _loc1_.addEventListener(DataEvent.DATA,this.socketReceivedData);
         _loc1_.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityError);
         return _loc1_;
      }
   }
}

