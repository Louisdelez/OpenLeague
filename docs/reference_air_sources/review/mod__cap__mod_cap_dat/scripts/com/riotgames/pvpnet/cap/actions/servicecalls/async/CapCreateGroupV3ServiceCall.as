package com.riotgames.pvpnet.cap.actions.servicecalls.async
{
   import com.riotgames.platform.common.services.lcdsproxy.ILcdsProxyServiceMessenger;
   import com.riotgames.platform.common.services.lcdsproxy.servicecalls.AsyncLcdsProxyServiceCall;
   import com.riotgames.platform.common.utils.encode.IEncode;
   import com.riotgames.platform.gameclient.notification.ClientNotificationProxyServiceName;
   
   public class CapCreateGroupV3ServiceCall extends AsyncLcdsProxyServiceCall
   {
      
      public static const METHOD_NAME:String = "createGroupV3";
      
      private static const QUEUE_ID_KEY:String = "queueId";
      
      private var queueId:int;
      
      public function CapCreateGroupV3ServiceCall(param1:int, param2:ILcdsProxyServiceMessenger, param3:IEncode)
      {
         this.queueId = param1;
         super(param2,ClientNotificationProxyServiceName.CAP,METHOD_NAME,param3);
      }
      
      override public function getRequestPayload(param1:Object = null) : Object
      {
         var _loc2_:Object = super.getRequestPayload(param1);
         _loc2_[QUEUE_ID_KEY] = this.queueId;
         return _loc2_;
      }
   }
}

