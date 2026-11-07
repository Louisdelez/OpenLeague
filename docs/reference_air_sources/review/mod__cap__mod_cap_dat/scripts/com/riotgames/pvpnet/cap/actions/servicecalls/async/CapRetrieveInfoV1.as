package com.riotgames.pvpnet.cap.actions.servicecalls.async
{
   import com.riotgames.platform.common.services.lcdsproxy.ILcdsProxyServiceMessenger;
   import com.riotgames.platform.common.services.lcdsproxy.servicecalls.AsyncLcdsProxyServiceCall;
   import com.riotgames.platform.common.utils.encode.IEncode;
   import com.riotgames.platform.gameclient.notification.ClientNotificationProxyServiceName;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   
   public class CapRetrieveInfoV1 extends AsyncLcdsProxyServiceCall
   {
      
      public static const METHOD_NAME:String = "retrieveInfoV1";
      
      private static const QUEUE_ID_KEY:String = "queueId";
      
      private var _queueId:int;
      
      public function CapRetrieveInfoV1(param1:CapModel, param2:int, param3:ILcdsProxyServiceMessenger, param4:IEncode)
      {
         this._queueId = param2;
         super(param3,ClientNotificationProxyServiceName.CAP,METHOD_NAME,param4);
      }
      
      override public function getRequestPayload(param1:Object = null) : Object
      {
         var _loc2_:Object = super.getRequestPayload(param1);
         _loc2_[QUEUE_ID_KEY] = this._queueId;
         return _loc2_;
      }
   }
}

