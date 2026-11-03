package com.riotgames.platform.common.services.lcdsproxy
{
   import com.riotgames.platform.common.services.lcdsproxy.servicecalls.IAsyncLcdsProxyServiceCall;
   import com.riotgames.platform.common.services.lcdsproxy.servicecalls.ILcdsProxyServiceCall;
   
   public class LcdsProxyFunctionMessenger implements ILcdsProxyServiceMessenger
   {
      
      private var _callback:Function;
      
      public function LcdsProxyFunctionMessenger(param1:Function)
      {
         super();
         this._callback = param1;
      }
      
      public function invokeAsyncProxyServiceWithoutSession(param1:IAsyncLcdsProxyServiceCall) : String
      {
         return null;
      }
      
      public function invokeAsyncProxyServiceWithSession(param1:IAsyncLcdsProxyServiceCall) : String
      {
         return null;
      }
      
      public function onMessageReceived(param1:String, param2:String = null, param3:String = null, param4:String = null) : void
      {
         if(this._callback != null)
         {
            this._callback.call(param1,param2,param3,param4);
         }
      }
      
      public function invokeProxyServiceWithoutSession(param1:ILcdsProxyServiceCall) : String
      {
         return null;
      }
      
      public function invokeProxyServiceWithSession(param1:ILcdsProxyServiceCall) : String
      {
         return null;
      }
      
      public function destroy() : void
      {
         this._callback = null;
      }
   }
}

