package com.riotgames.platform.gameclient.module.services.rest
{
   import blix.util.string.parseBool;
   import com.riotgames.platform.common.RiotServiceConfig;
   import com.riotgames.platform.common.services.IAuthService;
   import com.riotgames.platform.common.services.ILoginQueueMonitor;
   import com.riotgames.platform.common.services.PollingService;
   import com.riotgames.platform.common.services.RESTService;
   import com.riotgames.platform.common.services.login.queue.AuthResult;
   import com.riotgames.platform.common.services.login.queue.InGameCredentials;
   import com.riotgames.platform.common.services.login.queue.LoginQueueState;
   import com.riotgames.platform.common.utils.MultiValueProperty;
   import com.riotgames.platform.common.utils.ServiceLogger;
   import com.riotgames.util.json.jsonDecode;
   import com.riotgames.util.json.jsonEncode;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.getQualifiedClassName;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.rpc.events.FaultEvent;
   import mx.rpc.events.ResultEvent;
   import mx.rpc.http.HTTPService;
   
   public class RestAuthService extends EventDispatcher implements IAuthService, PollingService, RESTService
   {
      
      private static const LQ_REST_BASE:String = "/login-queue/rest/queues";
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var _pollingServiceURL:String;
      
      private var _lqUri:String;
      
      private var _queueId:String;
      
      private var _config:RiotServiceConfig;
      
      private var _queueMonitor:ILoginQueueMonitor;
      
      public function RestAuthService(param1:String, param2:RiotServiceConfig)
      {
         super();
         this._queueId = param1;
         this._config = param2;
         this._lqUri = param2.lq_uri + LQ_REST_BASE + "/" + this._queueId;
      }
      
      public function startPolling(param1:Function, param2:Function) : void
      {
         var _loc3_:HTTPService = new HTTPService();
         _loc3_.url = this._pollingServiceURL;
         _loc3_.method = "GET";
         _loc3_.requestTimeout = 20;
         _loc3_.addEventListener(ResultEvent.RESULT,param1);
         _loc3_.addEventListener(FaultEvent.FAULT,param2);
         _loc3_.send(null);
         ServiceLogger.requestREST("GET",this._pollingServiceURL,"(polling)");
      }
      
      public function customPOST(param1:String, param2:String, param3:String, param4:String, param5:Object, param6:String, param7:Function, param8:Function) : void
      {
         this.sendPost(param1,param2,param3,param4,param5,param6,null,param7,param8);
      }
      
      public function set queueMonitor(param1:ILoginQueueMonitor) : void
      {
         param1.pollingService = this;
         this._queueMonitor = param1;
      }
      
      public function getPollInterval() : int
      {
         return this._queueMonitor.getPollInterval();
      }
      
      private function sendGetWithFailover(param1:MultiValueProperty, param2:String, param3:String, param4:Function, param5:Function, param6:Function, param7:Number = NaN) : void
      {
         var _loc8_:Function = param6;
         if(param1.hasMultipleValues())
         {
            _loc8_ = this.createGetFailoverFunction(param1,param2,param3,param4,param5,param6);
         }
         var _loc9_:String = this.getRequestURL(param1.value,param2);
         this.sendGet(_loc9_,param3,param4,param5,_loc8_,param7);
      }
      
      private function getPublishDelay(param1:Object) : Number
      {
         var params:Object = param1;
         try
         {
            return parseFloat(params["delay"]);
         }
         catch(error:Error)
         {
         }
         return 0;
      }
      
      private function sendGet(param1:String, param2:String, param3:Function, param4:Function, param5:Function, param6:Number = NaN) : void
      {
         var _loc7_:String = "RestAuthService." + param2;
         var _loc8_:HttpRequest = this.getHttpRequest(param2,param3,param4,param5);
         if(!isNaN(param6))
         {
            _loc8_.timeout = param6;
         }
         _loc8_.get(param1);
         ServiceLogger.requestREST("GET",param1,param2);
      }
      
      private function getHttpRequest(param1:String, param2:Function, param3:Function, param4:Function) : HttpRequest
      {
         var _loc5_:HttpRequest = new HttpRequest(param1,param2,param3,param4);
         _loc5_.sanitizer = new AuthSanitizer();
         return _loc5_;
      }
      
      public function cancelQueue(param1:String, param2:Function, param3:Function) : void
      {
         this.sendPostWithFailover(this._config.lq_uri,"cancelQueue/","application/json",null,null,param1,"cancelQueue",null,param2,param3);
      }
      
      private function isFailoverEvent(param1:Event) : Boolean
      {
         var _loc2_:FaultEvent = param1 as FaultEvent;
         if(!_loc2_)
         {
            return false;
         }
         if(_loc2_.statusCode == 0)
         {
            return true;
         }
         return false;
      }
      
      private function sendPostWithFailover(param1:MultiValueProperty, param2:String, param3:String, param4:String, param5:String, param6:Object, param7:String, param8:Function, param9:Function, param10:Function) : void
      {
         var _loc11_:Function = param10;
         if(param1.hasMultipleValues())
         {
            _loc11_ = this.createPostFailoverFunction(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10);
         }
         var _loc12_:String = this.getRequestURL(param1.value,param2);
         this.sendPost(_loc12_,param3,param4,param5,param6,param7,param8,param9,_loc11_);
      }
      
      public function set pollingServiceURL(param1:String) : void
      {
         this._pollingServiceURL = param1;
      }
      
      private function createGetFailoverFunction(param1:MultiValueProperty, param2:String, param3:String, param4:Function, param5:Function, param6:Function) : Function
      {
         var lq_uriProp:MultiValueProperty = param1;
         var url:String = param2;
         var action:String = param3;
         var parser:Function = param4;
         var onSuccess:Function = param5;
         var onFailure:Function = param6;
         return function(param1:Event):void
         {
            logger.error("GET Request failed with URI [" + lq_uriProp.value + "]");
            if(!isFailoverEvent(param1))
            {
               execute(onFailure,[param1]);
               return;
            }
            if(lq_uriProp.nextValue())
            {
               sendGetWithFailover(lq_uriProp,url,action,parser,onSuccess,onFailure);
            }
            else
            {
               logger.error("No alternate URIs to retry");
               execute(onFailure,[param1]);
            }
         };
      }
      
      private function createPostFailoverFunction(param1:MultiValueProperty, param2:String, param3:String, param4:String, param5:String, param6:Object, param7:String, param8:Function, param9:Function, param10:Function) : Function
      {
         var lq_uriProp:MultiValueProperty = param1;
         var url:String = param2;
         var contentType:String = param3;
         var username:String = param4;
         var password:String = param5;
         var payload:Object = param6;
         var action:String = param7;
         var parser:Function = param8;
         var onSuccess:Function = param9;
         var onFailure:Function = param10;
         return function(param1:Event):void
         {
            logger.error("POST Request failed with URI [" + lq_uriProp.value + "]");
            if(!isFailoverEvent(param1))
            {
               execute(onFailure,[param1]);
               return;
            }
            if(lq_uriProp.nextValue())
            {
               sendPostWithFailover(lq_uriProp,url,contentType,username,password,payload,action,parser,onSuccess,onFailure);
            }
            else
            {
               logger.error("No alternate URIs to retry");
               execute(onFailure,[param1]);
            }
         };
      }
      
      private function getBacklog(param1:Object) : int
      {
         var params:Object = param1;
         var result:int = 0;
         try
         {
            result = parseInt(params["backlog"]);
         }
         catch(error:Error)
         {
         }
         return result;
      }
      
      private function sendPost(param1:String, param2:String, param3:String, param4:String, param5:Object, param6:String, param7:Function, param8:Function, param9:Function) : void
      {
         var _loc10_:String = "RestAuthService." + param6;
         var _loc11_:HttpRequest = this.getHttpRequest(param6,param7,param8,param9);
         _loc11_.post(param1,param3,param4,param5,param2);
         ServiceLogger.requestREST("POST",param1,param6,[param5]);
      }
      
      public function forcePoll() : void
      {
         this._queueMonitor.forcePoll();
      }
      
      private function parseAuthStatus(param1:String) : AuthResult
      {
         var _loc6_:Object = null;
         var _loc7_:String = null;
         var _loc2_:Object = jsonDecode(param1);
         var _loc3_:AuthResult = new AuthResult();
         _loc3_.authToken = _loc2_["token"];
         _loc3_.reason = _loc2_["reason"];
         _loc3_.status = _loc2_["status"];
         _loc3_.username = _loc2_["user"];
         _loc3_.summoner = _loc2_["summoner"];
         _loc3_.vcap = _loc2_["vcap"];
         if(_loc2_["lqt"] != null)
         {
            _loc3_.lqt = jsonEncode(_loc2_["lqt"]);
         }
         else
         {
            _loc3_.lqt = _loc2_["lqt"];
         }
         if(_loc2_["gasToken"] != null)
         {
            _loc3_.gasToken = jsonEncode(_loc2_["gasToken"]);
         }
         var _loc4_:Object = _loc2_["inGameCredentials"];
         _loc3_.inGameCredentials = new InGameCredentials();
         if(_loc4_ != null && parseBool(_loc4_["inGame"]) == true)
         {
            _loc3_.inGameCredentials.playerId = Number(_loc4_["summonerId"]);
            _loc3_.inGameCredentials.inGame = parseBool(_loc4_["inGame"]);
            _loc3_.inGameCredentials.serverIp = _loc4_["serverIp"];
            _loc3_.inGameCredentials.serverPort = parseInt(_loc4_["serverPort"]);
            _loc3_.inGameCredentials.encryptionKey = _loc4_["encryptionKey"];
            _loc3_.inGameCredentials.handshakeToken = _loc4_["handshakeToken"];
         }
         var _loc5_:Array = _loc2_["tickers"];
         if(_loc5_ != null)
         {
            _loc3_.queueState = new LoginQueueState();
            _loc3_.queueState.user = _loc3_.username;
            _loc3_.queueState.queueChampName = _loc2_["champ"];
            _loc3_.queueState.loginsPerSecond = this.getRate(_loc2_);
            _loc3_.queueState.publishDelay = this.getPublishDelay(_loc2_);
            _loc3_.queueState.backlog = this.getBacklog(_loc2_);
            for each(_loc6_ in _loc5_)
            {
               _loc7_ = "n-" + _loc6_["node"];
               _loc3_.queueState.client.positions[_loc7_] = parseInt(_loc6_["id"]);
               _loc3_.queueState.queue.positions[_loc7_] = parseInt(_loc6_["current"]);
            }
         }
         return _loc3_;
      }
      
      private function getRate(param1:Object) : int
      {
         var rate:int = 0;
         var params:Object = param1;
         try
         {
            rate = parseInt(params["rate"]);
            return rate == 0 ? 10 : rate;
         }
         catch(error:Error)
         {
         }
         return 10;
      }
      
      public function stopListening() : void
      {
         this._queueMonitor.clearListeners();
         this._queueMonitor.disconnect();
      }
      
      public function authenticate(param1:String, param2:Function, param3:Function) : void
      {
         var _loc4_:Object = {"payload":param1};
         this.sendPostWithFailover(this._config.lq_uri,"authenticate",HTTPService.CONTENT_TYPE_FORM,null,null,_loc4_,"authenticate",this.parseAuthStatus,param2,param3);
      }
      
      private function getRequestURL(param1:String, param2:String) : String
      {
         return param1 + LQ_REST_BASE + "/" + this._queueId + "/" + param2;
      }
      
      private function urlEscape(param1:String) : String
      {
         var text:String = param1;
         try
         {
            return escape(text);
         }
         catch(error:Error)
         {
            logger.error("Unable to escape text: \'" + text + "\'");
         }
         return text;
      }
      
      public function listenForStatusChange(param1:LoginQueueState, param2:Function, param3:Function) : void
      {
         this._queueMonitor.addQueueListener(param2);
         this._queueMonitor.connect(param1,param3);
      }
      
      public function getQueueId() : String
      {
         return this._queueId;
      }
      
      private function getAuthUrl() : String
      {
         return this._config == null ? null : this._config.lq_uri.value;
      }
      
      private function execute(param1:Function, param2:Array) : void
      {
         if(param1 != null)
         {
            param1.apply(null,param2);
         }
      }
      
      public function getAuthToken(param1:String, param2:Function, param3:Function) : void
      {
         this.sendPostWithFailover(this._config.lq_uri,"token/","application/json",null,null,param1,"getAuthToken",null,param2,param3);
      }
   }
}

