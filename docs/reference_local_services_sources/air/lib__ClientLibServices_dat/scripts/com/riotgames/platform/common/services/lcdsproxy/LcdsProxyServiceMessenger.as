package com.riotgames.platform.common.services.lcdsproxy
{
   import blix.action.IAction;
   import com.riotgames.platform.common.services.lcdsproxy.responses.LcdsProxyMessageAction;
   import com.riotgames.platform.common.services.lcdsproxy.responses.factory.ILcdsProxyMessageActionFactory;
   import com.riotgames.platform.common.services.lcdsproxy.servicecalls.IAsyncLcdsProxyServiceCall;
   import com.riotgames.platform.common.services.lcdsproxy.servicecalls.ILcdsProxyServiceCall;
   import com.riotgames.platform.common.utils.decode.IDecode;
   import com.riotgames.platform.common.utils.decode.JSONDecoder;
   import com.riotgames.platform.gameclient.services.IBaseLcdsService;
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import flash.utils.getQualifiedClassName;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.rpc.events.ResultEvent;
   
   public class LcdsProxyServiceMessenger implements ILcdsProxyServiceMessenger
   {
      
      public static const ENDPOINT_NAME:String = "lcdsServiceProxy";
      
      public static const METHOD_NAME:String = "call";
      
      public static const ACK_STATUS:String = "ACK";
      
      public static const SERVICE_CALL_SUCCESS_STATUS:String = "OK";
      
      private var _timeoutTimer:Timer;
      
      private var _serviceCallUuidDictionary:Dictionary;
      
      private var _messageActionFactory:ILcdsProxyMessageActionFactory;
      
      private var _asyncServiceCallsUuidDictionary:Dictionary;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var _lcdsService:IBaseLcdsService;
      
      private var _destroyed:Boolean = false;
      
      private const TIMEOUT_TICK:int = 500;
      
      private var _routedErrorMap:Dictionary;
      
      private var _lcdsProxyDecoder:IDecode = new JSONDecoder();
      
      public function LcdsProxyServiceMessenger(param1:IBaseLcdsService, param2:ILcdsProxyMessageActionFactory = null)
      {
         super();
         this._lcdsService = param1;
         this._messageActionFactory = param2;
         this._serviceCallUuidDictionary = new Dictionary();
         this._asyncServiceCallsUuidDictionary = new Dictionary(true);
         this._routedErrorMap = new Dictionary();
         this._timeoutTimer = new Timer(this.TIMEOUT_TICK);
         this._timeoutTimer.addEventListener(TimerEvent.TIMER,this.onTick);
      }
      
      private function doSetup(param1:ILcdsProxyServiceCall) : void
      {
         this.validateCall(param1);
         param1.getCompleted().addOnce(this.doRemove);
         param1.getErred().addOnce(this.doRemove);
         param1.getAborted().addOnce(this.doRemove);
         this._serviceCallUuidDictionary[param1.uuid] = param1;
      }
      
      public function invokeProxyServiceWithoutSession(param1:ILcdsProxyServiceCall) : String
      {
         this.doSetup(param1);
         this._lcdsService.invokeServiceWithoutSession(ENDPOINT_NAME,METHOD_NAME,param1.toMessage(),this.onResult,this.onComplete,this.routedErrorMap,param1.asyncObject,false,false,false);
         return param1.uuid;
      }
      
      public function get routedErrorMap() : Dictionary
      {
         return this._routedErrorMap;
      }
      
      public function destroy() : void
      {
         var _loc2_:String = null;
         this._destroyed = true;
         this._timeoutTimer.removeEventListener(TimerEvent.TIMER,this.onTick);
         this._timeoutTimer.stop();
         var _loc1_:ILcdsProxyServiceCall = null;
         for(_loc2_ in this._serviceCallUuidDictionary)
         {
            _loc1_ = this._serviceCallUuidDictionary[_loc2_];
            this.doRemove(_loc1_);
         }
      }
      
      private function doAsyncSetup(param1:IAsyncLcdsProxyServiceCall) : void
      {
         this.validateCall(param1);
         this._asyncServiceCallsUuidDictionary[param1.uuid] = param1;
         if(!this._timeoutTimer.running)
         {
            this._timeoutTimer.start();
         }
      }
      
      public function invokeAsyncProxyServiceWithSession(param1:IAsyncLcdsProxyServiceCall) : String
      {
         this.doAsyncSetup(param1);
         return this.invokeProxyServiceWithSession(param1);
      }
      
      private function isAsyncServiceCall(param1:ILcdsProxyServiceCall) : Boolean
      {
         return this._asyncServiceCallsUuidDictionary[param1.uuid] == param1;
      }
      
      public function onResult(param1:ResultEvent = null) : void
      {
         if(this._destroyed)
         {
            return;
         }
         var _loc2_:Object = this.getResultObject(param1);
         var _loc3_:String = LcdsProxyMessageAction.getStatus(_loc2_);
         var _loc4_:String = LcdsProxyMessageAction.getMessageId(_loc2_);
         var _loc5_:String = LcdsProxyMessageAction.getPayload(_loc2_);
         var _loc6_:IAsyncLcdsProxyServiceCall = this._asyncServiceCallsUuidDictionary[_loc4_] as IAsyncLcdsProxyServiceCall;
         if(_loc6_ != null)
         {
            if(_loc3_ == ACK_STATUS)
            {
               _loc6_.handleAck();
            }
            else
            {
               this.logger.error("Non-async ACK response received for async service call (IAsyncLcdsProxyServiceCall).");
               _loc6_.handleError(_loc3_);
            }
         }
         else
         {
            this.onMessageReceived(_loc4_,_loc3_,_loc5_);
         }
      }
      
      private function validateCall(param1:ILcdsProxyServiceCall) : void
      {
         if(param1 == null)
         {
            throw new Error("Unable to invoke - no service call provided.");
         }
         if(this._serviceCallUuidDictionary[param1.uuid] != null)
         {
            throw new Error("Unable to track message - uuid already taken");
         }
      }
      
      private function doRemove(param1:ILcdsProxyServiceCall) : void
      {
         var _loc2_:String = null;
         delete this._serviceCallUuidDictionary[param1.uuid];
         param1.getAborted().remove(this.doRemove);
         param1.abort();
         param1.destroy();
         delete this._asyncServiceCallsUuidDictionary[param1.uuid];
         var _loc3_:int = 0;
         var _loc4_:* = this._asyncServiceCallsUuidDictionary;
         for(_loc2_ in _loc4_)
         {
         }
         this._timeoutTimer.stop();
      }
      
      public function onMessageReceived(param1:String, param2:String = null, param3:String = null, param4:String = null) : void
      {
         var _loc5_:ILcdsProxyServiceCall = null;
         if(param1 != null)
         {
            _loc5_ = this._serviceCallUuidDictionary[param1];
            if(_loc5_ == null)
            {
               throw new Error("Async response received for untracked service call. Unable to act.");
            }
            if(param2 == null || param2 == SERVICE_CALL_SUCCESS_STATUS || param2 == ACK_STATUS)
            {
               _loc5_.handleResponse(param3,param4);
            }
            else
            {
               _loc5_.handleError(param2);
            }
         }
         else
         {
            this.handleAsyncMessage(param4,param3);
         }
      }
      
      public function invokeProxyServiceWithSession(param1:ILcdsProxyServiceCall) : String
      {
         this.doSetup(param1);
         this._lcdsService.invokeServiceWithSession(ENDPOINT_NAME,METHOD_NAME,param1.toMessage(),this.onResult,this.onComplete,this.routedErrorMap,param1.asyncObject,false,false,false);
         return param1.uuid;
      }
      
      protected function getResultObject(param1:ResultEvent) : Object
      {
         return param1 != null ? param1.result : null;
      }
      
      public function onComplete(param1:ResultEvent = null) : void
      {
         if(this._destroyed)
         {
            return;
         }
         var _loc2_:Object = this.getResultObject(param1);
         var _loc3_:String = LcdsProxyMessageAction.getMessageId(_loc2_);
         var _loc4_:ILcdsProxyServiceCall = this._serviceCallUuidDictionary[_loc3_];
         if(_loc4_ == null)
         {
            this.logger.error("Attempting to complete on an unknown service call.  Ignoring...");
            return;
         }
         _loc4_.handleComplete(_loc2_);
      }
      
      public function invokeAsyncProxyServiceWithoutSession(param1:IAsyncLcdsProxyServiceCall) : String
      {
         this.doAsyncSetup(param1);
         return this.invokeProxyServiceWithoutSession(param1);
      }
      
      private function handleAsyncMessage(param1:String, param2:String) : void
      {
         var _loc3_:IAction = this._messageActionFactory.createAction(param1,param2) as IAction;
         if(_loc3_ == null)
         {
            throw new Error("Unable to act on message - methodName: " + param1 + " payload: " + param2);
         }
         _loc3_.invoke();
      }
      
      private function onTick(param1:TimerEvent) : void
      {
         var _loc3_:IAsyncLcdsProxyServiceCall = null;
         var _loc4_:IAsyncLcdsProxyServiceCall = null;
         var _loc2_:Array = [];
         for each(_loc3_ in this._asyncServiceCallsUuidDictionary)
         {
            _loc3_.timeoutDuration += this.TIMEOUT_TICK;
            if(_loc3_.timeoutDuration > _loc3_.timeoutLifetime)
            {
               _loc2_.push(_loc3_);
            }
         }
         for each(_loc4_ in _loc2_)
         {
            _loc4_.handleTimeout();
            this.doRemove(_loc4_);
         }
      }
   }
}

