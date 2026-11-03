package com.riotgames.platform.common.services.lcdsproxy.servicecalls
{
   import com.riotgames.platform.common.services.lcdsproxy.ILcdsProxyServiceMessenger;
   import com.riotgames.platform.common.services.lcdsproxy.responses.LcdsProxyMessageAction;
   import com.riotgames.platform.common.utils.ServiceLogger;
   import com.riotgames.platform.common.utils.decode.IDecode;
   import com.riotgames.platform.common.utils.encode.IEncode;
   import mx.rpc.Fault;
   import mx.utils.UIDUtil;
   
   public class LcdsProxyServiceCall extends LcdsProxyMessageAction implements ILcdsProxyServiceCall
   {
      
      private static const UUID_INDEX:int = 0;
      
      private static const SERVICE_NAME_INDEX:int = 1;
      
      private static const SERVICE_METHOD_NAME_INDEX:int = 2;
      
      private static const SERVICE_REQUEST_PAYLOAD_INDEX:int = 3;
      
      protected var _lcdsProxyMessenger:ILcdsProxyServiceMessenger;
      
      private var _uuid:String;
      
      protected var _asyncObject:Object = null;
      
      private var _encoder:IEncode;
      
      private var _serviceName:String;
      
      private var _serviceMethodName:String;
      
      private var _fault:Fault = null;
      
      private var _timeCreated:Date;
      
      public function LcdsProxyServiceCall(param1:ILcdsProxyServiceMessenger, param2:String, param3:String, param4:IEncode = null, param5:IDecode = null, param6:Object = null)
      {
         super(null,param5);
         this._timeCreated = new Date();
         this._asyncObject = param6;
         this._serviceName = param2;
         this._serviceMethodName = param3;
         this._encoder = param4;
         this._lcdsProxyMessenger = param1;
         this._uuid = this.generateUuid();
      }
      
      public function handleError(param1:String = null) : void
      {
         var _loc2_:String = "Error: ";
         var _loc3_:String = param1 != null && param1.lastIndexOf(_loc2_) != -1 ? param1.substr(param1.lastIndexOf(_loc2_) + _loc2_.length,param1.length) : param1;
         err(new Fault(_loc3_,param1));
         logger.error(param1);
         ServiceLogger.fault(this.serviceName,this.serviceMethodName,this.fault);
         destroy();
      }
      
      override protected function doInvocation() : void
      {
         this._lcdsProxyMessenger.invokeProxyServiceWithoutSession(this);
         this.logServiceRequest();
      }
      
      public function handleResponse(param1:String = null, param2:String = null) : void
      {
         _responsePayload = param1;
         _responseMethodName = param2;
      }
      
      public function toMessage() : Array
      {
         var _loc1_:Array = new Array();
         _loc1_[UUID_INDEX] = this._uuid;
         _loc1_[SERVICE_NAME_INDEX] = this._serviceName;
         _loc1_[SERVICE_METHOD_NAME_INDEX] = this._serviceMethodName;
         var _loc2_:Object = this.getRequestPayload();
         if(this._encoder != null)
         {
            _loc1_[SERVICE_REQUEST_PAYLOAD_INDEX] = this.encodePayload(_loc2_);
         }
         else
         {
            _loc1_[SERVICE_REQUEST_PAYLOAD_INDEX] = _loc2_;
         }
         return _loc1_;
      }
      
      public function get uuid() : String
      {
         return this._uuid;
      }
      
      private function generateUuid() : String
      {
         return UIDUtil.createUID();
      }
      
      private function encodePayload(param1:Object = null) : String
      {
         return this._encoder != null ? this._encoder.encode(param1) : "";
      }
      
      public function handleComplete(param1:Object = null) : void
      {
         super.doInvocation();
      }
      
      public function get timeCreated() : Date
      {
         return this._timeCreated;
      }
      
      public function get serviceName() : String
      {
         return this._serviceName;
      }
      
      public function get serviceMethodName() : String
      {
         return this._serviceMethodName;
      }
      
      public function get fault() : Fault
      {
         return getError() as Fault;
      }
      
      private function getMethodArgs() : Array
      {
         return [this.toMessage()[SERVICE_REQUEST_PAYLOAD_INDEX]];
      }
      
      public function getRequestPayload(param1:Object = null) : Object
      {
         return param1 != null ? param1 : new Object();
      }
      
      public function get asyncObject() : Object
      {
         return this._asyncObject;
      }
      
      protected function logServiceRequest() : void
      {
         ServiceLogger.request(this.serviceName,this.serviceMethodName,[this._uuid,this.getMethodArgs()]);
      }
   }
}

