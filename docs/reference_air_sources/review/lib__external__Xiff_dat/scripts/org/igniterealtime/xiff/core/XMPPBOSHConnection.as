package org.igniterealtime.xiff.core
{
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.xml.XMLDocument;
   import flash.xml.XMLNode;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.rpc.events.FaultEvent;
   import mx.rpc.events.ResultEvent;
   import mx.rpc.http.HTTPService;
   import org.igniterealtime.xiff.events.ConnectionSuccessEvent;
   import org.igniterealtime.xiff.events.DisconnectionEvent;
   import org.igniterealtime.xiff.events.IncomingDataEvent;
   import org.igniterealtime.xiff.events.LoginEvent;
   import org.igniterealtime.xiff.events.OutgoingDataEvent;
   import org.igniterealtime.xiff.util.Callback;
   
   public class XMPPBOSHConnection extends XMPPConnection
   {
      
      private static const logger:ILogger = Log.getLogger("org.igniterealtime.xiff.core.XMPPBOSHConnection");
      
      private static const HTTP_PORT:int = 7070;
      
      private static const HTTPS_PORT:int = 7443;
      
      private static const BOSH_VERSION:String = "1.6";
      
      private static const headers:Object = {
         "post":[],
         "get":["Cache-Control","no-store","Cache-Control","no-cache","Pragma","no-cache"]
      };
      
      private const responseTimer:Timer = new Timer(0,1);
      
      private var requestCount:int = 0;
      
      private var requestQueue:Array = [];
      
      private var responseQueue:Array = [];
      
      private var isDisconnecting:Boolean = false;
      
      private var sid:String;
      
      private var rid:Number;
      
      private var pollingEnabled:Boolean = false;
      
      private var lastPollTime:Date = null;
      
      private var inactivity:uint;
      
      private var boshPollingInterval:uint = 10000;
      
      private var pauseEnabled:Boolean = false;
      
      private var maxPause:uint;
      
      private var pauseTimer:Timer;
      
      private var streamRestarted:Boolean;
      
      private var _secure:Boolean;
      
      private var _port:Number;
      
      private var _maxConcurrentRequests:uint;
      
      private var _hold:uint;
      
      private var _wait:uint;
      
      private var _boshPath:String;
      
      public function XMPPBOSHConnection(param1:Boolean = false)
      {
         super();
         this.secure = param1;
         this.hold = 1;
         this.wait = 20;
         this.maxConcurrentRequests = 2;
         this.boshPollingInterval = 10000;
         this.boshPath = "http-bind/";
      }
      
      override public function connect(param1:String = null) : Boolean
      {
         logger.debug("BOSH connect()");
         var _loc2_:Object = {
            "xml:lang":"en",
            "xmlns":"http://jabber.org/protocol/httpbind",
            "xmlns:xmpp":"urn:xmpp:xbosh",
            "xmpp:version":"1.0",
            "hold":this.hold,
            "rid":this.nextRID,
            "secure":this.secure,
            "wait":this.wait,
            "ver":BOSH_VERSION,
            "to":domain
         };
         var _loc3_:XMLNode = new XMLNode(1,"body");
         _loc3_.attributes = _loc2_;
         this.sendRequests(_loc3_);
         return true;
      }
      
      public function set maxConcurrentRequests(param1:uint) : void
      {
         this._maxConcurrentRequests = param1;
      }
      
      public function get maxConcurrentRequests() : uint
      {
         return this._maxConcurrentRequests;
      }
      
      public function set hold(param1:uint) : void
      {
         this._hold = param1;
      }
      
      public function get hold() : uint
      {
         return this._hold;
      }
      
      public function set wait(param1:uint) : void
      {
         this._wait = param1;
      }
      
      public function get wait() : uint
      {
         return this._wait;
      }
      
      public function set secure(param1:Boolean) : void
      {
         logger.debug("set secure: {0}",param1);
         this._secure = param1;
         this.port = this._secure ? HTTPS_PORT : HTTP_PORT;
      }
      
      public function get secure() : Boolean
      {
         return this._secure;
      }
      
      override public function set port(param1:Number) : void
      {
         logger.debug("set port: {0}",param1);
         this._port = param1;
      }
      
      override public function get port() : Number
      {
         return this._port;
      }
      
      public function set boshPath(param1:String) : void
      {
         this._boshPath = param1;
      }
      
      public function get boshPath() : String
      {
         return this._boshPath;
      }
      
      public function get httpServer() : String
      {
         return (this.secure ? "https" : "http") + "://" + server + ":" + this.port + "/" + this.boshPath;
      }
      
      override public function disconnect() : void
      {
         var _loc1_:XMLNode = null;
         if(active)
         {
            _loc1_ = this.createRequest();
            _loc1_.attributes.type = "terminate";
            this.sendRequests(_loc1_);
            active = false;
            loggedIn = false;
            dispatchEvent(new DisconnectionEvent());
         }
      }
      
      public function processConnectionResponse(param1:XMLNode) : void
      {
         dispatchEvent(new ConnectionSuccessEvent());
         var _loc2_:Object = param1.attributes;
         this.sid = _loc2_.sid;
         this.wait = _loc2_.wait;
         if(Boolean(_loc2_.polling))
         {
            this.boshPollingInterval = _loc2_.polling * 1000;
         }
         if(Boolean(_loc2_.inactivity))
         {
            this.inactivity = _loc2_.inactivity * 1000;
         }
         if(Boolean(_loc2_.maxpause))
         {
            this.maxPause = _loc2_.maxpause * 1000;
            this.pauseEnabled = true;
         }
         if(Boolean(_loc2_.requests))
         {
            this.maxConcurrentRequests = _loc2_.requests;
         }
         logger.debug("Polling interval: {0}",this.boshPollingInterval);
         logger.debug("Inactivity timeout: {0}",this.inactivity);
         logger.debug("Max requests: {0}",this.maxConcurrentRequests);
         logger.debug("Max pause: {0}",this.maxPause);
         active = true;
         addEventListener(LoginEvent.LOGIN,this.handleLogin);
         this.responseTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.processResponse);
      }
      
      private function processResponse(param1:TimerEvent = null) : void
      {
         var _loc2_:XMLNode = this.responseQueue.shift();
         var _loc3_:String = _loc2_.nodeName.toLowerCase();
         switch(_loc3_)
         {
            case "stream:features":
               handleStreamFeatures(_loc2_);
               this.streamRestarted = false;
               break;
            case "stream:error":
               handleStreamError(_loc2_);
               break;
            case "iq":
               handleIQ(_loc2_);
               break;
            case "message":
               handleMessage(_loc2_);
               break;
            case "presence":
               handlePresence(_loc2_);
               break;
            case "success":
               handleAuthentication(_loc2_);
               break;
            case "failure":
               handleAuthentication(_loc2_);
               break;
            default:
               dispatchError("undefined-condition","Unknown Error","modify",500);
         }
         this.resetResponseProcessor();
      }
      
      override protected function restartStream() : void
      {
         var _loc1_:XMLNode = this.createRequest();
         _loc1_.attributes["xmpp:restart"] = "true";
         _loc1_.attributes["xmlns:xmpp"] = "urn:xmpp:xbosh";
         _loc1_.attributes["xml:lang"] = "en";
         _loc1_.attributes["to"] = domain;
         this.sendRequests(_loc1_);
         this.streamRestarted = true;
      }
      
      public function pauseSession(param1:uint) : Boolean
      {
         logger.debug("Pausing session for {0} seconds",param1);
         var _loc2_:uint = param1 * 1000;
         if(!this.pauseEnabled || _loc2_ > this.maxPause || _loc2_ <= this.boshPollingInterval)
         {
            return false;
         }
         this.pollingEnabled = false;
         var _loc3_:XMLNode = this.createRequest();
         _loc3_.attributes["pause"] = param1;
         this.sendRequests(_loc3_);
         this.pauseTimer = new Timer(_loc2_ - 2000,1);
         this.pauseTimer.addEventListener(TimerEvent.TIMER,this.handlePauseTimeout);
         this.pauseTimer.start();
         return true;
      }
      
      private function handlePauseTimeout(param1:TimerEvent) : void
      {
         logger.debug("handlePauseTimeout");
         this.pollingEnabled = true;
         this.pollServer();
      }
      
      private function resetResponseProcessor() : void
      {
         if(this.responseQueue.length > 0)
         {
            this.responseTimer.reset();
            this.responseTimer.start();
         }
      }
      
      private function httpResponse(param1:XMLNode, param2:Boolean, param3:ResultEvent) : void
      {
         var _loc8_:XMLNode = null;
         var _loc9_:Boolean = false;
         var _loc10_:XMLNode = null;
         --this.requestCount;
         var _loc4_:String = param3.result as String;
         logger.info("INCOMING {0}",_loc4_);
         var _loc5_:XMLDocument = new XMLDocument();
         _loc5_.ignoreWhite = this.ignoreWhite;
         _loc5_.parseXML(_loc4_);
         var _loc6_:XMLNode = _loc5_.firstChild;
         var _loc7_:IncomingDataEvent = new IncomingDataEvent();
         _loc7_.data = _loc5_;
         dispatchEvent(_loc7_);
         if(this.streamRestarted && !_loc6_.hasChildNodes())
         {
            this.streamRestarted = false;
            bindConnection();
         }
         if(_loc6_.attributes["type"] == "terminate")
         {
            dispatchError("BOSH Error",_loc6_.attributes["condition"],"",-1);
            active = false;
         }
         if(Boolean(_loc6_.attributes["sid"]) && !loggedIn)
         {
            this.processConnectionResponse(_loc6_);
            _loc9_ = false;
            for each(_loc10_ in _loc6_.childNodes)
            {
               if(_loc10_.nodeName == "stream:features")
               {
                  _loc9_ = true;
               }
            }
            if(!_loc9_)
            {
               this.pollingEnabled = true;
               this.pollServer();
            }
         }
         for each(_loc8_ in _loc6_.childNodes)
         {
            this.responseQueue.push(_loc8_);
         }
         this.resetResponseProcessor();
         if(this.requestCount == 0 && !this.sendQueuedRequests())
         {
            this.pollServer();
         }
      }
      
      private function httpError(param1:XMLNode, param2:Boolean, param3:FaultEvent) : void
      {
         this.disconnect();
         dispatchError("Unknown HTTP Error",param3.fault.rootCause.text,"",-1);
      }
      
      override protected function sendXML(param1:*) : void
      {
         this.sendQueuedRequests(param1);
      }
      
      private function sendQueuedRequests(param1:* = null) : Boolean
      {
         if(Boolean(param1))
         {
            this.requestQueue.push(param1);
         }
         else if(this.requestQueue.length == 0)
         {
            return false;
         }
         return this.sendRequests();
      }
      
      private function sendRequests(param1:XMLNode = null, param2:Boolean = false) : Boolean
      {
         var _loc7_:Array = null;
         var _loc8_:uint = 0;
         if(this.requestCount >= this.maxConcurrentRequests)
         {
            return false;
         }
         ++this.requestCount;
         if(!param1)
         {
            if(param2)
            {
               param1 = this.createRequest();
            }
            else
            {
               _loc7_ = [];
               _loc8_ = 0;
               while(_loc8_ < 10 && this.requestQueue.length > 0)
               {
                  _loc7_.push(this.requestQueue.shift());
                  _loc8_++;
               }
               param1 = this.createRequest(_loc7_);
            }
         }
         var _loc3_:HTTPService = new HTTPService();
         _loc3_.method = "post";
         _loc3_.headers = headers[_loc3_.method];
         _loc3_.url = this.httpServer;
         _loc3_.resultFormat = HTTPService.RESULT_FORMAT_TEXT;
         _loc3_.contentType = "text/xml";
         var _loc4_:Callback = new Callback(this,this.httpResponse,param1,param2);
         var _loc5_:Callback = new Callback(this,this.httpError,param1,param2);
         _loc3_.addEventListener(ResultEvent.RESULT,_loc4_.call,false);
         _loc3_.addEventListener(FaultEvent.FAULT,_loc5_.call,false);
         _loc3_.send(param1);
         var _loc6_:OutgoingDataEvent = new OutgoingDataEvent();
         _loc6_.data = param1;
         dispatchEvent(_loc6_);
         if(param2)
         {
            this.lastPollTime = new Date();
            logger.info("Polling");
         }
         logger.info("OUTGOING {0}",param1);
         return true;
      }
      
      private function pollServer() : void
      {
         if(!isActive() || !this.pollingEnabled || this.sendQueuedRequests() || this.requestCount > 0)
         {
            return;
         }
         this.sendRequests(null,true);
      }
      
      private function get nextRID() : Number
      {
         if(!this.rid)
         {
            this.rid = Math.floor(Math.random() * 1000000);
         }
         return ++this.rid;
      }
      
      private function createRequest(param1:Array = null) : XMLNode
      {
         var _loc4_:XMLNode = null;
         var _loc2_:Object = {
            "xmlns":"http://jabber.org/protocol/httpbind",
            "rid":this.nextRID,
            "sid":this.sid
         };
         var _loc3_:XMLNode = new XMLNode(1,"body");
         if(Boolean(param1))
         {
            for each(_loc4_ in param1)
            {
               _loc3_.appendChild(_loc4_);
            }
         }
         _loc3_.attributes = _loc2_;
         return _loc3_;
      }
      
      private function handleLogin(param1:LoginEvent) : void
      {
         this.pollingEnabled = true;
         this.pollServer();
      }
      
      override public function sendKeepAlive() : void
      {
      }
   }
}

