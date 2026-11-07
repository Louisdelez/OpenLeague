package com.riotgames.pvpnet.cap.actions.servicecalls.async
{
   import com.riotgames.platform.common.services.lcdsproxy.ILcdsProxyServiceMessenger;
   import com.riotgames.platform.common.services.lcdsproxy.servicecalls.AsyncLcdsProxyServiceCall;
   import com.riotgames.platform.common.utils.encode.IEncode;
   import com.riotgames.platform.gameclient.notification.ClientNotificationProxyServiceName;
   
   public class CapDeclineCandidateServiceCall extends AsyncLcdsProxyServiceCall
   {
      
      public static const METHOD_NAME:String = "declineCandidateV2";
      
      private var _slotId:Number;
      
      public function CapDeclineCandidateServiceCall(param1:Number, param2:ILcdsProxyServiceMessenger, param3:IEncode)
      {
         super(param2,ClientNotificationProxyServiceName.CAP,METHOD_NAME,param3);
         this._slotId = param1;
      }
      
      override public function getRequestPayload(param1:Object = null) : Object
      {
         var _loc2_:Object = super.getRequestPayload(param1);
         _loc2_.slotId = this._slotId;
         return _loc2_;
      }
   }
}

