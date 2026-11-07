package com.riotgames.pvpnet.suggestedplayers.service
{
   import com.riotgames.platform.common.responder.Responder;
   import com.riotgames.platform.common.services.lcdsproxy.ILcdsProxyServiceMessenger;
   import com.riotgames.platform.common.services.lcdsproxy.servicecalls.IAsyncLcdsProxyServiceCall;
   import com.riotgames.platform.common.services.lcdsproxy.servicecalls.ILcdsProxyServiceCall;
   import com.riotgames.platform.gameclient.services.IBaseLcdsService;
   import flash.utils.Dictionary;
   
   public class SuggestedPlayersService extends Responder implements ILcdsProxyServiceMessenger
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
      
      private var callDictionary:Dictionary;
      
      public function SuggestedPlayersService(param1:IBaseLcdsService)
      {
         super();
         this._lcdsService = param1;
         this.callDictionary = new Dictionary();
      }
      
      public function invokeAsyncProxyServiceWithSession(param1:IAsyncLcdsProxyServiceCall) : String
      {
         this.callDictionary[param1.uuid] = param1;
         this._lcdsService.invokeServiceWithSession(ENDPOINT_NAME,METHOD_NAME,param1.toMessage(),onResult,param1.handleComplete,null,param1.asyncObject,false,false,false);
         return param1.uuid;
      }
      
      public function invokeAsyncProxyServiceWithoutSession(param1:IAsyncLcdsProxyServiceCall) : String
      {
         this.callDictionary[param1.uuid] = param1;
         this._lcdsService.invokeServiceWithoutSession(ENDPOINT_NAME,METHOD_NAME,param1.toMessage(),onResult,param1.handleComplete,null,param1.asyncObject,false,false,false);
         return param1.uuid;
      }
      
      public function invokeProxyServiceWithSession(param1:ILcdsProxyServiceCall) : String
      {
         throw new Error("shouldn\'t be used");
      }
      
      public function invokeProxyServiceWithoutSession(param1:ILcdsProxyServiceCall) : String
      {
         throw new Error("shouldn\'t be used");
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
               this.deleteServiceCall(_loc5_);
            }
            else if(param2 == ACK_STATUS)
            {
               _loc5_.handleAck();
            }
            else if(param2 == SERVICE_CALL_SUCCESS_STATUS)
            {
               _loc5_.handleResponse(param3,param4);
               this.deleteServiceCall(_loc5_);
            }
            else
            {
               _loc5_.handleError(param2);
               this.deleteServiceCall(_loc5_);
            }
         }
      }
      
      private function deleteServiceCall(param1:IAsyncLcdsProxyServiceCall) : void
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

