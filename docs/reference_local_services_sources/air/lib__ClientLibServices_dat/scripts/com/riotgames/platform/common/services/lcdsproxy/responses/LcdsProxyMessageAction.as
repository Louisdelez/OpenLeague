package com.riotgames.platform.common.services.lcdsproxy.responses
{
   import avmplus.getQualifiedClassName;
   import blix.action.BasicAction;
   import com.riotgames.platform.common.utils.decode.IDecode;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class LcdsProxyMessageAction extends BasicAction implements ILcdsProxyMessageAction
   {
      
      public static const MESSAGE_ID_KEY:String = "messageId";
      
      public static const METHOD_NAME_KEY:String = "methodName";
      
      public static const STATUS_KEY:String = "status";
      
      public static const PAYLOAD_KEY:String = "payload";
      
      public static const SERVICE_NAME_KEY:String = "serviceName";
      
      protected var _decoder:IDecode;
      
      protected var _responseMethodName:String;
      
      protected var _responsePayload:String;
      
      protected var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      public function LcdsProxyMessageAction(param1:String, param2:IDecode, param3:String = null)
      {
         super(false);
         this._decoder = param2;
         this._responseMethodName = param1;
         this._responsePayload = param3;
      }
      
      public static function getStatus(param1:Object) : String
      {
         return param1 != null ? param1[STATUS_KEY] : null;
      }
      
      public static function getMessageId(param1:Object) : String
      {
         return param1 != null ? param1[MESSAGE_ID_KEY] : null;
      }
      
      public static function getServiceName(param1:Object) : String
      {
         return param1 != null ? param1[SERVICE_NAME_KEY] : null;
      }
      
      public static function getPayload(param1:Object) : String
      {
         return param1 != null ? param1[PAYLOAD_KEY] : null;
      }
      
      public static function getMethodName(param1:Object) : String
      {
         return param1 != null ? param1[METHOD_NAME_KEY] : null;
      }
      
      public function set payload(param1:String) : void
      {
         this._responsePayload = param1;
      }
      
      protected function decodePayload(param1:String = null) : Object
      {
         return this._decoder != null && param1 != null ? this._decoder.decode(param1) : new Object();
      }
      
      [Abstract]
      protected function doDecode(param1:Object) : void
      {
      }
      
      override public function complete() : void
      {
         super.complete();
         destroy();
      }
      
      override protected function doInvocation() : void
      {
         var _loc1_:Object = this.decodePayload(this._responsePayload);
         this.doDecode(_loc1_);
         this.complete();
      }
   }
}

