package com.riotgames.pvpnet.cap.actions.servicecalls.async
{
   import com.riotgames.platform.common.services.lcdsproxy.ILcdsProxyServiceMessenger;
   import com.riotgames.platform.common.services.lcdsproxy.servicecalls.AsyncLcdsProxyServiceCall;
   import com.riotgames.platform.common.utils.encode.IEncode;
   import com.riotgames.platform.gameclient.notification.ClientNotificationProxyServiceName;
   
   public class CapIndicateReadinessServiceCall extends AsyncLcdsProxyServiceCall
   {
      
      private static const METHOD_NAME:String = "indicateReadinessV1";
      
      private static const READY_KEY:String = "ready";
      
      protected var ready:Boolean = false;
      
      public function CapIndicateReadinessServiceCall(param1:ILcdsProxyServiceMessenger, param2:IEncode, param3:Boolean)
      {
         this.ready = param3;
         super(param1,ClientNotificationProxyServiceName.CAP,METHOD_NAME,param2);
      }
      
      override public function getRequestPayload(param1:Object = null) : Object
      {
         param1 = super.getRequestPayload(param1);
         param1[READY_KEY] = this.ready;
         return param1;
      }
   }
}

