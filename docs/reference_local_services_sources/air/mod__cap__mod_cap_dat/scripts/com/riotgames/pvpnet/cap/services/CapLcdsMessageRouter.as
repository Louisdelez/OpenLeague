package com.riotgames.pvpnet.cap.services
{
   import blix.action.IAction;
   import com.riotgames.platform.common.services.lcdsproxy.ILcdsProxyServiceMessenger;
   import com.riotgames.platform.common.services.lcdsproxy.servicecalls.IAsyncLcdsProxyServiceCall;
   import com.riotgames.platform.common.services.lcdsproxy.servicecalls.ILcdsProxyServiceCall;
   import com.riotgames.pvpnet.cap.factory.response.BaseCapMessageActionFactory;
   
   public class CapLcdsMessageRouter implements ILcdsProxyServiceMessenger
   {
      
      public static const MESSAGE_ID_KEY:String = "messageId";
      
      public static const METHOD_NAME_KEY:String = "methodName";
      
      public static const STATUS_KEY:String = "status";
      
      public static const PAYLOAD_KEY:String = "payload";
      
      public static const SERVICE_NAME_KEY:String = "serviceName";
      
      public static const ACK_STATUS:String = "ACK";
      
      public static const SERVICE_CALL_SUCCESS_STATUS:String = "OK";
      
      private var _handlerFactory:BaseCapMessageActionFactory;
      
      public function CapLcdsMessageRouter(param1:BaseCapMessageActionFactory)
      {
         super();
         this._handlerFactory = param1;
      }
      
      public function invokeAsyncProxyServiceWithoutSession(param1:IAsyncLcdsProxyServiceCall) : String
      {
         return null;
      }
      
      public function onMessageReceived(param1:String, param2:String = null, param3:String = null, param4:String = null) : void
      {
         var _loc5_:IAction = null;
         if(param2 == SERVICE_CALL_SUCCESS_STATUS)
         {
            _loc5_ = this._handlerFactory.createAction(param4,param3);
            if(_loc5_)
            {
               _loc5_.invoke();
            }
         }
      }
      
      public function invokeAsyncProxyServiceWithSession(param1:IAsyncLcdsProxyServiceCall) : String
      {
         return null;
      }
      
      public function invokeProxyServiceWithSession(param1:ILcdsProxyServiceCall) : String
      {
         return null;
      }
      
      public function invokeProxyServiceWithoutSession(param1:ILcdsProxyServiceCall) : String
      {
         return null;
      }
      
      public function destroy() : void
      {
         this._handlerFactory = null;
      }
   }
}

