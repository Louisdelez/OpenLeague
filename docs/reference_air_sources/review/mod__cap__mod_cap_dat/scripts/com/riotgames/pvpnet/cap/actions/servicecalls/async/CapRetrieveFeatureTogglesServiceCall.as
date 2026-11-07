package com.riotgames.pvpnet.cap.actions.servicecalls.async
{
   import com.riotgames.platform.common.services.lcdsproxy.ILcdsProxyServiceMessenger;
   import com.riotgames.platform.common.services.lcdsproxy.servicecalls.AsyncLcdsProxyServiceCall;
   import com.riotgames.platform.common.utils.encode.IEncode;
   import com.riotgames.platform.gameclient.notification.ClientNotificationProxyServiceName;
   
   public class CapRetrieveFeatureTogglesServiceCall extends AsyncLcdsProxyServiceCall
   {
      
      public static const METHOD_NAME:String = "retrieveFeatureToggles";
      
      public function CapRetrieveFeatureTogglesServiceCall(param1:ILcdsProxyServiceMessenger, param2:IEncode)
      {
         super(param1,ClientNotificationProxyServiceName.CAP,METHOD_NAME,param2);
      }
   }
}

