package com.riotgames.pvpnet.endofgamegiftwindow.services
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.responder.Responder;
   import com.riotgames.platform.common.services.lcdsproxy.servicecalls.IAsyncLcdsProxyServiceCall;
   import com.riotgames.platform.common.services.lcdsproxy.servicecalls.ILcdsProxyServiceCall;
   import com.riotgames.platform.common.utils.decode.IDecode;
   import com.riotgames.platform.gameclient.services.IBaseLcdsService;
   import flash.utils.Dictionary;
   
   public class EndOfGameGiftService extends Responder implements IEndOfGameGiftService
   {
      
      public static const DESTINATION_SERVICE_NAME:String = "endOfGameGifting";
      
      public static const SERVICE_ENDPOINT_NAME:String = "lcdsServiceProxy";
      
      public static const SERVICE_METHOD_NAME:String = "call";
      
      public static const ACK_STATUS:String = "ACK";
      
      public static const SERVICE_CALL_SUCCESS_STATUS:String = "OK";
      
      public static const SERVICE_CALL_ERROR_STATUS:String = "ERROR";
      
      public static const SERVICE_STATUS_UNAVAILABLE:String = "SERVICE UNAVAILABLE";
      
      private var _callRoster:Dictionary;
      
      private var _lcdsService:IBaseLcdsService;
      
      private var _decoder:IDecode;
      
      private var _serviceCallResponseReceived:Signal;
      
      private var _serviceUnavailableSignal:Signal;
      
      public function EndOfGameGiftService(param1:IBaseLcdsService, param2:IDecode)
      {
         super();
         this._callRoster = new Dictionary();
         this._lcdsService = param1;
         this._decoder = param2;
         this._serviceCallResponseReceived = new Signal();
         this._serviceUnavailableSignal = new Signal();
      }
      
      public function serviceCallResponseReceived() : ISignal
      {
         return this._serviceCallResponseReceived;
      }
      
      public function serviceUnavailable() : ISignal
      {
         return this._serviceUnavailableSignal;
      }
      
      public function invokeProxyServiceWithSession(param1:ILcdsProxyServiceCall) : String
      {
         this._lcdsService.invokeServiceWithSession(SERVICE_ENDPOINT_NAME,SERVICE_METHOD_NAME,param1.toMessage(),onResult,param1.handleComplete,null,param1.asyncObject,false,false,false);
         return param1.uuid;
      }
      
      public function invokeAsyncProxyServiceWithSession(param1:IAsyncLcdsProxyServiceCall) : String
      {
         this._callRoster[param1.uuid] = param1;
         param1.getCompleted().addOnce(this.onCallComplete);
         return this.invokeProxyServiceWithSession(param1);
      }
      
      public function invokeProxyServiceWithoutSession(param1:ILcdsProxyServiceCall) : String
      {
         this._lcdsService.invokeServiceWithoutSession(SERVICE_ENDPOINT_NAME,SERVICE_METHOD_NAME,param1.toMessage(),onResult,param1.handleComplete,null,param1.asyncObject,false,false,false);
         return param1.uuid;
      }
      
      public function invokeAsyncProxyServiceWithoutSession(param1:IAsyncLcdsProxyServiceCall) : String
      {
         this._callRoster[param1.uuid] = param1;
         param1.getCompleted().addOnce(this.onCallComplete);
         return this.invokeProxyServiceWithoutSession(param1);
      }
      
      public function onMessageReceived(param1:String, param2:String = null, param3:String = null, param4:String = null) : void
      {
         if(param2 == SERVICE_STATUS_UNAVAILABLE)
         {
            this._serviceUnavailableSignal.dispatch();
         }
         else
         {
            this._serviceCallResponseReceived.dispatch(param4,param3);
         }
      }
      
      private function onCallComplete(param1:IAsyncLcdsProxyServiceCall) : void
      {
         if(this._callRoster[param1.uuid])
         {
            delete this._callRoster[param1.uuid];
         }
      }
      
      public function destroy() : void
      {
         this._callRoster = null;
         this._lcdsService = null;
         this._decoder = null;
      }
   }
}

