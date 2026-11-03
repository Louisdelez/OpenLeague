package com.riotgames.pvpnet.CLS.services
{
   import com.riotgames.platform.common.responder.Responder;
   import com.riotgames.platform.common.services.lcdsproxy.ILcdsProxyServiceMessenger;
   import com.riotgames.platform.common.services.lcdsproxy.servicecalls.IAsyncLcdsProxyServiceCall;
   import com.riotgames.platform.common.services.lcdsproxy.servicecalls.ILcdsProxyServiceCall;
   import com.riotgames.platform.common.utils.decode.IDecode;
   import com.riotgames.platform.gameclient.services.IBaseLcdsService;
   import flash.utils.Dictionary;
   
   public class LeaguesService extends Responder implements ILcdsProxyServiceMessenger
   {
      
      public static const ENDPOINT_NAME:String = "lcdsServiceProxy";
      
      public static const METHOD_NAME:String = "call";
      
      public static const MESSAGE_ID_KEY:String = "messageId";
      
      public static const METHOD_NAME_KEY:String = "methodName";
      
      public static const STATUS_KEY:String = "status";
      
      public static const PAYLOAD_KEY:String = "payload";
      
      public static const SERVICE_NAME_KEY:String = "serviceName";
      
      public static const ACK_STATUS:String = "ACK";
      
      public static const SERVICE_CALL_SUCCESS_STATUS:String = "OK";
      
      private var _lcdsService:IBaseLcdsService;
      
      private var _decoder:IDecode;
      
      private var callDictionary:Dictionary;
      
      public function LeaguesService(param1:IBaseLcdsService, param2:IDecode)
      {
         super();
         this.callDictionary = new Dictionary();
         this._lcdsService = param1;
         this._decoder = param2;
      }
      
      public function invokeAsyncProxyServiceWithSession(param1:IAsyncLcdsProxyServiceCall) : String
      {
         this.callDictionary[param1.uuid] = param1;
         param1.getCompleted().addOnce(this.handleServiceCallComplete);
         return this.invokeProxyServiceWithSession(param1);
      }
      
      public function invokeAsyncProxyServiceWithoutSession(param1:IAsyncLcdsProxyServiceCall) : String
      {
         this.callDictionary[param1.uuid] = param1;
         param1.getCompleted().addOnce(this.handleServiceCallComplete);
         return this.invokeProxyServiceWithoutSession(param1);
      }
      
      public function invokeProxyServiceWithSession(param1:ILcdsProxyServiceCall) : String
      {
         this._lcdsService.invokeServiceWithSession(ENDPOINT_NAME,METHOD_NAME,param1.toMessage(),this.onResult,param1.handleComplete,null,param1.asyncObject,false,false,false);
         return param1.uuid;
      }
      
      public function invokeProxyServiceWithoutSession(param1:ILcdsProxyServiceCall) : String
      {
         this._lcdsService.invokeServiceWithoutSession(ENDPOINT_NAME,METHOD_NAME,param1.toMessage(),this.onResult,param1.handleComplete,null,param1.asyncObject,false,false,false);
         return param1.uuid;
      }
      
      public function onMessageReceived(param1:String, param2:String = null, param3:String = null, param4:String = null) : void
      {
         var _loc5_:IAsyncLcdsProxyServiceCall = null;
         if(this.callDictionary[param1])
         {
            _loc5_ = this.callDictionary[param1] as IAsyncLcdsProxyServiceCall;
         }
         if(_loc5_)
         {
            if(!param2)
            {
               _loc5_.handleError(param2);
            }
            else if(param2 == SERVICE_CALL_SUCCESS_STATUS)
            {
               _loc5_.handleAck();
               _loc5_.handleResponse(param3,param4);
            }
            else
            {
               _loc5_.handleError(param2);
            }
         }
      }
      
      override protected function onError(param1:Object = null) : void
      {
         super.onError(param1);
      }
      
      override protected function onResult(param1:Object = null) : void
      {
         super.onResult(param1);
      }
      
      protected function handleServiceCallComplete(param1:IAsyncLcdsProxyServiceCall) : void
      {
         if(this.callDictionary[param1.uuid])
         {
            delete this.callDictionary[param1.uuid];
         }
      }
      
      public function destroy() : void
      {
         this.callDictionary = null;
         this._lcdsService = null;
      }
   }
}

