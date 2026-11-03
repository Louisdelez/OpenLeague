package com.riotgames.pvpnet.cap.services
{
   import com.riotgames.platform.common.responder.Responder;
   import com.riotgames.platform.common.services.lcdsproxy.ILcdsProxyServiceMessenger;
   import com.riotgames.platform.common.services.lcdsproxy.servicecalls.IAsyncLcdsProxyServiceCall;
   import com.riotgames.platform.common.services.lcdsproxy.servicecalls.ILcdsProxyServiceCall;
   import com.riotgames.platform.common.utils.decode.IDecode;
   import com.riotgames.platform.gameclient.services.IBaseLcdsService;
   import com.riotgames.pvpnet.cap.util.CapLocaleUtil;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
   import com.riotgames.pvpnet.tracking.Dradis;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class CapService extends Responder implements ILcdsProxyServiceMessenger
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
      
      public static const TRACKING_IDENTIFIER:String = "pb__teambuilder__service_call_timeout";
      
      private static const DEFAULT_TIMEOUT:Number = 30000;
      
      private var _decoder:IDecode;
      
      private var _timer:Timer;
      
      private var _lcdsService:IBaseLcdsService;
      
      private var callDictionary:Dictionary;
      
      private var numPendingResponses:int = 0;
      
      public function CapService(param1:IBaseLcdsService, param2:IDecode)
      {
         super();
         this.callDictionary = new Dictionary();
         this._lcdsService = param1;
         this._decoder = param2;
      }
      
      public function invokeProxyServiceWithSession(param1:ILcdsProxyServiceCall) : String
      {
         this._lcdsService.invokeServiceWithSession(ENDPOINT_NAME,METHOD_NAME,param1.toMessage(),this.onResult,param1.handleComplete,null,param1.asyncObject,false,false,false);
         return param1.uuid;
      }
      
      public function destroy() : void
      {
         if(this._timer)
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.handleTimerComplete);
            this._timer = null;
         }
      }
      
      protected function handleServiceCallComplete(param1:IAsyncLcdsProxyServiceCall) : void
      {
         if(this.callDictionary[param1.uuid])
         {
            delete this.callDictionary[param1.uuid];
         }
      }
      
      public function invokeAsyncProxyServiceWithoutSession(param1:IAsyncLcdsProxyServiceCall) : String
      {
         ++this.numPendingResponses;
         this.callDictionary[param1.uuid] = param1;
         param1.getCompleted().addOnce(this.handleServiceCallComplete);
         this.startTimerIfNeeded();
         return this.invokeProxyServiceWithoutSession(param1);
      }
      
      public function invokeProxyServiceWithoutSession(param1:ILcdsProxyServiceCall) : String
      {
         this._lcdsService.invokeServiceWithoutSession(ENDPOINT_NAME,METHOD_NAME,param1.toMessage(),this.onResult,param1.handleComplete,null,param1.asyncObject,false,false,false);
         return param1.uuid;
      }
      
      private function startTimerIfNeeded() : void
      {
         this.createTimerIfNeeded();
         if(this.shouldStartTimer())
         {
            this._timer.reset();
            this._timer.start();
         }
      }
      
      private function shouldStartTimer() : Boolean
      {
         return DynamicClientConfigManager.getConfiguration("TeamBuilder","TimeoutsEnabled",true).getBoolean();
      }
      
      override protected function onResult(param1:Object = null) : void
      {
         super.onResult(param1);
      }
      
      public function invokeAsyncProxyServiceWithSession(param1:IAsyncLcdsProxyServiceCall) : String
      {
         ++this.numPendingResponses;
         this.callDictionary[param1.uuid] = param1;
         param1.getCompleted().addOnce(this.handleServiceCallComplete);
         this.startTimerIfNeeded();
         return this.invokeProxyServiceWithSession(param1);
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
            else if(param2 == ACK_STATUS)
            {
               _loc5_.handleAck();
            }
            else if(param2 == SERVICE_CALL_SUCCESS_STATUS)
            {
               --this.numPendingResponses;
               this.stopTimerIfNeeded();
               _loc5_.handleResponse(param3,param4);
            }
            else
            {
               _loc5_.handleError(param2);
            }
         }
      }
      
      private function handleTimerComplete(param1:TimerEvent) : void
      {
         this._timer.stop();
         this._timer.reset();
         this.displayAlert();
      }
      
      override protected function onError(param1:Object = null) : void
      {
         super.onError(param1);
      }
      
      private function stopTimerIfNeeded() : void
      {
         if(this.shouldStopTimer())
         {
            this._timer.stop();
         }
      }
      
      private function shouldStopTimer() : Boolean
      {
         return this.numPendingResponses <= 0;
      }
      
      private function displayAlert() : void
      {
         var _loc1_:String = CapLocaleUtil.getResourceString("gf_dialog_service_call_timeout_title","Error");
         var _loc2_:String = CapLocaleUtil.getResourceString("gf_dialog_service_call_timeout_body","There may be a problem with the server or your connection. Please relog and try again.");
         var _loc3_:AlertAction = new AlertAction(_loc1_,_loc2_);
         _loc3_.add();
         Dradis.track(TRACKING_IDENTIFIER);
      }
      
      private function createTimerIfNeeded() : void
      {
         var _loc1_:Number = NaN;
         if(!this._timer)
         {
            _loc1_ = Number(DynamicClientConfigManager.getConfiguration("TeamBuilder","TimeoutDelay",DEFAULT_TIMEOUT).getNumber());
            this._timer = new Timer(_loc1_);
            this._timer.addEventListener(TimerEvent.TIMER,this.handleTimerComplete);
         }
      }
   }
}

