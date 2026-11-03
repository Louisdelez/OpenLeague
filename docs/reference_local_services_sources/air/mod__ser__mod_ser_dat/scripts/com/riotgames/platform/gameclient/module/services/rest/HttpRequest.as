package com.riotgames.platform.gameclient.module.services.rest
{
   import com.riotgames.platform.common.utils.DefaultSanitizer;
   import com.riotgames.platform.common.utils.Sanitizer;
   import com.riotgames.platform.common.utils.ServiceLogger;
   import com.riotgames.util.logging.ErrorUtil;
   import flash.events.Event;
   import flash.utils.getQualifiedClassName;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.messaging.messages.HTTPRequestMessage;
   import mx.rpc.Fault;
   import mx.rpc.events.FaultEvent;
   import mx.rpc.events.ResultEvent;
   import mx.rpc.http.HTTPService;
   import mx.utils.Base64Encoder;
   
   public class HttpRequest
   {
      
      public var responseParser:Function;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      public var timeout:int = 30;
      
      public var onSuccess:Function;
      
      private var _sanitizer:Sanitizer = new DefaultSanitizer();
      
      public var onFailure:Function;
      
      public var url:String;
      
      public var action:String;
      
      public function HttpRequest(param1:String, param2:Function, param3:Function, param4:Function)
      {
         super();
         this.action = param1;
         this.responseParser = param2;
         this.onSuccess = param3;
         this.onFailure = param4;
      }
      
      public static function logRESTResponse(param1:ResultEvent, param2:String) : void
      {
         var _loc3_:HTTPRequestMessage = null;
         if(param1.token != null && param1.token.message is HTTPRequestMessage)
         {
            _loc3_ = param1.token.message as HTTPRequestMessage;
            ServiceLogger.responseREST(_loc3_.method,_loc3_.url,param2);
         }
         else
         {
            ServiceLogger.responseREST("unknown","unknown",param2);
         }
      }
      
      public static function logRESTFault(param1:FaultEvent, param2:Fault) : void
      {
         var _loc3_:HTTPRequestMessage = null;
         if(param1.token != null && param1.token.message is HTTPRequestMessage)
         {
            _loc3_ = param1.token.message as HTTPRequestMessage;
            ServiceLogger.faultREST(_loc3_.method,_loc3_.url,param2);
         }
         else
         {
            ServiceLogger.faultREST("unknown","unknown",param2);
         }
      }
      
      public function set sanitizer(param1:Sanitizer) : void
      {
         this._sanitizer = param1 == null ? new DefaultSanitizer() : param1;
      }
      
      public function get(param1:String) : void
      {
         var _loc2_:HTTPService = new HTTPService();
         _loc2_.url = param1;
         _loc2_.method = "GET";
         _loc2_.requestTimeout = this.timeout;
         _loc2_.addEventListener(ResultEvent.RESULT,this.processHttpResponse);
         _loc2_.addEventListener(FaultEvent.FAULT,this.processHttpResponse);
         _loc2_.send(null);
      }
      
      public function post(param1:String, param2:String, param3:String, param4:Object, param5:String) : void
      {
         var _loc7_:Base64Encoder = null;
         var _loc6_:HTTPService = new HTTPService();
         _loc6_.url = param1;
         _loc6_.method = "POST";
         _loc6_.contentType = param5;
         _loc6_.requestTimeout = this.timeout;
         if(param2 != null && param3 != null)
         {
            _loc7_ = new Base64Encoder();
            _loc7_.insertNewLines = false;
            _loc7_.encode(param2 + ":" + param3);
            _loc6_.headers = {"Authorization":"Basic " + _loc7_.toString()};
         }
         _loc6_.addEventListener(ResultEvent.RESULT,this.processHttpResponse);
         _loc6_.addEventListener(FaultEvent.FAULT,this.processHttpResponse);
         _loc6_.send(param4);
      }
      
      public function get sanitizer() : Sanitizer
      {
         return this._sanitizer;
      }
      
      private function echoText(param1:String) : String
      {
         return param1;
      }
      
      private function execute(param1:Function, param2:Array) : void
      {
         if(param1 != null)
         {
            param1.apply(null,param2);
         }
      }
      
      private function processHttpResponse(param1:Event) : void
      {
         var result:String = null;
         var parser:Function = null;
         var response:Object = null;
         var event:Event = param1;
         if(event is ResultEvent)
         {
            result = (event as ResultEvent).result as String;
            logRESTResponse(event as ResultEvent,result);
            try
            {
               if(result == null)
               {
                  this.logger.error("9001" + this.action + ": Error: null result string");
                  this.execute(this.onFailure,["No Response"]);
               }
               else
               {
                  parser = this.responseParser == null ? this.echoText : this.responseParser;
                  response = parser(result);
                  this.execute(this.onSuccess,[response]);
               }
            }
            catch(error:Error)
            {
               logError(action + ": Error parsing result " + result,error);
               execute(onFailure,[error]);
            }
         }
         else if(event is FaultEvent)
         {
            this.logFault(this.action + ": Service fault: ",event);
            this.execute(this.onFailure,[event]);
         }
      }
      
      private function logError(param1:String, param2:Error) : void
      {
         var _loc3_:String = param1 + " " + param2.name + " #" + param2.errorID + ": " + param2.message + "\n" + param2.getStackTrace();
         _loc3_ = this.sanitizer.sanitize(_loc3_);
         this.logger.error(ErrorUtil.get4DigitCode(param2.errorID) + _loc3_);
      }
      
      private function logFault(param1:String, param2:Event) : void
      {
         var _loc3_:FaultEvent = param2 as FaultEvent;
         var _loc4_:String = "";
         if(_loc3_.fault.content != null)
         {
            _loc4_ = _loc3_.fault.content.toString();
         }
         var _loc5_:String = param1 + _loc4_ + ": " + _loc3_.fault.faultString + ": " + _loc3_.fault.faultCode + ": " + _loc3_.fault.faultDetail;
         _loc5_ = this.sanitizer.sanitize(_loc5_);
         this.logger.error(ErrorUtil.get4DigitCode(_loc3_.fault.errorID) + _loc5_);
         logRESTFault(_loc3_,_loc3_.fault);
      }
   }
}

